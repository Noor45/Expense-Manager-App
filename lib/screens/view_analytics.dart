import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../api/networkUtils.dart';
import '../model/bank_model.dart';
import '../model/bank_transaction_model.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/empty_widget.dart';
import '../widgets/input_filed.dart';

class ViewAnalytics extends StatefulWidget {
  ViewAnalytics({super.key});

  final Color leftBarColor = AppColors.contentColorGreen;
  final Color rightBarColor = Colors.red;

  @override
  State<StatefulWidget> createState() => ViewAnalyticsState();
}

class ViewAnalyticsState extends State<ViewAnalytics> {
  final double width = 25;
  List<BankModel> bankList = Constants.bankList ?? [];
  Map<String, int> bankListModeMap = {
    for (var mode in Constants.bankList ?? [])
      if (mode.bankName != null && mode.status == 0) mode.bankName!: mode.id ?? 0
  };
  int? selectedBank = 1;
  int? selectedTab = 1;
  late List<BarChartGroupData> rawBarGroups = [];
  late List<BarChartGroupData> showingBarGroups = [];

  int touchedGroupIndex = -1;
  Map<String, List<BankTransactionModel>> groupedExpenses = {};

  bool isLoading = true;

  int _selectedOptionId = 5;

  final List<Map<String, dynamic>> _options = [
    {'id': 1, 'value': 'Daily'},
    {'id': 2, 'value': 'Weekly'},
    {'id': 3, 'value': 'Monthly'},
    {'id': 4, 'value': 'Yearly'},
    {'id': 5, 'value': 'All'},
  ];
  List<BankTransactionModel>? transactionList = [];
  List<BankTransactionModel>? allTransactionList = [];
  List<BankTransactionModel>? dailyTransactionList = [];
  List<BankTransactionModel>? weeklyTransactionList = [];
  List<BankTransactionModel>? monthlyTransactionList = [];
  List<BankTransactionModel>? yearlyTransactionList = [];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  double totalIncome = 0;
  double totalExpense = 0;
  double maxY = 0.0;
  double interval = 0.0;
  @override
  void initState() {
    setState(() {
      print(bankListModeMap);
      selectedBank = bankListModeMap.isEmpty ? 1 : bankListModeMap.values.first;
      print(Constants.bankList);
    });
    super.initState();
    fetchData();
  }



