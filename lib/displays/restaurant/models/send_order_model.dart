import 'dart:convert';

class SenOrderModel {
  String userId;
  String order;

  SenOrderModel({
    required this.userId,
    required this.order,
  });

  factory SenOrderModel.fromJson(String str) =>
      SenOrderModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SenOrderModel.fromMap(Map<String, dynamic> json) => SenOrderModel(
        userId: json["userId"],
        order: json["order"],
      );

  Map<String, dynamic> toMap() => {
        "userId": userId,
        "order": order,
      };
}
