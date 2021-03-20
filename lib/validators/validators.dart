import 'package:countero/forms/new_profile_controllers.dart';
import 'package:flutter/material.dart';
import '../dates_formatter.dart';


class Validator {
  static Function(String) defaultValidator({
    bool required=false,
    bool positiveValue=false,
    bool nonNegativeValue=false
  }) {
    return (String value) {
      if (required && value.isEmpty) {
        return "To pole jest wymagane";
      }
      if (positiveValue && (value.isNotEmpty && double.parse(value) <= 0)) {
        return "Pole musi zawierac wartosc wieksza niz 0";
      }
      if (positiveValue && (value.isNotEmpty && double.parse(value) < 0)) {
        return "Pole nie moze zawierac wartosci mniejszej niz 0";
      }
      return null;
    };
  }

  static Function(String) datesValidator({
    @required TextEditingController beginDateController
  }) {
    return (String dateTo) {
      DateTime parsedDateFrom = toDateTime(beginDateController.text);
      DateTime parsedDateTo = toDateTime(dateTo);
      int monthDiff = getDatesMonthDiff(parsedDateFrom, parsedDateTo);
      if (monthDiff <= 0) {
        return "Data rozpoczecia jest pozniejsza niz data zakonczenia";
      }
      return null;
    };
  }

  static Function(String) targetValidator({
    @required BasicDataControllers controllers
  }) {
    return (String value) {
      String monthlyIncome = controllers.earnings.text;
      String spareGoal = controllers.target.text;
      DateTime dateFrom = toDateTime(controllers.dateFrom.text);
      DateTime dateTo = toDateTime(controllers.dateTo.text);
      if (spareGoal.isEmpty) {
        return "To pole jest wymagane";
      }
      if (monthlyIncome.isEmpty) {
        return null;
      }
      int monthsDiff = getDatesMonthDiff(dateFrom, dateTo);
      if (monthsDiff * double.parse(monthlyIncome) < double.parse(spareGoal)) {
        return "Nie mozliwe jest zaoszczedzic taka kwote w tym okresie przy podanych przychodach";
      }
      return null;
    };
  }
}