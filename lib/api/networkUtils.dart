
import 'dart:io';

import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class NetworkUtil {

  static NetworkUtil _instance = new NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  uploadDataWithImage(String name, String email, String password, File image, String companyId) async {
    try {
      var url = Uri.https('www.desired-techs.com', 'ExpenseManager/Api/register.php');

      var request = http.MultipartRequest('POST', url)
        ..fields['name'] = name
        ..fields['email'] = email
        ..fields['password'] = password
        ..fields['company_id'] = companyId
        ..files.add(await http.MultipartFile.fromPath('image', image.path));
      var response = await http.Response.fromStream(await request.send());
      return response.body;
    } catch (e) {
      print(e);
    }
  }

  post(String url,
      {Map<String, String>? headers, body, encoding}) {
    try{
      var URL = Uri.https('www.desired-techs.com', '/ExpenseManager/Api/$url.php');
      return http
          .post(
          URL,
          body: body,
          headers: headers,
          encoding: encoding);
    }
    catch(e){
      print(e);
    }
  }

  adminPost(String url,
      {Map<String, String>? headers, body, encoding}) {
    try{
      var URL = Uri.https('www.desired-techs.com', '/ExpenseManager/admin-api/$url.php');
      return http
          .post(
          URL,
          body: body,
          headers: headers,
          encoding: encoding);
    }
    catch(e){
      print(e);
    }
  }

  Future<String?> uploadIncomeDataWithImage(String description, String amount, String selectedDate, String selectedPaymentMode, String bankId, String bankName, File image) async {
    try {
      var url = Uri.https('www.desired-techs.com', 'ExpenseManager/Api/add_income.php');
      var request = http.MultipartRequest('POST', url)
        ..fields['userid'] = Constants.userDetail!.uid!.toString()
        ..fields['name'] = Constants.userDetail!.name!
        ..fields['access'] = Constants.userDetail!.access.toString()!
        ..fields['bankid'] = bankId
        ..fields['bankname'] = bankName
        ..fields['amount'] = amount
        ..fields['date'] = selectedDate
        ..fields['paymentmode'] = selectedPaymentMode
        ..fields['description'] = description
        ..files.add(await http.MultipartFile.fromPath('image', image.path));
      var response = await http.Response.fromStream(await request.send());
      return response.body;
    } catch (e) {
      print('Error during image upload: $e');
      return null; // Return null in case of an exception
    }
  }

  Future<String?> uploadExpenseDataWithImage(
      int? selectedExpenseItem,
      int? selectedGeneral,
      int? selectedBusiness,
      int? selectedEveryDayExpense,
      int? selectedDept,
      int? selectedDeptExpense,
      int? selectedDeptToolsExpense,
      int? selectedCompassion,
      int? selectedEmployee,
      int? selectedBank,
      int? selectedPaymentMode,
      String? description,
      String? amount,
      String? selectedDate,
      File image,
      String? companyId,
  ) async {
    try {
      var url = Uri.https('www.desired-techs.com', 'ExpenseManager/Api/add-expense.php');

      var request = http.MultipartRequest('POST', url)
        ..fields['expense_type_id'] = selectedExpenseItem.toString()
        ..fields['general_expense_id'] = selectedGeneral.toString()
        ..fields['buisness_expense_id'] = selectedBusiness.toString()
        ..fields['department_id'] = selectedDept.toString()
        ..fields['departments_expense_id'] = selectedDeptExpense.toString()
        ..fields['departments_compensation_id'] = selectedCompassion.toString()
        ..fields['departments_purchase_id'] = selectedDeptToolsExpense.toString()
        ..fields['payment_mode_id'] = selectedPaymentMode.toString()
        ..fields['amount'] = amount!
        ..fields['description'] = description!
        ..fields['user_id'] = Constants.userDetail!.uid.toString()
        ..fields['bank_id'] = selectedBank.toString()
        ..fields['departments_employee_id'] = selectedEmployee.toString()
        ..fields['date'] = selectedDate.toString()
        ..fields['company_id'] = companyId!
        ..files.add(await http.MultipartFile.fromPath('screenshot', image.path));
      var response = await http.Response.fromStream(await request.send());
      return response.body;
    } catch (e) {
      print('Error during image upload: $e');
      return null; // Return null in case of an exception
    }
  }




}
