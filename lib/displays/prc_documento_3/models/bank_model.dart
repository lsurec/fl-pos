// To parse this JSON data, do
//
//     final bankModel = bankModelFromMap(jsonString);

import 'dart:convert';

class BankModel {
  int banco;
  String nombre;
  int? orden;

  BankModel({
    required this.banco,
    required this.nombre,
    this.orden,
  });

  factory BankModel.fromJson(String str) => BankModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BankModel.fromMap(Map<String, dynamic> json) => BankModel(
        banco: json["banco"],
        nombre: json["nombre"],
        orden: json["orden"],
      );

  Map<String, dynamic> toMap() => {
        "banco": banco,
        "nombre": nombre,
        "orden": orden,
      };
}

class SelectBankModel {
  SelectBankModel({
    required this.bank,
    required this.isSelected,
  });

  BankModel bank;
  bool isSelected;
}
