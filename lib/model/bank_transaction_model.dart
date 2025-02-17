class BankTransactionModel {
  int? id;
  int? incomeId;
  int? userId;
  int? bankId;
  int? companyId;
  int? amountAdd;
  int? amountDetect;
  int? currentAmount;
  int? actualAmount;
  int? paymentMode;
  int? expenseId;
  DateTime? date;


  BankTransactionModel({
    this.id,
    this.companyId,
    this.incomeId,
    this.userId,
    this.bankId,
    this.amountAdd,
    this.amountDetect,
    this.currentAmount,
    this.actualAmount,
    this.paymentMode,
    this.expenseId,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      BankTransactionModelFields.ID: id,
      BankTransactionModelFields.INCOME_ID: incomeId,
      BankTransactionModelFields.TRANSACTION_BY: userId,
      BankTransactionModelFields.BANK_ID: bankId,
      BankTransactionModelFields.AMOUNT_ADD: amountAdd,
      BankTransactionModelFields.AMOUNT_DETECT: amountDetect,
      BankTransactionModelFields.CURRENT_AMOUNT: currentAmount,
      BankTransactionModelFields.ACTUAL_AMOUNT: actualAmount,
      BankTransactionModelFields.PAYMENT_MODE: paymentMode,
      BankTransactionModelFields.EXPENSE_ID: expenseId,
      BankTransactionModelFields.DATE: date,
      BankTransactionModelFields.COMPANY_ID: companyId,
    };
  }


  BankTransactionModel.fromMap(Map<String, dynamic> map) {
    id = map[BankTransactionModelFields.ID];
    incomeId = map[BankTransactionModelFields.INCOME_ID];
    userId = map[BankTransactionModelFields.TRANSACTION_BY];
    bankId = map[BankTransactionModelFields.BANK_ID];
    amountAdd = map[BankTransactionModelFields.AMOUNT_ADD];
    amountDetect = map[BankTransactionModelFields.AMOUNT_DETECT];
    currentAmount = map[BankTransactionModelFields.CURRENT_AMOUNT];
    actualAmount = map[BankTransactionModelFields.ACTUAL_AMOUNT];
    paymentMode = map[BankTransactionModelFields.PAYMENT_MODE];
    expenseId = map[BankTransactionModelFields.EXPENSE_ID];
    date = DateTime.parse(map[BankTransactionModelFields.DATE]);
    companyId = map[BankTransactionModelFields.COMPANY_ID];
  }


  @override
  String toString() {
    return 'BankTransactionModel{id: $id, company_id: $companyId, income_id: $incomeId, date: $date, user_id: $userId,  bank_id: $bankId, amount_add: $amountAdd, amount_detect: $amountDetect, current_amount: $currentAmount, actual_amount: $actualAmount, payment_mode: $paymentMode, expense_id: $expenseId} ';
  }
}


class BankTransactionModelFields {
  static const String ID = "id";
  static const String INCOME_ID = "income_id";
  static const String TRANSACTION_BY = "transaction_by";
  static const String BANK_ID = "bank_id";
  static const String BANK_NAME = "bank_name";
  static const String AMOUNT_ADD = "amount_add";
  static const String AMOUNT_DETECT = "amount_detect";
  static const String CURRENT_AMOUNT = "current_amount";
  static const String ACTUAL_AMOUNT = "actual_amount";
  static const String PAYMENT_MODE = "payment_mode";
  static const String EXPENSE_ID = "expense_id";
  static const String DATE = "date";
  static const String COMPANY_ID = "company_id";
}