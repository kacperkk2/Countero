import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Informacje"),
        ),
        body: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Countero to aplikacja, która pomoże Ci monitorować swój codzienny budżet. "
                    "Dzięki większej kontroli łatwiej będzie Ci zacząć oszczędzać. "
                    "Aplikacja przechowuje wprowadzone wpisy o wydatkach oraz na bieżąco "
                    "aktualizuje Twoje cele.",
                style: TextStyle(fontSize: 17.0, color: Theme.of(context).primaryColorLight),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 30.0),
              Text(
                "Możliwe jest ustalenie zestawu kategorii dla wydatków oraz kosztów stałych, "
                    "czyli takich które co miesiąc należy opłacić np. czynsz. "
                    "Aplikacja w oparciu o Twoje dochody oraz wydatki określi kwoty zaoszczędzone w każdym miesiącu.",
                style: TextStyle(fontSize: 17.0, color: Theme.of(context).primaryColorLight),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 30.0),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(0.0),
                    width: 50.0, // you can adjust the width as you need
                    child: Icon(Icons.attach_money, size: 35.0, color: Theme.of(context).primaryColorLight),
                  ),
                  Container(
                    padding: const EdgeInsets.all(0.0),
                    width: 60.0, // you can adjust the width as you need
                    child: Icon(Icons.attach_money, size: 48.0, color: Theme.of(context).primaryColorLight),
                  ),
                  Container(
                    padding: const EdgeInsets.all(0.0),
                    width: 70.0, // you can adjust the width as you need
                    child: Icon(Icons.attach_money, size: 60.0, color: Theme.of(context).primaryColorLight),
                  ),
                  Container(
                    padding: const EdgeInsets.all(0.0),
                    width: 80.0, // you can adjust the width as you need
                    child: Icon(Icons.attach_money, size: 80.0, color: Theme.of(context).primaryColorLight),
                  ),
                  Container(
                    padding: const EdgeInsets.all(0.0),
                    width: 50.0, // you can adjust the width as you need
                    child: Icon(Icons.attach_money, size: 115.0, color: Theme.of(context).accentColor),
                  ),
                ]
              ),
              SizedBox(height: 30.0),
              Text(
                "Załóż profil aby przekonać się, że oszczędzanie z Countero jest ŁATWIEJSZE!",
                style: TextStyle(fontSize: 23.0, color: Theme.of(context).accentColor),
                textAlign: TextAlign.justify,
              ),
            ]
          )
      )
    );
  }
}
