import 'package:countero/pages/edit_categories.dart';
import 'package:countero/validators/validators.dart';
import 'package:flutter/material.dart';
import 'new_profile_controllers.dart';
import 'new_profile_form_fields.dart';

class NewProfileForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final NewProfileControllers controllers;
  final int fixedCostCount;
  final int categoriesCount;
  final bool leaveDates;

  NewProfileForm({
    this.formKey,
    this.controllers,
    this.fixedCostCount,
    this.categoriesCount,
    this.leaveDates = false,
  });

  @override
  _NewProfileForm createState() => _NewProfileForm();
}

class _NewProfileForm extends State<NewProfileForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: ListView(
        children: <Widget>[
          EarningsAndTargetSection(
              controllers: widget.controllers.data,
              leaveDates: widget.leaveDates
          ),
          FixedCostsSection(
              controllers: widget.controllers,
              fixedCostCount: widget.fixedCostCount,
              leaveDates: widget.leaveDates
          ),
          CategoriesSection(
              controllers: widget.controllers.categories,
              categoriesCount: widget.categoriesCount
          ),
          SizedBox(height: 30.0)
        ],
      ),
    );
  }
}

class EarningsAndTargetSection extends StatefulWidget {
  final BasicDataControllers controllers;
  final bool leaveDates;

  EarningsAndTargetSection({this.controllers, this.leaveDates});

  @override
  _EarningsAndTargetSectionState createState() => _EarningsAndTargetSectionState();
}

class _EarningsAndTargetSectionState extends State<EarningsAndTargetSection> {
  bool minimized = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ToggledHeader("Wplywy oraz cel", onClick: changeToggled),
        Offstage(
          offstage: minimized,
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomNumberFormField(
                  controller: widget.controllers.earnings,
                  label: "Miesięczne wplywy (zł)",
                  validator:
                  Validator.defaultValidator(required: true, positiveValue: true),
                ),
                SizedBox(height: 20.0),
                CustomNumberFormField(
                  controller: widget.controllers.target,
                  label: "Cel do zaoszczedzenia (zł)",
                  validator:
                  Validator.targetValidator(controllers: widget.controllers),
                ),
                SizedBox(height: 20.0),
                BeginDateField(
                  controller: widget.controllers.dateFrom,
                  leaveDates: widget.leaveDates,
                ),
                SizedBox(height: 20.0),
                FinishDateField(
                  controller: widget.controllers.dateTo,
                  leaveDates: widget.leaveDates,
                  validator: Validator.datesValidator(
                    beginDateController: widget.controllers.dateFrom
                  )
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void changeToggled() {
    setState(() {
      minimized = !minimized;
    });
  }
}

class ToggledHeader extends StatefulWidget {
  final String headerName;
  final VoidCallback onClick;

  ToggledHeader(this.headerName, {this.onClick});

  @override
  _ToggledHeaderState createState() => _ToggledHeaderState();
}

class _ToggledHeaderState extends State<ToggledHeader> {
  bool minimized = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onClick.call();
        setState(() {
          minimized = !minimized;
        });
      },
      child: Container(
        height: 40,
        width: double.infinity,
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.headerName,
                  style: TextStyle(color: Theme.of(context).primaryColorLight),
                ),
              ),
              Icon(minimized
                  ? Icons.arrow_drop_up
                  : Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}

class FixedCostsSection extends StatefulWidget {
  final NewProfileControllers controllers;
  final int fixedCostCount;
  final bool leaveDates;

  FixedCostsSection({this.controllers, this.fixedCostCount, this.leaveDates});

  @override
  _FixedCostsSectionState createState() => _FixedCostsSectionState();
}

class _FixedCostsSectionState extends State<FixedCostsSection> {
  bool minimized = false;
  int listSize;

  @override
  void initState() {
    super.initState();
    if (widget.fixedCostCount != null) {
      listSize = widget.fixedCostCount;
    }
    else {
      listSize = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = List.generate(
        listSize * 2,
        (index) => index.isEven
        ? Padding(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: FixedCostSectionElement(
              controllers: widget.controllers.fixedCosts[index ~/ 2],
              onRemove: () => pop(index ~/ 2),
              leaveDates: widget.leaveDates
          ),
        )
        : Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Divider(
              thickness: 2, color: Theme.of(context).primaryColor),
        )
    );
    list.add(AddListElementButton(onPressed: append));

    return Column(
      children: [
        ToggledHeader("Co miesieczne koszty stale", onClick: changeToggled),
        Offstage(
            offstage: minimized,
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: list,
            )
        )
      ],
    );
  }

  void changeToggled() {
    setState(() {
      minimized = !minimized;
    });
  }

