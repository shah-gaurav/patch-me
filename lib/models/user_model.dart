import 'dart:async';

import 'package:binding/binding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'patch_time_model.dart';

class UserModel extends NotifyPropertyChanged {
  Timer _timer;
  DocumentReference _userDocument;
  Stream<DocumentSnapshot> _userDocumentSteam;
  StreamSubscription<DocumentSnapshot> _streamSubscription;

  // Document Keys
  final _startTimeKey = 'start-time';
  final _dataKey = 'data';

  // Properties

  // name
  static const namePropertyName = 'name';
  String _name;

  String get name => _name;

  set name(String name) {
    _name = name;
    propertyChanged(propertyName: namePropertyName);
  }

  String userId;
  int _patchTimePerDay;

  int get patchTimePerDay => _patchTimePerDay;

  set patchTimePerDay(int patchTimePerDay) {
    _patchTimePerDay = patchTimePerDay;
    propertyChanged(propertyName: todayTotalTimePropertyName);
  }

  // isLoading Property
  static const isLoadingPropertyName = 'isLoading';
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
    propertyChanged(propertyName: isLoadingPropertyName);
  }

  // timerStartTime Property
  static const timerStartTimePropertyName = 'timerStartTime';
  DateTime _timerStartTime;
  DateTime get timerStartTime => _timerStartTime;
  set timerStartTime(value) {
    _timerStartTime = value;
    propertyChanged(propertyName: timerStartTimePropertyName);
    propertyChanged(propertyName: todayTotalTimePropertyName);
  }

  // data Property
  List<PatchTimeModel> _data = List<PatchTimeModel>();

  List<PatchTimeModel> get data {
    _data.sort((a, b) => b.date.compareTo(a.date));
    return _data;
  }

  // Computed Properties

  PatchTimeModel get dataForToday {
    return _getDataForDate(DateTime.now());
  }

  PatchTimeModel _getDataForDate(DateTime date) {
    final index = _data.indexWhere((item) =>
        item.date.year == date.year &&
        item.date.month == date.month &&
        item.date.day == date.day);
    if (index == -1) {
      var returnValue = PatchTimeModel.fromDate(date, 0, patchTimePerDay);
      _data.add(returnValue);
      return returnValue;
    } else {
      return _data[index];
    }
  }

  int get elapsedTime {
    if (timerStartTime == null) return 0;

    final elapsedTime = DateTime.now().difference(timerStartTime).inMinutes;

    if (elapsedTime < 0)
      return 0;
    else
      return elapsedTime;
  }

  static const todayTotalTimePropertyName = 'todayTotalTime';

  int get todayTotalTime => dataForToday.minutes + elapsedTime;

  double get todayPercentage => (todayTotalTime / patchTimePerDay > 1)
      ? 1.0
      : todayTotalTime / patchTimePerDay;

  int get todayMinutesRemaining => patchTimePerDay - todayTotalTime;

  bool get maxTimeExceededForToday => todayTotalTime >= patchTimePerDay * 2;

  // Constructor

  UserModel({String name, this.userId, int patchTimePerDay}) {
    _name = name;
    _patchTimePerDay = patchTimePerDay;
  }

  // Methods
  void loadUser() {
    isLoading = true;
    _loadDocument();
  }

  Future<void> _loadDocument() async {
    _userDocument = Firestore.instance.collection('users').document(userId);
    final snapShot = await _userDocument.get();

    if (snapShot == null || !snapShot.exists) {
      // Document with id == docId doesn't exist.
      await _userDocument.setData({_startTimeKey: null});
    }

    _userDocumentSteam = _userDocument.snapshots();
    _streamSubscription = _userDocumentSteam.listen((userDocument) {
      if (userDocument[_dataKey] != null) {
        _data.clear();
        for (var item in List.from(userDocument[_dataKey])) {
          _data.add(PatchTimeModel.fromJson(item));
        }
      }
      if (userDocument[_startTimeKey] != null) {
        timerStartTime =
            DateTime.fromMillisecondsSinceEpoch(userDocument[_startTimeKey]);
        if (DateTime.now().difference(timerStartTime) <
            Duration(minutes: patchTimePerDay * 2)) {
          _startTicker();
        } else {
          _getDataForDate(timerStartTime).minutes = patchTimePerDay * 2;
          timerStartTime = null;
          _stopTicker();
          save();
        }
      } else {
        timerStartTime = null;
        _stopTicker();
      }
      isLoading = false;
    });
  }

  void _startTicker() {
    if (_timer == null) {
      _timer = Timer.periodic(Duration(seconds: 10), (timer) {
        if (maxTimeExceededForToday) {
          stopTimer();
        }
        propertyChanged(propertyName: todayTotalTimePropertyName);
      });
    }
  }

  void _stopTicker() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  Future<void> save() async {
    await _userDocument.updateData({
      _startTimeKey: timerStartTime?.millisecondsSinceEpoch,
      _dataKey: _data.map((item) => item.toJson()).toList(),
    });
  }

  void startTimer() async {
    timerStartTime = DateTime.now();
    _startTicker();
    await save();
  }

  void stopTimer() async {
    dataForToday.minutes = todayTotalTime;
    timerStartTime = null;
    _stopTicker();
    await save();
  }

  void cancelSubscription() {
    if (_streamSubscription != null) {
      print('cancelling subscription');
      _streamSubscription.cancel();
    }
  }

  updatePatchTime({DateTime date, int patchTime}) async {
    _data.firstWhere((e) => e.date == date).minutes = patchTime;
    await save();
  }
}
