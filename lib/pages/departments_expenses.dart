import 'dart:io';

import 'package:expense_wallet/cards/vertical_cards.dart';
import 'package:expense_wallet/model/department_expense_list_model.dart';
import 'package:expense_wallet/pages/management.dart';
import 'package:expense_wallet/pages/purchase_tools_list.dart';
import 'package:flutter/material.dart';
import '../cards/small_card.dart';
import '../model/department_model.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/empty_widget.dart';


class DepartmentScreen extends StatefulWidget {
  const DepartmentScreen({Key? key, required this.businessExpenseId, required this.expenseType, required this.expenseTypeId}) : super(key: key);
  final int businessExpenseId;
  final int expenseTypeId;
  final String expenseType;

  @override
  State<DepartmentScreen> createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {

  List<DepartmentModel>? department = [];
  @override
  void initState() {
    setState(() {
      Constants.departments!.forEach((element) {
        if(element.status == 0){
          department!.add(element);
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
        title: const Text(
          'Departments',
          style:
          TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: department!.isEmpty ? Container(child: emptyWidget('Add department from company portal', context),) :
      GridView.builder(
        padding: const EdgeInsets.all(20.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid
          crossAxisSpacing: 10.0, // Spacing between columns
          mainAxisSpacing: 10.0, // Spacing between rows
        ),
        itemCount: department!.length,
        itemBuilder: (BuildContext context, int index) {
          return SmallCards(
            text: department![index].deptName!,
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          ExpensesDetail(
                            departmentId: department![index].id!,
                            businessExpenseId: widget.businessExpenseId,
                            expenseTypeId: widget.expenseTypeId,
                          )
                  )
              );
            },

          );
        },
      ),
    );
  }
}



class ExpensesDetail extends StatefulWidget {
  const ExpensesDetail({Key? key, required this.businessExpenseId, required this.expenseTypeId,  required this.departmentId}) : super(key: key);
  final int departmentId;
  final int businessExpenseId;
  final int expenseTypeId;

  @override
  State<ExpensesDetail> createState() => _ExpensesDetailState();
}

class _ExpensesDetailState extends State<ExpensesDetail> {
  List<DepartmentTypeExpenseModel>? dptExpense = [];
  int comp = 1;
  int tools = 2;
  @override
  void initState() {
    setState(() {
      Constants.departmentExpenseList!.forEach((element) {
        // if(element. == 0){
          dptExpense!.add(element);
        // }
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
        title: const Text(
          'Department Expenses',
          style:
          TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: dptExpense!.isEmpty ? Container(  child: emptyWidget('Add department Expense Category from company portal', context),) :
      Column(
        children: [
          const SizedBox(height: 25,),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: dptExpense!.length,
              itemBuilder: (BuildContext context, int index) {
                if(dptExpense![index].dptExpenseType! == 1){
                  comp = dptExpense![index].dptExpenseType!;
                }else{
                  tools = dptExpense![index].dptExpenseType!;
                }
                return Column(
                  children: [
                    comp == 1 && dptExpense![index].status == 1 && tools == 2 && dptExpense![index].status == 1
                        ? Padding (
                      padding: const EdgeInsets.fromLTRB(15, 15, 10, 15),
                      child: index == 0  ? Container(child: emptyWidget('Activate department Expense Category from your company portal', context),) : SizedBox(),
                    ) : const SizedBox(),
                    Visibility(
                      visible: dptExpense![index].status! == 0 ? true : false,
                      child: VerticalCard(
                        text: dptExpense![index].name!,
                        onTap: () {
                          if(dptExpense![index].dptExpenseType! == 1) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                  Management(
                                    departmentId: widget.departmentId,
                                    departmentExpenseId: dptExpense![index].dptExpenseType!,
                                    expenseTypeId: widget.expenseTypeId,
                                    businessExpenseId: widget.businessExpenseId,
                                  )
                              )
                            );
                          } else {
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PurchaseTools(
                                          departmentId: widget.departmentId,
                                          departmentExpenseId: dptExpense![index].dptExpenseType!,
                                          expenseTypeId: widget.expenseTypeId,
                                          businessExpenseId: widget.businessExpenseId,
                                        )
                                )
                            );
                          }

                        },

                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

