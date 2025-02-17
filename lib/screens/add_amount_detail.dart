import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../api/networkUtils.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class AddedTransactionDetailsScreen extends StatefulWidget {
  static String addedTransactionDetailsID = "/added_bank_transaction_screen";
  final String transactionId;
  const AddedTransactionDetailsScreen({super.key, required this.transactionId});
  @override
  State<AddedTransactionDetailsScreen> createState() =>
      _AddedTransactionDetailsScreenState();
}

class _AddedTransactionDetailsScreenState
    extends State<AddedTransactionDetailsScreen> {
  late Map<String, dynamic> transaction = {};
  late bool isLoading = false;
  String paymentMode = '';
  String bankName = '';
  String bankImage = '';

  Future fetchPost() async {
    setState(() {
      isLoading = true;
    });
    final response =
        await NetworkUtil.internal().post('item-data-income', body: {
      'id': widget.transactionId,
      'company_id': Constants.userDetail!.companyId!.toString()
    });
    Map<String, dynamic> jsonMap = json.decode(response.body);
    if (jsonMap['code'] == 200) {
      transaction = await jsonMap['data'][0];
      setState(() {
        Constants.listPaymentMode?.forEach((e) {
          if (e.id == int.parse(transaction['payment_mode'])) {
            paymentMode = e.name!;
          }
        });
        Constants.bankList?.forEach((e) {
          if (e.id == int.parse(transaction['bank_id'])) {
            bankName = e.bankName!;
            bankImage = e.image!;
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Transaction Detail'),
        backgroundColor: ColorRefer.kPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading == false
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    CircularNetworkImage(
                      imageUrl:
                          'https://desired-techs.com/ExpenseManager/images/bank/${bankImage}',
                    ),
                    const SizedBox(height: 10),
                    Text(
                      bankName,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black45,
                          fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 50),
                    buildDetailItem(
                        'Amount',
                        '+  Rs.${moneyFormat(transaction['amount'])}',
                        '1',
                        FontAwesomeIcons.moneyCheck),
                    buildDetailItem(
                        'Date',
                        DateFormat("MMM dd yyyy HH:mm:ss a")
                            .format(DateTime.parse(transaction['datetime'])),
                        '1',
                        FontAwesomeIcons.calendarAlt),
                    buildDetailItem(
                        'Payment Mode',
                        paymentMode,
                        transaction['payment_mode'],
                        FontAwesomeIcons.creditCard),
                    buildDetailItem('Description', transaction['details'], '1',
                        FontAwesomeIcons.stickyNote),
                    if (transaction['image'] != null &&
                        transaction['image'] != '')
                      buildScreenshot(transaction['image']),
                  ],
                ),
              )
            : const Center(
                child:
                    CircularProgressIndicator(color: ColorRefer.kPrimaryColor)),
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
                style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black45,
                    fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              '$value',
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      title == 'Amount' ? FontWeight.w600 : FontWeight.w400,
                  color: title == 'Amount' ? Colors.green : Colors.black45),
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
          Image.network(
              'https://desired-techs.com/ExpenseManager/images/expense/$screenshotUrl'),
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
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            );
          }
        },
        errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          return const Icon(Icons.error, size: 50, color: Colors.red);
        },
      ),
    );
  }
}
