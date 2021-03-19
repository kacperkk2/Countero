import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GetDateField extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateFormat dateFormat;
  final FocusNode focusNode;
  final String labelText;
  final Icon prefixIcon;
  final Icon suffixIcon;
  final String Function(String) validator;
  final TextEditingController controller;

  GetDateField({
    Key key,
    this.controller,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.dateFormat,
    this.initialDate,
    this.validator,
    @required this.lastDate,
    @required this.firstDate,
  })  : assert(firstDate != null),
        assert(lastDate != null),
        super(key: key) {
    assert(!this.lastDate.isBefore(this.firstDate),
    'lastDate ${this.lastDate} must be on or after firstDate ${this.firstDate}.');
    assert(
    initialDate == null ||
        (initialDate != null && !this.initialDate.isBefore(this.firstDate)),
    'initialDate ${this.initialDate} must be on or after firstDate ${this.firstDate}.');
  }

  @override
  _GetDateFieldState createState() => _GetDateFieldState();
}

class _GetDateFieldState extends State<GetDateField> {
  DateFormat _dateFormat;
  DateTime _selectedDate;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    if (widget.dateFormat != null) {
      _dateFormat = widget.dateFormat;
    } else {
      _dateFormat = new DateFormat('MMM yyyy', "pl");
    }

    _selectedDate = widget.initialDate;

    _controller =
    widget.controller == null ? TextEditingController() : widget.controller;

    _controller.text =
    _selectedDate != null ? _dateFormat.format(_selectedDate) : null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      controller: _controller,
      style: TextStyle(fontSize: 17.0),
      validator: widget.validator,
      decoration: InputDecoration(
        errorMaxLines: 3,
        isDense: true,
        contentPadding: EdgeInsets.all(1.0),
        prefixIcon: widget.prefixIcon != null
            ? Padding(
          padding: EdgeInsets.only(top: 11.0),
          child: widget.prefixIcon,
        )
            : widget.prefixIcon,
        suffixIcon: Container(
          height: 48,
          width: 48,
          child: widget.suffixIcon != null
              ? Padding(
              padding: EdgeInsets.only(top: 11.0),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: widget.suffixIcon))
              : widget.suffixIcon,
        ),
        labelText: widget.labelText,
      ),
      onTap: () => _selectDate(context),
      readOnly: true,
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      locale: const Locale("pl", "PL"),
      initialDate: _selectedDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      _selectedDate = pickedDate;
      _controller.text = _dateFormat.format(_selectedDate);
    }

    if (widget.focusNode != null) {
      widget.focusNode.nextFocus();
    }
  }
}
