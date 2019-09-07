import 'package:intl/intl.dart';

class PatchTimeModel {
  String dateAsString;
  int minutes;
  int targetMinutes;

  DateTime get date => DateFormat.yMd().parse(dateAsString);
  set date(value) {
    dateAsString = DateFormat.yMd().format(value);
  }

  PatchTimeModel({this.dateAsString, this.minutes, this.targetMinutes});
  PatchTimeModel.fromDate(DateTime date, int minutes, int targetMinutes) {
    this.date = date;
    this.minutes = minutes;
    this.targetMinutes = targetMinutes;
  }

  PatchTimeModel.fromJson(Map<dynamic, dynamic> json)
      : dateAsString = json['date'],
        minutes = json['minutes'],
        targetMinutes = json['target-minutes'];

  Map<dynamic, dynamic> toJson() => {
        'date': DateFormat.yMd().format(date),
        'minutes': minutes,
        'target-minutes': targetMinutes
      };
}
