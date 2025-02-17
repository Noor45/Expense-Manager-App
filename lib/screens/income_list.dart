import 'dart:async';
import 'dart:convert';
import 'package:expense_wallet/cards/income_cards.dart';
import 'package:flutter/material.dart';
import '../api/networkUtils.dart';
import '../model/bank_model.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/dialogs.dart';
import 'bank_transaction_screen.dart';
import '../widgets/empty_widget.dart';


class ViewIncomeList extends StatefulWidget {
  const ViewIncomeList({super.key});

  @override
  State<ViewIncomeList> createState() => _ViewIncomeListState();
}

class _ViewIncomeListState extends State<ViewIncomeList> {
  bool hasData = false;
  int count = 1;
  StreamController? _bankListController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Future fetchData() async {
    final response = await NetworkUtil.internal().post('fetch_list_bank', body: {
      'company_id': Constants.userDetail!.companyId!.toString(),
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> typeExpense = data['data'];
      Constants.income = data['income'];
      Constants.spend = data['spending'];
      Constants.bankList?.clear();
      for (var element in typeExpense) {
        BankModel bankList = BankModel.fromMap(element);
        Constants.bankList!.add(bankList);
      }
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  loadData() async {
    fetchData().then((res) async {
      _bankListController?.add(res['data']);
      return res;
    });
  }

  showSnack() {
    return ScaffoldMessenger.of(context).showSnackBar( const SnackBar( content: Text("New Content Loaded"), duration: Duration(milliseconds: 700), ), );
  }

  Future<void> _handleRefresh() async {
    count++;
    fetchData().then((res) async {
      _bankListController?.add(res['data']);
      showSnack();
      return null;
    });
  }

  @override
  void initState() {
    _bankListController = StreamController();
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: ColorRefer.kPrimaryColor,
          centerTitle: true,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: ColorRefer.kPrimaryColor,
          ),
          title: const Text(
            "Income",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),

      ),
      body: StreamBuilder (
        stream: _bankListController!.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Center(
            child: snapshot.hasError ? Text(snapshot.error.toString())
              : snapshot.hasData == true && snapshot.data.length != 0?
            Scrollbar(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: ColorRefer.kPrimaryColor,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        var bank = snapshot.data[index];
                        return Column(
                          children: [
                            Visibility(
                              visible: bank['status']! != 0 ? true : false,
                              child: index == 0  ? Container( padding: const EdgeInsets.only(top: 80), child: emptyWidget('Activate your registered banks from your company portal !', context),) : SizedBox()
                            ),
                            Visibility(
                              visible: bank['status']! == 0 ? true : false,
                              child: IncomeCard(
                                id: bank['id']!,
                                imagePath: bank['image']!,
                                text: bank['bank_name'],
                                amount: bank['current_amount']!,
                                index: index,
                                onTap: () async {
                                  Constants.bankId = bank['id']!;
                                  await Navigator.pushNamed(context, ViewBankTransactionList.viewBankTransactionScreenID, arguments: bank['bank_name']);
                                  loadData();
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ) :
            snapshot.hasData == true && snapshot.data.length == 0 ?
            Container( padding: const EdgeInsets.only(top: 80), child: emptyWidget('Add banks from your company portal', context),) :
            snapshot.connectionState != ConnectionState.done ?
            const CircularProgressIndicator(color: ColorRefer.kPrimaryColor)  : !snapshot.hasData && snapshot.connectionState == ConnectionState.done ? Container( padding: const EdgeInsets.only(top: 80), child: emptyWidget('No Bank to Show', context),) : Container( padding: const EdgeInsets.only(top: 80), child: emptyWidget('No Bank Added to Show', context),),
          );
        }
      ),
    );
  }
}

