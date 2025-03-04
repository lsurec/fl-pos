class ReportUnidadesVendidasModel {
  String bodega;
  int idBodega;
  List<ProductReportUnidadesVendidas> products;
  double total;

  ReportUnidadesVendidasModel({
    required this.bodega,
    required this.idBodega,
    required this.products,
    required this.total,
  });
}

class ProductReportUnidadesVendidas {
  int id;
  String desc;
  double cantidad;
  double unidades;

  ProductReportUnidadesVendidas({
    required this.id,
    required this.desc,
    required this.cantidad,
    required this.unidades,
  });
}
