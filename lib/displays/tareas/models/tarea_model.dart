import 'dart:convert';

class TareaModel {
  dynamic tarea;
  int iDTarea;
  String? usuarioCreador;
  String? emailCreador;
  String? usuarioResponsable;
  String? descripcion;
  DateTime fechaInicial;
  DateTime fechaFinal;
  int referencia;
  String? iDReferencia;
  String? descripcionReferencia;
  String? ultimoComentario;
  DateTime? fechaUltimoComentario;
  String? usuarioUltimoComentario;
  String? tareaObservacion1;
  DateTime tareaFechaIni;
  DateTime tareaFechaFin;
  int tipoTarea;
  String? descripcionTipoTarea;
  int estadoObjeto;
  String? tareaEstado;
  String? usuarioTarea;
  String? backColor;
  int nivelPrioridad;
  String? nomNivelPrioridad;

  TareaModel({
    required this.tarea,
    required this.iDTarea,
    required this.usuarioCreador,
    required this.emailCreador,
    required this.usuarioResponsable,
    required this.descripcion,
    required this.fechaInicial,
    required this.fechaFinal,
    required this.referencia,
    required this.iDReferencia,
    required this.descripcionReferencia,
    required this.ultimoComentario,
    required this.fechaUltimoComentario,
    required this.usuarioUltimoComentario,
    required this.tareaObservacion1,
    required this.tareaFechaIni,
    required this.tareaFechaFin,
    required this.tipoTarea,
    required this.descripcionTipoTarea,
    required this.estadoObjeto,
    required this.tareaEstado,
    required this.usuarioTarea,
    required this.backColor,
    required this.nivelPrioridad,
    required this.nomNivelPrioridad,
  });

  factory TareaModel.fromJson(String str) =>
      TareaModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TareaModel.fromMap(Map<String, dynamic> json) => TareaModel(
        tarea: json["tarea"],
        iDTarea: json["iD_Tarea"],
        usuarioCreador: json["usuario_Creador"],
        emailCreador: json["email_Creador"],
        usuarioResponsable: json["usuario_Responsable"],
        descripcion: json["descripcion"],
        fechaInicial: DateTime.parse(json["fecha_Inicial"]),
        fechaFinal: DateTime.parse(json["fecha_Final"]),
        referencia: json["referencia"],
        iDReferencia: json["iD_Referencia"],
        descripcionReferencia: json["descripcion_Referencia"],
        ultimoComentario: json["ultimo_Comentario"],
        fechaUltimoComentario: json["fecha_Ultimo_Comentario"] == null
            ? null
            : DateTime.parse(json["fecha_Ultimo_Comentario"]),
        usuarioUltimoComentario: json["usuario_Ultimo_Comentario"],
        tareaObservacion1: json["tarea_Observacion_1"],
        tareaFechaIni: DateTime.parse(json["tarea_Fecha_Ini"]),
        tareaFechaFin: DateTime.parse(json["tarea_Fecha_Fin"]),
        tipoTarea: json["tipo_Tarea"],
        descripcionTipoTarea: json["descripcion_Tipo_Tarea"],
        estadoObjeto: json["estado_Objeto"],
        tareaEstado: json["tarea_Estado"],
        usuarioTarea: json["usuario_Tarea"],
        backColor: json["backColor"],
        nivelPrioridad: json["nivel_Prioridad"],
        nomNivelPrioridad: json["nom_Nivel_Prioridad"],
      );

  Map<String, dynamic> toMap() => {
        "tarea": tarea,
        "iD_Tarea": iDTarea,
        "usuario_Creador": usuarioCreador,
        "email_Creador": emailCreador,
        "usuario_Responsable": usuarioResponsable,
        "descripcion": descripcion,
        "fecha_Inicial": fechaInicial.toIso8601String(),
        "fecha_Final": fechaFinal.toIso8601String(),
        "referencia": referencia,
        "iD_Referencia": iDReferencia,
        "descripcion_Referencia": descripcionReferencia,
        "ultimo_Comentario": ultimoComentario,
        "fecha_Ultimo_Comentario": fechaUltimoComentario?.toIso8601String(),
        "usuario_Ultimo_Comentario": usuarioUltimoComentario,
        "tarea_Observacion_1": tareaObservacion1,
        "tarea_Fecha_Ini": tareaFechaIni.toIso8601String(),
        "tarea_Fecha_Fin": tareaFechaFin.toIso8601String(),
        "tipo_Tarea": tipoTarea,
        "descripcion_Tipo_Tarea": descripcionTipoTarea,
        "estado_Objeto": estadoObjeto,
        "tarea_Estado": tareaEstado,
        "usuario_Tarea": usuarioTarea,
        "backColor": backColor,
        "nivel_Prioridad": nivelPrioridad,
        "nom_Nivel_Prioridad": nomNivelPrioridad,
      };
}
