import 'dart:math';

import 'package:flustars/flustars.dart';
import 'package:sprintf/sprintf.dart';
import 'package:intl/intl.dart';
export 'package:common_utils/common_utils.dart';

/// int 拓展
extension IntExtension on int {
  String formatTime({String? format}) {
    //不满足13位,也就是当前不是毫秒,补足变成毫秒
    return DateUtil.formatDate(DateTime.fromMillisecondsSinceEpoch(toMs()), format: format);
  }

  int toMs() {
    final int leftLength = 13 - toString().length;
    int resultTime = this;
    if (leftLength > 0) {
      resultTime = this * (pow(10, leftLength) as int);
    }
    return resultTime;
  }

  DateTime toDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(this);
  }

  String toAmOrPmTime() {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(toMs());
    int hour = date.hour;
    hour = hour > 12 ? hour - 12 : hour;
    return '${hour >= 10 ? hour : '0$hour'}:${date.minute >= 10 ? date.minute : '0${date.minute}'}${hour > 12 ? ' PM' : ' AM'}';
  }

  String commonDateTime({bool showTime = false}) {
    if(0 == this){
      return '';
    }
    final int currentSeconds = DateUtil.getNowDateMs();
    if (isToDay(this, currentSeconds)) {
      return formatTime(format: DateFormats.h_m);
    }
    if (isYesterday(this, currentSeconds)) {
      return showTime?'昨天 ${formatTime(format: DateFormats.h_m)}':'昨天';
    }

    if (isSameWeek(this, currentSeconds)) {
      return DateUtil.getWeekday(DateTime.fromMillisecondsSinceEpoch(this * 1000), languageCode: "zh");
    }

    if (isSameYear(this, currentSeconds)) {
      return formatTime(format:showTime? 'MM月dd日 HH:mm':'MM月dd日');
    }
    return formatTime(format: showTime?'yyyy年MM月dd日 HH:mm':'yyyy年MM月dd日');
  }

}

bool isToDay(int time, int other) {
  final DateTime dateTime = time.toDateTime();
  final DateTime otherDateTime = other.toDateTime();
  final int year = dateTime.year;
  final int month = dateTime.month;
  final int day = dateTime.day;
  final int otherYear = otherDateTime.year;
  final int otherMonth = otherDateTime.month;
  final int otherDay = otherDateTime.day;
  return year == otherYear && month == otherMonth && day == otherDay;
}

bool isYesterday(int time, int other) {
  final DateTime dateTime = time.toDateTime();
  final DateTime otherDateTime = other.toDateTime();
  final int year = dateTime.year;
  final int month = dateTime.month;
  final int day = dateTime.day;
  final int otherYear = otherDateTime.year;
  final int otherMonth = otherDateTime.month;
  final int otherDay = otherDateTime.day;
  return year == otherYear && month == otherMonth && day - otherDay == -1;
}

bool isSameWeek(int time, int other) {
  final DateTime dateTime = time.toDateTime();
  final DateTime otherDateTime = other.toDateTime();
  final int year = dateTime.year;
  final int month = dateTime.month;
  final int week = dateTime.weekday;
  final int otherYear = otherDateTime.year;
  final int otherMonth = otherDateTime.month;
  final int otherWeek = otherDateTime.weekday;
  return year == otherYear && month == otherMonth && week == otherWeek;
}

bool isSameYear(int time, int other) {
  final DateTime dateTime = time.toDateTime();
  final DateTime otherDateTime = other.toDateTime();
  final year = dateTime.year;
  final otherYear = otherDateTime.year;
  return year == otherYear;
}


extension doubleExt on double{

  String  get formatDecimals{
    NumberFormat numberFormat = NumberFormat("###0.00", "zh");
    return numberFormat.format(this);
  }

}