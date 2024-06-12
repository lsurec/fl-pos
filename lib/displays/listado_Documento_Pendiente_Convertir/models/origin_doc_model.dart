import 'dart:convert';

class OriginDocModel {
  int documento;
  int tipoDocumento;
  String serieDocumento;
  int empresa;
  int localizacion;
  int estacionTrabajo;
  int fechaReg;
  dynamic fechaDocumento;
  dynamic fechaHora;
  dynamic usuario;
  dynamic documentoDescripcion;
  dynamic serie;
  int cuentaCorrentista;
  String cuentaCta;
  int? cuentaCorrentistaRef;
  dynamic nit;
  dynamic cliente;
  dynamic direccion;
  int iDDocumento;
  dynamic observacion1;
  DateTime? fechaIni;
  DateTime? fechaFin;
  double monto;
  int? referencia;
  int consecutivoInterno;
  DateTime? referenciaDFechaIni;
  DateTime? referenciaDFechaFin;
  String? referenciaDDescripcion;
  String? referenciaDObservacion;
  String? referenciaDObservacion2;
  String? referenciaDObservacion3;
  int? tipoReferencia;
  dynamic referenciaDDesTipoReferencia;
  int? consecutivoInternoRef;

  OriginDocModel({
    required this.documento,
    required this.tipoDocumento,
    required this.serieDocumento,
    required this.empresa,
    required this.localizacion,
    required this.estacionTrabajo,
    required this.fechaReg,
    required this.fechaDocumento,
    required this.fechaHora,
    required this.usuario,
    required this.documentoDescripcion,
    required this.serie,
    required this.cuentaCorrentista,
    required this.cuentaCta,
    required this.cuentaCorrentistaRef,
    required this.nit,
    required this.cliente,
    required this.direccion,
    required this.iDDocumento,
    required this.observacion1,
    required this.fechaIni,
    required this.fechaFin,
    required this.monto,
    required this.referencia,
    required this.consecutivoInterno,
    required this.referenciaDFechaIni,
    required this.referenciaDFechaFin,
    required this.referenciaDDescripcion,
    required this.referenciaDObservacion,
    required this.referenciaDObservacion2,
    required this.referenciaDObservacion3,
    required this.tipoReferencia,
    required this.referenciaDDesTipoReferencia,
    required this.consecutivoInternoRef,
  });

  factory OriginDocModel.fromJson(String str) =>
      OriginDocModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OriginDocModel.fromMap(Map<String, dynamic> json) => OriginDocModel(
        documento: json["documento"],
        tipoDocumento: json["tipo_Documento"],
        serieDocumento: json["serie_Documento"],
        empresa: json["empresa"],
        localizacion: json["localizacion"],
        estacionTrabajo: json["estacion_Trabajo"],
        fechaReg: json["fecha_Reg"],
        fechaDocumento: json["fecha_Documento"],
        fechaHora: json["fecha_Hora"],
        usuario: json["usuario"],
        documentoDescripcion: json["documento_Descripcion"],
        serie: json["serie"],
        cuentaCorrentista: json["cuenta_Correntista"],
        cuentaCta: json["cuenta_Cta"],
        cuentaCorrentistaRef: json["cuenta_Correntista_Ref"],
        nit: json["nit"],
        cliente: json["cliente"],
        direccion: json["direccion"],
        iDDocumento: json["iD_Documento"],
        observacion1: json["observacion_1"],
        fechaIni: json["fecha_Ini"] == null
            ? null
            : DateTime.parse(json["fecha_Ini"]),
        fechaFin: json["fecha_Fin"] == null
            ? null
            : DateTime.parse(json["fecha_Fin"]),
        monto: json["monto"]?.toDouble(),
        referencia: json["referencia"],
        consecutivoInterno: json["consecutivo_Interno"],
        referenciaDFechaIni: json["referencia_D_Fecha_Ini"] == null
            ? null
            : DateTime.parse(json["referencia_D_Fecha_Ini"]),
        referenciaDFechaFin: json["referencia_D_Fecha_Fin"] == null
            ? null
            : DateTime.parse(json["referencia_D_Fecha_Fin"]),
        referenciaDDescripcion: json["referencia_D_Descripcion"],
        referenciaDObservacion: json["referencia_D_Observacion"],
        referenciaDObservacion2: json["referencia_D_Observacion_2"],
        referenciaDObservacion3: json["referencia_D_Observacion_3"],
        tipoReferencia: json["tipo_Referencia"],
        referenciaDDesTipoReferencia: json["referencia_D_Des_Tipo_Referencia"],
        consecutivoInternoRef: json["consecutivo_Interno_Ref"],
      );

  Map<String, dynamic> toMap() => {
        "documento": documento,
        "tipo_Documento": tipoDocumento,
        "serie_Documento": serieDocumento,
        "empresa": empresa,
        "localizacion": localizacion,
        "estacion_Trabajo": estacionTrabajo,
        "fecha_Reg": fechaReg,
        "fecha_Documento": fechaDocumento,
        "fecha_Hora": fechaHora,
        "usuario": usuario,
        "documento_Descripcion": documentoDescripcion,
        "serie": serie,
        "cuenta_Correntista": cuentaCorrentista,
        "cuenta_Cta": cuentaCta,
        "cuenta_Correntista_Ref": cuentaCorrentistaRef,
        "nit": nit,
        "cliente": cliente,
        "direccion": direccion,
        "iD_Documento": iDDocumento,
        "observacion_1": observacion1,
        "fecha_Ini": fechaIni,
        "fecha_Fin": fechaFin,
        "monto": monto,
        "referencia": referencia,
        "consecutivo_Interno": consecutivoInterno,
        "referencia_D_Fecha_Ini": referenciaDFechaIni,
        "referencia_D_Fecha_Fin": referenciaDFechaFin,
        "referencia_D_Descripcion": referenciaDDescripcion,
        "referencia_D_Observacion": referenciaDObservacion,
        "referencia_D_Observacion_2": referenciaDObservacion2,
        "referencia_D_Observacion_3": referenciaDObservacion3,
        "tipo_Referencia": tipoReferencia,
        "referencia_D_Des_Tipo_Referencia": referenciaDDesTipoReferencia,
        "consecutivo_Interno_Ref": consecutivoInternoRef,
      };
}
