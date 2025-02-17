class CompanyModel {
  int? id;
  String? name;
  String? email;
  String? logo;
  String? password;

  CompanyModel({
    this.id,
    this.name,
    this.email,
    this.logo,
    this.password
  });

  Map<String, dynamic> toMap() {
    return {
      CompanyModelFields.ID: this.id,
      CompanyModelFields.NAME: this.name,
      CompanyModelFields.EMAIL: this.email,
      CompanyModelFields.IMAGE: this.logo,
      CompanyModelFields.PASSWORD: this.password,
    };
  }

  CompanyModel.fromMap(Map<String, dynamic> map) {
    this.id = map[CompanyModelFields.ID];
    this.name = map[CompanyModelFields.NAME];
    this.email = map[CompanyModelFields.EMAIL];
    this.logo = map[CompanyModelFields.IMAGE];
    this.password = map[CompanyModelFields.PASSWORD];
  }

  @override
  String toString() {
    return 'CompanyModel{id: $id, name: $name, email: $email, logo: $logo, password: $password, } ';
  }
}

class CompanyModelFields {
  static const String ID = "id";
  static const String NAME = "name";
  static const String IMAGE = "logo";
  static const String EMAIL = "email";
  static const String PASSWORD = "password";
}
