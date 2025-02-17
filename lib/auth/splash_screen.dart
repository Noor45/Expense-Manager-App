import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../funtions/check_session.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _initApp() async {
    checkSession(context);
    // Future.delayed(const Duration(seconds: 2), () {
    //   Get.offAll(() => SignInScreen(
    //   ));
    // });

  }
  @override
  void initState() {
    _initApp();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRefer.kPrimaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.width / 3,
            ),
            const SizedBox(height: 12),
            const AutoSizeText(
              'Expense Wallet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: ColorRefer.kSecondary1Color,
                fontWeight: FontWeight.w600,
                fontFamily: FontRefer.OpenSans,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
