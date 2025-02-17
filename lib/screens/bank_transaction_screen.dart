import 'dart:async';
import 'dart:convert';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../api/networkUtils.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';
import '../widgets/empty_widget.dart';
import '../model/bank_transaction_model.dart';
import 'add_amount_detail.dart';
import 'deduct_amount_detail_screen.dart';

class ViewBankTransactionList extends StatefulWidget {
  static String viewBankTransactionScreenID = "/add_bank_transaction_screen";
  const ViewBankTransactionList({super.key});

  @override
  State<ViewBankTransactionList> createState() => _ViewBankTransactionListState();
}

class _ViewBankTransactionListState extends State<ViewBankTransactionList> {
  bool hasData = false;
  int count = 1;
  List<BankTransactionModel>? allTransactionList = [];
  List<BankTransactionModel>? dailyTransactionList = [];
  List<BankTransactionModel>? weeklyTransactionList = [];
  List<BankTransactionModel>? monthlyTransactionList = [];
  List<BankTransactionModel>? yearlyTransactionList = [];
  StreamController? _bankTransactionListController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future fetchPost() async {
    final response = await NetworkUtil.internal().post('bank-transction-detail', body: {
      'user_id': Constants.userDetail!.access == 3 ? Constants.userDetail!.uid.toString() : 0.toString(),
      'bank_id': Constants.bankId.toString(),
      'company_id': Constants.userDetail!.companyId!.toString(),
    });
    Map<String, dynamic> jsonMap = json.decode(response.body);
    if (jsonMap['code'] == 200) {
      List<dynamic> typeExpense = jsonMap['data'];
      allTransactionList?.clear();
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
        BankTransactionModel bankTransactionList = BankTransactionModel
            .fromMap(element);
        allTransactionList!.add(bankTransactionList);
      }
      print(allTransactionList!.length);
      return typeExpense;
    } else {
      throw Exception('Failed to load data');
    }
  }

  loadData() async {
    fetchPost().then((res) async {
      _bankTransactionListController?.add(res);
      return res;
    });
  }


  showSnack() {
    return ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("New Content Loaded"),
        duration: Duration(milliseconds: 700),
      ),
    );
  }

  @override
  void initState() {
    _bankTransactionListController = StreamController();
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String bankName = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorRefer.kPrimaryColor,
        centerTitle: true,
        title: Text(
          '$bankName Transaction',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontFamily: FontRefer.OpenSans,
            color: Colors.black,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: _bankTransactionListController!.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == true && snapshot.data.length != 0) {
            List<dynamic> data = snapshot.data;
            filterTransactions();
            return Padding(
              padding: const EdgeInsets.only(top: 15),
              child: DefaultTabController(
                length: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ButtonsTabBar(
                      radius: 60,
                      elevation: 5,
                      backgroundColor: ColorRefer.kPrimaryColor,
                      contentPadding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                      tabs: const [
                        Tab(text: 'Today'),
                        Tab(text: 'Weekly'),
                        Tab(text: 'Monthly'),
                        Tab(text: 'Yearly'),
                        Tab(text: 'All'),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: TabBarView(
                        children: [
                          dailyTransactionList!.isNotEmpty ? buildTransactionListView(dailyTransactionList) : emptyWidget('No Transaction to Show', context),
                          weeklyTransactionList!.isNotEmpty ? buildTransactionListView(weeklyTransactionList) : emptyWidget('No Transaction to Show', context),
                          monthlyTransactionList!.isNotEmpty ? buildTransactionListView(monthlyTransactionList) : emptyWidget('No Transaction to Show', context),
                          yearlyTransactionList!.isNotEmpty ? buildTransactionListView(yearlyTransactionList) : emptyWidget('No Transaction to Show', context),
                          allTransactionList!.isNotEmpty ? buildTransactionListView(allTransactionList) : emptyWidget('No Transaction to Show', context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          else if (snapshot.hasData == false && snapshot.data == null) {
            return const Center(child: CircularProgressIndicator(color: ColorRefer.kPrimaryColor));
          }
          else if (snapshot.connectionState != ConnectionState.done) {
            return emptyWidget('No Transaction to Show', context);
          }
          else if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return emptyWidget('No Transaction to Show', context);
          }
          else if (snapshot.connectionState != ConnectionState.done) {
            return emptyWidget('No Transaction to Show', context);
          }
          else {
            return emptyWidget('No Transaction to Show', context);
          }
        }
      ),
    );
  }

  void filterTransactions() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday));
    final startOfMonth = DateTime(now.year, now.month, 1);
    final startOfYear = DateTime(now.year, 1, 1);

    dailyTransactionList = allTransactionList?.where((transaction) {
      return transaction.date?.day == now.day &&
          transaction.date?.month == now.month &&
          transaction.date?.year == now.year;
    }).toList();

    weeklyTransactionList = allTransactionList?.where((transaction) {
      return transaction.date!.isAfter(startOfWeek) && transaction.date!.isBefore(startOfWeek.add(const Duration(days: 7)));
    }).toList();

    monthlyTransactionList = allTransactionList?.where((transaction) {
      return transaction.date!.isAfter(startOfMonth) && transaction.date!.isBefore(DateTime(now.year, now.month + 1, 1));
    }).toList();

    yearlyTransactionList = allTransactionList?.where((transaction) {
      return transaction.date!.isAfter(startOfYear) && transaction.date!.isBefore(DateTime(now.year + 1, 1, 1));
    }).toList();
  }

  ListView buildTransactionListView(List<BankTransactionModel>? transactions) {
    return ListView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: transactions?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        var transaction = transactions![index];
        return buildTransactionTile(
          title: transaction.expenseId == 0 ? 'Add Amount' : 'Deduct Amount',
          date: DateFormat("MMM dd yyyy").format(transaction.date!),
          amount: '${transaction.expenseId == 0 ? '+' : '-'} Rs. ${transaction.expenseId == 0 ? moneyFormat(transaction.amountAdd.toString()): moneyFormat(transaction.amountDetect.toString())}',
          amountColor: transaction.expenseId == 0 ? Colors.green : Colors.red,
          onPressed: (){
            if(transaction.expenseId == 0){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddedTransactionDetailsScreen(transactionId: transaction.incomeId.toString()),
                ),
              );
            }else{
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DeductedTransactionDetailsScreen(transactionId: transaction.expenseId.toString()),
                ),
              );
            }

          }
        );
      },
    );
  }

  GestureDetector buildTransactionTile(
      {String? title,
      String? date,
      String? amount,
      Color? amountColor,
      Function? onPressed}) {
    return GestureDetector(
      onTap: (){
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
              leading: Icon(
                amountColor == Colors.green ? Icons.arrow_downward : Icons.arrow_upward,
                color: amountColor,
              ),
              title: Text(title!),
              subtitle: Text(date!),
              trailing: Text(
                amount!,
                style: TextStyle(color: amountColor, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
