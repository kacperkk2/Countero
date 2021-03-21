import 'package:countero/pages/user_cost_records.dart';
import 'package:countero/pages/user_reports.dart';
import 'package:flutter/material.dart';
import 'package:countero/models/profile_model.dart';
import 'package:provider/provider.dart';

import '../routing.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  static const String APP_NAME = 'Countero';

  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Consumer<ProfileModel>(
      builder: (
          BuildContext context,
          profileModel,
          Widget child) {
        return Scaffold(
            appBar: AppBar(
              title: Text(
                APP_NAME,
                style: Theme.of(context).textTheme.headline2,
              ),
              bottom: profileModel.profile == null
                  ? null
                  : getTabs(context, tabController),
              actions: [
                HomeSettings(profileModel.profile != null)
              ],
            ),
            body: profileModel.profile == null
                ? HomeEmpty()
                : HomeWithProfile(tabController),
        );
      });
  }
}


class HomeEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Rozpocznij!",
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(height: 30,),
            RawMaterialButton(
              onPressed: () {
                Navigator.pushNamed(
                    context,
                    MyRoute.CREATE_PROFILE.route
                );
              },
              elevation: 2.0,
              fillColor: Theme.of(context).accentColor,
              textStyle: Theme.of(context).textTheme.headline1,
              child: Icon(
                Icons.attach_money,
                size: 100.0,
              ),
              padding: EdgeInsets.all(30.0),
              shape: CircleBorder(),
            ),
          ]
      ),
    );
  }
}

class HomeWithProfile extends StatelessWidget {
  final TabController tabController;

  HomeWithProfile(this.tabController);

  @override
  Widget build(BuildContext context) {
    return TabBarView(
        controller: tabController,
        children: [
          UserCostRecords(),
          UserReports()
        ]
    );
  }
}

enum SettingsElement {
  DELETE_PROFILE,
  TEST_PROFILE
}

class HomeSettings extends StatelessWidget {
  final bool profileLoaded;

  HomeSettings(this.profileLoaded);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SettingsElement>(
      icon: Icon(Icons.more_vert),
      onSelected: (choice) => onSelected(context, choice),
      itemBuilder: (BuildContext context) => getAvailableSettings(context),
    );
  }

  void onSelected(BuildContext context, SettingsElement choice) {
    switch (choice) {
      case SettingsElement.DELETE_PROFILE:
        deleteProfile(context);
        break;
      case SettingsElement.TEST_PROFILE:
        //TODO add test profile to test app
        break;
    }
  }

  Future<void> deleteProfile(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Na pewno usunac profil?"),
          content: Text('Tej operacji nie da sie cofnac'),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cofnij',
                style: TextStyle(color: Theme.of(context).accentColor, fontSize: 18.0)
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Usuń',
                style: TextStyle(color: Theme.of(context).accentColor, fontSize: 18.0)
              ),
              onPressed: () {
                var profileModel = Provider.of<ProfileModel>(context, listen: false);
                profileModel.deleteCostRecords();
                profileModel.deleteProfile();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<PopupMenuItem<SettingsElement>> getAvailableSettings(BuildContext context) {
    List<PopupMenuItem<SettingsElement>> itemList = [];
    if (!profileLoaded) {
      itemList.add(PopupMenuItem<SettingsElement>(
          value: SettingsElement.TEST_PROFILE,
          child: Row(
            children: [
              Icon(Icons.handyman, color: Theme
                  .of(context)
                  .iconTheme
                  .color),
              SizedBox(width: 8),
              Expanded(child: Text(
                  'Testowy profil', style: TextStyle(fontSize: 17.0))),
            ],
          )
      ));
    }
    if (profileLoaded) {
      itemList.add(PopupMenuItem<SettingsElement>(
          value: SettingsElement.DELETE_PROFILE,
          child: Row(
            children: [
              Icon(Icons.delete_outlined, color: Theme.of(context).iconTheme.color),
              SizedBox(width: 8),
              Expanded(child: Text('Usun profil', style: TextStyle(fontSize: 17.0))),
            ],
          )
      ));
    }
    return itemList;
  }
}

TabBar getTabs(BuildContext context, TabController controller) {
  return TabBar(
    controller: controller,
    labelColor: Theme.of(context).accentColor,
    unselectedLabelColor: Theme.of(context).primaryColorLight,
    tabs: [
      Tab(
        icon: Icon(Icons.money_rounded, size: 27.5),
        child: Text("REKORDY", style: TextStyle(fontSize: 15.0)),
      ),
      Tab(
        icon: Icon(Icons.stacked_line_chart, size: 25.5),
        child: Text("RAPORTY", style: TextStyle(fontSize: 15.0)),
      ),
    ],
  );
}
