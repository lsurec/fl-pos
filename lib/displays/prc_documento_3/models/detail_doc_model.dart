import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';

class DetailDocModel {
  ClientModel client;
  String seller;
  List<TransactionDetail> transactions;
  List<AmountModel> payments;
  double subtotal;
  double total;
  double cargo;
  double descuento;
  String observacion;
  int doc;
  String serie;

  DetailDocModel({
    required this.client,
    required this.seller,
    required this.transactions,
    required this.payments,
    required this.cargo,
    required this.descuento,
    required this.observacion,
    required this.subtotal,
    required this.total,
    required this.doc,
    required this.serie,
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
