import 'package:flutter/cupertino.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import '../auth/login.dart';
import '../auth/option_screen.dart';
import '../controller/type_expense_controller.dart';
import '../model/user_model.dart';
import '../screens/full_access_main_screen.dart';
import '../screens/limited_access_main_screen.dart';
import '../utils/constants.dart';
import 'helping_funtion.dart';

Future<void> checkSession(BuildContext context) async {
  // try {
  await ExpenseController.getCompany();
  dynamic check = await SessionManager().containsKey("user_id");
  dynamic id = await SessionManager().get("user_id");
  dynamic companyId = await SessionManager().get("company_id");
  dynamic userDetail = await SessionManager().get("user_detail");
  if (check) {
    userDetail['id'] = int.parse(userDetail['id']);
    userDetail['access'] = int.parse(userDetail['access']);
    userDetail['company_id'] = int.parse(userDetail['company_id']);
    Constants.userId = id;
    Constants.companyId = companyId;
    Constants.userDetail = UserModel.fromMap(userDetail as Map<String, dynamic>);
    await getData();
    if(Constants.userDetail!.access == 1){
      Navigator.pushNamedAndRemoveUntil(context, FullAccessMainScreen.mainScreenID, (Route<dynamic> route) => false);
    }
    else{
      Navigator.pushNamedAndRemoveUntil(context, LimitedAccessMainScreen.mainScreenID, (Route<dynamic> route) => false);
    }
  } else {
    Future.delayed(const Duration(seconds: 1), () {
      // Navigator.pushNamed(context, SignInScreen.signInScreenID);
      Navigator.pushNamed(context, OptionScreen.ID);
    });
  }
}

