import 'dart:convert';
import 'dart:io';
import 'package:expense_wallet/pages/departments_expenses.dart';
import 'package:expense_wallet/pages/everyday_itmes.dart';
import 'package:flutter/material.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import '../api/networkUtils.dart';
import '../cards/small_card.dart';
import '../model/add_expense_model.dart';
import '../model/business_expense_list_model.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/empty_widget.dart';
import 'detail_history.dart';

class BusinessItems extends StatefulWidget {
  const BusinessItems({
    super.key,
    required this.expenseType,
    required this.expenseId,
  });
  final String expenseType;
  final int expenseId;

  @override
  State<BusinessItems> createState() => _BusinessItemsState();
}

class _BusinessItemsState extends State<BusinessItems> {
  Future<bool> fetchData(BuildContext context, int generalExpenseId) async {
    final response =
        await NetworkUtil.internal().post('data-screen-buisness', body: {
      'user_id': Constants.userDetail!.access == 3
          ? Constants.userDetail!.uid.toString()
          : 0.toString(),
      'expense_type_id': widget.expenseId.toString(),
      'buisness_expense_id': generalExpenseId.toString(),
      'company_id': Constants.companyId!.toString(),
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
      } else {
        showSnack();
        return false;
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  List<BusinessTypeExpenseModel>? business = [];
  @override
  void initState() {
    setState(() {
      Constants.businessExpenseList!.forEach((element) {
        if(element.status == 0){
          business!.add(element);
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
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: business!.isEmpty ? Container( child: emptyWidget('Add business expense from company portal', context),) :
      GridView.builder(
        padding: const EdgeInsets.all(20.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0, // Spacing between columns
          mainAxisSpacing: 10.0, // Spacing between rows
        ),
        itemCount: business!.length,
        itemBuilder: (BuildContext context, int index) {
          BusinessTypeExpenseModel item = business![index];
          return SmallCards(
            text: business![index].name!,
            onTap: () async {
              if (item.kuch == 5) {
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            DepartmentScreen(
                              expenseTypeId: widget.expenseId,
                              businessExpenseId: item.id!,
                              expenseType: item.name!,
                            )
                    )
                );
              } else if (item.kuch == 6) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                    EveryDayExpenses(
                      expenseTypeId: widget.expenseId,
                      businessExpenseId: item.id!,
                      expenseType: item.name!,
                    )
                  )
                );
              } else {
                SimpleFontelicoProgressDialog _dialog =
                    SimpleFontelicoProgressDialog(context: context);
                _dialog.show(
                    textStyle:
                        const TextStyle(fontSize: 14, color: Colors.grey),
                    message: 'Loading',
                    type: SimpleFontelicoProgressDialogType.phoenix,
                    indicatorColor: ColorRefer.kPrimaryColor);
                bool value = await fetchData(context, item.id!);
                _dialog.hide();
                if (value == true) {
                  Future.microtask(() {
                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailHistory(title: item.name!),
                        ),
                      );
                    }
                  });
                }
              }
            },
          );
        },
      ),
    );
  }

  showSnack() {
    return ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("No Record Found"),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }
}
