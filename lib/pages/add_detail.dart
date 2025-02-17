import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../widgets/input_filed.dart';




class AddUserDetail extends StatefulWidget {
  const AddUserDetail({super.key, this.jobDescriptionController});
  final TextEditingController? jobDescriptionController;

  @override
  State<AddUserDetail> createState() => _AddUserDetailState();
}

class _AddUserDetailState extends State<AddUserDetail> {
  String? jobDescription;
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
          'User Detail',
          style:
          TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        actions: [
        GestureDetector(
          onTap: (){

          },
          child: const Padding(
            padding: EdgeInsets.only(right: 15),
            child: AutoSizeText(
               "Save",
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: FontRefer.OpenSans,
                  color:Colors.white),
            ),
          ),
        )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
              children: [
                const SizedBox(height: 40),
                InputField(
                  textInputType: TextInputType.number,
                  label: 'Amount',
                  // validator: (firstName) {
                  //   if (firstName!.isEmpty) return "Name is required";
                  //   if (firstName.length < 3) return "Minimum three characters required";
                  //   return null;
                  // },
                  // onChanged: (value) => _name = value,
                ),
                const SizedBox(height: 15),
                SelectDateField(
                  // controller: widget.startDateController,
                  label: 'DD/MM/YY',
                  onChanged: (value){
                    setState(() {
                      // if(value != null && value!='') startDateSelected = true;
                      // String formattedDate = DateFormat('d MMM y').format(DateTime.parse(value));
                      // widget.startDate!.call(formattedDate);
                    });
                  },
                ),
                const SizedBox(height: 15),
                DropdownField(
                  label: 'Payment Mode',
                  hintText: 'Select Item',
                  // items: const ['Item 1', 'Item 2', 'Item 3'],
                  onChanged: (value) {
                    print('Selected: $value');
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an item';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                QuillField(
                  controller: widget.jobDescriptionController,
                  textInputType: TextInputType.text,
                  label: 'Description',
                  hintText: 'Write here...',
                  borderColor: ColorRefer.kLabelColor,
                  validator: (value) {
                    if (value!.isEmpty) return "Description is required";
                    if (value.length < 3) return "Minimum three characters required";
                    return null;
                  },
                  // onTaP: () async{
                  //   // FocusScope.of(context).requestFocus(new FocusNode());
                  //   // await Navigator.pushNamed(context, JobDesQuillWidgetScreen.jobQuillWidgetScreenID, arguments: jobDescription != null ? jobDescription : '');
                  //   // setState(() {
                  //   //   jobDescription = Constants.bio;
                  //   //   widget.jobDescriptionController?.text = stripHtmlTags(Constants.bio);
                  //   //   widget.jobDescriptionOnChange!.call(jobDescription);
                  //   // });
                  //   //
                  //   //
                  //   // final result = await Navigator.pushNamed(context, QuillWidgetScreen.quillWidgetScreenID, arguments: jobDescription != null ? jobDescription : '');
                  //   // if (result != null) {
                  //   //   setState(() {
                  //   //     jobDescription = result as String;
                  //   //     widget.jobDescriptionController?.text = stripHtmlTags(jobDescription!);
                  //   //     widget.jobDescriptionOnChange!.call(jobDescription);
                  //   //   });
                  //   // }
                  // },
                  onChanged: (value) {
                    setState(() {
                      jobDescription = value;
                    });
                  },
                ),
              ],
        ),
      ),
    );
  }
}
