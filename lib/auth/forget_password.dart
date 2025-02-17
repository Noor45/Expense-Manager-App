import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../api/networkUtils.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../widgets/dialogs.dart';
import '../widgets/input_filed.dart';
import '../widgets/round_btn.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const String ID = "forget_password_screen";

  const ForgetPasswordScreen({super.key});
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _email;
  bool isLoading = false;

  Future<void> _sendPasswordResetEmail() async {
    try {
      if (!_formKey.currentState!.validate()) return;
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      final response = await NetworkUtil.internal().post('forgot-password', body: {
        'email':  _email,
      });
      final output = jsonDecode(response.body);
      setState(() {
        isLoading = false;
      });
      if (output['code'] == 200) {
        msg(context,
            'Success',
            output['message']
        );
      } else if (output['code'] == 400){
        msg(
            context,
            'Failed',
            output['message']
        );
      }
    } catch(e){
      setState(() {
        isLoading = false;
      });
      print(e);
    }

  }

  msg(BuildContext context, String title, String msg){
    showDialogAlert(
        context: context,
        title: title,
        message: msg,
        actionButtonTitle: 'OK',
        actionButtonOnPressed: (){
          Navigator.pop(context);
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: const CircularProgressIndicator(
        color: ColorRefer.kPrimaryColor,
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Reset Password',
            style:
            TextStyle(fontFamily: FontRefer.OpenSans),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              const AutoSizeText(
                'Enter your email below, We will send you password reset email.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: FontRefer.OpenSans,
                ),
              ),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: InputField(
                  textInputType: TextInputType.emailAddress,
                  label: 'Email',
                  validator: (String? emailValue) {
                    if (_email.isEmpty ?? true) {
                      return 'Email is required';
                    } else {
                      String p =
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                      RegExp regExp = RegExp(p);
                      if (regExp.hasMatch((_email ?? ""))) {
                        return null;
                      } else {
                        return 'Email Syntax is not Correct';
                      }
                    }
                  },
                  onChanged: (value) => _email = value,
                ),
              ),
              const SizedBox(height: 30),
              RoundedButton(
                title: 'Send email',
                buttonRadius: 20,
                colour: ColorRefer.kPrimaryColor,
                height: 45,
                onPressed: () => _sendPasswordResetEmail(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
