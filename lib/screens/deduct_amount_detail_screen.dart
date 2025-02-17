import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../api/networkUtils.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class DeductedTransactionDetailsScreen extends StatefulWidget {
  static String deductedTransactionDetailsID = "/add_bank_transaction_screen";
  final String transactionId;
  const DeductedTransactionDetailsScreen({super.key, required this.transactionId});
  @override
  State<DeductedTransactionDetailsScreen> createState() => _DeductedTransactionDetailsScreenState();
}

class _DeductedTransactionDetailsScreenState extends State<DeductedTransactionDetailsScreen> {
  late Map<String, dynamic> transaction = {};
  late bool isLoading = false;
  String paymentMode = '';
  String bankName = '';
  String bankImage = '';
  String expenseType = '';
  String generalExpense = '';
  String businessExpense = '';
  String department = '';
  String departmentExpense = '';
  String departmentPurchase = '';
  String compensationType = '';
  String employee = '';
  String everyDayExpense = '';
  String transactionBy = '';



  Future fetchPost() async {
    setState(() {
      isLoading = true;
    });
    final response = await NetworkUtil.internal().post('item-data-expense', body: {
      'id': widget.transactionId,
      'company_id': Constants.userDetail!.companyId!.toString()
    });
    Map<String, dynamic> jsonMap = json.decode(response.body);
    if (jsonMap['code'] == 200) {
      transaction = await jsonMap['data'][0];
      setState(() {

        Constants.listPaymentMode?.forEach((e) {
          if (e.id == int.parse(transaction['payment_mode_id'])) {
            paymentMode = e.name!;
          }
        });
        Constants.bankList?.forEach((e) {
          if (e.id == int.parse(transaction['bank_id'])) {
            bankName = e.bankName!;
            bankImage = e.image!;
          }
        });

        Constants.generalExpenseList?.forEach((e) {
          if (e.id == int.parse(transaction['general_expense_id'])) {
            generalExpense = e.name!;
          }
        });

        Constants.businessExpenseList?.forEach((e) {
          if (e.id == int.parse(transaction['buisness_expense_id'])) {
            businessExpense = e.name!;
          }
        });

        Constants.typeExpense?.forEach((e) {
          if (e.expenseTypeId == int.parse(transaction['expense_type_id'])) {
            expenseType = e.expenseName!;
          }
        });

        Constants.departments?.forEach((e) {
          if (e.id == int.parse(transaction['department_id'])) {
            department = e.deptName!;
          }
        });

        Constants.departmentExpenseList?.forEach((e) {
          if (e.id == int.parse(transaction['departments_expense_id'])) {
            departmentExpense = e.name!;
          }
        });
        Constants.compensationList?.forEach((e) {
          if (e.id == int.parse(transaction['departments_compensation_id'])) {
            compensationType = e.type!;
          }
        });

        Constants.employeesList?.forEach((e) {
          if (e.id == int.parse(transaction['departments_employee_id'])) {
            employee = e.name!;
          }
        });

        Constants.dptPurchasingList?.forEach((e) {
          if (e.id == int.parse(transaction['departments_purchase_id'])) {
            departmentPurchase = e.name!;
          }
        });

        Constants.everydayExpenseList?.forEach((e) {
          if (e.id == int.parse(transaction['everyday_expense_id'])) {
            everyDayExpense = e.name!;
          }
        });

        Constants.userLists?.forEach((e) {
          if (e.uid == int.parse(transaction['transaction_by'])) {
            if(e.uid == Constants.userDetail!.uid){
              transactionBy = 'Self';
            }else{
              transactionBy = e.name!;
            }
          }
        });


        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }


  @override
  void initState() {
    fetchPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(transaction);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Transaction Detail'),
        backgroundColor: ColorRefer.kPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading == false ?
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              CircularNetworkImage(
                imageUrl: 'https://desired-techs.com/ExpenseManager/images/bank/${bankImage}',
              ),
              SizedBox(height: 10),
              Text(
                '$bankName',
                style: const TextStyle(fontSize: 16, color: Colors.black45, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 30),
              buildDetailItem('Amount',  '-  Rs.${moneyFormat(transaction['amount'])}', '1', FontAwesomeIcons.moneyCheck),
              buildDetailItem('Date', DateFormat("MMM dd yyyy").format(DateTime.parse(transaction['date'])), '1', FontAwesomeIcons.calendarAlt),
              buildDetailItem('Payment Mode',  paymentMode, transaction['payment_mode_id'], FontAwesomeIcons.creditCard),
              buildDetailItem('Type', expenseType, transaction['expense_type_id'], FontAwesomeIcons.tags),
              buildDetailItem('Expense', generalExpense, transaction['general_expense_id'], FontAwesomeIcons.moneyBillWave),
              buildDetailItem('Expense', businessExpense, transaction['buisness_expense_id'], FontAwesomeIcons.briefcase),
              buildDetailItem('Department', department, transaction['department_id'], FontAwesomeIcons.building),
              buildDetailItem('Expense Type', departmentExpense, transaction['departments_expense_id'], FontAwesomeIcons.sitemap),
              buildDetailItem('Pay For', compensationType, transaction['departments_compensation_id'], FontAwesomeIcons.donate),
              buildDetailItem('Name', employee, transaction['departments_employee_id'], FontAwesomeIcons.users),
              buildDetailItem('Name', departmentPurchase, transaction['departments_purchase_id'], FontAwesomeIcons.shoppingCart),
              buildDetailItem('Pay For', everyDayExpense, transaction['everyday_expense_id'], FontAwesomeIcons.calendarDay),
              buildDetailItem('Transaction By', transactionBy, transaction['transaction_by'], FontAwesomeIcons.user),

              buildDetailItem('Description', transaction['description'], '1', FontAwesomeIcons.stickyNote),
              if ( transaction['screenshot'] != null) buildScreenshot( transaction['screenshot']),
            ],
          ),
        ) :
        const Center(child: CircularProgressIndicator(color: ColorRefer.kPrimaryColor)),
      ),
    );
  }

  Widget buildDetailItem(String title, String value, String id, IconData icon) {
    if (int.parse(id) == 0) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black45, size: 14),
              const SizedBox(width: 16),
              Text(
                title,

                style: const TextStyle(fontSize: 14, color: Colors.black45, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              '$value',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 13, fontWeight: title == 'Amount' ? FontWeight.w600 : FontWeight.w400, color: title == 'Amount' ? Colors.red : Colors.black45),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildScreenshot(String screenshotUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Screenshot:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Image.network('https://desired-techs.com/ExpenseManager/images/expense/$screenshotUrl'),
        ],
      ),
    );
  }


}

class CircularNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double size;

  const CircularNetworkImage({
    super.key,
    required this.imageUrl,
    this.size = 100.0, // Default size
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            );
          }
        },
        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
          return const Icon(Icons.error, size: 50, color: Colors.red);
        },
      ),
    );
  }
}

