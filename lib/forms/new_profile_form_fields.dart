import 'package:countero/forms/get_date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class CustomNumberFormField extends StatelessWidget {
  final String Function(String value) validator;
  final String label;
  final String helpText;
  final TextEditingController controller;

  CustomNumberFormField({
    this.label,
    this.controller,
    this.helpText,
    this.validator
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(fontSize: 17.0),
      inputFormatters: [
        CustomNumberTextInputFormatter(),
        FilteringTextInputFormatter.allow(RegExp(r'^\d{1,6}(\.\d{0,2})?'))
      ],
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(1.0),
        isDense: true,
        labelText: label,
        helperText: helpText,
        errorMaxLines: 2,
      ),
      keyboardType: TextInputType.number,
      validator: validator,
    );
  }
}

class CustomNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue) {
    var selectionIndex = newValue.selection.end;
    return TextEditingValue(
        text: newValue.text.replaceAll(",", "."),
        selection: TextSelection.collapsed(offset: selectionIndex)
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final String Function(String value) validator;
  final String label;
  final int maxLength;
  final TextEditingController controller;

  CustomTextFormField({
    this.label,
    this.controller,
    this.maxLength = 50,
    this.validator
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLength: maxLength,
      textCapitalization: TextCapitalization.sentences,
      style: TextStyle(fontSize: 17.0),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(1.0),
        isDense: true,
        labelText: label,
        errorMaxLines: 2,
      ),
      keyboardType: TextInputType.name,
      validator: validator,
    );
  }
}

class BeginDateField extends StatelessWidget {
  final TextEditingController controller;

  BeginDateField({this.controller});

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    return CustomDateFormField(
      controller: controller,
      label: "Data rozpoczecia",
      lastDate: currentDate.add(Duration(days: 366 * 10)),
      firstDate: currentDate,
      initialDate: currentDate,
    );
  }
}

class FinishDateField extends StatelessWidget {
  final TextEditingController controller;
  final String Function(String) validator;

  FinishDateField({this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    return CustomDateFormField(
      controller: controller,
      label: "Data zakonczenia",
      lastDate: currentDate.add(Duration(days: 366 * 10)),
      initialDate: DateTime(currentDate.year, currentDate.month + 1, 1),
      firstDate: currentDate,
      validator: validator,
    );
  }
}

class CustomDateFormField extends StatelessWidget {
  final String Function(String value) validator;
  final String label;
  final TextEditingController controller;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateFormat dateFormat;

  CustomDateFormField({
    this.dateFormat,
    this.label,
    this.controller,
    this.validator,
    this.initialDate,
    @required this.lastDate,
    @required this.firstDate,
  });

  @override
  Widget build(BuildContext context) {
    return GetDateField(
      dateFormat: dateFormat,
      controller: controller,
      labelText: label,
      suffixIcon: Icon(Icons.calendar_today_outlined, size: 20),
      lastDate: lastDate,
      initialDate: initialDate,
      firstDate: firstDate,
      validator: validator,
    );
  }
}