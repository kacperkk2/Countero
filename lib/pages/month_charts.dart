import 'package:countero/models/cost_record.dart';
import 'package:countero/models/profile.dart';
import 'package:countero/models/profile_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../dates_formatter.dart';


class MonthCharts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GroupedCostRecords month = ModalRoute.of(context).settings.arguments;
    ProfileModel profileModel = Provider.of<ProfileModel>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: Text("${toMonth(month.date)} ${toYear(month.date)}"),
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            CustomPieChart(
              moneySaved: month.moneySaved,
              moneyPaid: month.moneyPaid,
            ),
            SizedBox(
              height: 20,
            ),
            Visibility(
              visible: month.records.isNotEmpty,
              child: CustomBarChart(
                month: month,
                categoriesMap: profileModel.categoriesMap
              ),
            ),
          ],
        )
    );
  }
}

class CustomPieChart extends StatefulWidget {
  final double moneySaved;
  final double moneyPaid;

  CustomPieChart({this.moneySaved, this.moneyPaid});

  @override
  State<StatefulWidget> createState() => _CustomPieChartState();
}

class _CustomPieChartState extends State<CustomPieChart> {
  int touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 6,
                child: Container(
                  height: 180,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                        setState(() {
                          if (pieTouchResponse.touchInput is FlLongPressEnd ||
                              pieTouchResponse.touchInput is FlPanEnd) {
                            touchedIndex = -1;
                          } else {
                            touchedIndex = pieTouchResponse.touchedSectionIndex;
                          }
                        });
                      }),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 0,
                      sections: showingSections(),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Indicator(
                      color: Colors.blue[300],
                      text: 'Wydano',
                      textColor: Colors.grey,
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Indicator(
                      color: Colors.green[300],
                      textColor: Colors.grey,
                      text: 'Zaoszczędzono',
                      isSquare: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 90 : 80;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue[300],
            value: widget.moneyPaid > 0 ? widget.moneyPaid : 0,
            title: widget.moneyPaid > 0 ? NumberFormat("###,###,##0.00", "pl_PL").format(widget.moneyPaid) : "",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.grey[850]
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.green[300],
            value: widget.moneySaved > 0 ? widget.moneySaved : 0,
            title: widget.moneySaved > 0 ? NumberFormat("###,###,##0.00", "pl_PL").format(widget.moneySaved) : "",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.grey[850]
            ),
          );
        default:
          return null;
      }
    });
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key key,
    this.color,
    this.text,
    this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}

class CustomBarChart extends StatefulWidget {
  final GroupedCostRecords month;
  final Map<int, Category> categoriesMap;

  CustomBarChart({this.month, this.categoriesMap});

  @override
  State<StatefulWidget> createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
  final double width = 7;

  List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex;
  double maxValue;
  double grossSpace;

  @override
  void initState() {
    super.initState();
    showingBarGroups = _groupExpensesByCategory();
    grossSpace = showingBarGroups.length >= 6 ? 120/showingBarGroups.length : 20;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              'Wydatki względem kategorii',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Indicator(
                  color: Colors.red[400],
                  text: "Limit",
                  isSquare: true,
                  textColor: Colors.grey,
                ),
                SizedBox(width: 20,),
                Indicator(
                  color: Theme.of(context).accentColor,
                  text: "Wydano",
                  isSquare: true,
                  textColor: Colors.grey,
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: BarChart(
                  BarChartData(
                    groupsSpace: grossSpace,
                    alignment: BarChartAlignment.center,
                    barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.grey,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                  NumberFormat("###,###,##0.00", "pl_PL").format(rod.y),
                                  TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold));
                            })),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: SideTitles(
                          showTitles: true,
                          rotateAngle: 320,
                          margin: 20,
                          getTextStyles: (value) => TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          getTitles: (double value) {
                            String name =
                                widget.categoriesMap[value.toInt()].name;
                            return name.length > 15
                                ? name.substring(0, 14) + "..."
                                : name;
                          }),
                      leftTitles: SideTitles(
                        showTitles: true,
                        getTextStyles: (value) => const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14),
                        margin: 25,
                        reservedSize: 14,
                        interval: maxValue/4,
                        getTitles: (value) {
                          bool displayInK = maxValue >= 1000.0;
                          if (value == 0 ) {
                            return "0";
                          } else if (value == maxValue/4) {
                            return displayInK
                                ? NumberFormat("##0.#", "pl_PL").format(maxValue/4000) +"K"
                                : NumberFormat("###0", "pl_PL").format(maxValue/4);
                          } else if (value == maxValue/2) {
                            return displayInK
                                ? NumberFormat("##0.#", "pl_PL").format(maxValue/2000) +"K"
                                : NumberFormat("###0", "pl_PL").format(maxValue/2);
                          } else if (value == 3*maxValue/4) {
                            return displayInK
                                ? NumberFormat("##0.#", "pl_PL").format(3*maxValue/4000) +"K"
                                : NumberFormat("###0", "pl_PL").format(3*maxValue/4);
                          } else if (value == maxValue) {
                            return displayInK
                                ? NumberFormat("##0.#", "pl_PL").format(maxValue/1000) +"K"
                                : NumberFormat("###0", "pl_PL").format(maxValue);
                          } else {
                            return '';
                          }
                        },
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      horizontalInterval: maxValue/4,
                      getDrawingHorizontalLine: (value)  {
                        var primaryColorLight = Theme.of(context).primaryColorLight;

                        if (value == maxValue/4) {
                          return FlLine(color: primaryColorLight, strokeWidth: 1);
                        } else if (value == maxValue/2) {
                          return FlLine(color: primaryColorLight, strokeWidth: 1);
                        } else if (value == 3*maxValue/4) {
                          return FlLine(color: primaryColorLight, strokeWidth: 1);
                        } else {
                          return FlLine(color: Colors.transparent);
                        }
                      },
                    ),
                    borderData: FlBorderData(
                        show: true,
                        border:
                        Border.symmetric(horizontal: BorderSide(color: Theme.of(context).primaryColorLight, width: 1))),
                    barGroups: showingBarGroups,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 2, x: x, barRods: [
      BarChartRodData(
        y: y1,
        colors: [Colors.red[400]],
        width: width,
      ),
      BarChartRodData(
        y: y2,
        colors: [Colors.blue[300]],
        width: width,
      ),
    ]);
  }

  List<BarChartGroupData> _groupExpensesByCategory() {
    Map<int, double> categoryValuesMap = Map<int, double>();
    maxValue = 0;

    widget.categoriesMap.keys.forEach((e) => categoryValuesMap[e] = 0.0);

    widget.month.records.forEach((e) =>
        categoryValuesMap.update(e.categoryId, (value) => value + e.value));

    categoryValuesMap.entries.forEach((e) {
      maxValue = e.value > maxValue ? e.value : maxValue;
    });

    categoryValuesMap.removeWhere((key, value) => value == 0.0);

    return categoryValuesMap.entries.map((e) {
      return makeGroupData(
          e.key, widget.categoriesMap[e.key].limit ?? 0, e.value);
    }).toList();
  }
}