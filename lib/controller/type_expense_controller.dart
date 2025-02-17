import 'dart:convert';
import 'dart:io';
import 'package:expense_wallet/model/user_model.dart';
import 'package:http/http.dart' as http;
import '../model/bank_transaction_model.dart';
import '../model/company_model.dart';
import '../model/department_purchasing_list_model.dart';
import '../model/payment_model.dart';
import '../../api/networkUtils.dart';
import '../model/bank_model.dart';
import '../model/business_expense_list_model.dart';
import '../model/compensation_list_model.dart';
import '../model/department_expense_list_model.dart';
import '../model/department_model.dart';
import '../model/employee_list_model.dart';
import '../model/everyday_expense_list_model.dart';
import '../model/expense_type_model.dart';
import '../model/general_expense_list_model.dart';
import '../utils/constants.dart';

class ExpenseController {

  static getExpense() async {
    final response = await NetworkUtil.internal().post('fetch_expense_type', body: {
      'company_id': Constants.userDetail!.companyId!.toString(),
    });
    if (response.statusCode == 200) {
      Constants.typeExpense?.clear();
      List<dynamic> typeExpense = json.decode(response.body);
      for (var element in typeExpense) {
        ExpenseTypeModel expenseTypeList = ExpenseTypeModel.fromMap(element);
        Constants.typeExpense!.add(expenseTypeList);
      }
    } else {
      throw Exception('Failed to load post');
    }
  }

  static getUsers() async {
    final response = await NetworkUtil.internal().post('fetch-user', body: {
      'company_id': Constants.userDetail!.companyId!.toString(),
    });
    Map<String, dynamic> jsonMap = json.decode(response.body);
    if (jsonMap['code'] == 200) {
      List<dynamic> usersList = jsonMap['data'];

      Constants.userLists?.clear();
      for (var element in usersList) {
        element['id'] = int.parse(element['id']);
        element['access'] = int.parse(element['access']);
        element['company_id'] = int.parse(element['company_id']);
        UserModel usersList = UserModel.fromMap(element);
        Constants.userLists!.add(usersList);
      }
    } else {
      throw Exception('Failed to load post');
    }
  }

  static getStats() async {
    final response = await NetworkUtil.internal().post('dashboard-analytics', body: {
      'company_id': Constants.userDetail!.companyId!.toString(),
    });
    if (response.statusCode == 200) {
      print(response.body);
      var expense = json.decode(response.body);
      Constants.income = expense['income'];
      Constants.spend = expense['spending'];
    } else {
      throw Exception('Failed to load post');
    }
  }

