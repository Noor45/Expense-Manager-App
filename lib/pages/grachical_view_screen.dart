import 'dart:io';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/add_expense_model.dart';
import '../utils/colors.dart';

class GraphicalViewScreen extends StatefulWidget {
  final List<AddExpenseModel> expenses;

  GraphicalViewScreen({super.key, required this.expenses});

  @override
  State<StatefulWidget> createState() => GraphicalViewScreenState();
}

class GraphicalViewScreenState extends State<GraphicalViewScreen> {
  final double width = 25;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;
  Map<String, List<AddExpenseModel>> groupedExpenses = {};

  @override
  void initState() {
    super.initState();
    for (var expense in widget.expenses) {
      String dateKey = DateFormat('MMM dd').format(expense.datetime!);
      if (groupedExpenses[dateKey] == null) {
        groupedExpenses[dateKey] = [];
      }
      groupedExpenses[dateKey]!.add(expense);
    }

    rawBarGroups = groupedExpenses.entries.map((entry) {
      int x = groupedExpenses.keys.toList().indexOf(entry.key);
      List<BarChartRodData> rods = entry.value.map((expense) {
        return BarChartRodData(
          toY: expense.amount!.toDouble(),
          color: ColorRefer.kPrimaryColor,
          width: width,
          borderRadius: const BorderRadius.all(Radius.circular(1.0)),
          gradient: const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: <Color>[
              ColorRefer.kPrimaryColor,
              ColorRefer.kPrimaryColor,
            ],
          ),
        );
      }).toList();

      return BarChartGroupData(
        barsSpace: 2, // Reduced space between bar groups
        x: x,
        barRods: rods,
      );
    }).toList();

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    final maxY = widget.expenses.map((e) => e.amount!).reduce(math.max).toDouble() + 10;
    final interval = ((maxY / 20).ceil() * 5).toDouble();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Platform.isIOS ? Icons.arrow_back_ios_sharp : Icons.arrow_back_rounded,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: ColorRefer.kPrimaryColor,
        title: const Text(
          'Graphical View',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          margin: EdgeInsets.only(top: 150),
          height: 400,
          width: math.max(MediaQuery.of(context).size.width, showingBarGroups.length * (width + 50)),
          child: AspectRatio(
            aspectRatio: 1,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        'Rs. ${rod.toY.ceil().toString()}',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= rawBarGroups.length) return const SizedBox.shrink();
                        final dateKey = groupedExpenses.keys.elementAt(index);
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            dateKey,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                      reservedSize: 20,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      interval: interval,
                      getTitlesWidget: (value, meta) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 0,
                          child: Text(value.toInt().toString()),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                barGroups: showingBarGroups,
                gridData: const FlGridData(show: false),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
