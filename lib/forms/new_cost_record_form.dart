import 'package:countero/dates_formatter.dart';
import 'package:countero/forms/new_cost_record_controllers.dart';
import 'package:countero/models/cost_record.dart';
import 'package:countero/models/profile.dart';
import 'package:countero/models/profile_model.dart';
import 'package:countero/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'new_profile_form_fields.dart';

class NewCostRecordForm extends StatefulWidget {
  final formKey;
  final NewCostRecordControllers controllers;
  final costRecordIdx;

  NewCostRecordForm({this.formKey, this.controllers, this.costRecordIdx});

  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<NewCostRecordForm> {
  @override
  void initState() {
    super.initState();
    if (widget.costRecordIdx != null) {
      updateControllers();
    }
  }

  void updateControllers() {
    final profileModel = Provider.of<ProfileModel>(context, listen: false);
    CostRecord costRecord = profileModel.getCostRecordByIndex(widget.costRecordIdx);
    widget.controllers.update(costRecord);
  }

  @override
  Widget build(BuildContext context) {
    final profileModel = Provider.of<ProfileModel>(context, listen: false);

    return Form(
      key: widget.formKey,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomTextFormField(
              controller: widget.controllers.name,
              label: "Nazwa",
              validator: Validator.defaultValidator(required: true),
            ),
            CustomDateFormField(
              controller: widget.controllers.date,
              label: "Data",
              dateFormat: DateFormat('MMM dd, yyyy', "pl"),
              lastDate: DateTime.now().isAfter(profileModel.profile.dateTo)
                  ? profileModel.profile.dateTo
                  : DateTime.now(),
              initialDate: widget.costRecordIdx == null
                  ? DateTime.now().isAfter(profileModel.profile.dateTo)
                    ? profileModel.profile.dateTo
                    : DateTime.now()
                  : toCostDateTime(widget.controllers.date.text),
              firstDate: profileModel.profile.dateFrom,
            ),
            SizedBox(height: 20.0),
            CustomNumberFormField(
              controller: widget.controllers.value,
              label: "Kwota (zł)",
              validator: Validator.defaultValidator(required: true, positiveValue: true),
            ),
            SizedBox(height: 20.0),
            AppSelect(
              controller: widget.controllers.category,
              items: getCategories(
                  profileModel.profile.categories
              ),
              label: "Kategoria",
              validator: Validator.defaultValidator(required: true, positiveValue: true),
            )
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> getCategories(List<Category> categories) {
    List<Map<String, dynamic>> list = List.generate(
        categories.length,
            (index) => {
          'value': (categories[index].id).toString(),
          'label': categories[index].name
        });
    return list;
  }
}