  Future fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response = await NetworkUtil.internal().post('bank-transction-detail', body: {
      'user_id': Constants.userDetail!.access == 3 ? Constants.userDetail!.uid.toString() : 0.toString(),
      'bank_id': selectedBank.toString(),
      'company_id': Constants.userDetail!.companyId!.toString(),
    });
    Map<String, dynamic> jsonMap = json.decode(response.body);
    if (jsonMap['code'] == 200) {
      List<dynamic> typeExpense = jsonMap['data'];
      transactionList?.clear();
      for (var element in typeExpense) {
        element['id'] = int.parse(element['id']);
        element['income_id'] = int.parse(element['income_id']);
        element['user_id'] = int.parse(element['user_id']);
        element['bank_id'] = int.parse(element['bank_id']);
        element['amount_add'] = int.parse(element['amount_add']);
        element['current_amount'] = int.parse(element['current_amount']);
        element['actual_amount'] = int.parse(element['actual_amount']);
        element['amount_detect'] = int.parse(element['amount_detect']);
        element['payment_mode'] = int.parse(element['payment_mode']);
        element['expense_id'] = int.parse(element['expense_id']);
        element['company_id'] = int.parse(element['company_id']);
        BankTransactionModel bankTransactionList = BankTransactionModel.fromMap(element);
        transactionList!.add(bankTransactionList);
      }
      transactionList!.forEach((transaction) {
        allTransactionList!.add(transaction);
      });
      addGraphData(allTransactionList!);

    } else {
      throw Exception('Failed to load data');
    }
  }

  addGraphData(List<BankTransactionModel> transactionList){
    // totalIncome = 0;
    // totalExpense = 0;
    // groupedExpenses = {};
    // for (var transaction in transactionList) {
    //   totalIncome += transaction.amountAdd!.toDouble();
    //   totalExpense += transaction.amountDetect!.toDouble();
    //   String dateKey = DateFormat('MMM dd').format(transaction.date!);
    //   if (groupedExpenses[dateKey] == null) {
    //     groupedExpenses[dateKey] = [];
    //   }
    //   groupedExpenses[dateKey]!.add(transaction);
    // }
    // rawBarGroups.clear();
    // showingBarGroups.clear();
    // rawBarGroups = groupedExpenses.entries.map((entry) {
    //   int x = groupedExpenses.keys.toList().indexOf(entry.key);
    //   double y1 = entry.value.map((e) => e.amountAdd!.toDouble()).reduce(math.max);
    //   double y2 = entry.value.map((e) => e.amountDetect!.toDouble()).reduce(math.max);
    //   return makeGroupData(x, y1, y2);
    // }).toList();
    // setState(() {
    //   showingBarGroups = rawBarGroups;
    //   maxY = transactionList.isEmpty == true ? 0.0 : transactionList.map((e) => math.max(e.amountAdd!, e.amountDetect!)).reduce(math.max).toDouble();
    //   interval = ((maxY / 5).ceil() * 1).toDouble();
    //   isLoading = false;
    // });
    totalIncome = 0;
    totalExpense = 0;
    groupedExpenses = {};
    for (var transaction in transactionList) {
      totalIncome += transaction.amountAdd!.toDouble();
      totalExpense += transaction.amountDetect!.toDouble();
      String dateKey = DateFormat('MMM dd').format(transaction.date!);
      if (groupedExpenses[dateKey] == null) {
        groupedExpenses[dateKey] = [];
      }
      groupedExpenses[dateKey]!.add(transaction);
    }
    rawBarGroups.clear();
    showingBarGroups.clear();
    rawBarGroups = groupedExpenses.entries.map((entry) {
      int x = groupedExpenses.keys.toList().indexOf(entry.key);
      double y1 = entry.value.map((e) => e.amountAdd!.toDouble()).reduce(math.max);
      double y2 = entry.value.map((e) => e.amountDetect!.toDouble()).reduce(math.max);
      return makeGroupData(x, y1, y2);
    }).toList();
    if (mounted) {
      setState(() {
        showingBarGroups = rawBarGroups;
        maxY = transactionList.isEmpty
            ? 0.0
            : transactionList.map((e) => math.max(e.amountAdd!, e.amountDetect!)).reduce(math.max).toDouble();
        interval = ((maxY / 5).ceil() * 1).toDouble();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: ColorRefer.kPrimaryColor,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: ColorRefer.kPrimaryColor,
        ),
        title: const Text(
          "Analytics",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),

      ),
      backgroundColor: Colors.white,
      body:  bankListModeMap.isEmpty ? Container( padding: const EdgeInsets.only(top: 80), child: emptyWidget('No bank transaction to show', context),) :  SingleChildScrollView(
        child: Column(
          children: [
            Visibility(
              visible: bankListModeMap.isEmpty ? false : true,
              child: Padding(
                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                child: DropdownField(
                  label: 'Select Bank',
                  hintText: 'Choose item',
                  value: bankListModeMap.isEmpty ? '' : bankListModeMap.keys.first,
                  items: bankListModeMap.keys.toList(),
                  onChanged: (value) {
                    int? selectedId = bankListModeMap[value];
                    setState(() {
                      selectedBank = selectedId;
                      fetchData();
                    });
                  },
                  onTap: (){},
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an item';
                    }
                    return null;
                  },
                ),
              ),
            ),
            isLoading == false && allTransactionList!.isNotEmpty == true ?
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: _selectedOptionId.toString(),
                    onChanged: (newValue) {
                      final now = DateTime.now();
                      final startOfWeek = now.subtract(Duration(days: now.weekday));
                      final startOfMonth = DateTime(now.year, now.month, 1);
                      final startOfYear = DateTime(now.year, 1, 1);
                      setState(() {
                        _selectedOptionId = int.parse(newValue!);
                        if(_selectedOptionId == 1) {
                          allTransactionList = transactionList?.where((transaction) {
                            return transaction.date?.day == now.day &&
                                transaction.date?.month == now.month &&
                                transaction.date?.year == now.year;
                          }).toList();
                          addGraphData(allTransactionList!);
                        }
                        if(_selectedOptionId == 2) {
                          allTransactionList = transactionList?.where((transaction) {
                            return transaction.date!.isAfter(startOfWeek) && transaction.date!.isBefore(startOfWeek.add(const Duration(days: 7)));
                          }).toList();
                          addGraphData(allTransactionList!);
                        }
                        else if (_selectedOptionId == 3){
                          allTransactionList = transactionList?.where((transaction) {
                            return transaction.date!.isAfter(startOfMonth) && transaction.date!.isBefore(DateTime(now.year, now.month + 1, 1));
                          }).toList();
                          addGraphData(allTransactionList!);
                        }
                        else if (_selectedOptionId == 4){
                          allTransactionList = transactionList?.where((transaction) {
                            return transaction.date!.isAfter(startOfYear) && transaction.date!.isBefore(DateTime(now.year + 1, 1, 1));
                          }).toList();
                          addGraphData(allTransactionList!);
                        }
                        else if (_selectedOptionId == 5){
                          transactionList!.forEach((transaction) {
                            allTransactionList!.add(transaction);
                          });
                          addGraphData(allTransactionList!);
                        }
                      });
                    },
                    items: _options.map<DropdownMenuItem<String>>((Map<String, dynamic> option) {
                      return DropdownMenuItem<String>(
                        value: option['id'].toString(),
                        child: Text(option['value']!),
                      );
                    }).toList(),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = 1;
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: selectedTab != 1 ? ColorRefer.kPrimaryColor : Colors.black,
                          ),
                          child: Icon(Icons.bar_chart_outlined ,color: selectedTab != 1 ? Colors.black : ColorRefer.kPrimaryColor,),
                        ),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = 2;
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: selectedTab == 1 ? ColorRefer.kPrimaryColor : Colors.black,
                          ),
                          child: Icon(Icons.pie_chart_outline, color: selectedTab == 1 ? Colors.black : ColorRefer.kPrimaryColor,),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ) : const SizedBox(),
            isLoading == false && allTransactionList!.isNotEmpty == true ?
            Container(
              padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
              child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          color: AppColors.contentColorGreen,
                        ),
                        const Text(' Income', style: TextStyle(fontSize: 10)),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          width: 10,
                          height: 10,
                          color: Colors.red,
                        ),
                        const Text(' Expense', style: TextStyle(fontSize: 10)),
                      ],
                    ), ]),) : const SizedBox(),
            isLoading
                ? const Padding(
              padding: EdgeInsets.only(top: 150),
              child: Center(child: CircularProgressIndicator(color: ColorRefer.kPrimaryColor)),
            )
                : allTransactionList!.isEmpty ?  Container( padding: const EdgeInsets.only(top: 80), child: emptyWidget('No Transaction to Show', context),):
            selectedTab == 1 ?
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child:
                Container(
                  margin: const EdgeInsets.only(top: 70, bottom: 50),
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
                                '${rodIndex == 0 ? '+' : '-'} Rs. ${moneyFormat(rod.toY.ceil().toString())}',
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
                        gridData: FlGridData(
                          show: true,
                          checkToShowVerticalLine: (value) => value % interval == 0,
                          getDrawingHorizontalLine: (value) => const FlLine(
                            color: Color(0xffe7e8ec),
                            strokeWidth: 1,
                          ),
                          getDrawingVerticalLine: (value) => const FlLine(
                            color: Color(0xffe7e8ec),
                            strokeWidth: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
            ) :
            SizedBox(
              height: 400,
              child: PieChart(
                PieChartData(
                  sections: showingSections(),
                  sectionsSpace: 0,
                  centerSpaceRadius: 0,
                  borderData: FlBorderData(
                    show: false,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedGroupIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 100.0 : 150.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: widget.leftBarColor,
            value: totalIncome,
            title: 'Income \nRs. ${moneyFormat(totalIncome.toInt().toString())}',
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
            radius: radius,
          );
        case 1:
          return PieChartSectionData(
            color: widget.rightBarColor,
            value: totalExpense,
            title: 'Expense \nRs. ${moneyFormat(totalExpense.toInt().toString())}',
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
            radius: radius,
          );
        default:
          throw Error();
      }
    });
  }


  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          borderRadius: const BorderRadius.all(Radius.circular(2.0)),
          toY: y1,
          color: widget.leftBarColor,
          width: width,
        ),
        BarChartRodData(
          borderRadius: const BorderRadius.all(Radius.circular(1.0)),
          toY: y2,
          color: widget.rightBarColor,
          width: width,
        ),
      ],
    );
  }
}