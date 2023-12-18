class ErrorModel {
  ErrorModel({
    required this.date,
    required this.description,
    this.url,
    required this.storeProcedure,
  });

  DateTime date;
  String description;
  String? url;
  String? storeProcedure;
}
