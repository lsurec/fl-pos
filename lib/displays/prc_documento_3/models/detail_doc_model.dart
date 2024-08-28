import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/models/empresa_model.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/models/estacion_model.dart';

class DetailDocModel {
  int idRef;
  String fecha;
  int consecutivo;
  EmpresaModel empresa;
  EstacionModel estacion;
  String serie;
  String serieDesc;
  int documento;
  String documentoDesc;
  ClientModel? client;
  String? seller;
  List<TransactionDetail> transactions;
  List<AmountModel> payments;
  double subtotal;
  double total;
  double cargo;
  double descuento;
  String observacion;
  int? docRefTipoReferencia;
  DateTime? docRefFechaIni;
  DateTime? docRefFechaFin;
  DateTime? docFechaIni;
  DateTime? docFechaFin;
  String? docRefObservacion2;
  String? docRefDescripcion;
  String? docRefObservacion3;
  String? docRefObservacion;

  DetailDocModel({
    required this.idRef,
    required this.fecha,
    required this.consecutivo,
    required this.empresa,
    required this.estacion,
    required this.client,
    required this.seller,
    required this.transactions,
    required this.payments,
    required this.cargo,
    required this.descuento,
    required this.observacion,
    required this.subtotal,
    required this.total,
    required this.documento,
    required this.documentoDesc,
    required this.serie,
    required this.serieDesc,
    this.docRefTipoReferencia,
    this.docRefFechaIni,
    this.docRefFechaFin,
    this.docFechaIni,
    this.docFechaFin,
    this.docRefObservacion2,
    this.docRefDescripcion,
    this.docRefObservacion3,
    this.docRefObservacion,
  });
}

class TransactionDetail {
  ProductModel product;
  int cantidad;
  double total;

  TransactionDetail({
    required this.product,
    required this.cantidad,
    required this.total,
  });
}
