import 'dart:convert';

import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/models/models.dart';

class SaveDocModel {
  SaveDocModel({
    required this.user,
    required this.empresa,
    required this.estacion,
    required this.cliente,
    required this.vendedor,
    required this.serie,
    required this.tipoDocumento,
    required this.detalles,
    required this.pagos,
    required this.tipoRef,
    required this.refFechaEntrega,
    required this.refFechaRecoger,
    required this.refFechaInicio,
    required this.refFechaFin,
    required this.refContacto,
    required this.refDescripcion,
    required this.refDireccionEntrega,
    required this.refObservacion,
  });

  String user;
  EmpresaModel empresa;
  EstacionModel estacion;
  ClientModel? cliente;
  SellerModel? vendedor;
  SerieModel? serie;
  int tipoDocumento;
  List<TraInternaModel> detalles;
  List<AmountModel> pagos;
  TipoReferenciaModel? tipoRef;
  String? refFechaEntrega;
  String? refFechaRecoger;
  String? refFechaInicio;
  String? refFechaFin;
  String? refContacto;
  String? refDescripcion;
  String? refDireccionEntrega;
  String? refObservacion;

  factory SaveDocModel.fromJson(String str) =>
      SaveDocModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SaveDocModel.fromMap(Map<String, dynamic> json) => SaveDocModel(
        user: json["user"],
        empresa: EmpresaModel.fromMap(json["empresa"] ?? {}),
        estacion: EstacionModel.fromMap(json["estacion"] ?? {}),
        cliente: json["cliente"] != null
            ? ClientModel.fromMap(json["cliente"])
            : null,
        vendedor: json["vendedor"] != null
            ? SellerModel.fromMap(json["vendedor"])
            : null,
        serie: json["serie"] != null ? SerieModel.fromMap(json["serie"]) : null,
        tipoDocumento: json["tipoDocumento"],
        detalles: List<TraInternaModel>.from(
            json["detalles"].map((x) => TraInternaModel.fromMap(x))),
        pagos: List<AmountModel>.from(
            json["pagos"].map((x) => AmountModel.fromMap(x))),
        tipoRef: json["tipoRef"] != null
            ? TipoReferenciaModel.fromMap(json["tipoRef"])
            : null,
        refFechaEntrega: json["refFechaEntrega"],
        refFechaRecoger: json["refFechaRecoger"],
        refFechaInicio: json["refFechaInicio"],
        refFechaFin: json["refFechaFin"],
        refContacto: json["refContacto"],
        refDescripcion: json["refDescripcion"],
        refDireccionEntrega: json["refDireccionEntrega"],
        refObservacion: json["refObservacion"],
      );

  Map<String, dynamic> toMap() => {
        "user": user,
        "empresa": empresa.toMap(),
        "estacion": estacion.toMap(),
        "cliente": cliente?.toMap(),
        "vendedor": vendedor?.toMap(),
        "serie": serie?.toMap(),
        "tipoDocumento": tipoDocumento,
        "detalles": List<dynamic>.from(detalles.map((x) => x.toMap())),
        "pagos": List<dynamic>.from(pagos.map((x) => x.toMap())),
        "tipoRef": tipoRef?.toMap(),
        "refFechaEntrega": refFechaEntrega,
        "refFechaRecoger": refFechaRecoger,
        "refFechaInicio": refFechaInicio,
        "refFechaFin": refFechaFin,
        "refContacto": refContacto,
        "refDescripcion": refDescripcion,
        "refDireccionEntrega": refDireccionEntrega,
        "refObservacion": refObservacion,
      };
}
