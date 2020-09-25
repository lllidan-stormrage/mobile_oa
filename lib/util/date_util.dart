import 'package:mobileoa/model/month.dart';

class DateUtils {
  static String getYyMmDd() {
    var date = DateTime.now();
    return "${date.year.toString().padLeft(2, "0")}/${date.month.toString().padLeft(2, "0")}/${date.day.toString().padLeft(2, "0")}";
  }

  static int getDayInMonth() {
    var date = DateTime.now();
    return getMonthDay(date.year, date.month);
  }

  //时间转时间戳
  static int getTimeStamp(Month value) {
    var dateTime = new DateTime(
        value.year, value.month, value.day, value.hour, value.minute);
    return dateTime.millisecondsSinceEpoch;
  }

  static String getTimeStrByTimeStamp(String timeStamp) {
    int time = int.parse(timeStamp);
    var mDate = DateTime.fromMillisecondsSinceEpoch(time);
    return '${mDate.year}/${mDate.month}/${mDate.day}  ${mDate.hour}:${mDate.minute}';
  }

  static String getTimeOnlyHourMinutesStrByTimeStamp(String timeStamp) {
    int time = int.parse(timeStamp);
    var mDate = DateTime.fromMillisecondsSinceEpoch(time);
    return '${mDate.hour}:${mDate.minute}';
  }

  static String getTimeStrByTimeStampByTime(int year, int month, int day) {
    return '$year/$month/$day';
  }

  //不晓得怎么获取一个月的时间，就先写死吧
  static int getMonthDay(int year, int month) {
    switch (year) {
      case 2020:
        if (month == 6) {
          return 30;
        } else if (month == 7) {
          return 31;
        } else if (month == 8) {
          return 31;
        } else if (month == 9) {
          return 30;
        } else if (month == 10) {
          return 31;
        } else if (month == 11) {
          return 30;
        } else if (month == 12) {
          return 31;
        }
        break;
      case 2021:
        if (month == 1) {
          return 31;
        } else if (month == 2) {
          return 28;
        } else if (month == 3) {
          return 31;
        } else if (month == 4) {
          return 30;
        } else if (month == 5) {
          return 31;
        } else if (month == 6) {
          return 30;
        } else if (month == 7) {
          return 31;
        } else if (month == 8) {
          return 31;
        } else if (month == 9) {
          return 30;
        } else if (month == 10) {
          return 31;
        } else if (month == 11) {
          return 30;
        } else if (month == 12) {
          return 31;
        }
        break;
      case 2022:
        if (month == 1) {
          return 31;
        } else if (month == 2) {
          return 28;
        } else if (month == 3) {
          return 31;
        } else if (month == 4) {
          return 30;
        } else if (month == 5) {
          return 31;
        } else if (month == 6) {
          return 30;
        } else if (month == 7) {
          return 31;
        } else if (month == 8) {
          return 31;
        } else if (month == 9) {
          return 30;
        } else if (month == 10) {
          return 31;
        } else if (month == 11) {
          return 30;
        } else if (month == 12) {
          return 31;
        }
        break;
    }
    return 30;
  }
}
