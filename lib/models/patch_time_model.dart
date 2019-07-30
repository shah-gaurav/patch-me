import 'package:intl/intl.dart';

class PatchTimeModel {
  String dateAsString;
  int minutes;

  DateTime get date => DateFormat.yMd().parse(dateAsString);
  set date(value) {
    dateAsString = DateFormat.yMd().format(value);
  }

  PatchTimeModel({this.dateAsString, this.minutes});
  PatchTimeModel.fromDate(DateTime date, int minutes) {
    this.date = date;
    this.minutes = minutes;
  }

  PatchTimeModel.fromJson(Map<dynamic, dynamic> json)
      : dateAsString = json['date'],
        minutes = json['minutes'];

  Map<dynamic, dynamic> toJson() => {
        'date': DateFormat.yMd().format(date),
        'minutes': minutes,
      };
}
