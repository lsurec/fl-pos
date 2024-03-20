import 'dart:convert';

class ResComentarioModel {
  dynamic storeProcedure;
  int res;
  bool success;

  ResComentarioModel({
    required this.storeProcedure,
    required this.res,
    required this.success,
  });

  factory ResComentarioModel.fromJson(String str) =>
      ResComentarioModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResComentarioModel.fromMap(Map<String, dynamic> json) =>
      ResComentarioModel(
        storeProcedure: json["storeProcedure"],
        res: json["res"],
        success: json["success"],
      );

  Map<String, dynamic> toMap() => {
        "storeProcedure": storeProcedure,
        "res": res,
        "success": success,
      };
}
