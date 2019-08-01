import 'dart:async';

import 'package:binding/binding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'patch_time_model.dart';

class UserModel extends NotifyPropertyChanged {
  final totalTimePerDay = 120;

  Timer _timer;
  DocumentReference _userDocument;
  Stream<DocumentSnapshot> _userDocumentSteam;

  // Document Keys
  final _startTimeKey = 'start-time';
  final _dataKey = 'data';

  // Properties

  // name
  String name;
  String userId;

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

  // Computed Properties

  PatchTimeModel get dataForToday {
    final index = _data.indexWhere((item) =>
        item.date.year == DateTime.now().year &&
        item.date.month == DateTime.now().month &&
        item.date.day == DateTime.now().day);
    if (index == -1) {
      var returnValue = PatchTimeModel.fromDate(
        DateTime.now(),
        0,
      );
      _data.add(returnValue);
      return returnValue;
    } else {
      return _data[index];
    }
  }

  int get elapsedTime {
    if (timerStartTime == null) return 0;

    final elapsedTime = DateTime.now().difference(timerStartTime).inSeconds;

    if (elapsedTime < 0)
      return 0;
    else
      return elapsedTime;
  }

  static const todayTotalTimePropertyName = 'todayTotalTime';

  int get todayTotalTime => dataForToday.minutes + elapsedTime;

  double get todayPercentage => (todayTotalTime / totalTimePerDay > 1)
      ? 1.0
      : todayTotalTime / totalTimePerDay;

  int get todayMinutesRemaining => totalTimePerDay - todayTotalTime;

  // Constructor

  UserModel({this.name, this.userId}) {
    isLoading = true;
    _loadDocument();
  }

  // Methods

  Future<void> _loadDocument() async {
    _userDocument = Firestore.instance.collection('users').document(userId);
    final snapShot = await _userDocument.get();

    if (snapShot == null || !snapShot.exists) {
      // Document with id == docId doesn't exist.
      await _userDocument.setData({_startTimeKey: null});
    }

    _userDocumentSteam = _userDocument.snapshots();
    _userDocumentSteam.listen((userDocument) {
      if (userDocument[_dataKey] != null) {
        _data.clear();
        for (var item in List.from(userDocument[_dataKey])) {
          _data.add(PatchTimeModel.fromJson(item));
        }
      }
      if (userDocument[_startTimeKey] != null) {
        timerStartTime =
            DateTime.fromMillisecondsSinceEpoch(userDocument[_startTimeKey]);
        _startTicker();
      } else {
        timerStartTime = null;
        _stopTicker();
      }
      isLoading = false;
    });
  }

  void _startTicker() {
    if (_timer == null) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
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
}
