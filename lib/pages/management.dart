import 'dart:io';
import 'package:expense_wallet/pages/contractor_list_name.dart';
import 'package:expense_wallet/pages/emplyee_list_name.dart';
import 'package:expense_wallet/pages/investor%20_list_name.dart';
import 'package:flutter/material.dart';
import '../cards/vertical_cards.dart';
import '../model/compensation_list_model.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/empty_widget.dart';

class Management extends StatefulWidget {
  const Management({Key? key, required this.businessExpenseId, required this.departmentId, required this.expenseTypeId,  required this.departmentExpenseId}) : super(key: key);
  final int departmentExpenseId;
  final int businessExpenseId;
  final int departmentId;
  final int expenseTypeId;

  @override
  State<Management> createState() => _ManagementState();
}

class _ManagementState extends State<Management> {
  List<CompensationModel>? compensation = [];
  int employee = 1, investor = 2, contractor = 3;
  @override
  void initState() {
    setState(() {
      Constants.compensationList!.forEach((element) {
        compensation!.add(element);
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
          'Compensations',
          style:
          TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body:
      compensation!.isEmpty ? Container(child: emptyWidget('No Expense to show', context),) :
      Column(
        children: [
          const SizedBox(height: 25,),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: compensation!.length,
              itemBuilder: (BuildContext context, int index) {
                print(compensation);
                if(compensation![index].compTypeId! == 1) {
                  employee = compensation![index].compTypeId!;
                }else if(compensation![index].compTypeId! == 2) {
                  investor = compensation![index].compTypeId!;
                }else {
                  contractor = compensation![index].compTypeId!;
                }
                int expenseId = compensation![index].compTypeId!; // Assuming 'id' is the key for database ID
                return Column(
                  children: [
                    (employee == 1 && compensation![index].status == 1) && (investor == 2 && compensation![index].status == 1) && (contractor == 3 && compensation![index].status == 1)
                        ? Padding (
                      padding: const EdgeInsets.fromLTRB(15, 15, 10, 15),
                      child: index == 0  ? Container(child: emptyWidget('Activate Compensation Category from your company portal', context),) : SizedBox(),
                    ) : const SizedBox(),
                    Visibility(
                      visible: compensation![index].status! == 0 ? true : false,
                      child: VerticalCard(
                        text: compensation![index].type!,
                        onTap: () {
                          if (expenseId == 1) {
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EmployeeName(
                                          businessExpenseId: widget.businessExpenseId,
                                          departmentExpenseId: widget.departmentExpenseId,
                                          departmentId: widget.departmentId,
                                          departmentsCompensationId: compensation![index].compTypeId!,
                                          departmentsPurchaseId: 0,
                                          expenseTypeId: widget.expenseTypeId,
                                        )
                                )
                            );
                          } else if (expenseId == 2) {
                            // Navigate to BusinessItems screen
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        InvestorName(
                                          businessExpenseId: widget.businessExpenseId,
                                          departmentExpenseId: widget.departmentExpenseId,
                                          departmentId: widget.departmentId,
                                          departmentsCompensationId: compensation![index].compTypeId!,
                                          departmentsPurchaseId: 0,
                                          expenseTypeId: widget.expenseTypeId,
                                        )
                                )
                            );
                          }
                          else if (expenseId == 3) {
                            // Navigate to BusinessItems screen
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ContractorName(
                                          businessExpenseId: widget.businessExpenseId,
                                          departmentExpenseId: widget.departmentExpenseId,
                                          departmentId: widget.departmentId,
                                          departmentsCompensationId: compensation![index].compTypeId!,
                                          departmentsPurchaseId: 0,
                                          expenseTypeId: widget.expenseTypeId,
                                        )
                                )
                            );
                          } else {
                            // Handle other IDs if needed
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
