import 'dart:io';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/add_expense_model.dart';
import '../screens/deduct_amount_detail_screen.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/empty_widget.dart';
import 'grachical_view_screen.dart';
import 'package:intl/intl.dart';

// enum Calendar { day, week, month, year }
class DetailHistory extends StatefulWidget {
  static String detailHistoryScreenID = "/detail_history_screen";
  final String title;
  const DetailHistory({super.key, required this.title});
  @override
  State<DetailHistory> createState() => _DetailHistoryState();
}

class _DetailHistoryState extends State<DetailHistory> {
  // bool isMonthly = true;
  // void _handleToggleButtons(int index) {
  //   setState(() {
  //     isMonthly = index == 0;
  //   });
  // }
  // Calendar calendarView = Calendar.day;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
        title: Text(
          '${widget.title} Expense',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: const RecordsTab(),
    );
  }
}

class RecordsTab extends StatefulWidget {
  const RecordsTab({super.key});

  @override
  State<RecordsTab> createState() => _RecordsTabState();
}

class _RecordsTabState extends State<RecordsTab> {

  int selectedValue = 0;
  List<AddExpenseModel>? allTransactionList = [];
  List<AddExpenseModel>? dailyTransactionList = [];
  List<AddExpenseModel>? weeklyTransactionList = [];
  List<AddExpenseModel>? monthlyTransactionList = [];
  List<AddExpenseModel>? yearlyTransactionList = [];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    filterTransactions();
    super.initState();
  }

  void filterTransactions() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday));
    final startOfMonth = DateTime(now.year, now.month, 1);
    final startOfYear = DateTime(now.year, 1, 1);
    dailyTransactionList = Constants.expenseList?.where((transaction) {
      return transaction.datetime?.day == now.day &&
          transaction.datetime?.month == now.month &&
          transaction.datetime?.year == now.year;
    }).toList();

    weeklyTransactionList = Constants.expenseList?.where((transaction) {
      return transaction.datetime!.isAfter(startOfWeek) && transaction.datetime!.isBefore(startOfWeek.add(const Duration(days: 7)));
    }).toList();

    monthlyTransactionList = Constants.expenseList?.where((transaction) {
      return transaction.datetime!.isAfter(startOfMonth) && transaction.datetime!.isBefore(DateTime(now.year, now.month + 1, 1));
    }).toList();

    yearlyTransactionList = Constants.expenseList?.where((transaction) {
      return transaction.datetime!.isAfter(startOfYear) && transaction.datetime!.isBefore(DateTime(now.year + 1, 1, 1));
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: DefaultTabController(
          length: 5,
          child: Column(
            children: [
              ButtonsTabBar(
                radius: 60,
                elevation: 2,
                backgroundColor: ColorRefer.kPrimaryColor,
                contentPadding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                tabs: const [
                  Tab(text: 'Today', icon: Icon(Icons.calendar_today_outlined),),
                  Tab(text: 'Weekly', icon: Icon(Icons.calendar_view_week_sharp),),
                  Tab(text: 'Monthly', icon: Icon(Icons.calendar_view_month_sharp),),
                  Tab(text: 'Yearly', icon: Icon(Icons.calendar_month_sharp),),
                  Tab(text: 'All', icon: Icon(Icons.edit_calendar),),
                ],
                onTap: (value){
                  setState(() {
                    selectedValue = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    dailyTransactionList!.isNotEmpty ? buildTransactionListView(dailyTransactionList) : emptyWidget('No Transaction to Show', context),
                    weeklyTransactionList!.isNotEmpty ? buildTransactionListView(weeklyTransactionList) : emptyWidget('No Transaction to Show', context),
                    monthlyTransactionList!.isNotEmpty ? buildTransactionListView(monthlyTransactionList) : emptyWidget('No Transaction to Show', context),
                    yearlyTransactionList!.isNotEmpty ? buildTransactionListView(yearlyTransactionList) : emptyWidget('No Transaction to Show', context),
                    Constants.expenseList!.isNotEmpty ? buildTransactionListView(Constants.expenseList) : emptyWidget('No Transaction to Show', context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: selectedValue == 0 && dailyTransactionList!.length > 1 ? button()
          : selectedValue == 1 && weeklyTransactionList!.length > 1 ?  button()
          : selectedValue == 2 && monthlyTransactionList!.length > 1 ?  button()
          : selectedValue == 3 && yearlyTransactionList!.length > 1 ?  button() : button(),
    );
  }

  Widget button(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 30, right: 10),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GraphicalViewScreen(
                  expenses: selectedValue == 0 ? dailyTransactionList! : selectedValue == 1 ?
                  weeklyTransactionList! : selectedValue == 2 ? monthlyTransactionList! : selectedValue == 3 ? yearlyTransactionList! : Constants.expenseList!
              ),
            ),
          );
        },
        tooltip: 'Graphical View',
        backgroundColor: ColorRefer.kPrimaryColor,
        child: const Icon(
          CupertinoIcons.graph_square,
          size: 30,
          color: Colors.black,
        ),
      ),
    );
  }
  ListView buildTransactionListView(List<AddExpenseModel>? transactions) {
    return ListView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: transactions?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        var transaction = transactions![index];
        return buildTransactionTile(
            title: 'Spend Amount',
            date: DateFormat("MMM dd yyyy").format(transaction.datetime!),
            amount: 'Rs. ${ moneyFormat(transaction.amount.toString())}',
            amountColor: ColorRefer.kPrimaryColor,
            onPressed: () {
              // if(transaction.expenseId == 0){
              //   // Navigator.push(
              //   //   context,
              //   //   MaterialPageRoute(
              //   //     builder: (context) => AddedTransactionDetailsScreen(transactionId: transaction.incomeId.toString()),
              //   //   ),
              //   // );
              // }
              // else{
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeductedTransactionDetailsScreen(transactionId: transaction.id.toString()),
                  ),
                );
              // }
            }
        );
      },
    );
  }

  GestureDetector buildTransactionTile({String? title, String? date, String? amount, Color? amountColor, Function? onPressed}) {
    return GestureDetector(
      onTap: () {
        onPressed!.call();
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
        child: Container(
          width: 400,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10), // Set a circular radius of 10 pixels
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Set shadow color and opacity
                offset: const Offset(4.0, 4.0), // Offset the shadow right-bottom
                blurRadius: 5.0, // Apply some blur
              ),
            ],
          ),
          child: Center(
            child: ListTile(
              // leading: Icon(
              //   amountColor == Colors.green ? Icons.arrow_downward : Icons.arrow_upward,
              //   color: amountColor,
              // ),
              title: Text(title!),
              subtitle: Text(date!),
              trailing: Text(
                amount!,
                style: TextStyle(color: amountColor, fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }
}







