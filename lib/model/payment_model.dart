class PaymentModel {
  int? id;
  String? name;

  PaymentModel({
    this.id,
    this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      PaymentModeModel.ID: this.id,
      PaymentModeModel.NAME: this.name,
    };
  }

  PaymentModel.fromMap(Map<String, dynamic> map) {
    this.id = map[PaymentModeModel.ID];
    this.name = map[PaymentModeModel.NAME];
  }

  @override
  String toString() {
    return 'PaymentModel{id: $id, text: $name}';
  }
}

class PaymentModeModel {
  static const String ID = "id";
  static const String NAME = "name";
}