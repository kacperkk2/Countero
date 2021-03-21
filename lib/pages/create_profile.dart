import 'package:countero/forms/new_profile_controllers.dart';
import 'package:countero/models/cost_record.dart';
import 'package:countero/models/profile.dart';
import 'package:countero/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:countero/forms/new_profile_form.dart';
import 'package:provider/provider.dart';

import '../dates_formatter.dart';

class CreateProfile extends StatelessWidget {
  final controllers = NewProfileControllers();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tworzenie profilu"),
      ),
      body: NewProfileForm(
        formKey: formKey,
        controllers: controllers,
      ),
      floatingActionButton: CustomSaveButton(
          formKey: formKey, onClick: () => createProfile(context)
      )
    );
  }

  void createProfile(BuildContext context) {
    Profile profile = controllersToProfile(controllers);
    var profileModel = Provider.of<ProfileModel>(context, listen: false);
    profileModel.profile = profile;
    
    List<FixedCost> costs = profile.fixedCosts;
    var monthsRange = generateRangeInMonths(profile.dateFrom, profile.dateTo);
    List<CostRecord> costsInRange = [];
    for (DateTime month in monthsRange) {
      for (FixedCost cost in costs) {
        if (monthInRange(month, cost.dateFrom, cost.dateTo)) {
          costsInRange.add(
              CostRecord(
                  name: cost.name, 
                  amount: cost.amount, 
                  categoryId: 0,
                  date: month
              )
          );
        }
      }
    }
    profileModel.records = costsInRange;
    Navigator.pop(context);
  }
}

class CustomSaveButton extends StatelessWidget {
  final VoidCallback onClick;
  final GlobalKey<FormState> formKey;

  CustomSaveButton({this.formKey, this.onClick});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        if (formKey.currentState.validate()) {
          onClick.call();
        }
        else {
          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content:
              Text('Prosze poprawic pola zaznaczone na czerwono',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).errorColor,
                    fontSize: 15.0,
                  )),
              backgroundColor: Theme.of(context).primaryColor,
            )
          );
        }
      },
      label: Text('Zatwierdź'),
      icon: Icon(Icons.create),
      backgroundColor: Theme.of(context).accentColor,
    );
  }
}


