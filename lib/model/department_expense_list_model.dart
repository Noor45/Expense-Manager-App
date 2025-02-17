class DepartmentTypeExpenseModel {
  int? id;
  int? companyId;
  int? dptExpenseType;
  int? status;
  String? name;


  DepartmentTypeExpenseModel({
    this.id,
    this.name,
    this.dptExpenseType,
    this.status,
    this.companyId,
  });

  Map<String, dynamic> toMap() {
    return {
      DepartmentTypeExpenseFields.ID: id,
      DepartmentTypeExpenseFields.NAME: name,
      DepartmentTypeExpenseFields.COMPANY_ID: companyId,
      DepartmentTypeExpenseFields.DPT_EXPENSE_TYPE: dptExpenseType,
      DepartmentTypeExpenseFields.STATUS: status,
    };
  }


  DepartmentTypeExpenseModel.fromMap(Map<String, dynamic> map) {
    id = map[DepartmentTypeExpenseFields.ID];
    name = map[DepartmentTypeExpenseFields.NAME];
    companyId = map[DepartmentTypeExpenseFields.COMPANY_ID];
    dptExpenseType = map[DepartmentTypeExpenseFields.DPT_EXPENSE_TYPE];
    status = map[DepartmentTypeExpenseFields.STATUS];
  }


  @override
  String toString() {
    return 'DepartmentTypeExpense{id: $id, company_id: $companyId, name: $name, dpt_expense_type: $dptExpenseType, status: $status} ';
  }
}


class DepartmentTypeExpenseFields {
  static const String ID = "id";
  static const String NAME = "name";
  static const String COMPANY_ID = "company_id";
  static const String DPT_EXPENSE_TYPE = "dpt_expense_type";
  static const String STATUS = "status";
}