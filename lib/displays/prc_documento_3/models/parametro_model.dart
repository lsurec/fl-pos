import 'dart:convert';

class ParametroModel {
  int parametro;
  bool pa;
  int? paEntero;
  String? paCaracter;
  dynamic campo1;
  dynamic campo2;
  String? campo3;
  dynamic campo4;
  dynamic campo5;
  dynamic campo6;
  dynamic campo7;
  dynamic campo8;
  dynamic campo9;
  dynamic campo10;
  dynamic campo11;
  dynamic campo12;

  ParametroModel({
    required this.parametro,
    required this.pa,
    required this.paEntero,
    required this.paCaracter,
    required this.campo1,
    required this.campo2,
    required this.campo3,
    required this.campo4,
    required this.campo5,
    required this.campo6,
    required this.campo7,
    required this.campo8,
    required this.campo9,
    required this.campo10,
    required this.campo11,
    required this.campo12,
  });

  factory ParametroModel.fromJson(String str) =>
      ParametroModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ParametroModel.fromMap(Map<String, dynamic> json) => ParametroModel(
        parametro: json["parametro"],
        pa: json["pa"],
        paEntero: json["pa_Entero"],
        paCaracter: json["pa_Caracter"],
        campo1: json["campo_1"],
        campo2: json["campo_2"],
        campo3: json["campo_3"],
        campo4: json["campo_4"],
        campo5: json["campo_5"],
        campo6: json["campo_6"],
        campo7: json["campo_7"],
        campo8: json["campo_8"],
        campo9: json["campo_9"],
        campo10: json["campo_10"],
        campo11: json["campo_11"],
        campo12: json["campo_12"],
      );

  Map<String, dynamic> toMap() => {
        "parametro": parametro,
        "pa": pa,
        "pa_Entero": paEntero,
        "pa_Caracter": paCaracter,
        "campo_1": campo1,
        "campo_2": campo2,
        "campo_3": campo3,
        "campo_4": campo4,
        "campo_5": campo5,
        "campo_6": campo6,
        "campo_7": campo7,
        "campo_8": campo8,
        "campo_9": campo9,
        "campo_10": campo10,
        "campo_11": campo11,
        "campo_12": campo12,
      };
}
