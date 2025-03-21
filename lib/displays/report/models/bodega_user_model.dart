import 'dart:convert';

class BodegaUserModel {
  int bodega;
  int empresa;
  String nombre;
  int raiz;
  int nivel;
  DateTime fechaHora;
  String userName;
  DateTime? mFechaHora;
  String? mUserName;
  int tipoBodega;
  bool trasegar;
  int localizacion;
  int orden;
  bool produccion;
  bool opcCompra;
  bool opcVenta;

  BodegaUserModel({
    required this.bodega,
    required this.empresa,
    required this.nombre,
    required this.raiz,
    required this.nivel,
    required this.fechaHora,
    required this.userName,
    this.mFechaHora,
    this.mUserName,
    required this.tipoBodega,
    required this.trasegar,
    required this.localizacion,
    required this.orden,
    required this.produccion,
    required this.opcCompra,
    required this.opcVenta,
  });

  factory BodegaUserModel.fromJson(String str) =>
      BodegaUserModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BodegaUserModel.fromMap(Map<String, dynamic> json) => BodegaUserModel(
        bodega: json["bodega"],
        empresa: json["empresa"],
        nombre: json["nombre"],
        raiz: json["raiz"],
        nivel: json["nivel"],
        fechaHora: DateTime.parse(json["fecha_Hora"]),
        userName: json["userName"],
        mFechaHora: json["m_Fecha_Hora"] == null
            ? null
            : DateTime.parse(json["m_Fecha_Hora"]),
        mUserName: json["m_UserName"],
        tipoBodega: json["tipo_Bodega"],
        trasegar: json["trasegar"],
        localizacion: json["localizacion"],
        orden: json["orden"],
        produccion: json["produccion"],
        opcCompra: json["opc_Compra"],
        opcVenta: json["opc_Venta"],
      );

  Map<String, dynamic> toMap() => {
        "bodega": bodega,
        "empresa": empresa,
        "nombre": nombre,
        "raiz": raiz,
        "nivel": nivel,
        "fecha_Hora": fechaHora.toIso8601String(),
        "userName": userName,
        "m_Fecha_Hora": mFechaHora?.toIso8601String(),
        "m_UserName": mUserName,
        "tipo_Bodega": tipoBodega,
        "trasegar": trasegar,
        "localizacion": localizacion,
        "orden": orden,
        "produccion": produccion,
        "opc_Compra": opcCompra,
        "opc_Venta": opcVenta,
      };
}
