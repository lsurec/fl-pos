import 'dart:convert';

class OriginDocModel {
  int documento;
  int tipoDocumento;
  String serieDocumento;
  int empresa;
  int localizacion;
  int estacionTrabajo;
  int fechaReg;
  String fechaDocumento;
  String fechaHora;
  String usuario;
  String documentoDecripcion;
  String serie;
  int iDDocumento;
  String observacion;
  dynamic fechaPedido;

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
    required this.documentoDecripcion,
    required this.serie,
    required this.iDDocumento,
    required this.observacion,
    required this.fechaPedido,
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
        documentoDecripcion: json["documento_Decripcion"],
        serie: json["serie"],
        iDDocumento: json["iD_Documento"],
        observacion: json["observacion"],
        fechaPedido: json["fecha_Pedido"],
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
        "documento_Decripcion": documentoDecripcion,
        "serie": serie,
        "iD_Documento": iDDocumento,
        "observacion": observacion,
        "fecha_Pedido": fechaPedido,
      };
}
