import 'dart:convert';

class IdDeviceResModel {
  dynamic mensaje;
  dynamic resultado;

  IdDeviceResModel({
    required this.mensaje,
    required this.resultado,
  });

  factory IdDeviceResModel.fromJson(String str) =>
      IdDeviceResModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory IdDeviceResModel.fromMap(Map<String, dynamic> json) =>
      IdDeviceResModel(
        mensaje: json["mensaje"],
        resultado: json["resultado"],
      );

  Map<String, dynamic> toMap() => {
        "mensaje": mensaje,
        "resultado": resultado,
      };
}
