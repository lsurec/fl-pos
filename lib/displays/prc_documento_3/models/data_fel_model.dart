import 'dart:convert';

class DataFelModel {
  String serieDocumento;
  String numeroAutorizacion;
  String numeroDocumento;
  DateTime fechaHoraCertificacion;
  String nitCertificador;
  String nombreCertificador;

  DataFelModel({
    required this.serieDocumento,
    required this.numeroAutorizacion,
    required this.numeroDocumento,
    required this.fechaHoraCertificacion,
    required this.nitCertificador,
    required this.nombreCertificador,
  });

  factory DataFelModel.fromJson(String str) =>
      DataFelModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DataFelModel.fromMap(Map<String, dynamic> json) => DataFelModel(
        serieDocumento: json["serieDocumento"],
        numeroAutorizacion: json["numeroAutorizacion"],
        numeroDocumento: json["numeroDocumento"],
        fechaHoraCertificacion: DateTime.parse(json["fechaHoraCertificacion"]),
        nitCertificador: json["nitCertificador"],
        nombreCertificador: json["nombreCertificador"],
      );

  Map<String, dynamic> toMap() => {
        "serieDocumento": serieDocumento,
        "numeroAutorizacion": numeroAutorizacion,
        "numeroDocumento": numeroDocumento,
        "fechaHoraCertificacion": fechaHoraCertificacion.toIso8601String(),
        "nitCertificador": nitCertificador,
        "nombreCertificador": nombreCertificador,
      };
}
