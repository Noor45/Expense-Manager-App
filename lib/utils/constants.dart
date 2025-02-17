import '../model/add_expense_model.dart';
import '../model/bank_model.dart';
import '../model/bank_transaction_model.dart';
import '../model/business_expense_list_model.dart';
import '../model/company_model.dart';
import '../model/department_expense_list_model.dart';
import '../model/department_model.dart';
import '../model/department_purchasing_list_model.dart';
import '../model/employee_list_model.dart';
import '../model/compensation_list_model.dart';
import '../model/everyday_expense_list_model.dart';
import '../model/expense_type_model.dart';
import '../model/general_expense_list_model.dart';

import '../model/payment_model.dart';
import '../model/user_model.dart';

class Constants {
  static int? userId = 0;
  static int? companyId = 0;
  static int? bankId = 0;
  static int? spend = 0;
  static int? income = 0;
  static UserModel? userDetail;
  static CompanyModel? companyDetail;
  static List<ExpenseTypeModel>? typeExpense = [];
  static List<GeneralTypeExpenseModel>? generalExpenseList = [];
  static List<BusinessTypeExpenseModel>? businessExpenseList = [];
  static List<EveryDayExpenseModel>? everydayExpenseList = [];
  static List<DepartmentModel>? departments = [];
  static List<CompanyModel>? companyList = [];
  static List<DepartmentTypeExpenseModel>? departmentExpenseList = [];
  static List<CompensationModel>? compensationList = [];
  static List<EmployeeListModel>? employeesList = [];
  static List<BankModel>? bankList = [];
  static List<BankTransactionModel>? bankTransactionList = [];
  static List<PaymentModel>? listPaymentMode = [];
  static List<AddExpenseModel>? expenseList = [];
  static List<DepartmentPurchaseModel>? dptPurchasingList = [];
  static List<UserModel>? userLists = [];

}

 clear() {
  Constants.userId = 0;
  Constants.bankId = 0;
  Constants.userDetail = UserModel();
  Constants.typeExpense = [];
  Constants.generalExpenseList = [];
  Constants.businessExpenseList = [];
  Constants.everydayExpenseList = [];
  Constants.departments = [];
  Constants.departmentExpenseList = [];
  Constants.compensationList = [];
  Constants.employeesList = [];
  Constants.bankList = [];
  Constants.bankTransactionList = [];
  Constants.listPaymentMode = [];
  Constants.dptPurchasingList = [];
  Constants.userLists = [];

}

String moneyFormat(String price) {
  var value = price;
  value = value.replaceAll(RegExp(r'\D'), '');
  value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
  return value;
}
