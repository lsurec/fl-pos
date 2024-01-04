import 'dart:convert';

class ClientModel {
  int cuentaCorrentista;
  String cuentaCta;
  String facturaNombre;
  String facturaNit;
  String facturaDireccion;
  dynamic cCDireccion;
  String desCuentaCta;
  dynamic direccion1CuentaCta;
  dynamic eMail;
  dynamic telefono;

  ClientModel({
    required this.cuentaCorrentista,
    required this.cuentaCta,
    required this.facturaNombre,
    required this.facturaNit,
    required this.facturaDireccion,
    required this.cCDireccion,
    required this.desCuentaCta,
    required this.direccion1CuentaCta,
    required this.eMail,
    required this.telefono,
  });

  factory ClientModel.fromJson(String str) =>
      ClientModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ClientModel.fromMap(Map<String, dynamic> json) => ClientModel(
        cuentaCorrentista: json["cuenta_Correntista"],
        cuentaCta: json["cuenta_Cta"],
        facturaNombre: json["factura_Nombre"],
        facturaNit: json["factura_NIT"],
        facturaDireccion: json["factura_Direccion"],
        cCDireccion: json["cC_Direccion"],
        desCuentaCta: json["des_Cuenta_Cta"],
        direccion1CuentaCta: json["direccion_1_Cuenta_Cta"],
        eMail: json["eMail"],
        telefono: json["telefono"],
      );

  Map<String, dynamic> toMap() => {
        "cuenta_Correntista": cuentaCorrentista,
        "cuenta_Cta": cuentaCta,
        "factura_Nombre": facturaNombre,
        "factura_NIT": facturaNit,
        "factura_Direccion": facturaDireccion,
        "cC_Direccion": cCDireccion,
        "des_Cuenta_Cta": desCuentaCta,
        "direccion_1_Cuenta_Cta": direccion1CuentaCta,
        "eMail": eMail,
        "telefono": telefono,
      };
}
