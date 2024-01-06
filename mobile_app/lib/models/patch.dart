import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Patch {
  int patchTimePerDay;
  bool? timerRunning;
  int? timeRemaining;
  int? startTime;
  List<String> tokens;
  List<PatchData> data;

  Patch({
    required this.patchTimePerDay,
    this.timerRunning,
    this.timeRemaining,
    this.startTime,
    this.tokens = const [],
    this.data = const [],
  });

  int get secondsSinceTimerStarted {
    if (timerRunning == true) {
      return DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(startTime!))
          .inSeconds;
    }
    return 0;
  }

  PatchData get patchDataForToday => data.firstWhere(
      (element) => DateUtils.isSameDay(element.date, DateTime.now()),
      orElse: () => PatchData(
            date: DateTime.now(),
            minutes: 0,
            targetMinutes: patchTimePerDay,
          ));

  int get totalTimePatchedToday {
    if (timerRunning == true) {
      return patchDataForToday.minutes +
          DateTime.now()
              .difference(
                DateTime.fromMillisecondsSinceEpoch(startTime!),
              )
              .inMinutes;
    }
    return patchDataForToday.minutes;
  }

  factory Patch.fromJson(Map<String, dynamic> json) => Patch(
        patchTimePerDay: json["patch-time-per-day"],
        timerRunning: json["timer-running"],
        timeRemaining: json["time-remaining"],
        startTime: json["start-time"],
        tokens: json["tokens"] == null
            ? []
            : List<String>.from(json["tokens"]!.map((x) => x)),
        data: json["data"] == null
            ? []
            : List<PatchData>.from(
                json["data"]!.map((x) => PatchData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "patch-time-per-day": patchTimePerDay,
        "timer-running": timerRunning,
        "time-remaining": timeRemaining,
        "start-time": startTime,
        "tokens": List<dynamic>.from(tokens.map((x) => x)),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class PatchData {
  DateTime date;
  int minutes;
  int targetMinutes;

  PatchData({
    required this.date,
    required this.minutes,
    required this.targetMinutes,
  });

  factory PatchData.fromJson(Map<String, dynamic> json) => PatchData(
        date: DateFormat.yMd().parse(json["date"]),
        minutes: json["minutes"],
        targetMinutes: json["target-minutes"],
      );

  Map<String, dynamic> toJson() => {
        "date": DateFormat.yMd().format(date),
        "minutes": minutes,
        "target-minutes": targetMinutes,
      };
}
