import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import '../api/networkUtils.dart';
import '../cards/management_cards.dart';
import '../model/add_expense_model.dart';
import '../model/employee_list_model.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/empty_widget.dart';
import 'detail_history.dart';

class ContractorName extends StatefulWidget {
  const ContractorName({Key? key, required this.businessExpenseId, required this.departmentId, required this.expenseTypeId,  required this.departmentExpenseId, required this.departmentsCompensationId, required this.departmentsPurchaseId}) : super(key: key);
  final int departmentExpenseId;
  final int departmentsCompensationId;
  final int departmentsPurchaseId;
  final int businessExpenseId;
  final int departmentId;
  final int expenseTypeId;

  @override
  State<ContractorName> createState() => _ContractorNameState();
}

class _ContractorNameState extends State<ContractorName> {

  Future<bool> fetchData(BuildContext context, int employeeId) async {
    final response = await NetworkUtil.internal().post('data-screen-buisness-department', body: {
      'user_id': Constants.userDetail!.access == 3 ? Constants.userDetail!.uid.toString() : 0.toString(),
      'expense_type_id': widget.expenseTypeId.toString(),
      'buisness_expense_id': widget.businessExpenseId.toString(),
      'department_id': widget.departmentId.toString(),
      'departments_expense_id': widget.departmentExpenseId.toString(),
      'departments_compensation_id': widget.departmentsCompensationId.toString(),
      'departments_employee_id': employeeId.toString(),
      'departments_purchase_id': widget.departmentsPurchaseId.toString(),
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
  List<EmployeeListModel>? contractor = [];
  @override
  void initState() {
    setState(() {
      Constants.employeesList!.forEach((element) {
        if(element.status == 0 && element.dptId == widget.departmentId && element.employeeType! == 3){
          contractor!.add(element);
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
            child: Icon(Platform.isIOS
                ? Icons.arrow_back_ios_sharp
                : Icons.arrow_back_rounded)),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: ColorRefer.kPrimaryColor,
        title: const Text(
          'Contractor',
          style:
          TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
    body: contractor!.isEmpty ? Container( child: emptyWidget('Add contractor expense from company portal', context),) :
    Column(
        children: [
          const SizedBox(height: 25),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: Constants.employeesList!.length,
              itemBuilder: (BuildContext context, int index) {
                if (Constants.employeesList![index].employeeType! == 3) {
                  return ManagementCards(
                    text: Constants.employeesList![index].name!,
                    imagePath: Constants.employeesList![index].image!,
                    onTap: () async{
                      SimpleFontelicoProgressDialog _dialog = SimpleFontelicoProgressDialog(context: context);
                      _dialog.show(textStyle: const TextStyle(fontSize: 14, color: Colors.grey),  message: 'Loading', type: SimpleFontelicoProgressDialogType.phoenix, indicatorColor: ColorRefer.kPrimaryColor);
                      bool value = await fetchData(context, Constants.employeesList![index].id!);
                      _dialog.hide();
                      if(value == true) {
                        Future.microtask(() {
                          if (mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  DetailHistory(title: Constants.employeesList![index].name!),
                              ),
                            );
                          }
                        });
                      }
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  showSnack() {
    return ScaffoldMessenger.of(context).showSnackBar( const SnackBar( content: Text("No Records Found"), duration: Duration(milliseconds: 1500), ), );
  }
}
