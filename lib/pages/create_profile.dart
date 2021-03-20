import 'package:countero/forms/new_profile_controllers.dart';
import 'package:countero/models/profile.dart';
import 'package:countero/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:countero/forms/new_profile_form.dart';
import 'package:provider/provider.dart';

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
      floatingActionButton: CreateProfileButton(
          formKey: formKey, onClick: () => createProfile(context)
      )
    );
  }

  void createProfile(BuildContext context) {
    Profile profile = controllersToProfile(controllers);
    var profileModel = Provider.of<ProfileModel>(context, listen: false);
    profileModel.profile = profile;
    Navigator.pop(context);
  }
}

class CreateProfileButton extends StatelessWidget {
  final VoidCallback onClick;
  final GlobalKey<FormState> formKey;

  CreateProfileButton({this.formKey, this.onClick});

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
      label: Text('Utworz profil'),
      icon: Icon(Icons.create),
      backgroundColor: Theme.of(context).accentColor,
    );
  }
}


