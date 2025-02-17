import '../controller/type_expense_controller.dart';

getData() async{
  await ExpenseController.getExpense();
  await ExpenseController.getGeneralItems();
  await ExpenseController.getUsers();
  await ExpenseController.getBusinessItems();
  await ExpenseController.getEverydayitms();
  await ExpenseController.getDepartments();
  await ExpenseController.getDepartmentsExpense();
  await ExpenseController.getDepartmentsPurchasingTool();
  await ExpenseController.getEmployeeType();
  await ExpenseController.getManagement();
  await ExpenseController.getStats();
  await ExpenseController.getBankLists();
  // await ExpenseController.getCompany();
  // await ExpenseController.getTransactionLists();
  await ExpenseController.paymentModeList();
}