class ExpenseTypeModel {
  int? id;
  int? companyId;
  int? status;
  int? expenseTypeId;
  String? expenseName;


  ExpenseTypeModel({
    this.id,
    this.companyId,
    this.expenseTypeId,
    this.status,
    this.expenseName,

  });

  Map<String, dynamic> toMap() {
    return {
      ExpenseTypeModelFields.ID: id,
      ExpenseTypeModelFields.TYPE: expenseName,
      ExpenseTypeModelFields.STATUS: status,
      ExpenseTypeModelFields.EXPENSE_TYPE_ID: expenseTypeId,
      ExpenseTypeModelFields.COMPANY_ID: companyId,
    };
  }


  ExpenseTypeModel.fromMap(Map<String, dynamic> map) {
    id = map[ExpenseTypeModelFields.ID];
    expenseName = map[ExpenseTypeModelFields.TYPE];
    companyId = map[ExpenseTypeModelFields.COMPANY_ID];
    status = map[ExpenseTypeModelFields.STATUS];
    expenseTypeId = map[ExpenseTypeModelFields.EXPENSE_TYPE_ID];
  }


  @override
  String toString() {
    return 'ExpenseTypeModel{id: $id, company_id: $companyId,  expense_name: $expenseName,  status: $status, expense_type_id: $expenseTypeId, } ';
  }
}


class ExpenseTypeModelFields {
  static const String ID = "id";
  static const String TYPE = "expense_name";
  static const String STATUS = "status";
  static const String COMPANY_ID = "company_id";
  static const String EXPENSE_TYPE_ID = "expense_type_id";
}