class EveryDayExpenseModel {
  int? id;
  int? status;
  int? companyId;
  String? name;


  EveryDayExpenseModel({
    this.id,
    this.name,
    this.companyId,
    this.status,

  });

  Map<String, dynamic> toMap() {
    return {
      EveryDayExpenseFields.ID: id,
      EveryDayExpenseFields.STATUS: status,
      EveryDayExpenseFields.NAME: name,
      EveryDayExpenseFields.COMPANY_ID: companyId,

    };
  }


  EveryDayExpenseModel.fromMap(Map<String, dynamic> map) {
    id = map[EveryDayExpenseFields.ID];
    status = map[EveryDayExpenseFields.STATUS];
    name = map[EveryDayExpenseFields.NAME];
    companyId = map[EveryDayExpenseFields.COMPANY_ID];
  }


  @override
  String toString() {
    return 'EveryDayExpense{id: $id, name: $name, company_id: $companyId,  status: $status} ';
  }
}


class EveryDayExpenseFields {
  static const String ID = "id";
  static const String NAME = "name";
  static const String STATUS = "status";
  static const String COMPANY_ID = "company_id";
}