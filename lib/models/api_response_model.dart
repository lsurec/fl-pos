import 'dart:convert';

class ApiResponseModel {
  bool status;
  String message;
  String error;
  String storeProcedure;
  dynamic parameters;
  dynamic data;
  DateTime timestamp;
  String version;

  ApiResponseModel({
    required this.status,
    required this.message,
    required this.error,
    required this.storeProcedure,
    required this.parameters,
    required this.data,
    required this.timestamp,
    required this.version,
  });

  factory ApiResponseModel.fromJson(String str) =>
      ApiResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ApiResponseModel.fromMap(Map<String, dynamic> json) =>
      ApiResponseModel(
        status: json["status"],
        message: json["message"],
        error: json["error"],
        storeProcedure: json["storeProcedure"],
        parameters: json["parameters"],
        data: json["data"],
        timestamp: DateTime.parse(json["timestamp"]),
        version: json["version"],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "error": error,
        "storeProcedure": storeProcedure,
        "parameters": parameters,
        "data": data,
        "timestamp": timestamp.toIso8601String(),
        "version": version,
      };
}
