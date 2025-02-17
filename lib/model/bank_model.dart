class BankModel {
  int? id;
  int? status;
  String? bankName;
  int? currentAmount;
  int? actualAmount;
  String? image;
  int? companyId;

  BankModel({
    this.id,
    this.status,
    this.bankName,
    this.currentAmount,
    this.actualAmount,
    this.image,
    this.companyId
  });

  Map<String, dynamic> toMap() {
    return {
      BankModelFields.ID: id,
      BankModelFields.STATUS: status,
      BankModelFields.BANK_NAME: bankName,
      BankModelFields.CURRENT_AMOUNT: currentAmount,
      BankModelFields.ACTUAL_AMOUNT: actualAmount,
      BankModelFields.IMAGE: image,
      BankModelFields.COMPANY_ID: companyId,
    };
  }


  BankModel.fromMap(Map<String, dynamic> map) {
    id = map[BankModelFields.ID];
    bankName = map[BankModelFields.BANK_NAME];
    currentAmount = map[BankModelFields.CURRENT_AMOUNT];
    actualAmount = map[BankModelFields.ACTUAL_AMOUNT];
    image = map[BankModelFields.IMAGE];
    status = map[BankModelFields.STATUS];
    companyId = map[BankModelFields.COMPANY_ID];
  }


  @override
  String toString() {
    return 'BankModel{id: $id, status: $status, bank_name: $bankName, current_amount: $currentAmount, actual_amount: $actualAmount, image: $image, company_id: $companyId} ';
  }
}


class BankModelFields {
  static const String ID = "id";
  static const String BANK_NAME = "bank_name";
  static const String CURRENT_AMOUNT = "current_amount";
  static const String ACTUAL_AMOUNT = "actual_amount";
  static const String IMAGE = "image";
  static const String STATUS = "status";
  static const String COMPANY_ID = "company_id";
}