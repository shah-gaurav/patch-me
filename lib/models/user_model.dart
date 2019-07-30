import 'dart:convert';

import 'package:binding/binding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'patch_time_model.dart';

class UserModel extends NotifyPropertyChanged {
  final document =
      Firestore.instance.collection('users').document('1111-1111-1111-1111');
  final totalTimePerDay = 120;
  final formatter = new DateFormat('yyyy-MM-dd');

  // Document Keys
  final _startTimeKey = 'start-time';
  final _dataKey = 'data';

  // Properties

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
    propertyChanged(propertyName: isTimerRunningPropertyName);
  }

  // data Property
  static const dataPropertyName = 'data';
  List<PatchTimeModel> _data = List<PatchTimeModel>();
  List<PatchTimeModel> get data => _data;

  // Computed Properties

  static const isTimerRunningPropertyName = 'isTimerRunning';
  bool get isTimerRunning => timerStartTime != null;

  PatchTimeModel get dataForToday {
    final index = _data.indexWhere((item) =>
        formatter.format(item.date) == formatter.format(DateTime.now()));
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

  double get todayPercentage => dataForToday.minutes / totalTimePerDay;

  int get todayMinutesRemaining => totalTimePerDay - dataForToday.minutes;

  // Methods

  void load() async {
    isLoading = true;
    var userDocument = await document.get();
    if (userDocument[_startTimeKey] != null) {
      timerStartTime =
          DateTime.fromMillisecondsSinceEpoch(userDocument[_startTimeKey]);
    }
    if (userDocument[_dataKey] != null) {
      for (var item in List.from(userDocument[_dataKey])) {
        print(item);
        _data.add(PatchTimeModel.fromJson(item));
      }
    }
    isLoading = false;
  }

  void save() async {
    await document.updateData({
      _startTimeKey: timerStartTime?.millisecondsSinceEpoch,
      _dataKey: data.map((item) => item.toJson()).toList(),
    });
  }

  void startTimer() async {
    timerStartTime = DateTime.now();
    save();
  }

  void stopTimer() async {
    final elapsedTime = DateTime.now().difference(timerStartTime).inSeconds;

    dataForToday.minutes = dataForToday.minutes + elapsedTime;

    timerStartTime = null;
    save();
  }
}
