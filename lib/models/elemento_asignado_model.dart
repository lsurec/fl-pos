import 'dart:convert';

class ElementoAsignadoModel {
  int elementoAsignado;
  String descripcion;
  String elementoId;
  int empresa;
  int raiz;
  int nivel;
  int estado;
  DateTime fechaHora;
  String userName;
  String mUserName;
  int pagina;
  int orden;
  int objSecuencia;
  int marca;
  DateTime modeloFecha;
  bool opcDetalle;

  ElementoAsignadoModel({
    required this.elementoAsignado,
    required this.descripcion,
    required this.elementoId,
    required this.empresa,
    required this.raiz,
    required this.nivel,
    required this.estado,
    required this.fechaHora,
    required this.userName,
    required this.mUserName,
    required this.pagina,
    required this.orden,
    required this.objSecuencia,
    required this.marca,
    required this.modeloFecha,
    required this.opcDetalle,
  });

  factory ElementoAsignadoModel.fromJson(String str) =>
      ElementoAsignadoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ElementoAsignadoModel.fromMap(Map<String, dynamic> json) =>
      ElementoAsignadoModel(
        elementoAsignado: json["elemento_Asignado"],
        descripcion: json["descripcion"],
        elementoId: json["elemento_Id"],
        empresa: json["empresa"],
        raiz: json["raiz"],
        nivel: json["nivel"],
        estado: json["estado"],
        fechaHora: DateTime.parse(json["fecha_Hora"]),
        userName: json["userName"],
        mUserName: json["m_UserName"],
        pagina: json["pagina"],
        orden: json["orden"],
        objSecuencia: json["obj_Secuencia"],
        marca: json["marca"],
        modeloFecha: DateTime.parse(json["modelo_Fecha"]),
        opcDetalle: json["opc_Detalle"],
      );

  Map<String, dynamic> toMap() => {
        "elemento_Asignado": elementoAsignado,
        "descripcion": descripcion,
        "elemento_Id": elementoId,
        "empresa": empresa,
        "raiz": raiz,
        "nivel": nivel,
        "estado": estado,
        "fecha_Hora": fechaHora.toIso8601String(),
        "userName": userName,
        "m_UserName": mUserName,
        "pagina": pagina,
        "orden": orden,
        "obj_Secuencia": objSecuencia,
        "marca": marca,
        "modelo_Fecha": modeloFecha.toIso8601String(),
        "opc_Detalle": opcDetalle,
      };
}
