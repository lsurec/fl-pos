import 'dart:convert';

class ResponseModel {
  String storeProcedure;
  dynamic data;

  ResponseModel({
    required this.storeProcedure,
    required this.data,
  });

  factory ResponseModel.fromJson(String str) =>
      ResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResponseModel.fromMap(Map<String, dynamic> json) => ResponseModel(
        storeProcedure: json["storeProcedure"],
        data: json["data"],
      );

  Map<String, dynamic> toMap() => {
        "storeProcedure": storeProcedure,
        "data": data,
      };
}
