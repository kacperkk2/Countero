import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
          SizedBox(height: 15,),
          RawMaterialButton(
            onPressed: () {},
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
