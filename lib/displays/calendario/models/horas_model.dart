import 'dart:convert';

class HorasModel {
  int hora24;
  String hora12;
  bool visible;

  HorasModel({
    required this.hora24,
    required this.hora12,
    required this.visible,
  });

  factory HorasModel.fromJson(String str) =>
      HorasModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HorasModel.fromMap(Map<String, dynamic> json) => HorasModel(
        hora24: json["hora24"],
        hora12: json["hora12"],
        visible: json["visible"],
      );

  Map<String, dynamic> toMap() => {
        "hora24": hora24,
        "hora12": hora12,
        "visible": visible,
      };
}
