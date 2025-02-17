class EmployeeListModel {
  int? id;
  int? status;
  int? companyId;
  int? dptId;
  String? name;
  String? image;
  int? employeeType;
  DateTime? dateOfJoining;

  EmployeeListModel({
    this.id,
    this.dptId,
    this.companyId,
    this.name,
    this.image,
    this.employeeType,
    this.dateOfJoining,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      EmployeeListModelFields.ID: id,
      EmployeeListModelFields.STATUS: status,
      EmployeeListModelFields.NAME: name,
      EmployeeListModelFields.IMAGE: image,
      EmployeeListModelFields.DPT_ID: dptId,
      EmployeeListModelFields.EMPLOYEE_TYPE: employeeType,
      EmployeeListModelFields.DATE_OF_JOINING: dateOfJoining,
      EmployeeListModelFields.COMPANY_ID: companyId,
    };
  }


  EmployeeListModel.fromMap(Map<String, dynamic> map) {
    id = map[EmployeeListModelFields.ID];
    status = map[EmployeeListModelFields.STATUS];
    name = map[EmployeeListModelFields.NAME];
    image = map[EmployeeListModelFields.IMAGE];
    employeeType = map[EmployeeListModelFields.EMPLOYEE_TYPE];
    dptId = map[EmployeeListModelFields.DPT_ID];
    companyId = map[EmployeeListModelFields.COMPANY_ID];
    dateOfJoining = DateTime.parse(map[EmployeeListModelFields.DATE_OF_JOINING]);
  }


  @override
  String toString() {
    return 'EmployeeListModel{id: $id, company_id: $companyId, dept_id: $dptId, status: $status, name: $name, employee_type: $employeeType, image: $image, date_of_joining: $dateOfJoining} ';
  }
}


class EmployeeListModelFields {
  static const String ID = "id";
  static const String NAME = "name";
  static const String IMAGE = "image";
  static const String EMPLOYEE_TYPE = "employee_type";
  static const String DATE_OF_JOINING = "date_of_joining";
  static const String STATUS = "status";
  static const String DPT_ID = "dept_id";
  static const String COMPANY_ID = "company_id";
}