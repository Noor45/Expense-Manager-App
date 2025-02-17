class DepartmentPurchaseModel {
  int? id;
  String? name;
  int? companyId;
  int? dptId;
  int? status;


  DepartmentPurchaseModel({
    this.id,
    this.name,
    this.companyId,
    this.dptId,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      DepartmentPurchaseModelFields.ID: id,
      DepartmentPurchaseModelFields.NAME: name,
      DepartmentPurchaseModelFields.STATUS: status,
      DepartmentPurchaseModelFields.COMPANY_ID: companyId,
      DepartmentPurchaseModelFields.DPT_ID: dptId,

    };
  }


  DepartmentPurchaseModel.fromMap(Map<String, dynamic> map) {
    id = map[DepartmentPurchaseModelFields.ID];
    name = map[DepartmentPurchaseModelFields.NAME];
    status = map[DepartmentPurchaseModelFields.STATUS];
    companyId = map[DepartmentPurchaseModelFields.COMPANY_ID];
    dptId = map[DepartmentPurchaseModelFields.DPT_ID];
  }


  @override
  String toString() {
    return 'DepartmentPurchaseModel{id: $id, company_id: $companyId, dpt_id: $dptId, name: $name, status: $status} ';
  }
}


class DepartmentPurchaseModelFields {
  static const String ID = "id";
  static const String NAME = "name";
  static const String STATUS = "status";
  static const String COMPANY_ID = "company_id";
  static const String DPT_ID = "dpt_id";
}