class AddExpenseModel {
  int? id;
  int? userId;
  int? userName;
  int? paymentMode;
  int? employeeType;
  int? amount;
  int? everydayExpense;
  int? department;
  int? departmentType;
  int? employee;
  int? expenseType;
  int? generalExpense;
  int? businessExpense;
  DateTime? datetime;
  String? description;
  int? bankId;
  int? companyId;
  int? transactionBy;
  int? access;
  String? image;

  AddExpenseModel({
    this.id,
    this.userId,
    this.userName,
    this.paymentMode,
    this.employeeType,
    this.amount,
    this.everydayExpense,
    this.department,
    this.departmentType,
    this.employee,
    this.expenseType,
    this.generalExpense,
    this.businessExpense,
    this.datetime,
    this.description,
    this.bankId,
    this.companyId,
    this.transactionBy,
    this.access,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      AddExpenseModelFields.ID: this.id,
      AddExpenseModelFields.USERID: this.userId,
      AddExpenseModelFields.USER_NAME: this.userName,
      AddExpenseModelFields.PAYMENT_MODE: this.paymentMode,
      AddExpenseModelFields.EMPLOYEE_TYPE: this.employeeType,
      AddExpenseModelFields.AMOUNT: this.amount,
      AddExpenseModelFields.EVERYDAY_EXPENSE: this.everydayExpense,
      AddExpenseModelFields.DEPARTMENT: this.department,
      AddExpenseModelFields.DEPARTMENT_TYPE: this.departmentType,
      AddExpenseModelFields.EMPLOYEE: this.employee,
      AddExpenseModelFields.EXPENSE_TYPE: this.expenseType,
      AddExpenseModelFields.GENERAL_EXPENSE: this.generalExpense,
      AddExpenseModelFields.BUSINESS_EXPENSE: businessExpense,
      AddExpenseModelFields.DATE_TIME: datetime,
      AddExpenseModelFields.DESCRIPTION: description,
      AddExpenseModelFields.BANK_ID: bankId,
      AddExpenseModelFields.TRANSACTION_BY: transactionBy,
      AddExpenseModelFields.ACCESS: access,
      AddExpenseModelFields.IMAGE: this.image,
      AddExpenseModelFields.COMPANY_ID: this.companyId,
    };
  }


  AddExpenseModel.fromMap(Map<String, dynamic> map) {
    id = map[AddExpenseModelFields.ID];
    userId = map[AddExpenseModelFields.USER_NAME];
    userName = map[AddExpenseModelFields.USERID];
    employeeType = map[AddExpenseModelFields.EMPLOYEE_TYPE];
    amount = map[AddExpenseModelFields.AMOUNT];
    everydayExpense = map[AddExpenseModelFields.EVERYDAY_EXPENSE];
    department = map[AddExpenseModelFields.DEPARTMENT];
    departmentType = map[AddExpenseModelFields.DEPARTMENT_TYPE];
    paymentMode = map[AddExpenseModelFields.PAYMENT_MODE];
    employee = map[AddExpenseModelFields.EMPLOYEE];
    datetime = DateTime.parse(map[AddExpenseModelFields.DATE_TIME]);
    expenseType = map[AddExpenseModelFields.ID];
    generalExpense = map[AddExpenseModelFields.GENERAL_EXPENSE];
    businessExpense = map[AddExpenseModelFields.BUSINESS_EXPENSE];
    description = map[AddExpenseModelFields.DESCRIPTION];
    bankId = map[AddExpenseModelFields.BANK_ID];
    transactionBy = map[AddExpenseModelFields.TRANSACTION_BY];
    image = map[AddExpenseModelFields.IMAGE];
    access = map[AddExpenseModelFields.ACCESS];
    companyId = map[AddExpenseModelFields.COMPANY_ID];
  }


  @override
  String toString() {
    return 'AddExpenseModel{id: $id, company_id: $companyId, user_name: $userName, user_id: $userId, bank_id: $bankId, employee_type: $employeeType, payment_mode: $paymentMode, amount: $amount, department: $department, department_type: $departmentType, image: $image, employee: $employee, access: $access, amount: $amount, datetime: $datetime, everyday_expense: $everydayExpense, general_expense: $generalExpense, bussiness_expense: $businessExpense, description: $description, transaction_by: $transactionBy} ';
  }
}


class AddExpenseModelFields {
  static const String ID = "id";
  static const String USERID = "user_id";
  static const String USER_NAME = "user_name";
  static const String PAYMENT_MODE = "payment_mode";
  static const String IMAGE = "screenshot";
  static const String EMPLOYEE_TYPE = "employee_type";
  static const String AMOUNT = "amount";
  static const String EVERYDAY_EXPENSE = "everyday_expense";
  static const String DEPARTMENT = "department";
  static const String DEPARTMENT_TYPE = "department_type";
  static const String EMPLOYEE = "employee";
  static const String EXPENSE_TYPE = "expense_type";
  static const String GENERAL_EXPENSE = "general_expense";
  static const String BUSINESS_EXPENSE = "business_expense";
  static const String DATE_TIME = "date";
  static const String DESCRIPTION = "description";
  static const String BANK_ID = "bank_id";
  static const String TRANSACTION_BY = "transaction_by";
  static const String ACCESS = "access";
  static const String COMPANY_ID = "company_id";
}