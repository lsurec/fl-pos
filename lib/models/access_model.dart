import 'dart:convert';

class AccessModel {
  String user;
  bool success;
  String message;
  String con;

  AccessModel({
    required this.user,
    required this.success,
    required this.message,
    required this.con,
  });

  factory AccessModel.fromJson(String str) =>
      AccessModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AccessModel.fromMap(Map<String, dynamic> json) => AccessModel(
        user: json["user"],
        success: json["success"],
        message: json["message"],
        con: json["con"],
      );

  Map<String, dynamic> toMap() => {
        "user": user,
        "success": success,
        "message": message,
        "con": con,
      };
}
