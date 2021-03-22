import 'package:countero/models/cost_record.dart';
import 'package:countero/models/profile.dart';
import 'package:countero/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../dates_formatter.dart';
import '../routing.dart';

class UserCostRecords extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileModel>(
        builder: (
            BuildContext context,
            profileModel,
            Widget child) {

          var profileDateRange = profileModel.getProfileDateRange();
          var profile = profileModel.profile;
          var costRecordsMap =
              profileModel.getCostRecordsDividedByDateRange(profileDateRange, profile);
          var isDateFromBeforeNow = profile.dateFrom.isBefore(DateTime.now());

          return Scaffold(
            body: isDateFromBeforeNow
                ? profileModel.records.isEmpty
                  ? UserCostRecordsEmpty()
                  : UserCostRecordsNotEmpty(
                    categoryMap: profileModel.categoriesMap,
                    profileModel: profileModel,
                    dateRange: profileDateRange,
                    costRecordsMap: costRecordsMap,
                  )
                : UserCostRecordsDateFromBeforeNow(profile.dateFrom),
            bottomNavigationBar: Visibility(
              visible: isDateFromBeforeNow,
              child: UserCostRecordsSummary(
                monthlyBalance:
                    getDatesMonthDiff(DateTime.now(), profile.dateTo) >= 0
                    ? getAmountOfTheMonth(costRecordsMap[profileDateRange.last], profile)
                    : 0.0,
                totalSpareAmount: profileModel.records.isNotEmpty
                    ? getSavedMoneyAmount(costRecordsMap, profileDateRange)
                    : 0.0,
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Visibility(
              visible: isDateFromBeforeNow,
              child: FloatingActionButton(
                onPressed: () => Navigator.pushNamed(context, MyRoute.MODIFY_COST_RECORD.route),
                child: Icon(Icons.add),
              ),
            ),
          );
        });
  }

  getAmountOfTheMonth(GroupedCostRecords costRecords, Profile profile) {
    return profile.earnings - costRecords.moneyPaid - costRecords.monthTarget;
  }

  getSavedMoneyAmount(
      Map<DateTime, GroupedCostRecords> costRecordsMap,
      List<DateTime> profileDateRange) {
    double result = 0;
    for (int i = profileDateRange.length - 2; i >= 0; --i) {
      result += costRecordsMap[profileDateRange[i]].moneySaved;
    }
    if (getDatesMonthDiff(DateTime.now(), profileDateRange.last) < 0) {
      result += costRecordsMap[profileDateRange.last].moneySaved;
    }
    return result;
  }
}

class UserCostRecordsDateFromBeforeNow extends StatelessWidget {
  final DateTime dateFrom;

  UserCostRecordsDateFromBeforeNow(this.dateFrom);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(21.5),
      child: Center(
          child: Text(
            "Oszczedzanie rozpocznie sie od miesiaca " + toMonth(dateFrom),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15.0),
          )),
    );
  }
}

class UserCostRecordsEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(21.5),
      child: Center(
          child: Text(
            "Brak rekordow",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15.0),
          )),
    );
  }
}

class UserCostRecordsSummary extends StatelessWidget {
  final double monthlyBalance;
  final double totalSpareAmount;

  UserCostRecordsSummary({this.monthlyBalance, this.totalSpareAmount});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "BUDŻET",
                      textAlign: TextAlign.left,
                      style:
                      TextStyle(color: Theme.of(context).primaryColorLight),
                    ),
                  ],
                ),
                Text(
                  "${NumberFormat("###,###,##0.00", "pl_PL").format(monthlyBalance)} zł",
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                      "OSZCZĘDZONO",
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Theme.of(context).primaryColorLight),
                    ),
                  ],
                ),
                Text(
                  "${NumberFormat("###,###,##0.00", "pl_PL").format(totalSpareAmount)} zł",
                  textAlign: TextAlign.right,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class UserCostRecordsNotEmpty extends StatefulWidget {
  final Map<int, Category> categoryMap;
  ProfileModel profileModel;
  final Map<DateTime, GroupedCostRecords> costRecordsMap;
  final List<DateTime> dateRange;

  UserCostRecordsNotEmpty({
    this.categoryMap, 
    this.profileModel,
    this.costRecordsMap, 
    this.dateRange
  });

  @override
  _UserCostRecordsNotEmptyState createState() => _UserCostRecordsNotEmptyState();
}

class _UserCostRecordsNotEmptyState extends State<UserCostRecordsNotEmpty> {

  @override
  void initState() {
    super.initState();
    widget.profileModel = Provider.of<ProfileModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ShaderMask(
        shaderCallback: (Rect rect) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.transparent, Colors.black],
            stops: [0.0, 0.9, 1.0],
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child: ListView(
          children: recordsTiles(),
        ),
      ),
    );
  }

  recordsTiles() {
    bool rangeInSingleYear = isSameYear(widget.dateRange.first, widget.dateRange.last);
    bool rangeInSingleMonth = widget.dateRange.length == 1;
    List<Widget> listTiles = [];
    for (int i = widget.dateRange.length - 1; i >= 0; --i) {
      DateTime date = widget.dateRange[i];
      GroupedCostRecords groupedRecords = widget.costRecordsMap[date];
      if (!rangeInSingleMonth) {
        if (!rangeInSingleYear && date.month == 12) {
          addYearTile(date, listTiles);
        }
        addMonthTile(listTiles, date, groupedRecords);
      }
      else {
        listTiles.add(CustomDivider(first: true));
      }
      addRecordsToList(groupedRecords.records, listTiles);
    }

    listTiles.removeLast();
    listTiles.addAll([
      CustomDivider(last: true),
      Container(
        child: SizedBox(height: 40.0),
        color: Theme.of(context).canvasColor,
      )
    ]);

    return listTiles;
  }

  void addMonthTile(
      List<Widget> listTiles, DateTime date,
      GroupedCostRecords groupedRecords) {
    listTiles.add(MonthTile(
      month: toMonth(date),
      spared: groupedRecords.moneySaved,
      first: listTiles.isEmpty && getDatesMonthDiff(date, DateTime.now()) == 0,
      onAnalyticsTap: () => Navigator.pushNamed(
        context,
        MyRoute.MONTH_CHARTS.route,
        arguments: groupedRecords,
      ),
    ));
    listTiles.add(CustomDivider(first: true));
  }

  void addYearTile(DateTime date, List<Widget> listTiles) {
    listTiles.add(YearTile(year: toYear(date)));
    listTiles.add(CustomDivider(isYearDivider: true));
  }

  addRecordsToList(List<IndexedCostRecord> records, List list) {
    if (records != null && records.isNotEmpty) {
      var expenseTiles = List.generate(
          records.length * 2,
              (index) => index.isEven
              ? CostRecordTile(
                  onTap: () => Navigator.pushNamed(
                      context,
                      MyRoute.MODIFY_COST_RECORD.route,
                      arguments: records[index ~/ 2].index.toString()
                  ),
                name: records[index ~/ 2].name,
                value: records[index ~/ 2].value,
                date: records[index ~/ 2].date,
                category: widget.profileModel.categoriesMap[records[index ~/ 2].categoryId].name,
              )
              : CustomDivider(last: index == records.length * 2 - 1));
      list.addAll(expenseTiles);
    }
    else {
      list.addAll(<Widget>[
        EmptyTile(),
        CustomDivider(last: true),
      ]);
    }
  }
}

