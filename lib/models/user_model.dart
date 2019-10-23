import 'dart:async';

import 'package:binding/binding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:patch_me/models/firebase_constants.dart';

import 'patch_time_model.dart';

class UserModel extends NotifyPropertyChanged {
  Timer _timer;
  DocumentReference _userDocument;
  Stream<DocumentSnapshot> _userDocumentSteam;
  StreamSubscription<DocumentSnapshot> _streamSubscription;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Document Keys
  final _timerRunningKey = 'timer-running';
  final _startTimeKey = 'start-time';
  final _timeRemainingKey = 'time-remaining';
  final _patchTimePerDayKey = 'patch-time-per-day';
  final _dataKey = 'data';
  final _deviceTokensKey = 'tokens';

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

  // device tokens Property
  List<String> _deviceTokens = List<String>();

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
  Future<void> loadUser() async {
    isLoading = true;
    await _loadDocument();
  }

  Future<void> _loadDocument() async {
    await _auth.signInWithEmailAndPassword(
      email: FirebaseConstants.email,
      password: FirebaseConstants.password,
    );
    _userDocument = Firestore.instance.collection('users').document(userId);
    final snapShot = await _userDocument.get();

    if (snapShot == null || !snapShot.exists) {
      // Document with id == docId doesn't exist.
      await _userDocument.setData({_startTimeKey: null});
    } else {
      _loadUser(snapShot.data);
    }

    _userDocumentSteam = _userDocument.snapshots();
    _streamSubscription = _userDocumentSteam.listen((userDocument) {
      _loadUser(userDocument);
    });

    isLoading = false;
  }

  _loadUser(userDocument) {
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
    if (userDocument[_deviceTokensKey] != null) {
      _deviceTokens.clear();
      for (var item in List.from(userDocument[_deviceTokensKey])) {
        _deviceTokens.add(item);
      }
    }
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
      _patchTimePerDayKey: patchTimePerDay,
      _timerRunningKey: timerStartTime == null ? false : true,
      _startTimeKey: timerStartTime?.millisecondsSinceEpoch,
      _timeRemainingKey: timerStartTime == null
          ? 0
          : (todayMinutesRemaining > 0 ? todayMinutesRemaining : 60),
      _deviceTokensKey: _deviceTokens,
      _dataKey: data.map((item) => item.toJson()).toList(),
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
    _auth.signOut();
  }

  updatePatchTime({DateTime date, int patchTime}) async {
    _data.firstWhere((e) => e.date == date).minutes = patchTime;
    await save();
  }

  Future<void> addDeviceToken(String token) async {
    if (!_deviceTokens.contains(token)) {
      _deviceTokens.add(token);
      await save();
    }
  }

  Future<void> removeAllDeviceTokens() async {
    _deviceTokens.clear();
    await save();
  }
}
