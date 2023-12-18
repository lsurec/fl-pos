import 'dart:convert';

class ResStatusModel {
  int statusCode;
  String response;

  ResStatusModel({
    required this.statusCode,
    required this.response,
  });

  factory ResStatusModel.fromJson(String str) =>
      ResStatusModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResStatusModel.fromMap(Map<String, dynamic> json) => ResStatusModel(
        statusCode: json["statusCode"],
        response: json["response"],
      );

  Map<String, dynamic> toMap() => {
        "statusCode": statusCode,
        "response": response,
      };
}
