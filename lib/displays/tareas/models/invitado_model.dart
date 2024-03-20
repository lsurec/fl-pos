import 'dart:convert';

class InvitadoModel {
  int tareaUserName;
  String eMail;
  String userName;

  InvitadoModel({
    required this.tareaUserName,
    required this.eMail,
    required this.userName,
  });

  factory InvitadoModel.fromJson(String str) =>
      InvitadoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory InvitadoModel.fromMap(Map<String, dynamic> json) => InvitadoModel(
        tareaUserName: json["tarea_UserName"],
        eMail: json["eMail"],
        userName: json["userName"],
      );

  Map<String, dynamic> toMap() => {
        "tarea_UserName": tareaUserName,
        "eMail": eMail,
        "userName": userName,
      };
}
