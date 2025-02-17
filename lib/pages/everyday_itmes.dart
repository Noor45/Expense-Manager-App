import 'dart:convert';
import 'dart:io';
import 'package:expense_wallet/pages/detail_history.dart';
import 'package:flutter/material.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import '../api/networkUtils.dart';
import '../cards/small_card.dart';
import '../model/add_expense_model.dart';
import '../model/everyday_expense_list_model.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/empty_widget.dart';

class EveryDayExpenses extends StatefulWidget {
  final int businessExpenseId;
  final int expenseTypeId;
  final String expenseType;
  const EveryDayExpenses({super.key,  required this.businessExpenseId, required this.expenseType, required this.expenseTypeId});

  @override
  State<EveryDayExpenses> createState() => _EveryDayExpensesState();
}

class _EveryDayExpensesState extends State<EveryDayExpenses> {
  Future<bool> fetchData(BuildContext context, int everyDayExpenseId) async {
    final response = await NetworkUtil.internal().post('data-screen-buisness-everyday', body: {
      'user_id': Constants.userDetail!.access == 3 ? Constants.userDetail!.uid.toString() : 0.toString(),
      'expense_type_id': widget.expenseTypeId.toString(),
      'buisness_expense_id': widget.businessExpenseId.toString(),
      'everyday_expense_id': everyDayExpenseId.toString(),
      'company_id': Constants.userDetail!.companyId!.toString()
    });
    if (response.statusCode == 200) {
      List<dynamic> typeExpense = json.decode(response.body);
      if (typeExpense.isNotEmpty) {
        Constants.expenseList?.clear();
        for (var element in typeExpense) {
          AddExpenseModel expenseList = AddExpenseModel.fromMap(element);
          Constants.expenseList!.add(expenseList);
        }
        return true;
      }else{
        showSnack();
        return false;
      }

    } else {
      throw Exception('Failed to load data');
    }
  }

  List<EveryDayExpenseModel>? everyday = [];
  @override
  void initState() {
    setState(() {
      Constants.everydayExpenseList!.forEach((element) {
        if(element.status == 0){
          everyday!.add(element);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Platform.isIOS
                ? Icons.arrow_back_ios_sharp
                : Icons.arrow_back_rounded)),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: ColorRefer.kPrimaryColor,
        title: Text(
          widget.expenseType,
          style:
          const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: everyday!.isEmpty ? Container(child: emptyWidget('Add everyday expense from company portal', context),) :
      GridView.builder(
        padding: const EdgeInsets.all(20.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid
          crossAxisSpacing: 10.0, // Spacing between columns
          mainAxisSpacing: 10.0, // Spacing between rows
        ),
        itemCount: everyday!.length,
        itemBuilder: (BuildContext context, int index) {
          final item = everyday![index];
          print(item);
          return SmallCards(
            text: everyday![index].name!,
            onTap: () async{
              SimpleFontelicoProgressDialog _dialog = SimpleFontelicoProgressDialog(context: context);
              _dialog.show(textStyle: const TextStyle(fontSize: 14, color: Colors.grey),  message: 'Loading', type: SimpleFontelicoProgressDialogType.phoenix, indicatorColor: ColorRefer.kPrimaryColor);
              bool value = await fetchData(context, item.id!);
              _dialog.hide();
              if(value == true){
                Future.microtask(() {
                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  DetailHistory(title: item.name!),
                      ),
                    );
                  }
                });
              }
            },

          );
        },
      ),
    );
  }

  showSnack() {
    return ScaffoldMessenger.of(context).showSnackBar( const SnackBar( content: Text("No Record Found"), duration: Duration(milliseconds: 1500), ), );
  }
}
