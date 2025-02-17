class CompensationModel {
  int? id;
  int? companyId;
  int? compTypeId;
  int? status;
  String? type;


  CompensationModel({
    this.id,
    this.type,
    this.companyId,
    this.compTypeId,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      CompensationModelFields.ID: id,
      CompensationModelFields.TYPE: type,
      CompensationModelFields.COMP_TYPE_ID: compTypeId,
      CompensationModelFields.STATUS: status,
      CompensationModelFields.COMPANY_ID: companyId,

    };
  }


  CompensationModel.fromMap(Map<String, dynamic> map) {
    id = map[CompensationModelFields.ID];
    type = map[CompensationModelFields.TYPE];
    status = map[CompensationModelFields.STATUS];
    compTypeId = map[CompensationModelFields.COMP_TYPE_ID];
    companyId = map[CompensationModelFields.COMPANY_ID];
  }


  @override
  String toString() {
    return 'CompensationModel{id: $id, company_id: $companyId, comp_id_type: $compTypeId, status: $status, type: $type} ';
  }
}


class CompensationModelFields {
  static const String ID = "id";
  static const String TYPE = "type";
  static const String COMPANY_ID = "company_id";
  static const String COMP_TYPE_ID = "comp_id_type";
  static const String STATUS = "status";
}