  static getGeneralItems() async {
    final response = await NetworkUtil.internal().post('fetch_general_expense', body: {
      'company_id': Constants.userDetail!.companyId!.toString(),
    });
    if (response.statusCode == 200) {
      Constants.generalExpenseList?.clear();
      List<dynamic> typeExpense = json.decode(response.body);
      for (var element in typeExpense) {
        GeneralTypeExpenseModel list = GeneralTypeExpenseModel.fromMap(element);
        Constants.generalExpenseList!.add(list);
      }
    } else {
      throw Exception('Failed to load post');
    }
  }
  static getBusinessItems() async {
    final response = await NetworkUtil.internal().post('fetch_bussiness_expense', body: {
      'company_id': Constants.userDetail!.companyId!.toString(),
    });
    if (response.statusCode == 200) {
      Constants.businessExpenseList?.clear();
      List<dynamic> typeExpense = json.decode(response.body);
      for (var element in typeExpense) {
        BusinessTypeExpenseModel list = BusinessTypeExpenseModel.fromMap(element);
        Constants.businessExpenseList!.add(list);
      }
    } else {
      throw Exception('Failed to load post');
    }
  }
  static getEverydayitms() async {
    final response = await NetworkUtil.internal().post('fetch_everyday_expense', body: {
      'company_id': Constants.userDetail!.companyId!.toString(),
    });
    if (response.statusCode == 200) {
      Constants.everydayExpenseList?.clear();
      List<dynamic> typeExpense = json.decode(response.body);
      for (var element in typeExpense) {
        EveryDayExpenseModel everyDayExpenseList = EveryDayExpenseModel.fromMap(element);
        Constants.everydayExpenseList!.add(everyDayExpenseList);
      }
    } else {
      throw Exception('Failed to load post');
    }
  }
  static getDepartments() async {
    final response = await NetworkUtil.internal().post('fetch_departments', body: {
      'company_id': Constants.userDetail!.companyId!.toString(),
    });
    if (response.statusCode == 200) {
      Constants.departments?.clear();
      List<dynamic> typeExpense = json.decode(response.body);
      for (var element in typeExpense) {
        DepartmentModel departmentList = DepartmentModel.fromMap(element);
        Constants.departments!.add(departmentList);
      }
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<void> getCompany() async {
    try {
      // final response = await NetworkUtil().post('fetch_company');
      var URL = Uri.https('www.desired-techs.com', '/ExpenseManager/Api/fetch_company.php');
      final res = await http
          .post(
          URL,
          body: {},
          headers: {},
         );
      print(res);
      final output = jsonDecode(res.body);
        if (output['code'] == 200) {
          Constants.companyList?.clear();
          List<dynamic> typeExpense = output['data'];
          for (var element in typeExpense) {
            CompanyModel company = CompanyModel.fromMap(element);
            Constants.companyList!.add(company);
          }
        }
    } catch (e) {
      print('SocketException: ${e}');
    }
  }

  static getDepartmentsExpense() async {
    final response = await NetworkUtil.internal().post('fetch_departments_expense', body: {
      'company_id': Constants.userDetail!.companyId!.toString(),
    });
    if (response.statusCode == 200) {
      Constants.departmentExpenseList?.clear();
      List<dynamic> typeExpense = json.decode(response.body);
      for (var element in typeExpense) {
        DepartmentTypeExpenseModel departmentTypeExpenseList = DepartmentTypeExpenseModel.fromMap(element);
        Constants.departmentExpenseList!.add(departmentTypeExpenseList);
      }
    } else {
      throw Exception('Failed to load post');
    }
  }
  static getDepartmentsPurchasingTool() async {
    final response = await NetworkUtil.internal().post('fetch_department_purchasing', body: {
      'company_id': Constants.userDetail!.companyId!.toString(),
    });
    if (response.statusCode == 200) {
      Constants.dptPurchasingList?.clear();
      List<dynamic> typeExpense = json.decode(response.body);
      for (var element in typeExpense) {
        DepartmentPurchaseModel departmentTypeExpenseList = DepartmentPurchaseModel.fromMap(element);
        Constants.dptPurchasingList!.add(departmentTypeExpenseList);
      }
    } else {
      throw Exception('Failed to load post');
    }
  }
  static getEmployeeType() async {
    final response = await NetworkUtil.internal().post('fetch_compensation_list', body: {
      'company_id': Constants.userDetail!.companyId!.toString(),
    });
    if (response.statusCode == 200) {
      Constants.compensationList?.clear();
      List<dynamic> typeExpense = json.decode(response.body);
      for (var element in typeExpense) {
        CompensationModel compensationList = CompensationModel.fromMap(element);
        Constants.compensationList!.add(compensationList);
      }
    } else {
      throw Exception('Failed to load post');
    }
  }
  static getManagement() async {
    final response = await NetworkUtil.internal().post('fetch_employees_list', body: {
      'company_id': Constants.userDetail!.companyId!.toString(),
    });
    if (response.statusCode == 200) {
      Constants.employeesList?.clear();
      List<dynamic> typeExpense = json.decode(response.body);
      for (var element in typeExpense) {
        EmployeeListModel employeeList = EmployeeListModel.fromMap(element);
        Constants.employeesList?.add(employeeList);
        // if (employeeList.employeeType == 1) {
        //   Constants.employeesList?.add(element);
        // } else if (employeeList.employeeType == 2) {
        //   Constants.employeesList?.add(element);
        // } else if (employeeList.employeeType == 3) {
        //   Constants.employeesList?.add(element);
        // }
      }
    } else {
      throw Exception('Failed to load post');
    }
  }
  static getBankLists() async {
    final response = await NetworkUtil.internal().post('fetch_list_bank', body: {
      'company_id': Constants.userDetail!.companyId!.toString(),
    });
    if (response.statusCode == 200) {
      Constants.bankList?.clear();
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> typeExpense = data['data'];
      for (var element in typeExpense) {
        BankModel bankList = BankModel.fromMap(element);
        Constants.bankList!.add(bankList);
      }
    } else {
      throw Exception('Failed to load post');
    }
  }
  static getTransactionLists(String bankId) async {
    final response = await NetworkUtil.internal().post('bank-transction-detail');
    if (response.statusCode == 200) {
      Constants.bankTransactionList?.clear();
      List<dynamic> typeExpense = json.decode(response.body);
      for (var element in typeExpense) {
        BankTransactionModel bankList = BankTransactionModel.fromMap(element);
        Constants.bankTransactionList!.add(bankList);
      }
    } else {
      throw Exception('Failed to load post');
    }
  }
  static paymentModeList() async {
    final response = await NetworkUtil.internal().post('fetch_payment_mode');
    if (response.statusCode == 200) {
      Constants.listPaymentMode?.clear();
      List<dynamic> typeExpense = json.decode(response.body);
      for (var element in typeExpense) {
        PaymentModel paymentModeList = PaymentModel.fromMap(element);
        Constants.listPaymentMode!.add(paymentModeList);
      }
    } else {
      throw Exception('Failed to load post');
    }
  }

  static addIncome(String username, int access ) async {
    final response = await NetworkUtil.internal().post('add_income', body: {
      'Userid': Constants.userId.toString(),
      'Username': Constants.userDetail?.name,
      'Accessid': Constants.userDetail?.access.toString(),
    });
    final output = jsonDecode(response.body);
    return output['code'];
  }
}