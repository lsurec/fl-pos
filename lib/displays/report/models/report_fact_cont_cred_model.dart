class ReportFactContCredModel {
  String bodega;
  int idBodega;
  List<DocReportModel> docs;
  double totalContado;
  double totalCredito;
  double totalContCred;

  ReportFactContCredModel({
    required this.bodega,
    required this.idBodega,
    required this.docs,
    required this.totalContado,
    required this.totalCredito,
    required this.totalContCred,
  });
}

class DocReportModel {
  int id;
  double monto;

  DocReportModel({
    required this.id,
    required this.monto,
  });
}
