import 'dart:convert';

class ApiResponseModel {
  bool success;
  String message;
  String error;
  String storeProcedure;
  dynamic parameters;
  dynamic data;
  DateTime timestamp;
  String version;
  String? url;

  ApiResponseModel({
    required this.success,
    required this.message,
    required this.error,
    required this.storeProcedure,
    required this.parameters,
    required this.data,
    required this.timestamp,
    required this.version,
    this.url,
  });

  factory ApiResponseModel.fromJson(String str) =>
      ApiResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ApiResponseModel.fromMap(Map<String, dynamic> json) =>
      ApiResponseModel(
        success: json["success"],
        message: json["message"],
        error: json["error"],
        storeProcedure: json["storeProcedure"],
        parameters: json["parameters"],
        data: json["data"],
        timestamp: DateTime.parse(json["timestamp"]),
        version: json["version"],
        url: json["url"],
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "error": error,
        "storeProcedure": storeProcedure,
        "parameters": parameters,
        "data": data,
        "timestamp": timestamp.toIso8601String(),
        "version": version,
        "url": url,
      };
}
