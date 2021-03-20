import 'package:intl/intl.dart';

DateFormat MMM_yyyy = new DateFormat('MMM yyyy', "pl");
DateFormat MM_yyyy = new DateFormat('MM-yyyy', "pl");
DateFormat dd_MMM = new DateFormat('dd MMM', "pl");
DateFormat MMMM = new DateFormat('MMMM', "pl");
DateFormat yyyy = new DateFormat('yyyy', "pl");
DateFormat dd = new DateFormat('dd', "pl");
DateFormat MMM_dd_yyyy = new DateFormat('MMM dd, yyyy', "pl");

DateTime toDateTime(String s) {
  return MMM_yyyy.parse(s);
}

String toDateString(DateTime date) {
  return MMM_yyyy.format(date);
}

String toSparedLine(DateTime date) {
  return MM_yyyy.format(date);
}

String toDayMonth(DateTime date) {
  return dd_MMM.format(date);
}

String toMonth(DateTime date) {
  return MMMM.format(date);
}

String toYear(DateTime date) {
  return yyyy.format(date);
}

String toDay(DateTime date) {
  return dd.format(date);
}

DateTime toCostDateTime(String s) {
  return MMM_dd_yyyy.parse(s);
}

String toCostDateTimeString(DateTime date) {
  return MMM_dd_yyyy.format(date);
}

List<DateTime> generateRangeInMonths(DateTime from, DateTime to) {
  int fromMonth = from.month;
  int fromYear = from.year;

  List<DateTime> result = [];
  while (fromMonth != to.month || fromYear != to.year) {
    result.add(DateTime(fromYear, fromMonth, 1));
    if (fromMonth == 12) {
      fromYear += 1;
      fromMonth = 1;
    }
    else {
      fromMonth += 1;
    }
  }

  result.add(to);
  return result;
}

bool monthInRange(DateTime current, DateTime from, DateTime to) {
  var fromToMonthDiff = getDatesMonthDiff(from, to);
  var currentFromMonthDiff = getDatesMonthDiff(from, current);

  if (currentFromMonthDiff < 0 || currentFromMonthDiff > fromToMonthDiff) {
    return false;
  }
  else {
    return true;
  }
}

int getDatesMonthDiff(DateTime dateFrom, DateTime dateTo) {
  int yearDiff = dateTo.year - dateFrom.year;
  int monthDiff = dateTo.month - dateFrom.month + yearDiff * 12;
  return monthDiff;
}

bool isSameYear(DateTime d1, DateTime d2) {
  return d1.year == d2.year;
}

DateTime setDayAsLast(DateTime date) {
  DateTime result;
  if (date.month == 12) {
    result = DateTime(date.year + 1, 1, 1).subtract(Duration(days: 1));
  }
  else {
    result = DateTime(date.year, date.month + 1, 1).subtract(Duration(days: 1));
  }
  return result;
}