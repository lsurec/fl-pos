import 'dart:convert';

class AccountPinModel {
  int cuentaCorrentista;
  String cuentaCta;
  String nombre;
  String nombres;
  String apellidos;
  String eMail;
  dynamic nit;

  AccountPinModel({
    required this.cuentaCorrentista,
    required this.cuentaCta,
    required this.nombre,
    required this.nombres,
    required this.apellidos,
    required this.eMail,
    required this.nit,
  });

  factory AccountPinModel.fromJson(String str) =>
      AccountPinModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AccountPinModel.fromMap(Map<String, dynamic> json) => AccountPinModel(
        cuentaCorrentista: json["cuenta_Correntista"],
        cuentaCta: json["cuenta_Cta"],
        nombre: json["nombre"],
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        eMail: json["eMail"],
        nit: json["nit"],
      );

  Map<String, dynamic> toMap() => {
        "cuenta_Correntista": cuentaCorrentista,
        "cuenta_Cta": cuentaCta,
        "nombre": nombre,
        "nombres": nombres,
        "apellidos": apellidos,
        "eMail": eMail,
        "nit": nit,
      };
}
