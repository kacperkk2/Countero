import 'package:countero/models/cost_record.dart';
import 'package:flutter/material.dart';

import '../dates_formatter.dart';

class NewCostRecordControllers {
  TextEditingController name = TextEditingController();
  TextEditingController value = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController category = TextEditingController(text: '1');

  void update(CostRecord costRecord) {
    name.text = costRecord.name;
    value.text = costRecord.amount.toString();
    date.text = toCostDateTimeString(costRecord.date);
    category.text = costRecord.categoryId.toString();
  }
}

CostRecord controllersToCostRecord(NewCostRecordControllers controllers) {
  CostRecord costRecord = CostRecord();
  costRecord.name = controllers.name.text;
  costRecord.categoryId = int.parse(controllers.category.text);
  costRecord.amount = double.parse(controllers.value.text);
  costRecord.date = toCostDateTime(controllers.date.text);
  return costRecord;
}