class CustomDivider extends StatelessWidget {
  final first;
  final last;
  final removeHeight;
  final isYearDivider;

  CustomDivider({
    this.first = false,
    this.last = false,
    this.removeHeight = false,
    this.isYearDivider = false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: [
            last
                ? Container(
                  child: SizedBox(height: 8.0),
                  color: Theme.of(context).primaryColorDark,
                )
                : Container(),
            Divider(
              thickness: isYearDivider ? 1.0 : 1.25,
              color: isYearDivider
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).primaryColorDark,
              height: first || last || removeHeight || isYearDivider ? 0 : 16,
            ),
            first
                ? Container(
                  child: SizedBox(height: 8.0),
                  color: Theme.of(context).primaryColorDark,
                )
                : Container(),
          ],
        ));
  }
}

class MonthTile extends StatelessWidget {
  final String month;
  final double spared;
  final bool first;
  final VoidCallback onAnalyticsTap;

  MonthTile({this.month, this.spared, this.first = false, this.onAnalyticsTap});

  @override
  Widget build(BuildContext context) {
    String moneyPrefix = spared >= 0 ? "+" : "";
    Color moneyColor = spared >= 0 ? Colors.green[400] : Colors.red[400];

    return Container(
      color: Color(0xFF272727),
      child: Padding(
        padding:
        EdgeInsets.only(top: 6.0, bottom: 6.0, left: 10.0, right: 10.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Visibility(
              visible: !first,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    onPressed: () => onAnalyticsTap.call(),
                    icon: Icon(
                      Icons.read_more,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  Text(
                    moneyPrefix + NumberFormat("###,###,##0.00", "pl_PL").format(spared),
                    style: TextStyle(fontSize: 13.0, color: moneyColor),
                  )
                ],
              ),
            ),
            Center(
              child: Text(
                month.toUpperCase(),
                style: TextStyle(
                    fontSize: 17.0, color: Theme.of(context).primaryColorLight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class YearTile extends StatelessWidget {
  final String year;

  YearTile({this.year});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF272727),
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Center(
          child: Text(
            year,
            style: TextStyle(
                fontSize: 25.0, color: Theme.of(context).primaryColorLight),
          ),
        ),
      ),
    );
  }
}

class EmptyTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Center(
        child: Text(
          "BRAK WYDATKÓW",
          style:
          TextStyle(fontSize: 15.0, color: Theme.of(context).accentColor),
        ),
      ),
    );
  }
}

class CostRecordTile extends StatelessWidget {
  final String name;
  final String category;
  final double value;
  final DateTime date;
  final VoidCallback onTap;

  final upperRowFontSize = 18.0;
  final lowerRowFontSize = 13.0;

  CostRecordTile({
    this.name,
    this.category,
    this.value,
    this.date,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap.call(),
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: category == "Stały wydatek"
                              ? Color(0xFF726573)
                              : Theme.of(context).accentColor,
                          fontSize: upperRowFontSize),
                    ),
                  ),
                  Text(
                    NumberFormat("###,###,##0.00", "pl_PL").format(value) + " zł",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: category == "Stały wydatek"
                            ? Color(0xFF726873)
                            : Theme.of(context).accentColor,
                        fontSize: upperRowFontSize),
                  ),
                ],
              ),
              SizedBox(
                height: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    category,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontSize: lowerRowFontSize),
                  ),
                  Text(
                    toDayMonth(date),
                    style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontSize: lowerRowFontSize),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}