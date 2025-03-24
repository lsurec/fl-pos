class ReportFactContCredModel {
  String bodega;
  int idBodega;
  List<DocReportModel> docs;
  DateTime startDate;
  DateTime endDate;
  double totalContado;
  double totalCredito;
  double totalContCred;

  ReportFactContCredModel({
    required this.bodega,
    required this.idBodega,
    required this.docs,
    required this.startDate,
    required this.endDate,
    required this.totalContado,
    required this.totalCredito,
    required this.totalContCred,
  });
}

class DocReportModel {
  int id;
  double monto;
  String tipo;

  DocReportModel({
    required this.id,
    required this.tipo,
    required this.monto,
  });
}
