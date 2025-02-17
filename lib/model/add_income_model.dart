class AddIncomeModel {
  int? id;
  int? userId;
  int? companyId;
  int? userName;
  int? paymentMode;
  int? amount;
  DateTime? datetime;
  String? bankName;
  String? details;
  int? bankId;
  int? access;
  String? image;

  AddIncomeModel({
    this.id,
    this.userId,
    this.companyId,
    this.userName,
    this.paymentMode,
    this.amount,
    this.datetime,
    this.bankName,
    this.bankId,
    this.access,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      AddIncomeModelFields.ID: this.id,
      AddIncomeModelFields.USERID: this.userId,
      AddIncomeModelFields.USER_NAME: this.userName,
      AddIncomeModelFields.PAYMENT_MODE: this.paymentMode,
      AddIncomeModelFields.AMOUNT: this.amount,
      AddIncomeModelFields.DATE_TIME: datetime,
      AddIncomeModelFields.DESCRIPTION: bankName,
      AddIncomeModelFields.BANK_ID: bankId,
      AddIncomeModelFields.ACCESS: access,
      AddIncomeModelFields.IMAGE: this.image,
      AddIncomeModelFields.COMPANY_ID: this.companyId,
    };
  }


  AddIncomeModel.fromMap(Map<String, dynamic> map) {
    id = map[AddIncomeModelFields.ID];
    userId = map[AddIncomeModelFields.USER_NAME];
    userName = map[AddIncomeModelFields.USERID];
    amount = map[AddIncomeModelFields.AMOUNT];
    paymentMode = map[AddIncomeModelFields.PAYMENT_MODE];
    datetime = DateTime.parse(map[AddIncomeModelFields.DATE_TIME]);
    bankName = map[AddIncomeModelFields.DESCRIPTION];
    bankId = map[AddIncomeModelFields.BANK_ID];
    image = map[AddIncomeModelFields.BANK_ID];
    access = map[AddIncomeModelFields.ACCESS];
    companyId = map[AddIncomeModelFields.COMPANY_ID];
  }


  @override
  String toString() {
    return 'AddIncomeModel{id: $id, company_id: $companyId, user_name: $userName, user_id: $userId, bank_id: $bankId, payment_mode: $paymentMode, amount: $amount, image: $image, access: $access, amount: $amount, datetime: $datetime} ';
  }
}


class AddIncomeModelFields {
  static const String ID = "id";
  static const String USERID = "user_id";
  static const String USER_NAME = "user_name";
  static const String PAYMENT_MODE = "payment_mode";
  static const String IMAGE = "image";
  static const String EMPLOYEE_TYPE = "employee_type";
  static const String AMOUNT = "amount";
  static const String EVERYDAY_EXPENSE = "everyday_expense";
  static const String DEPARTMENT = "department";
  static const String DEPARTMENT_TYPE = "department_type";
  static const String EMPLOYEE = "employee";
  static const String EXPENSE_TYPE = "expense_type";
  static const String GENERAL_EXPENSE = "general_expense";
  static const String BUSINESS_EXPENSE = "business_expense";
  static const String DATE_TIME = "datetime";
  static const String DESCRIPTION = "description";
  static const String BANK_ID = "bank_id";
  static const String ACCESS = "access";
  static const String COMPANY_ID = "company_id";
}