  void append() {
    setState(() {
      listSize += 1;
      widget.controllers.fixedCosts.add(FixedCostsControllers());
    });
  }

  void pop(int index) {
    setState(() {
      listSize -= 1;
      widget.controllers.fixedCosts.removeAt(index);
    });
  }
}

class AddListElementButton extends StatelessWidget {
  final VoidCallback onPressed;

  AddListElementButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(top: 18.0, bottom: 18.0),
        child: Container(
          decoration: ShapeDecoration(
            color: Theme.of(context).accentColor,
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: Icon(Icons.add),
            color: Colors.white,
            onPressed: () => onPressed.call(),
          ),
        ),
      ),
    );
  }
}

class FixedCostSectionElement extends StatefulWidget {
  final VoidCallback onRemove;
  final FixedCostsControllers controllers;
  final bool leaveDates;

  FixedCostSectionElement({this.controllers, this.onRemove, this.leaveDates});

  @override
  _FixedCostSectionElementState createState() => _FixedCostSectionElementState();
}

class _FixedCostSectionElementState extends State<FixedCostSectionElement> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              width: 300.0,
              child: CustomTextFormField(
                controller: widget.controllers.name,
                label: "Nazwa",
                validator: Validator.defaultValidator(required: true),
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              icon: Align(
                alignment: Alignment.center,
                child: Icon(Icons.delete_outline_rounded, size: 30)),
              onPressed: () => widget.onRemove.call()
            )
          ],
        ),
        SizedBox(
          width: 300.0,
          child: CustomNumberFormField(
            controller: widget.controllers.amount,
            label: "Kwota",
            validator: Validator.defaultValidator(required: true, positiveValue: true),
          ),
        ),
        SizedBox(height: 20.0),
        BeginDateField(
          controller: widget.controllers.dateFrom,
          leaveDates: widget.leaveDates,
        ),
        SizedBox(height: 20.0),
        FinishDateField(
          controller: widget.controllers.dateTo,
          validator: Validator.datesValidator(
          beginDateController: widget.controllers.dateFrom),
          leaveDates: widget.leaveDates,
        ),
      ],
    );
  }
}

class CategoriesSection extends StatefulWidget {
  final List<CategoriesControllers> controllers;
  final int categoriesCount;

  CategoriesSection({this.controllers, this.categoriesCount});
  
  @override
  _CategoriesSectionState createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  bool minimized = false;
  int listSize;

  @override
  void initState() {
    super.initState();
    if (widget.categoriesCount != null) {
      listSize = widget.categoriesCount;
    }
    else {
      listSize = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = List.generate(
        listSize * 2,
        (index) => index.isEven
        ? Padding(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: CategoriesSectionElement(
              controllers: widget.controllers[index ~/ 2],
              onRemove: () => pop(index ~/ 2)
          )
        )
        : Padding(
          padding: EdgeInsets.only(top: 20.0),
            child: Divider(
                thickness: 2, color: Theme.of(context).primaryColor),
        )
    );
    list.add(AddListElementButton(onPressed: append));

    return Column(
      children: [
        ToggledHeader("Kategorie wydatkow", onClick: changeToggled),
        Offstage(
          offstage: minimized,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: list,
          ),
        )
      ],
    );
  }

  void changeToggled() {
    setState(() {
      minimized = !minimized;
    });
  }

  void append() {
    setState(() {
      listSize += 1;
      widget.controllers.add(CategoriesControllers());
    });
  }

  void pop(int index) {
    setState(() {
      listSize -= 1;
      widget.controllers.removeAt(index);
    });
  }
}

class CategoriesSectionElement extends StatefulWidget {
  final VoidCallback onRemove;
  final CategoriesControllers controllers;

  CategoriesSectionElement({this.controllers, this.onRemove});

  @override
  _CategoriesSectionElementState createState() => _CategoriesSectionElementState();
}

class _CategoriesSectionElementState extends State<CategoriesSectionElement> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              width: 300.0,
              child: CustomTextFormField(
                maxLength: 25,
                controller: widget.controllers.name,
                label: "Nazwa",
                validator: Validator.defaultValidator(required: true),
              ),
            ),
            IconButton(
                padding: EdgeInsets.zero,
                icon: Align(
                    alignment: Alignment.center,
                    child: Icon(Icons.delete_outline_rounded, size: 30)),
                onPressed: () => widget.onRemove.call()
            )
          ],
        ),
        SizedBox(
          width: 300.0,
          child: CustomNumberFormField(
            controller: widget.controllers.limit,
            label: "Limit (zł)",
            helpText: "Puste pole oznacza brak limitu",
            validator: Validator.defaultValidator(positiveValue: true),
          ),
        ),
      ],
    );
  }
}