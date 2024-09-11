// To parse this JSON data, do
//
//     final sellerModel = sellerModelFromMap(jsonString);

import 'dart:convert';

class SellerModel {
  int cuentaCorrentista;
  String cuentaCta;
  String iDCuenta;
  String nomCuentaCorrentista;
  int orden;

  SellerModel({
    required this.cuentaCorrentista,
    required this.cuentaCta,
    required this.iDCuenta,
    required this.nomCuentaCorrentista,
    required this.orden,
  });

  factory SellerModel.fromJson(String str) =>
      SellerModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SellerModel.fromMap(Map<String, dynamic> json) => SellerModel(
        cuentaCorrentista: json["cuenta_Correntista"],
        cuentaCta: json["cuenta_Cta"],
        iDCuenta: json["iD_Cuenta"],
        nomCuentaCorrentista: json["nom_Cuenta_Correntista"],
        orden: json["orden"],
      );

  Map<String, dynamic> toMap() => {
        "cuenta_Correntista": cuentaCorrentista,
        "cuenta_Cta": cuentaCta,
        "iD_Cuenta": iDCuenta,
        "nom_Cuenta_Correntista": nomCuentaCorrentista,
        "orden": orden,
      };
}
