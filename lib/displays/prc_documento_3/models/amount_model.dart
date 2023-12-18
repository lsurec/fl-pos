import 'dart:convert';

import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';

class AmountModel {
  AmountModel({
    required this.checked,
    required this.amount,
    required this.diference,
    required this.authorization,
    required this.reference,
    required this.payment,
    this.account,
    this.bank,
  });

  bool checked;
  PaymentModel payment;
  double amount;
  double diference;
  String authorization;
  String reference;
  AccountModel? account;
  BankModel? bank;

  factory AmountModel.fromJson(String str) =>
      AmountModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AmountModel.fromMap(Map<String, dynamic> json) => AmountModel(
        checked: json["checked"],
        payment: PaymentModel.fromMap(json["payment"]),
        amount: json["amount"],
        diference: json["diference"],
        authorization: json["authorization"],
        reference: json["reference"],
        account: json["account"] == null
            ? null
            : AccountModel.fromMap(json["account"]),
        bank: json["bank"] == null ? null : BankModel.fromMap(json["bank"]),
      );

  Map<String, dynamic> toMap() => {
        "checked": checked,
        "payment": payment.toMap(),
        "amount": amount,
        "diference": diference,
        "authorization": authorization,
        "reference": reference,
        "account": account?.toMap(),
        "bank": bank?.toMap(),
      };
}
