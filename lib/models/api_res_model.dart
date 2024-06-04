class ApiResModel {
  int? typeError;
  bool succes;
  dynamic response;
  String url;
  String? storeProcedure;

  ApiResModel({
    this.typeError,
    required this.succes,
    required this.response,
    required this.url,
    required this.storeProcedure,
  });
}
