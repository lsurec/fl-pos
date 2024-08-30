import 'dart:convert';

class UpdateDocModel {
  int consecutivoInterno;
  int cuentaCorrentista;
  int? cuentaCorrentistaRef;
  String cuentaCuenta;
  String documentoDireccion;
  String documentoNit;
  String documentoNombre;
  int empresa;
  int estacionTrabajo;
  DateTime fechaDocumento;
  DateTime? fechaFin;
  DateTime fechaHora;
  DateTime? fechaIni;
  String idDocumento;
  int localizacion;
  String mUser;
  String observacion;
  int? referencia;
  String serieDocumento;
  int tipoDocumento;
  String user;

  UpdateDocModel({
    required this.consecutivoInterno,
    required this.cuentaCorrentista,
    required this.cuentaCorrentistaRef,
    required this.cuentaCuenta,
    required this.documentoDireccion,
    required this.documentoNit,
    required this.documentoNombre,
    required this.empresa,
    required this.estacionTrabajo,
    required this.fechaDocumento,
    required this.fechaFin,
    required this.fechaHora,
    required this.fechaIni,
    required this.idDocumento,
    required this.localizacion,
    required this.mUser,
    required this.observacion,
    required this.referencia,
    required this.serieDocumento,
    required this.tipoDocumento,
    required this.user,
  });

  factory UpdateDocModel.fromJson(String str) =>
      UpdateDocModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UpdateDocModel.fromMap(Map<String, dynamic> json) => UpdateDocModel(
        consecutivoInterno: json["consecutivoInterno"],
        cuentaCorrentista: json["cuentaCorrentista"],
        cuentaCorrentistaRef: json["cuentaCorrentistaRef"],
        cuentaCuenta: json["cuentaCuenta"],
        documentoDireccion: json["documentoDireccion"],
        documentoNit: json["documentoNit"],
        documentoNombre: json["documentoNombre"],
        empresa: json["empresa"],
        estacionTrabajo: json["estacionTrabajo"],
        fechaDocumento: DateTime.parse(json["fechaDocumento"]),
        fechaFin:
            json["fechaFin"] != null ? DateTime.parse(json["fechaFin"]) : null,
        fechaHora: DateTime.parse(json["fechaHora"]),
        fechaIni:
            json["fechaIni"] != null ? DateTime.parse(json["fechaIni"]) : null,
        idDocumento: json["idDocumento"],
        localizacion: json["localizacion"],
        mUser: json["mUser"],
        observacion: json["observacion"],
        referencia: json["referencia"],
        serieDocumento: json["serieDocumento"],
        tipoDocumento: json["tipoDocumento"],
        user: json["user"],
      );

  Map<String, dynamic> toMap() => {
        "consecutivoInterno": consecutivoInterno,
        "cuentaCorrentista": cuentaCorrentista,
        "cuentaCorrentistaRef": cuentaCorrentistaRef,
        "cuentaCuenta": cuentaCuenta,
        "documentoDireccion": documentoDireccion,
        "documentoNit": documentoNit,
        "documentoNombre": documentoNombre,
        "empresa": empresa,
        "estacionTrabajo": estacionTrabajo,
        "fechaDocumento": fechaDocumento.toIso8601String(),
        "fechaFin": fechaFin?.toIso8601String(),
        "fechaHora": fechaHora.toIso8601String(),
        "fechaIni": fechaIni?.toIso8601String(),
        "idDocumento": idDocumento,
        "localizacion": localizacion,
        "mUser": mUser,
        "observacion": observacion,
        "referencia": referencia,
        "serieDocumento": serieDocumento,
        "tipoDocumento": tipoDocumento,
        "user": user,
      };
}
