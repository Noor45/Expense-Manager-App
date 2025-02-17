import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import '../api/networkUtils.dart';
import '../cards/small_card.dart';
import '../model/add_expense_model.dart';
import '../model/department_purchasing_list_model.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/empty_widget.dart';
import 'detail_history.dart';

class PurchaseTools extends StatefulWidget {
  const PurchaseTools({Key? key, required this.businessExpenseId, required this.departmentId, required this.expenseTypeId,  required this.departmentExpenseId}) : super(key: key);
  final int departmentExpenseId;
  final int businessExpenseId;
  final int departmentId;
  final int expenseTypeId;

  @override
  State<PurchaseTools> createState() => _PurchaseToolsState();
}

class _PurchaseToolsState extends State<PurchaseTools> {

  Future<bool> fetchData(BuildContext context, int purchaseId) async {


    final response = await NetworkUtil.internal().post('data-screen-buisness-department', body: {
      'user_id': Constants.userDetail!.access == 3 ? Constants.userDetail!.uid.toString() : 0.toString(),
      'expense_type_id': widget.expenseTypeId.toString(),
      'buisness_expense_id': widget.businessExpenseId.toString(),
      'department_id': widget.departmentId.toString(),
      'departments_expense_id': widget.departmentExpenseId.toString(),
      'departments_purchase_id': purchaseId.toString(),
      'departments_compensation_id': 0.toString(),
      'departments_employee_id': 0.toString(),
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
  List<DepartmentPurchaseModel>? purchase = [];
  @override
  void initState() {
    setState(() {
      Constants.dptPurchasingList!.forEach((element) {
        if(element.status == 0 && element.dptId == widget.departmentId){
          purchase!.add(element);
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          child: Icon(
            Platform.isIOS ? Icons.arrow_back_ios_sharp : Icons.arrow_back_rounded,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: ColorRefer.kPrimaryColor,
        title: const Text(
          'Purchase Tools',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: purchase!.isEmpty ? Container(child: emptyWidget('Add purchase tools expense from company portal', context),) :
      GridView.builder(
        padding: const EdgeInsets.all(20.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid
          crossAxisSpacing: 10.0, // Spacing between columns
          mainAxisSpacing: 10.0, // Spacing between rows
        ),
        itemCount: purchase!.length,
        itemBuilder: (BuildContext context, int index) {
          DepartmentPurchaseModel item = purchase![index];
          return SmallCards(
            text: item.name!,
            onTap: () async {
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
    return ScaffoldMessenger.of(context).showSnackBar( const SnackBar( content: Text("No Records Found"), duration: Duration(milliseconds: 1500), ), );
  }
}
