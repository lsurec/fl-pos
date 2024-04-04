import 'dart:convert';

class TareaCalendarioModel {
  String rUserName;
  int tarea;
  String descripcion;
  DateTime fechaIni;
  DateTime fechaFin;
  int referencia;
  String userName;
  String observacion1;
  String nomUser;
  String nomCuentaCorrentista;
  String desTipoTarea;
  int? cuentaCorrentista;
  dynamic cuentaCta;
  String contacto1;
  String direccionEmpresa;
  int weekNumber;
  dynamic cantidadContacto;
  dynamic nombreContacto;
  String descripcionTarea;
  String texto;
  String backColor;
  int estado;
  String desTarea;
  String? usuarioResponsable;
  int nivelPrioridad;
  String nomNivelPrioridad;

  TareaCalendarioModel({
    required this.rUserName,
    required this.tarea,
    required this.descripcion,
    required this.fechaIni,
    required this.fechaFin,
    required this.referencia,
    required this.userName,
    required this.observacion1,
    required this.nomUser,
    required this.nomCuentaCorrentista,
    required this.desTipoTarea,
    required this.cuentaCorrentista,
    required this.cuentaCta,
    required this.contacto1,
    required this.direccionEmpresa,
    required this.weekNumber,
    required this.cantidadContacto,
    required this.nombreContacto,
    required this.descripcionTarea,
    required this.texto,
    required this.backColor,
    required this.estado,
    required this.desTarea,
    required this.usuarioResponsable,
    required this.nivelPrioridad,
    required this.nomNivelPrioridad,
  });

  factory TareaCalendarioModel.fromJson(String str) =>
      TareaCalendarioModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TareaCalendarioModel.fromMap(Map<String, dynamic> json) =>
      TareaCalendarioModel(
        rUserName: json["r_UserName"],
        tarea: json["tarea"],
        descripcion: json["descripcion"],
        fechaIni: DateTime.parse(json["fecha_Ini"]),
        fechaFin: DateTime.parse(json["fecha_Fin"]),
        referencia: json["referencia"],
        userName: json["userName"],
        observacion1: json["observacion_1"],
        nomUser: json["nom_User"],
        nomCuentaCorrentista: json["nom_Cuenta_Correntista"],
        desTipoTarea: json["des_Tipo_Tarea"],
        cuentaCorrentista: json["cuenta_Correntista"],
        cuentaCta: json["cuenta_Cta"],
        contacto1: json["contacto_1"],
        direccionEmpresa: json["direccion_Empresa"],
        weekNumber: json["weekNumber"],
        cantidadContacto: json["cantidad_Contacto"],
        nombreContacto: json["nombre_Contacto"],
        descripcionTarea: json["descripcion_Tarea"],
        texto: json["texto"],
        backColor: json["backColor"],
        estado: json["estado"],
        desTarea: json["des_Tarea"],
        usuarioResponsable: json["usuario_Responsable"],
        nivelPrioridad: json["nivel_Prioridad"],
        nomNivelPrioridad: json["nom_Nivel_Prioridad"],
      );

  Map<String, dynamic> toMap() => {
        "r_UserName": rUserName,
        "tarea": tarea,
        "descripcion": descripcion,
        "fecha_Ini": fechaIni.toIso8601String(),
        "fecha_Fin": fechaFin.toIso8601String(),
        "referencia": referencia,
        "userName": userName,
        "observacion_1": observacion1,
        "nom_User": nomUser,
        "nom_Cuenta_Correntista": nomCuentaCorrentista,
        "des_Tipo_Tarea": desTipoTarea,
        "cuenta_Correntista": cuentaCorrentista,
        "cuenta_Cta": cuentaCta,
        "contacto_1": contacto1,
        "direccion_Empresa": direccionEmpresa,
        "weekNumber": weekNumber,
        "cantidad_Contacto": cantidadContacto,
        "nombre_Contacto": nombreContacto,
        "descripcion_Tarea": descripcionTarea,
        "texto": texto,
        "backColor": backColor,
        "estado": estado,
        "des_Tarea": desTarea,
        "usuario_Responsable": usuarioResponsable,
        "nivel_Prioridad": nivelPrioridad,
        "nom_Nivel_Prioridad": nomNivelPrioridad,
      };
}
