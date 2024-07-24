// ignore_for_file: use_build_context_synchronously, avoid_print
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_post_printer_example/displays/calendario/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/models/models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/services/services.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/utilities/utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CrearTareaViewModel extends ChangeNotifier {
  //Listas para almacenar la respuesta de los servicios
  final List<TipoTareaModel> tiposTarea = [];
  final List<EstadoModel> estados = [];
  final List<PrioridadModel> prioridades = [];
  final List<PeriodicidadModel> periodicidades = [];
  //almacenar archivos seleccionados
  List<File> files = [];

  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //Validador del formulario
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //Text controller de fechas, horas, tiempo, titulo, observacion.

  TextEditingController tituloController = TextEditingController();
  TextEditingController tiempoController = TextEditingController();
  TextEditingController observacionController = TextEditingController();

  DateTime fechaInicial = DateTime.now();
  DateTime fechaFinal = DateTime.now();

  TipoTareaModel? tipoTarea; //tipo tarea
  EstadoModel? estado; //estado tarea
  PrioridadModel? prioridad; //prioridad tarea
  IdReferenciaModel? idReferencia; //id referencia
  UsuarioModel? responsable; //responsable activo de la tarea
  PeriodicidadModel? periodicidad; //peroodicidad tarea
  int idPantalla = 1;

  //Guardar usuarios seleccionados para ser invitados de la tarea
  List<UsuarioModel> invitados = [];

  CrearTareaViewModel() {
    //inicializar tiempo con 10 minutos
    tiempoController.text = "10";
  }

  //Volver a cargar tados
  loadData(BuildContext context) async {
    final bool succesEstados = await obtenerEstados(
      context,
    ); //obtener estados de tarea

    if (!succesEstados) {
      isLoading = false;
      return;
    }

    final bool succesPrioridades = await obtenerPrioridades(
      context,
    ); //obtener prioridades de la tarea

    if (!succesPrioridades) {
      isLoading = false;
      return;
    }

    final bool succesPeriodicidades = await obtenerPeriodicidad(
      context,
    ); //obtener periodicidades

    if (!succesPeriodicidades) {
      isLoading = false;
      return;
    }

    final bool succesTipos = await obtenerTiposTarea(
      context,
    ); //obtener tipos de tarea

    if (!succesTipos) {
      isLoading = false;
      return;
    }

    //Fechas y horas
    fechaInicial = DateTime.now();
    fechaFinal = addDate10Min(fechaInicial);

    //Tiempo estimado
    tiempoController.text = tiempoNum(fechaInicial, fechaFinal).toString();
    periodicidad = periodicidades[tiempoTipo(fechaInicial, fechaFinal)];
  }

  //Navegar a view para buscar Id de referencia.
  irIdReferencia(BuildContext context) {
    final vmRef = Provider.of<IdReferenciaViewModel>(context, listen: false);

    vmRef.idReferencias.clear();
    vmRef.buscarIdReferencia.text = "";

    Navigator.pushNamed(context, AppRoutes.selectReferenceId);
  }

  //Navegar a view para buscar usuarios
  irUsuarios(BuildContext context, int tipo, String titulo) {
    final vmUsuario = Provider.of<UsuariosViewModel>(context, listen: false);
    invitados = [];
    vmUsuario.tipoBusqueda = tipo;
    vmUsuario.usuarios = [];
    vmUsuario.buscar.text = '';

    Navigator.pushNamed(
      context,
      AppRoutes.selectResponsibleUser,
      arguments: titulo,
    );
  }

  //Recibe una fecha y le asigna 10 minutos más.
  DateTime addDate10Min(DateTime fecha) =>
      fecha.add(const Duration(minutes: 10));

  //Validar formulario
  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  //Limpiar formulario
  limpiar() {
    tituloController.text = "";
    observacionController.text = "";
    tiempoController.text = "10";
    responsable = null;
    idReferencia = null;
    invitados.clear();
    files.clear();
    notifyListeners();

    //Fechas y horas
    fechaInicial = DateTime.now();
    fechaFinal = addDate10Min(fechaInicial);
    notifyListeners();
  }

  //Crear tarea
  Future<void> crearTarea(BuildContext context) async {
    //Validar el formulario
    if (!isValidForm()) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'completarFormulario',
        ),
      );
      return;
    }

    //sino ha seleccionado la referencia
    if (idReferencia == null) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'seleccioneIdRef',
        ),
      );
      return;
    }

    //sino hay resoinsable
    if (responsable == null) {
      NotificationService.showSnackbar(AppLocalizations.of(context)!.translate(
        BlockTranslate.notificacion,
        'seleccioneRespo',
      ));
      return;
    }

    //View model para obtener el usuario y token
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.user;

    //View model para obtenerla empresa
    final vmLocal = Provider.of<LocalSettingsViewModel>(context, listen: false);
    EmpresaModel empresa = vmLocal.selectedEmpresa!;

    //view model de Tareas para insertar la nueva tarea en la lista de tareas
    final vmTarea = Provider.of<TareasViewModel>(context, listen: false);

    //view model del calendario
    final vmCalendario = Provider.of<CalendarioViewModel>(
      context,
      listen: false,
    );

    //Instancia del servicio
    final TareaService tareaService = TareaService();

    //Crear modelo de la nueva tarea
    NuevaTareaModel tarea = NuevaTareaModel(
      tarea: 0,
      descripcion: tituloController.text,
      fechaIni: fechaInicial,
      fechaFin: fechaFinal,
      referencia: idReferencia!.referencia,
      userName: user,
      observacion1: observacionController.text,
      tipoTarea: tipoTarea!.tipoTarea,
      estado: estado!.estado,
      empresa: empresa.empresa,
      nivelPrioridad: prioridad!.nivelPrioridad,
      tiempoEstimadoTipoPeriocidad: periodicidad!.tipoPeriodicidad,
      tiempoEstimado: tiempoController.text,
    );

    isLoading = true; //cargar pantalla

    //Realizar consumo de api para crear tareas
    final ApiResModel res = await tareaService.postTarea(token, tarea);

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

      NotificationService.showErrorView(context, res);

      return;
    }

    //Obtener respuesta correcta del api
    NuevaTareaModel creada = res.response[0];

    //Si se está creando desde busqueda de tareas

    if (idPantalla == 1 && res.succes) {
      //objeto de la vista de tareas
      vmTarea.loadData(context);
      //mostrra mensaje
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'tareaCreada',
        ),
      );
    }

    DateTime hoyFecha = DateTime.now();

    //Si se está creando desde el calendario
    if (idPantalla == 2 && res.succes) {
      //objeto de la vista calendario
      vmCalendario.obtenerTareasRango(
        context,
        hoyFecha.month,
        hoyFecha.year,
      );
      //mostrra mensaje
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'tareaCreada',
        ),
      );
    }
    //Crear modelo de Tarea para agregarla a la lista de tareas
    TareaModel resCreada = TareaModel(
      tarea: tarea,
      iDTarea: creada.tarea,
      usuarioCreador: user,
      emailCreador: "",
      usuarioResponsable: null,
      descripcion: tituloController.text,
      fechaInicial: fechaInicial,
      fechaFinal: fechaFinal,
      referencia: idReferencia!.referencia,
      iDReferencia: idReferencia!.referenciaId,
      descripcionReferencia: idReferencia!.descripcion,
      ultimoComentario: "",
      fechaUltimoComentario: null,
      usuarioUltimoComentario: null,
      tareaObservacion1: observacionController.text,
      tareaFechaIni: fechaInicial,
      tareaFechaFin: fechaFinal,
      tipoTarea: tipoTarea!.tipoTarea,
      descripcionTipoTarea: tipoTarea!.descripcion,
      estadoObjeto: estado!.estado,
      tareaEstado: estado!.descripcion,
      usuarioTarea: user,
      backColor: "#F4FA58",
      nivelPrioridad: prioridad!.nivelPrioridad,
      nomNivelPrioridad: prioridad!.nombre,
    );

    //Usuario responsable de la tarea
    //Crear modelo de usuario nuevo
    NuevoUsuarioModel usuarioResponsable = NuevoUsuarioModel(
      tarea: creada.tarea,
      userResInvi: responsable!.userName,
      user: user,
    );

    isLoading = true; //cargar pantalla

    //consumo de api para asignar responsable
    final ApiResModel resResponsable = await tareaService.postResponsable(
      token,
      usuarioResponsable,
    );

    //si el consumo salió mal
    if (!resResponsable.succes) {
      isLoading = false;

      //Abrir dialogo de error
      NotificationService.showErrorView(context, resResponsable);

      //Retornar respuesta incorrecta
      return;
    }

    //Obtener respuesta de api responsable
    ResNuevoUsuarioModel seleccionado = resResponsable.response[0];

    //Asignar responsable a la propiedad de la tarea
    resCreada.usuarioResponsable = seleccionado.userName;

    notifyListeners();

    //si hay invitados seleccionados
    if (invitados.isNotEmpty) {
      for (var usuario in invitados) {
        //usuario nuevo
        NuevoUsuarioModel usuarioInvitado = NuevoUsuarioModel(
          tarea: creada.tarea,
          userResInvi: usuario.userName,
          user: user,
        );

        isLoading = true; //cargar pantalla

        //consumo de api
        final ApiResModel resInvitado = await tareaService.postInvitados(
          token,
          usuarioInvitado,
        );

        //si el consumo salió mal
        if (!resInvitado.succes) {
          isLoading = false;

          //Abrir dialogo de error
          NotificationService.showErrorView(context, resInvitado);

          //Retornar respusta incorrecta
          return;
        }
      }
    }

    //Si hay archivos seleccionados
    if (files.isNotEmpty) {
      ComentarService comentarService = ComentarService();

      //Crear modelo de nuevo comentario
      ComentarModel comentario = ComentarModel(
        comentario: observacionController.text,
        tarea: resCreada.iDTarea,
        userName: user,
      );

      //consumo de api
      ApiResModel resComent = await comentarService.postComentar(
        token,
        comentario,
      );

      //si el consumo salió mal
      if (!resComent.succes) {
        isLoading = false;

        NotificationService.showErrorView(context, resComent);

        //Respuesta incorrecta
        return;
      }

      FilesService filesService = FilesService();
      int idComentario = resComent.response.res;

      bool resFiles = await filesService.posFilesComent(
        token,
        user,
        files,
        resCreada.iDTarea,
        idComentario,
        empresa.absolutePathPicture,
      );

      //si el consumo salió mal
      if (!resFiles) {
        isLoading = false;

        ApiResModel error = ApiResModel(
          succes: false,
          response:
              "No se pudieron subir los archivos. Verifique que la ruta de guardado esté disponible.",
          url: "",
          storeProcedure: null,
        );

        NotificationService.showErrorView(context, error);

        //Respuesta incorrecta
        return;
      }

      files.clear(); //limpiar lista de archivos
      notifyListeners();
      isLoading = false;
    }

    // //mostrra mensaje
    // NotificationService.showSnackbar(
    //   "Tarea creada correctamente.",
    // );

    isLoading = false; //detener carga

    return;
  }

  //Abrir picker de fecha inicial
  Future<void> abrirFechaInicial(BuildContext context) async {
    //abrir picker de la fecha inicial con la fecha actual
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: fechaInicial,
      firstDate: fechaInicial,
      lastDate: DateTime(2100),
      confirmText: AppLocalizations.of(context)!.translate(
        BlockTranslate.botones,
        'aceptar',
      ),
    );

    //si la fecha es null, no realiza nada
    if (pickedDate == null) return;

    //armar fecha con la fecha seleccionada en el picker
    fechaInicial = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      fechaInicial.hour,
      fechaInicial.minute,
    );

    //si la fecha inicial es despues de la final
    if (fechaInicial.isAfter(fechaFinal)) {
      //fecha final será igual a la fecha inicial + 10 minutos
      fechaFinal = addDate10Min(fechaInicial);
    }

    notifyListeners();

    tiempoController.text = tiempoNum(fechaInicial, fechaFinal).toString();
    periodicidad = periodicidades[tiempoTipo(fechaInicial, fechaFinal)];
  }

  //para la final
  Future<void> abrirFechaFinal(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: fechaFinal,
      //fecha minima es la inicial
      firstDate: fechaInicial,
      lastDate: DateTime(2100),
      confirmText: AppLocalizations.of(context)!.translate(
        BlockTranslate.botones,
        'aceptar',
      ),
    );

    //si la fecha es null, no realiza nada
    if (pickedDate == null) return;

    //armar fecha final con la fecha seleccionada en el picker
    fechaFinal = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      fechaFinal.hour,
      fechaFinal.minute,
    );

    notifyListeners();
    tiempoController.text = tiempoNum(fechaInicial, fechaFinal).toString();
    periodicidad = periodicidades[tiempoTipo(fechaInicial, fechaFinal)];
  }

  //Abrir y seleccionar hora inicial
  Future<void> abrirHoraInicial(BuildContext context) async {
    DateTime fechaHoraActual = DateTime.now();

    //inicializar picker de la hora con la hora recibida
    TimeOfDay? initialTime = TimeOfDay(
      hour: fechaInicial.hour,
      minute: fechaInicial.minute,
    );

    //abre el time picker con la hora inicial
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime, //hora inicial
      builder: (BuildContext context, Widget? child) {
        return Localizations.override(
          context: context,
          locale: const Locale('en', 'ES'),
          child: child,
        );
      },
    );

    //Estando en la vista del calendario cuando ingrese al formulario desde cualquier hora
    //Esa hora será la hora minima solo cuando esté en el calendario
    if (pickedTime != null) {
      if (idPantalla == 2 && pickedTime.hour < initialTime.hour) {
        // Muestra un mensaje de error o realiza alguna acción para indicar que la hora seleccionada es inválida
        NotificationService.showSnackbar(
          "${AppLocalizations.of(context)!.translate(
            BlockTranslate.notificacion,
            'horaPosterior',
          )} ${Utilities.formatearHora(fechaInicial)}",
        );

        fechaInicial = DateTime(
          fechaInicial.year,
          fechaInicial.month,
          fechaInicial.day,
          initialTime.hour,
          initialTime.minute,
        );

        notifyListeners();
        return;
      }
    }
    //si la fecha inicial es mayor a la fecha actual.
    if (compararFechas(fechaInicial, fechaHoraActual)) {
      initialTime = const TimeOfDay(hour: 0, minute: 0);

      //si la hora seleccionada es null, no hacer nada.
      if (pickedTime == null) return;
      //armar fecha inicial con la fecha inicial y hora seleccionada en los picker
      fechaInicial = DateTime(
        fechaInicial.year,
        fechaInicial.month,
        fechaInicial.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      //si la fecha inicial es despues de la final
      if (fechaInicial.isAfter(fechaFinal)) {
        //fecha final será igual a la fecha inicial + 10 minutos
        fechaFinal = addDate10Min(fechaInicial);
      }

      notifyListeners();
      return;
    }

    if (pickedTime != null) {
      if (pickedTime.hour < fechaHoraActual.hour ||
          (pickedTime.hour == fechaHoraActual.hour &&
              pickedTime.minute < fechaHoraActual.minute)) {
        // Muestra un mensaje de error o realiza alguna acción para indicar que la hora seleccionada es inválida
        NotificationService.showSnackbar(
          "${AppLocalizations.of(context)!.translate(
            BlockTranslate.notificacion,
            'horaPosterior',
          )} ${Utilities.formatearHora(fechaHoraActual)}",
        );

        fechaInicial = DateTime(
          fechaInicial.year,
          fechaInicial.month,
          fechaInicial.day,
          fechaHoraActual.hour,
          fechaHoraActual.minute,
        );

        notifyListeners();
        return;
      }
    }
    //si la hora seleccionada es null, no hacer nada.
    if (pickedTime == null) return;

    //armar fecha inicial con la fecha inicial y hora seleccionada en los picker
    fechaInicial = DateTime(
      fechaInicial.year,
      fechaInicial.month,
      fechaInicial.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    //si la fecha inicial es despues de la final
    if (fechaInicial.isAfter(fechaFinal)) {
      //fecha final será igual a la fecha inicial + 10 minutos
      fechaFinal = addDate10Min(fechaInicial);
    }

    notifyListeners();
    tiempoController.text = tiempoNum(fechaInicial, fechaFinal).toString();
    periodicidad = periodicidades[tiempoTipo(fechaInicial, fechaFinal)];
  }

  bool compararFechas(
    DateTime fechaInicial,
    DateTime fechaFinal,
  ) {
    return fechaInicial.isAfter(fechaFinal);
  }

  //Abrir picker de la fecha final
  Future<void> abrirHoraFinal(BuildContext context) async {
    TimeOfDay? initialTime = TimeOfDay(
      hour: fechaFinal.hour,
      minute: fechaFinal.minute,
    );

    //abre el time picker con la hora creada con la fecha final
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime, //hora inicial
      builder: (BuildContext context, Widget? child) {
        return Localizations.override(
          context: context,
          locale: const Locale('en', 'ES'),
          child: child,
        );
      },
    );

    //si la hora es null no hace nada
    if (pickedTime == null) return;

    //armar fecha final temporal con la fecha final y hora seleccionada en el picker
    final DateTime fechaTemp = DateTime(
      fechaFinal.year,
      fechaFinal.month,
      fechaFinal.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    // Verifica si las fechas son iguales (mismo día, mes y año).
    if (compararFechas(fechaInicial, fechaTemp)) {
      //verificar si la fecha temporal es menor a la incial
      if (fechaTemp.isBefore(fechaInicial)) {
        //mostrar mensaje de la hora de la fecha final no es valida
        NotificationService.showSnackbar(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.notificacion,
            'modifiqueFeHofinal',
          ),
        );
        return;
      }
    }

    //armar fecha inicial con la fecha inicial y hora seleccionada en los picker
    fechaFinal = DateTime(
      fechaFinal.year,
      fechaFinal.month,
      fechaFinal.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    notifyListeners();
    tiempoController.text = tiempoNum(fechaInicial, fechaFinal).toString();
    periodicidad = periodicidades[tiempoTipo(fechaInicial, fechaFinal)];
  }

  //Obtener Tipos
  Future<bool> obtenerTiposTarea(
    BuildContext context,
  ) async {
    tiposTarea.clear(); //Limpiar lista de tipos de tarea
    tipoTarea = null; //tipo de tarea = null

    //View model de login para obtener usuario y token
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.user;

    //Instancia del servico
    final TareaService tareaService = TareaService();

    isLoading = true; //cargar pantalla

    //Consumo de api
    final ApiResModel res = await tareaService.getTipoTarea(user, token);

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

      NotificationService.showErrorView(context, res);

      //retornar false si algo salio mal
      return false;
    }

    //Agregar respuesta de api a la lista de tipos de tarea
    tiposTarea.addAll(res.response);

    //Recorrer la lista y asignar a la variable tipoTarea: "Tarea"
    for (var i = 0; i < tiposTarea.length; i++) {
      TipoTareaModel tipo = tiposTarea[i];
      if (tipo.descripcion.toLowerCase() == "tarea") {
        tipoTarea = tipo;
        break;
      }
    }

    isLoading = false; //detener carga

    //retorar true si todo está correcto
    return true;
  }

  //Obtener Estados
  Future<bool> obtenerEstados(
    BuildContext context,
  ) async {
    estados.clear(); //limpiar lista de estados
    estado = null; //estado = null

    //View model de login para obtener token
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;

    //Instancia del servicio
    final TareaService tareaService = TareaService();

    isLoading = true; //cargar pantalla

    //Consumo de api
    final ApiResModel res = await tareaService.getEstado(token);

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;
      NotificationService.showErrorView(context, res);
      return false;
    }

    //Agregar respuesta de api a la lista de estados de tarea
    estados.addAll(res.response);

    //Recorrer la lista y asignar a la variable estado; "Activo"
    for (var i = 0; i < estados.length; i++) {
      EstadoModel e = estados[i];
      if (e.descripcion.toLowerCase() == "activo") {
        estado = e;
        break;
      }
    }

    isLoading = false; //detener carga

    //retornar true si todo está correcto
    return true;
  }

  //Obtener Prioridades
  Future<bool> obtenerPrioridades(
    BuildContext context,
  ) async {
    prioridades.clear(); //limpiar lista de prioridades
    prioridad = null; //prioridad = null

    //View model de login para obtener token
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.user;

    //Instancia del servicio
    final TareaService tareaService = TareaService();

    isLoading = true; //cargar pantalla

    //Consumo de api
    final ApiResModel res = await tareaService.getPrioridad(user, token);

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

      NotificationService.showErrorView(context, res);

      //retornar false si algo salio mal
      return false;
    }

    //Agregar respuesta de api a la lista de prioridades de tarea
    prioridades.addAll(res.response);

    //Recorrer la lista y asignar a la variable prioridad: "Normal"
    for (var i = 0; i < prioridades.length; i++) {
      PrioridadModel resPrioridad = prioridades[i];
      if (resPrioridad.nombre.toLowerCase() == "normal") {
        prioridad = resPrioridad;
        break;
      }
    }

    isLoading = false; //detener carga

    //Retornar true si todo está correcto
    return true;
  }

  //Obtener Periodicidades
  Future<bool> obtenerPeriodicidad(
    BuildContext context,
  ) async {
    periodicidades.clear(); //limpiar lista de periodicidades
    periodicidad = null; //periodicidad = null

    //View model de login para obtener token
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.user;
    //Instancia del servicio
    final TareaService tareaService = TareaService();

    isLoading = true; //cargar pantalla

    //Consumo de api
    final ApiResModel res = await tareaService.getPeriodicidad(user, token);

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;
      NotificationService.showErrorView(context, res);

      //si algo salió mal retornar false
      return false;
    }

    //Agregar a la lista de periodicidades la respuesta del api
    periodicidades.addAll(res.response);

    //Recorrer la lista de periodicidades y asignar a la variable periodicidad : "Minutos"
    for (var i = 0; i < periodicidades.length; i++) {
      PeriodicidadModel resPeriodicidad = periodicidades[i];
      if (resPeriodicidad.descripcion.toLowerCase() == "minutos") {
        periodicidad = resPeriodicidad;
        break;
      }
    }

    isLoading = false; //detener carga

    //Si todo está correcto retornar true
    return true;
  }

  //Seleccionar el ID regerencia
  seleccionarIdRef(
    BuildContext context,
    IdReferenciaModel idRefe,
  ) {
    idReferencia = idRefe;

    notifyListeners();

    if (idReferencia != null) {
      Navigator.pop(context);
    }
  }

  //Seleccionar responsable
  seleccionarResponsable(
    BuildContext context,
    UsuarioModel respon,
  ) {
    final vmUsuarios = Provider.of<UsuariosViewModel>(context, listen: false);
    final vmDetalle = Provider.of<DetalleTareaViewModel>(
      context,
      listen: false,
    );

    final vmDetalleCalendario = Provider.of<DetalleTareaCalendarioViewModel>(
      context,
      listen: false,
    );

    //Para actualizar usuarios
    if (vmUsuarios.tipoBusqueda == 3) {
      vmDetalle.cambiarResponsable(context, respon);
    }

    //5= detalles de la tarea del calendario
    if (vmUsuarios.tipoBusqueda == 5) {
      vmDetalleCalendario.cambiarResponsable(context, respon);
    }

    responsable = respon;
    notifyListeners();

    if (responsable != null) {
      Navigator.pop(context);
    }
  }

  //Guardar usuario
  guardarUsuarios(
    BuildContext context,
  ) {
    //View model de usuarios
    final vmUsuarios = Provider.of<UsuariosViewModel>(context, listen: false);
    //View model de detalle tarea
    final vmDetalle =
        Provider.of<DetalleTareaViewModel>(context, listen: false);

    //Limpiar lista de usuarios seleccionados
    vmUsuarios.usuariosSeleccionados.clear();

    //Recorrer lista de usuarios que estén seleccionados y agregarlos a la lista de usuarios seleccionados
    for (var usuario in vmUsuarios.usuarios) {
      if (usuario.select) {
        vmUsuarios.usuariosSeleccionados.add(usuario);
      }
    }

    notifyListeners();

    //Si hay usuarios seleccionados agrefarlos a la lista de invitados
    if (vmUsuarios.usuariosSeleccionados.isNotEmpty) {
      invitados.addAll(vmUsuarios.usuariosSeleccionados);
      Navigator.pop(context);
    }

    //si es tipo de busqueda es = 4 fuardar invitados desde detalle de tarea
    if (vmUsuarios.tipoBusqueda == 4) vmDetalle.guardarInvitados(context);
  }

  //Eliminar invitado de la lista de usuarios seleccionados para invitados
  void eliminarInvitado(int index) {
    invitados[index].select = false;
    invitados.removeAt(index);
    notifyListeners();
  }

  //Eliminar responsable selecionado para ser invitado de la tarea
  void eliminarResponsable() {
    responsable = null;
    notifyListeners();
  }

  //Eliminar archivos de la lista de inivtados
  void eliminarArchivos(int index) {
    files.removeAt(index);
    notifyListeners();
  }

  //seleccionar archivos para adjuntalos a la tarea
  Future<void> selectFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();
    }

    notifyListeners();
  }

  int tiempoNum(DateTime fechaIni, DateTime fechaFin) {
    int diffInMillis =
        fechaFin.millisecondsSinceEpoch - fechaIni.millisecondsSinceEpoch;
    double diffInSeconds = diffInMillis / 1000;
    double diffInMinutes = diffInSeconds / 60;
    double diffInHours = diffInMinutes / 60;
    double diffInDays = diffInHours / 24;
    double diffInWeeks = diffInDays / 7;
    int diffInMonths = fechaFin.month -
        fechaIni.month +
        (12 * (fechaFin.year - fechaIni.year));
    int diffInYears = fechaFin.year - fechaIni.year;

    if (diffInMinutes < 60) {
      return diffInMinutes.floor(); // diferencia en minutos
    } else if (diffInHours < 24) {
      return diffInHours.floor(); // diferencia en horas
    } else if (diffInDays < 7) {
      return diffInDays.floor(); // diferencia en días
    } else if (diffInWeeks < 4) {
      return diffInWeeks.floor(); // diferencia en semanas
    } else if (diffInMonths < 12) {
      return diffInMonths; // diferencia en meses
    } else {
      return diffInYears; // diferencia en años
    }
  }

  int tiempoTipo(DateTime fechaIni, DateTime fechaFin) {
    int diffInMillis =
        fechaFin.millisecondsSinceEpoch - fechaIni.millisecondsSinceEpoch;
    double diffInSeconds = diffInMillis / 1000;
    double diffInMinutes = diffInSeconds / 60;
    double diffInHours = diffInMinutes / 60;
    double diffInDays = diffInHours / 24;
    double diffInWeeks = diffInDays / 7;
    int diffInMonths = fechaFin.month -
        fechaIni.month +
        (12 * (fechaFin.year - fechaIni.year));
    // int diffInYears = fechaFin.year - fechaIni.year;

    if (periodicidades.isNotEmpty) {
      if (diffInMinutes < 60) {
        for (int i = 0; i < periodicidades.length; i++) {
          if (periodicidades[i].descripcion.toLowerCase() == "minutos") {
            return i;
          }
        }
      } else if (diffInHours < 24) {
        for (int i = 0; i < periodicidades.length; i++) {
          if (periodicidades[i].descripcion.toLowerCase() == "horas") {
            return i;
          }
        }
      } else if (diffInDays < 7) {
        for (int i = 0; i < periodicidades.length; i++) {
          if (periodicidades[i].descripcion.toLowerCase() == "dias") {
            return i;
          }
        }
      } else if (diffInWeeks < 4) {
        for (int i = 0; i < periodicidades.length; i++) {
          if (periodicidades[i].descripcion.toLowerCase() == "semanas") {
            return i;
          }
        }
      } else if (diffInMonths < 12) {
        for (int i = 0; i < periodicidades.length; i++) {
          if (periodicidades[i].descripcion.toLowerCase() == "mes") {
            return i;
          }
        }
      } else {
        for (int i = 0; i < periodicidades.length; i++) {
          if (periodicidades[i].descripcion.toLowerCase() == "año") {
            return i;
          }
        }
      }
    }
    return 0;
  }

  eliminarRef() {
    idReferencia = null;
    notifyListeners();
    print("eliminamos la refeencia");
  }
}
