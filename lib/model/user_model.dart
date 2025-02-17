class UserModel {
  int? uid;
  int? companyId;
  String? name;
  String? email;
  String? image;
  int? access;

  UserModel({
    this.uid,
    this.companyId,
    this.name,
    this.email,
    this.image,
    this.access
  });

  Map<String, dynamic> toMap() {
    return {
      UserModelFields.UID: uid,
      UserModelFields.NAME: name,
      UserModelFields.EMAIL: email,
      UserModelFields.IMAGE: image,
      UserModelFields.ACCESS: access,
      UserModelFields.COMPANY_ID: companyId,
    };
  }

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map[UserModelFields.UID];
    name = map[UserModelFields.NAME];
    email = map[UserModelFields.EMAIL];
    image = map[UserModelFields.IMAGE];
    access = map[UserModelFields.ACCESS];
    companyId = map[UserModelFields.COMPANY_ID];
  }

  @override
  String toString() {
    return 'UserModel{id: $uid, name: $name, email: $email, image: $image, access: $access, company_id: $companyId} ';
  }
}

class UserModelFields {
  static const String UID = "id";
  static const String NAME = "name";
  static const String IMAGE = "image";
  static const String EMAIL = "email";
  static const String ACCESS = "access";
  static const String COMPANY_ID = "company_id";
}
