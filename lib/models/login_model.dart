// To parse this JSON data, do
//
//     final loginModel = loginModelFromMap(jsonString);

import 'dart:convert';

class LoginModel {
  LoginModel({
    required this.user,
    required this.pass,
  });

  String user;
  String pass;

  factory LoginModel.fromJson(String str) =>
      LoginModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginModel.fromMap(Map<String, dynamic> json) => LoginModel(
        user: json["user"],
        pass: json["pass"],
      );

  Map<String, dynamic> toMap() => {
        "user": user,
        "pass": pass,
      };
}

class RespLogin {
  bool success;
  dynamic data;

  RespLogin({
    required this.success,
    required this.data,
  });

  factory RespLogin.fromJson(String str) => RespLogin.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RespLogin.fromMap(Map<String, dynamic> json) => RespLogin(
        success: json["success"],
        data: json["data"],
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "data": data,
      };
}
