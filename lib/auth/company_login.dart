import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:expense_wallet/auth/signup.dart';
import 'package:expense_wallet/screens/full_access_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../api/networkUtils.dart';
import '../funtions/helping_funtion.dart';
import '../model/company_model.dart';
import '../model/user_model.dart';
import '../screens/company_main_screen.dart';
import '../screens/limited_access_main_screen.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';
import '../widgets/dialogs.dart';
import '../widgets/input_filed.dart';
import '../widgets/round_btn.dart';
import 'forget_password.dart';

class CompanySignInScreen extends StatefulWidget {
  static String companySignInScreenID = "/company_sign_in_screen";
  const CompanySignInScreen({super.key});


  @override
  State<CompanySignInScreen> createState() => _CompanySignInScreenState();
}

class _CompanySignInScreenState extends State<CompanySignInScreen> {
  final formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool isLoading = false;

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
          backgroundColor: ColorRefer.kPrimaryColor,
          title: const Text(
            'Sign In',
            style:
            TextStyle(fontFamily: FontRefer.OpenSans),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 140),
                  const Text('Sign In as Company', style: TextStyle(
                      color: Color(0xff97a6ba),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      fontFamily: FontRefer.OpenSans,
                      letterSpacing: 2)),
                  const SizedBox(height: 45),
                  InputField(
                    textInputType: TextInputType.emailAddress,
                    label: 'Email',
                    hintText: 'user@mail.com',
                    validator: (String? emailValue) {
                      if (email?.isEmpty ?? true) {
                        return 'Email is required';
                      } else {
                        String p =
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                        RegExp regExp = RegExp(p);
                        if (regExp.hasMatch((email ?? ""))) {
                          return null;
                        } else {
                          return 'Email Syntax is not Correct';
                        }
                      }
                    },
                    onChanged: (value) => email = value,
                    controller: null,
                  ),
                  const SizedBox(height: 15),
                  PasswordInputField(
                    label: 'Password',
                    hintText: '• • • • • • • • •',
                    textInputType: TextInputType.emailAddress,
                    obscureText: true,
                    validator: (String? password) {
                      if (password?.isEmpty ?? true) {
                        return "Password is required!";
                      }
                      if ((password ?? "").length < 6) {
                        return "Minimum 6 characters are required";
                      }
                      return null;
                    },
                    onChanged: (value) => password = value,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () =>
                            Navigator.pushNamed(
                                context, ForgetPasswordScreen.ID),
                        child: const Center(
                          child: AutoSizeText(
                            'Forgot Password?',
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: FontRefer.OpenSans,
                                color: Color(0xff97a6ba),
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  RoundedButton(
                      title: 'SIGN IN',
                      buttonRadius: 25,
                      colour: ColorRefer.kPrimaryColor,
                      height: 48,
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) return;
                        setState(() {
                          isLoading = true;
                        });
                        await signIn();
                      }),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: FontRefer.OpenSans,
                          color: Colors.grey,
                        ),
                      ),
                      InkWell(
                          onTap: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SignUPScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: FontRefer.OpenSans,
                                color: ColorRefer.kSecondary1Color,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  signIn() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    // try {
    if (email == null || password == null) {
      setState(() {
        isLoading = false; // Show loading indicator
      });
      throw Exception("Email or password is null");
    }
    print(email);
    print(password);
    final response = await NetworkUtil.internal().adminPost('login', body: {
      'email': email!,
      'password': password!,
    });
    final output = jsonDecode(response.body);
    if (output['code'] == 200) {
      Navigator.pushNamedAndRemoveUntil(context,  CompanyMainScreen.ID, (Route<dynamic> route) => false);

      // if(int.parse(output['data']['access']) == 0) {
      //   showDialogAlert(
        //     context: context, title: "No Access", message: 'Your account is not approved yet.', actionButtonTitle: "OK", actionButtonOnPressed: () {
        //   Navigator.pop(context);
        //   setState(() {
        //     isLoading = false;
        //   });
        // });
      // }
      // else{
        var sessionManager = SessionManager();
        // await sessionManager.set('user_id', output['data']['id']);
        await sessionManager.set('company_id', output['data']['company_id']);
        await sessionManager.set("company_detail", jsonEncode(output['data']));
        Constants.companyId = int.parse(output['data']['id']);
        output['data']['id'] = int.parse(output['data']['id']);
        Constants.companyDetail = CompanyModel.fromMap(output['data'] as Map<String, dynamic>);
        await getData();
        setState(() {
          isLoading = false;
        });
        // if(Constants.userDetail!.access == 1){
        // }
        // else{
          Navigator.pushNamedAndRemoveUntil(context, LimitedAccessMainScreen.mainScreenID, (Route<dynamic> route) => false);
        // }
      // }
    } else {
      setState(() {
        isLoading = false; // Show loading indicator
      });
      showDialogAlert(
          context: context, title: "Invalid", message: output['message'], actionButtonTitle: "OK", actionButtonOnPressed: () {
        Navigator.pop(context);
      });
    }
    // } catch (e) {
    //   AppDialog().showOSDialog(
    //     context,
    //     "Error",
    //     "An error occurred. Please try again later.",
    //     "OK",
    //         () {},
    //   );
    // } finally {
    //   setState(() {
    //     isLoading = false; // Hide loading indicator
    //   });
    // }
  }


}