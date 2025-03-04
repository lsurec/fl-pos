class ReportStockModel {
  String bodega;
  int idBodega;
  List<ProductReportStockModel> products;

  ReportStockModel({
    required this.bodega,
    required this.idBodega,
    required this.products,
  });
}

class ProductReportStockModel {
  int id;
  String desc;
  double existencias;

  ProductReportStockModel({
    required this.id,
    required this.desc,
    required this.existencias,
  });
}
