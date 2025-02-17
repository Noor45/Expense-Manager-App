import 'package:expense_wallet/auth/login.dart';
import 'package:expense_wallet/pages/detail_history.dart';
import 'package:expense_wallet/screens/add_expences.dart';
import 'package:expense_wallet/screens/bank_transaction_screen.dart';
import 'package:expense_wallet/screens/company_main_screen.dart';
import 'package:expense_wallet/screens/full_access_main_screen.dart';
import 'package:expense_wallet/screens/limited_access_main_screen.dart';
import 'package:expense_wallet/screens/privacy_policy.dart';
import 'package:expense_wallet/screens/term_and_condition.dart';
import 'package:flutter/material.dart';

import 'auth/company_login.dart';
import 'auth/forget_password.dart';
import 'auth/option_screen.dart';
import 'auth/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        ForgetPasswordScreen.ID: (_) => const ForgetPasswordScreen(),
        FullAccessMainScreen.mainScreenID: (context) => const FullAccessMainScreen(),
        LimitedAccessMainScreen.mainScreenID: (context) => const LimitedAccessMainScreen(),
        SignInScreen.signInScreenID: (context) => const SignInScreen(),
        AddExpenses.addExpenseScreenID: (context) => const AddExpenses(),
        OptionScreen.ID: (context) => const OptionScreen(),
        CompanySignInScreen.companySignInScreenID: (context) => const CompanySignInScreen(),
        DetailHistory.detailHistoryScreenID: (context) => const DetailHistory(title: ''),
        ViewBankTransactionList.viewBankTransactionScreenID: (context) => const ViewBankTransactionList(),
        CompanyMainScreen.ID: (context) => CompanyMainScreen(),
        TermsAndConditionScreen.ID: (context) => TermsAndConditionScreen(),
        PrivacyAndPolicyScreen.ID: (context) => PrivacyAndPolicyScreen(),
      },
    );
  }
}


