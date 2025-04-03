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
        mensaje: json["Mensaje"],
        resultado: json["Resultado"],
      );

  Map<String, dynamic> toMap() => {
        "Mensaje": mensaje,
        "Resultado": resultado,
      };
}
