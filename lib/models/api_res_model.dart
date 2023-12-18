class ApiResModel {
  int? typeError;
  bool succes;
  dynamic message;
  String url;
  String? storeProcedure;

  ApiResModel({
    this.typeError,
    required this.succes,
    required this.message,
    required this.url,
    required this.storeProcedure,
  });
}
