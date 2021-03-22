import 'package:countero/models/cost_record.dart';
import 'package:countero/models/profile.dart';
import 'package:countero/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class UserReports extends StatefulWidget {
  @override
  _UserReportsState createState() => _UserReportsState();
}

class _UserReportsState extends State<UserReports> {
  ProfileModel profileModel;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          'Oszczędzanie',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        CustomLineChart(
            profileModel.getCostRecordsDividedByDateRange(
                profileModel.getProfileDateRange(),
                profileModel.profile
            ),
            profileModel.getProfileDateRange()
        ),
        SizedBox(
          height: 30,
        ),
        CustomBarChart(
            profileModel.getCostRecordsDividedByDateRange(
                profileModel.getProfileDateRange(),
                profileModel.profile
            ),
            profileModel.categoriesMap
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    profileModel = Provider.of<ProfileModel>(context, listen: false);
  }
}


// CHARTS

class CustomLineChart extends StatefulWidget {
  final Map<DateTime, GroupedCostRecords> costRecordsMap;
  final List<DateTime> dateRange;

  CustomLineChart(this.costRecordsMap, this.dateRange);

  @override
  _CustomLineChartState createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart> {
  List<Color> gradientColors = [Colors.blue[300]];
  List<FlSpot> spots;
  double maxY = 0.0;

  @override
  void initState() {
    super.initState();
    spots = _getSpots();

    if (maxY <= 0.0) {
      maxY = 1000.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.40,
      child: Padding(
        padding:
        const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
        child: LineChart(
          mainData(),
        ),
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: maxY/4,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Theme.of(context).primaryColorLight,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Theme.of(context).primaryColorLight,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          rotateAngle: 320,
          getTextStyles: (value) => const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 12
          ),
          getTitles: (value) {
            if (value > 0 && value % 1.0 == 0) {
              return DateFormat('MM-yyyy', "pl").format(widget.dateRange[(value.toInt() - 1)]);
            }

            if (value == 0) {
              DateTime date = widget.dateRange[0];
              DateTime resultDate;
              if (date.month != 1) {
                resultDate = DateTime(
                    date.year, date.month - 1, date.day);
              } else {
                resultDate = DateTime(
                    date.year-1, 12, date.day);
              }

              return DateFormat('MM-yyyy', "pl").format(resultDate);
            }

            return "";
          },
          margin: 15,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          interval: maxY/4,
          getTitles: (value) {
            bool displayInK = maxY >= 1000.0;
            NumberFormat fh =  NumberFormat("##0.#", "pl_PL");
            NumberFormat f =  NumberFormat("###0", "pl_PL");
            if (value == 0 ) {
              return "0";
            } else if (value == maxY/4) {
              return displayInK ? fh.format(maxY/4000) +"K" : f.format(maxY/4);
            } else if (value == maxY/2) {
              return displayInK ? fh.format(maxY/2000) +"K" : f.format(maxY/2);
            } else if (value == 3*maxY/4) {
              return displayInK ? fh.format(3*maxY/4000) +"K" : f.format(3*maxY/4);
            } else if (value == maxY) {
              return displayInK ? fh.format(maxY/1000) +"K" : f.format(maxY);
            } else {
              return '';
            }
          },
          reservedSize: 45,
          margin: 8,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border:
          Border.all(color: Theme.of(context).primaryColorLight, width: 1)),
      minX: 0,
      maxX: widget.dateRange.length.toDouble(),
      minY: 0,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
            show: true,
            colors:
            gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  List<FlSpot> _getSpots() {
    List<FlSpot> result = [FlSpot(0.0, 0.0)];
    double spared = 0.0;

    for (int i = 1; i < widget.dateRange.length; ++i) {
      spared += widget.costRecordsMap[widget.dateRange[i]].moneySaved;
      maxY = spared > maxY ? spared : maxY;

      double positiveSpared = spared >= 0 ? spared : 0;
      result.add(FlSpot((i+1).toDouble(), double.parse(positiveSpared.toStringAsFixed(2))));
    }

    return result;
  }
}

class CustomBarChart extends StatefulWidget {
  final Map<DateTime, GroupedCostRecords> data;
  final Map<int, Category> categoriesMap;

  CustomBarChart(this.data, this.categoriesMap);

  @override
  State<StatefulWidget> createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
  final Color barColor = Colors.blue[300];
  final double width = 7;

  List<BarChartGroupData> showingBarGroups;

  int maxValue;
  double grossSpace;

  @override
  void initState() {
    super.initState();
    showingBarGroups = _groupCategoryLimits();
    grossSpace = showingBarGroups.length >= 6 ? 120 / showingBarGroups.length : 20;
  }

  @override
  Widget build(BuildContext context) {
    return maxValue > 0
        ? AspectRatio(
          aspectRatio: 1,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  'Przekroczenia limitów kategorii',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(
                  height: 25,
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
                                getTooltipItem:
                                    (group, groupIndex, rod, rodIndex) {
                                  return BarTooltipItem(
                                      NumberFormat("###0", "pl_PL").format(rod.y),
                                      TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold));
                                })),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: SideTitles(
                              showTitles: true,
                              rotateAngle: 320,
                              margin: 15,
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
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                            margin: 25,
                            reservedSize: 14,
                            interval: maxValue / 4,
                            getTitles: (value) {
                              NumberFormat f =  NumberFormat("##0.#", "pl_PL");
                              if (value == 0) {
                                return "0";
                              } else if (value == maxValue / 4) {
                                return f.format(maxValue / 4);
                              } else if (value == maxValue / 2) {
                                return f.format(maxValue / 2)
                                    .toString();
                              } else if (value == 3 * maxValue / 4) {
                                return f.format(3 * maxValue / 4)
                                    .toString();
                              } else if (value == maxValue) {
                                return f.format(maxValue.toDouble());
                              } else {
                                return '';
                              }
                            },
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          horizontalInterval: maxValue / 4,
                          getDrawingHorizontalLine: (value) {
                            var primaryColorLight =
                                Theme.of(context).primaryColorLight;
                            if (value == maxValue / 4) {
                              return FlLine(
                                  color: primaryColorLight, strokeWidth: 1);
                            } else if (value == maxValue / 2) {
                              return FlLine(
                                  color: primaryColorLight, strokeWidth: 1);
                            } else if (value == 3 * maxValue / 4) {
                              return FlLine(
                                  color: primaryColorLight, strokeWidth: 1);
                            } else {
                              return FlLine(color: Colors.transparent);
                            }
                          },
                        ),
                        borderData: FlBorderData(
                            show: true,
                            border: Border.symmetric(
                                horizontal: BorderSide(
                                    color:
                                    Theme.of(context).primaryColorLight,
                                    width: 1))),
                        barGroups: showingBarGroups,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        )
        : Container();
  }

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(barsSpace: 2, x: x, barRods: [
      BarChartRodData(
        y: y,
        colors: [barColor],
        width: width,
      ),
    ]);
  }

  List<BarChartGroupData> _groupCategoryLimits() {
    Map<int, int> categoryValuesMap = Map<int, int>();
    maxValue = 0;

    widget.categoriesMap.keys.forEach((e) => categoryValuesMap[e] = 0);

    widget.data.values.forEach((GroupedCostRecords records) {
      Map<int, double> monthSummary = _groupExpensesByCategory(records);
      monthSummary.entries.forEach((e) {
        if (widget.categoriesMap[e.key].limit != null &&
            (e.value > widget.categoriesMap[e.key].limit)) {
          categoryValuesMap.update(e.key, (value) => value += 1);
        }
      });
    });

    categoryValuesMap.values.forEach((val) {
      maxValue = val > maxValue ? val : maxValue;
    });

    categoryValuesMap.removeWhere((key, value) => value == 0);

    return categoryValuesMap.entries.map((e) {
      return makeGroupData(e.key, e.value.toDouble());
    }).toList();
  }

  Map<int, double> _groupExpensesByCategory(GroupedCostRecords monthData) {
    Map<int, double> categoryValuesMap = Map<int, double>();

    widget.categoriesMap.keys.forEach((e) => categoryValuesMap[e] = 0.0);

    monthData.records.forEach((e) =>
        categoryValuesMap.update(e.categoryId, (value) => value + e.value));

    categoryValuesMap.removeWhere((key, value) => value == 0.0);

    return categoryValuesMap;
  }
}