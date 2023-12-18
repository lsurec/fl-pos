// To parse this JSON data, do
//
//     final accountModel = accountModelFromMap(jsonString);

import 'dart:convert';

class AccountModel {
  dynamic cuentaBancaria;
  dynamic descripcion;
  dynamic banco;
  dynamic idCuentaBancaria;
  dynamic banIni;
  dynamic banIniMes;
  dynamic cuenta;
  dynamic numDoc;
  dynamic saldo;
  dynamic estado;
  dynamic lugar;
  dynamic banIniDia;
  dynamic fechaHora;
  dynamic userName;
  dynamic mFechaHora;
  dynamic mUserName;
  dynamic orden;
  dynamic serieIni;
  dynamic serieFin;
  dynamic moneda;
  dynamic cuentaM;

  AccountModel({
    required this.cuentaBancaria,
    required this.descripcion,
    required this.banco,
    required this.idCuentaBancaria,
    required this.banIni,
    required this.banIniMes,
    required this.cuenta,
    required this.numDoc,
    required this.saldo,
    required this.estado,
    required this.lugar,
    required this.banIniDia,
    required this.fechaHora,
    required this.userName,
    required this.mFechaHora,
    required this.mUserName,
    this.orden,
    required this.serieIni,
    required this.serieFin,
    required this.moneda,
    this.cuentaM,
  });

  factory AccountModel.fromJson(String str) =>
      AccountModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AccountModel.fromMap(Map<String, dynamic> json) => AccountModel(
        cuentaBancaria: json["cuenta_Bancaria"],
        descripcion: json["descripcion"],
        banco: json["banco"],
        idCuentaBancaria: json["id_Cuenta_Bancaria"],
        banIni: json["ban_Ini"],
        banIniMes: json["ban_Ini_Mes"],
        cuenta: json["cuenta"],
        numDoc: json["num_Doc"],
        saldo: json["saldo"],
        estado: json["estado"],
        lugar: json["lugar"],
        banIniDia: json["ban_Ini_Dia"],
        fechaHora: json["fecha_Hora"],
        userName: json["userName"],
        mFechaHora: json["m_Fecha_Hora"],
        mUserName: json["m_UserName"],
        orden: json["orden"],
        serieIni: json["serie_Ini"],
        serieFin: json["serie_Fin"],
        moneda: json["moneda"],
        cuentaM: json["cuenta_M"],
      );

  Map<String, dynamic> toMap() => {
        "cuenta_Bancaria": cuentaBancaria,
        "descripcion": descripcion,
        "banco": banco,
        "id_Cuenta_Bancaria": idCuentaBancaria,
        "ban_Ini": banIni,
        "ban_Ini_Mes": banIniMes,
        "cuenta": cuenta,
        "num_Doc": numDoc,
        "saldo": saldo,
        "estado": estado,
        "lugar": lugar,
        "ban_Ini_Dia": banIniDia,
        "fecha_Hora": fechaHora,
        "userName": userName,
        "m_Fecha_Hora": mFechaHora,
        "m_UserName": mUserName,
        "orden": orden,
        "serie_Ini": serieIni,
        "serie_Fin": serieFin,
        "moneda": moneda,
        "cuenta_M": cuentaM,
      };
}

class SelectAccountModel {
  SelectAccountModel({
    required this.account,
    required this.isSelected,
  });

  AccountModel account;
  bool isSelected;
}
