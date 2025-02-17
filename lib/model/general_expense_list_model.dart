class GeneralTypeExpenseModel {
  int? id;
  int? companyId;
  int? status;
  String? name;


  GeneralTypeExpenseModel({
    this.id,
    this.companyId,
    this.name,

  });

  Map<String, dynamic> toMap() {
    return {
      GeneralTypeExpenseFields.ID: id,
      GeneralTypeExpenseFields.STATUS: status,
      GeneralTypeExpenseFields.NAME: name,
      GeneralTypeExpenseFields.COMPANY_ID: companyId,

    };
  }


  GeneralTypeExpenseModel.fromMap(Map<String, dynamic> map) {
    id = map[GeneralTypeExpenseFields.ID];
    status = map[GeneralTypeExpenseFields.STATUS];
    name = map[GeneralTypeExpenseFields.NAME];
    companyId = map[GeneralTypeExpenseFields.COMPANY_ID];
  }


  @override
  String toString() {
    return 'GeneralTypeExpense{id: $id, company_id: $companyId, name: $name, status: $status} ';
  }
}


class GeneralTypeExpenseFields {
  static const String ID = "id";
  static const String NAME = "name";
  static const String STATUS = "status";
  static const String COMPANY_ID = "company_id";
}