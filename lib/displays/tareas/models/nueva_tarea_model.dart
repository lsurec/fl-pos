import 'dart:convert';

class NuevaTareaModel {
  int tarea;
  String descripcion;
  DateTime fechaIni;
  DateTime fechaFin;
  int referencia;
  String userName;
  String observacion1;
  int tipoTarea;
  int estado;
  int empresa;
  int nivelPrioridad;
  dynamic tiempoEstimadoTipoPeriocidad;
  dynamic tiempoEstimado;

  NuevaTareaModel({
    required this.tarea,
    required this.descripcion,
    required this.fechaIni,
    required this.fechaFin,
    required this.referencia,
    required this.userName,
    required this.observacion1,
    required this.tipoTarea,
    required this.estado,
    required this.empresa,
    required this.nivelPrioridad,
    required this.tiempoEstimadoTipoPeriocidad,
    required this.tiempoEstimado,
  });

  factory NuevaTareaModel.fromJson(String str) =>
      NuevaTareaModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NuevaTareaModel.fromMap(Map<String, dynamic> json) => NuevaTareaModel(
        tarea: json["tarea"],
        descripcion: json["descripcion"],
        fechaIni: DateTime.parse(json["fecha_Ini"]),
        fechaFin: DateTime.parse(json["fecha_Fin"]),
        referencia: json["referencia"],
        userName: json["userName"],
        observacion1: json["observacion_1"],
        tipoTarea: json["tipo_Tarea"],
        estado: json["estado"],
        empresa: json["empresa"],
        nivelPrioridad: json["nivel_Prioridad"],
        tiempoEstimadoTipoPeriocidad: json["tiempo_Estimado_Tipo_Periocidad"],
        tiempoEstimado: json["tiempo_Estimado"],
      );

  Map<String, dynamic> toMap() => {
        "tarea": tarea,
        "descripcion": descripcion,
        "fecha_Ini": fechaIni.toIso8601String(),
        "fecha_Fin": fechaFin.toIso8601String(),
        "referencia": referencia,
        "userName": userName,
        "observacion_1": observacion1,
        "tipo_Tarea": tipoTarea,
        "estado": estado,
        "empresa": empresa,
        "nivel_Prioridad": nivelPrioridad,
        "tiempo_Estimado_Tipo_Periocidad": tiempoEstimadoTipoPeriocidad,
        "tiempo_Estimado": tiempoEstimado,
      };
}
