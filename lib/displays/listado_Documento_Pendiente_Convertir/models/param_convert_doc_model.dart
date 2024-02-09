import 'dart:convert';

class ParamConvertDoc {
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

  ParamConvertDoc({
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
  });

  factory ParamConvertDoc.fromJson(String str) =>
      ParamConvertDoc.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ParamConvertDoc.fromMap(Map<String, dynamic> json) => ParamConvertDoc(
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
      };
}
