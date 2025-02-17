import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../api/networkUtils.dart';
import '../model/payment_model.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';
import '../widgets/input_filed.dart';
import 'bank_transaction_screen.dart';

class AddIncome extends StatefulWidget {
  const AddIncome({super.key, required this.id, required this.bankName});
  final int id;
  final String bankName;

  @override
  State<AddIncome> createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  String? description;
  String? amount;
  String? selectedDate;
  String? selectedPaymentMode;
  final picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  TextEditingController desController = TextEditingController();
  File? image;
  List<PaymentModel> paymentModes = Constants.listPaymentMode ?? [];
  Map<String, int> paymentModeMap = {
    for (var mode in Constants.listPaymentMode ?? [])
      if (mode.name != null) mode.name!: mode.id ?? 0
  };

  void pickImage(ImageSource imageSource) async {
    XFile? galleryImage = await picker.pickImage(source: imageSource);
    setState(() {
      image = File(galleryImage!.path);
    });
  }

  bool isLoading = false;

  Future<void> _submitData(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    formKey.currentState?.save();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      var response;
      if (image != null) {
        var postResponse = await NetworkUtil.internal().uploadIncomeDataWithImage(
          description ?? '',
          amount ?? '',
          selectedDate ?? '',
          selectedPaymentMode ?? '',
          widget.id.toString(), // Pass bank ID as a string
          widget.bankName,
          image!, // Pass the image file
        );
        response = postResponse;
      }
      else {
        print('Posting data without image...');
        var postResponse = await NetworkUtil.internal().post(
          'add_income',
          body: {
            'userid': Constants.userDetail?.uid?.toString() ?? '',
            'name': Constants.userDetail?.name ?? '',
            'access': Constants.userDetail?.access.toString() ?? '',
            'description': description ?? '',
            'amount': amount ?? '',
            'date': selectedDate ?? '',
            'paymentmode': selectedPaymentMode ?? '',
            'image': '',
            'bankid': widget.id.toString(), // Ensure id is converted to String
            'bankname': widget.bankName,
            'company_id': Constants.userDetail!.companyId.toString(),

          },
        );
        response = postResponse?.body;
      }
      print('API Response: $response');

      final output = jsonDecode(response);
      if (output['code'] == 200) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Income added successfully')),
        );
        Constants.bankId = widget.id;
        String bankName = '';
        Constants.bankList?.forEach((e) {
          if (e.id == Constants.bankId) {
            bankName = e.bankName!;
          }
        });
        Navigator.pushReplacementNamed(context, ViewBankTransactionList.viewBankTransactionScreenID, arguments: bankName);
      } else {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Failed to add income: ${output['message']}')),
        );
      }
    } catch (e) {
      print('Error: $e');
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: const CircularProgressIndicator(
        color: ColorRefer.kPrimaryColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Platform.isIOS
                  ? Icons.arrow_back_ios_sharp
                  : Icons.arrow_back_rounded,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: ColorRefer.kPrimaryColor,
          title: const Text(
            'Add Income',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputField(
                        textInputType: TextInputType.number,
                        label: 'Amount',
                        hintText: 'Enter your amount',
                        validator: (firstAmount) {
                          if (firstAmount!.isEmpty) return "Amount is required";
                          if (firstAmount.isEmpty) return "Minimum one character required";
                          return null;
                        },
                        onChanged: (value) => amount = value,
                      ),
                      const SizedBox(height: 15),
                      SelectDateField(
                        label: 'DD/MM/YY',
                        hint: 'Select Date',
                        onChanged: (value) {
                          setState(() {
                            if (value != null && value != '') {
                              selectedDate = value;
                              print(selectedDate);
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      DropdownField(
                        label: 'Payment Mode',
                        hintText: 'Select Mode',
                        items: paymentModeMap.keys.toList(),
                        onChanged: (value) {
                          setState(() {
                            int? selectedId = paymentModeMap[value];
                            selectedPaymentMode = selectedId.toString();
                          });
                        },
                        onTap: (){},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an item';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: QuillField(
                          controller: desController,
                          textInputType: TextInputType.text,
                          enable: true,
                          label: 'Description',
                          hintText: 'Write here...',
                          borderColor: ColorRefer.kLabelColor,
                          validator: (value) {
                            if (value!.isEmpty) return "Description is required";
                            if (value.length < 3) return "Minimum three characters required";
                            return null;
                          },
                          onTaP: () async {},
                          onChanged: (value) => description = value,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: InkWell(
                          onTap: () {
                            // Specify the image source, e.g., ImageSource.gallery or ImageSource.camera
                            pickImage(ImageSource.gallery);
                          },
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  width: 125,
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(color: ColorRefer.kLabelColor),
                                  ),
                                  child: image == null
                                      ? const Text('Choose file')
                                      : Image.file(
                                    image!,
                                    fit: BoxFit.cover,
                                    width: 100.0,
                                    height: 200.0,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10, bottom: 50),
                                child: Text(
                                  'Add Screen',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: ColorRefer.kLabelColor,
                                    fontFamily: FontRefer.OpenSans,
                                    backgroundColor: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, bottom: 25),
                  child: GestureDetector(
                    onTap: () {
                      _submitData(context);
                    },
                    child: Container(
                      width: 125,
                      height: 45,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: ColorRefer.kPrimaryColor,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: const Center(
                        child: Text(
                          "Add",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
