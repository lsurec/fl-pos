import 'dart:convert';

class ParamConvertDocModel {
  String pUserName;
  int pODocumento;
  int pOTipoDocumento;
  String pOSerieDocumento;
  int pOEmpresa;
  int pOEstacionTrabajo;
  int pOFechaReg;
  int pDTipoDocumento;
  String pDSerieDocumento;
  int pDEmpresa;
  int pDEstacionTrabajo;
  int pDDocumento;
  int pDFechaReg;

  ParamConvertDocModel({
    required this.pUserName,
    required this.pODocumento,
    required this.pOTipoDocumento,
    required this.pOSerieDocumento,
    required this.pOEmpresa,
    required this.pOEstacionTrabajo,
    required this.pOFechaReg,
    required this.pDTipoDocumento,
    required this.pDSerieDocumento,
    required this.pDEmpresa,
    required this.pDEstacionTrabajo,
    required this.pDDocumento,
    required this.pDFechaReg,
  });

  factory ParamConvertDocModel.fromJson(String str) =>
      ParamConvertDocModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ParamConvertDocModel.fromMap(Map<String, dynamic> json) =>
      ParamConvertDocModel(
        pUserName: json["pUserName"],
        pODocumento: json["pO_Documento"],
        pOTipoDocumento: json["pO_Tipo_Documento"],
        pOSerieDocumento: json["pO_Serie_Documento"],
        pOEmpresa: json["pO_Empresa"],
        pOEstacionTrabajo: json["pO_Estacion_Trabajo"],
        pOFechaReg: json["pO_Fecha_Reg"],
        pDTipoDocumento: json["pD_Tipo_Documento"],
        pDSerieDocumento: json["pD_Serie_Documento"],
        pDEmpresa: json["pD_Empresa"],
        pDEstacionTrabajo: json["pD_Estacion_Trabajo"],
        pDDocumento: json["pD_Documento"],
        pDFechaReg: json["pD_Fecha_Reg"],
      );

  Map<String, dynamic> toMap() => {
        "pUserName": pUserName,
        "pO_Documento": pODocumento,
        "pO_Tipo_Documento": pOTipoDocumento,
        "pO_Serie_Documento": pOSerieDocumento,
        "pO_Empresa": pOEmpresa,
        "pO_Estacion_Trabajo": pOEstacionTrabajo,
        "pO_Fecha_Reg": pOFechaReg,
        "pD_Tipo_Documento": pDTipoDocumento,
        "pD_Serie_Documento": pDSerieDocumento,
        "pD_Empresa": pDEmpresa,
        "pD_Estacion_Trabajo": pDEstacionTrabajo,
        "pD_Documento": pDDocumento,
        "pD_Fecha_Reg": pDFechaReg,
      };
}
