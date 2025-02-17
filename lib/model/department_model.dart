class DepartmentModel {
  int? id;
  String? deptName;
  int? companyId;
  int? status;

  DepartmentModel({
    this.id,
    this.deptName,
    this.status,
    this.companyId,
  });

  Map<String, dynamic> toMap() {
    return {
      DepartmentModelFields.ID: id,
      DepartmentModelFields.DEPT_NAME: deptName,
      DepartmentModelFields.STATUS: status,
      DepartmentModelFields.COMPANY_ID: companyId,

    };
  }


  DepartmentModel.fromMap(Map<String, dynamic> map) {
    id = map[DepartmentModelFields.ID];
    deptName = map[DepartmentModelFields.DEPT_NAME];
    status = map[DepartmentModelFields.STATUS];
    companyId = map[DepartmentModelFields.COMPANY_ID];
  }


  @override
  String toString() {
    return 'DepartmentModel{id: $id, company_id: $companyId, dept_name: $deptName, status: $status} ';
  }
}


class DepartmentModelFields {
  static const String ID = "id";
  static const String DEPT_NAME = "dept_name";
  static const String STATUS = "status";
  static const String COMPANY_ID = "company_id";
}