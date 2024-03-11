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
  int cuentaCorrentista;
  dynamic cuentaCta;
  dynamic cantidadContacto;
  dynamic nombreContacto;
  dynamic tipoDocumento;
  dynamic idDocumento;
  dynamic refSerie;
  dynamic fechaDocumento;
  dynamic elementoAsignado;
  dynamic actividadPaso;
  dynamic ejecutado;
  dynamic ejecutadoPor;
  dynamic ejecutadoFecha;
  dynamic ejecutadoFechaHora;
  dynamic producto;
  int estado;
  int empresa;
  int nivelPrioridad;
  dynamic tareaPadre;
  dynamic tiempoEstimadoTipoPeriocidad;
  dynamic tiempoEstimado;
  dynamic mUserName;
  dynamic observacion2;

  NuevaTareaModel({
    required this.tarea,
    required this.descripcion,
    required this.fechaIni,
    required this.fechaFin,
    required this.referencia,
    required this.userName,
    required this.observacion1,
    required this.tipoTarea,
    required this.cuentaCorrentista,
    required this.cuentaCta,
    required this.cantidadContacto,
    required this.nombreContacto,
    required this.tipoDocumento,
    required this.idDocumento,
    required this.refSerie,
    required this.fechaDocumento,
    required this.elementoAsignado,
    required this.actividadPaso,
    required this.ejecutado,
    required this.ejecutadoPor,
    required this.ejecutadoFecha,
    required this.ejecutadoFechaHora,
    required this.producto,
    required this.estado,
    required this.empresa,
    required this.nivelPrioridad,
    required this.tareaPadre,
    required this.tiempoEstimadoTipoPeriocidad,
    required this.tiempoEstimado,
    required this.mUserName,
    required this.observacion2,
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
        cuentaCorrentista: json["cuenta_Correntista"],
        cuentaCta: json["cuenta_Cta"],
        cantidadContacto: json["cantidad_Contacto"],
        nombreContacto: json["nombre_Contacto"],
        tipoDocumento: json["tipo_Documento"],
        idDocumento: json["id_Documento"],
        refSerie: json["ref_Serie"],
        fechaDocumento: json["fecha_Documento"],
        elementoAsignado: json["elemento_Asignado"],
        actividadPaso: json["actividad_Paso"],
        ejecutado: json["ejecutado"],
        ejecutadoPor: json["ejecutado_Por"],
        ejecutadoFecha: json["ejecutado_Fecha"],
        ejecutadoFechaHora: json["ejecutado_Fecha_Hora"],
        producto: json["producto"],
        estado: json["estado"],
        empresa: json["empresa"],
        nivelPrioridad: json["nivel_Prioridad"],
        tareaPadre: json["tarea_Padre"],
        tiempoEstimadoTipoPeriocidad: json["tiempo_Estimado_Tipo_Periocidad"],
        tiempoEstimado: json["tiempo_Estimado"],
        mUserName: json["m_UserName"],
        observacion2: json["observacion_2"],
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
        "cuenta_Correntista": cuentaCorrentista,
        "cuenta_Cta": cuentaCta,
        "cantidad_Contacto": cantidadContacto,
        "nombre_Contacto": nombreContacto,
        "tipo_Documento": tipoDocumento,
        "id_Documento": idDocumento,
        "ref_Serie": refSerie,
        "fecha_Documento": fechaDocumento,
        "elemento_Asignado": elementoAsignado,
        "actividad_Paso": actividadPaso,
        "ejecutado": ejecutado,
        "ejecutado_Por": ejecutadoPor,
        "ejecutado_Fecha": ejecutadoFecha,
        "ejecutado_Fecha_Hora": ejecutadoFechaHora,
        "producto": producto,
        "estado": estado,
        "empresa": empresa,
        "nivel_Prioridad": nivelPrioridad,
        "tarea_Padre": tareaPadre,
        "tiempo_Estimado_Tipo_Periocidad": tiempoEstimadoTipoPeriocidad,
        "tiempo_Estimado": tiempoEstimado,
        "m_UserName": mUserName,
        "observacion_2": observacion2,
      };
}
