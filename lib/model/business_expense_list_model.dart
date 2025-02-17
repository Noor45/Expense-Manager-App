class BusinessTypeExpenseModel {
  int? id;
  int? status;
  int? companyId;
  int? kuch;
  String? name;


  BusinessTypeExpenseModel({
    this.id,
    this.name,
    this.kuch,
    this.companyId,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      BusinessTypeExpenseFields.ID: id,
      BusinessTypeExpenseFields.STATUS: status,
      BusinessTypeExpenseFields.NAME: name,
      BusinessTypeExpenseFields.KUCH: kuch,
      BusinessTypeExpenseFields.COMPANY_ID: this.companyId,

    };
  }


  BusinessTypeExpenseModel.fromMap(Map<String, dynamic> map) {
    id = map[BusinessTypeExpenseFields.ID];
    name = map[BusinessTypeExpenseFields.NAME];
    status = map[BusinessTypeExpenseFields.STATUS];
    companyId = map[BusinessTypeExpenseFields.COMPANY_ID];
    kuch = map[BusinessTypeExpenseFields.KUCH];
  }


  @override
  String toString() {
    return 'BusinessTypeExpense{id: $id, company_id: $companyId, name: $name, status: $status, kuch: $kuch} ';
  }
}


class BusinessTypeExpenseFields {
  static const String ID = "id";
  static const String NAME = "name";
  static const String STATUS = "status";
  static const String COMPANY_ID = "company_id";
  static const String KUCH = "kuch";
}