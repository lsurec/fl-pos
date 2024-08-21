import 'dart:convert';

class EmpresaModel {
  int empresa;
  String empresaNombre;
  String razonSocial;
  String empresaNit;
  String empresaDireccion;
  String numeroPatronal;
  int estado;
  String campo1;
  String campo2;
  String campo3;
  String campo4;
  String campo5;
  String campo6;
  String campo7;
  String campo8;
  int moneda;
  String monedaNombre;
  String monedaSimbolo;
  String monedaIsoCode;
  String empresaImg;
  String absolutePathPicture;

  EmpresaModel({
    required this.empresa,
    required this.empresaNombre,
    required this.razonSocial,
    required this.empresaNit,
    required this.empresaDireccion,
    required this.numeroPatronal,
    required this.estado,
    required this.campo1,
    required this.campo2,
    required this.campo3,
    required this.campo4,
    required this.campo5,
    required this.campo6,
    required this.campo7,
    required this.campo8,
    required this.moneda,
    required this.monedaNombre,
    required this.monedaSimbolo,
    required this.monedaIsoCode,
    required this.empresaImg,
    required this.absolutePathPicture,
  });

  factory EmpresaModel.fromJson(String str) =>
      EmpresaModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EmpresaModel.fromMap(Map<String, dynamic> json) => EmpresaModel(
        empresa: json["empresa"],
        empresaNombre: json["empresa_Nombre"],
        razonSocial: json["razon_Social"],
        empresaNit: json["empresa_NIT"],
        empresaDireccion: json["empresa_Direccion"],
        numeroPatronal: json["numero_Patronal"],
        estado: json["estado"],
        campo1: json["campo_1"],
        campo2: json["campo_2"],
        campo3: json["campo_3"],
        campo4: json["campo_4"],
        campo5: json["campo_5"],
        campo6: json["campo_6"],
        campo7: json["campo_7"],
        campo8: json["campo_8"],
        moneda: json["moneda"],
        monedaNombre: json["moneda_Nombre"],
        monedaSimbolo: json["moneda_Simbolo"],
        monedaIsoCode: json["moneda_ISO_Code"],
        empresaImg: json["empresa_Img"],
        absolutePathPicture: json["absolutePathPicture"],
      );

  Map<String, dynamic> toMap() => {
        "empresa": empresa,
        "empresa_Nombre": empresaNombre,
        "razon_Social": razonSocial,
        "empresa_NIT": empresaNit,
        "empresa_Direccion": empresaDireccion,
        "numero_Patronal": numeroPatronal,
        "estado": estado,
        "campo_1": campo1,
        "campo_2": campo2,
        "campo_3": campo3,
        "campo_4": campo4,
        "campo_5": campo5,
        "campo_6": campo6,
        "campo_7": campo7,
        "campo_8": campo8,
        "moneda": moneda,
        "moneda_Nombre": monedaNombre,
        "moneda_Simbolo": monedaSimbolo,
        "moneda_ISO_Code": monedaIsoCode,
        "empresa_Img": empresaImg,
        "absolutePathPicture": absolutePathPicture,
      };

  // Sobrescribimos el método de comparación
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmpresaModel &&
          runtimeType == other.runtimeType &&
          empresa == other.empresa &&
          empresaNombre == other.empresaNombre &&
          razonSocial == other.razonSocial &&
          empresaNit == other.empresaNit &&
          empresaDireccion == other.empresaDireccion &&
          numeroPatronal == other.numeroPatronal &&
          estado == other.estado &&
          campo1 == other.campo1 &&
          campo2 == other.campo2 &&
          campo3 == other.campo3 &&
          campo4 == other.campo4 &&
          campo5 == other.campo5 &&
          campo6 == other.campo6 &&
          campo7 == other.campo7 &&
          campo8 == other.campo8 &&
          moneda == other.moneda &&
          monedaNombre == other.monedaNombre &&
          monedaSimbolo == other.monedaSimbolo &&
          monedaIsoCode == other.monedaIsoCode &&
          empresaImg == other.empresaImg &&
          absolutePathPicture == other.absolutePathPicture;

  @override
  int get hashCode =>
      empresa.hashCode ^
      empresaNombre.hashCode ^
      razonSocial.hashCode ^
      empresaNit.hashCode ^
      empresaDireccion.hashCode ^
      numeroPatronal.hashCode ^
      estado.hashCode ^
      campo1.hashCode ^
      campo2.hashCode ^
      campo3.hashCode ^
      campo4.hashCode ^
      campo5.hashCode ^
      campo6.hashCode ^
      campo7.hashCode ^
      campo8.hashCode ^
      moneda.hashCode ^
      monedaNombre.hashCode ^
      monedaSimbolo.hashCode ^
      monedaIsoCode.hashCode ^
      empresaImg.hashCode ^
      absolutePathPicture.hashCode;
}
