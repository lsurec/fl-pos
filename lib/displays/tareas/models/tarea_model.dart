class TareaModel {
  dynamic tarea;
  int iDTarea;
  String usuarioCreador;
  String? emailCreador;
  String usuarioResponsable;
  String descripcion;
  DateTime? fechaInicial;
  DateTime? fechaFinal;
  int referencia;
  String? iDReferencia;
  String? descripcionReferencia;
  String? ultimoComentario;
  DateTime? fechaUltimoComentario;
  String? usuarioUltimoComentario;
  String tareaObservacion1;
  DateTime tareaFechaIni;
  DateTime? tareaFechaFin;
  int? tipoTarea;
  String? descripcionTipoTarea;
  int? estadoObjeto;
  String tareaEstado;
  String? usuarioTarea;
  String? backColor;
  int? nivelPrioridad;
  String? nomNivelPrioridad;

  TareaModel({
    required this.iDTarea,
    required this.usuarioCreador,
    required this.usuarioResponsable,
    required this.descripcion,
    required this.referencia,
    required this.tareaObservacion1,
    required this.tareaFechaIni,
    required this.tareaEstado,
  });
}

class FiltroModel {
  int id;
  String filtro;

  FiltroModel({required this.id, required this.filtro});
}
