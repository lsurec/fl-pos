// ignore_for_file: use_build_context_synchronously, avoid_print
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/services/services.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CrearTareaViewModel extends ChangeNotifier {
  //Listas para almacenar la respuesta de los servicios
  final List<TipoTareaModel> tiposTarea = [];
  final List<EstadoModel> estados = [];
  final List<PrioridadModel> prioridades = [];
  final List<PeriodicidadModel> periodicidades = [];

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

  //Guardar usuarios seleccionados para ser invitados de la tarea
  List<UsuarioModel> invitados = [];

  CrearTareaViewModel() {
    //inicializar tiempo con 10 minutos
    tiempoController.text = "10";
  }

  //Volver a cargar tados
  loadData(BuildContext context) async {
    await obtenerTiposTarea(context);
    await obtenerEstados(context);
    await obtenerPeriodicidad(context);
    await obtenerPrioridades(context);

    //Fechas y horas
    fechaInicial = DateTime.now();
    fechaFinal = addDate10Min(fechaInicial);
  }

  //Navegar a view para buscar Id de referencia.
  irIdReferencia(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.selectReferenceId);
  }

  //Navegar a view para buscar usuarios
  irUsuarios(BuildContext context, int tipo) {
    final vmUsuario = Provider.of<UsuariosViewModel>(context, listen: false);
    invitados = [];
    vmUsuario.tipoBusqueda = tipo;
    Navigator.pushNamed(context, AppRoutes.selectResponsibleUser);
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
          "Complete todos loa campos obligarorios para continuar");
      return;
    }

    //sino ha seleccionado la referencia
    if (idReferencia == null) {
      NotificationService.showSnackbar("Añada Id Referencia para continuar.");
      return;
    }

    //sino hay resoinsable
    if (responsable == null) {
      NotificationService.showSnackbar("Añada un responsable para continuar.");
      return;
    }

    //View model para obtener el usuario y token
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.user;

    //View model para obtenerla empresa
    final vmLocal = Provider.of<LocalSettingsViewModel>(context, listen: false);
    int empresa = vmLocal.selectedEmpresa!.empresa;

    //view model de Tareas para insertar la nueva tarea en la lista de tareas
    final vmTarea = Provider.of<TareasViewModel>(context, listen: false);

    //Instancia del servicio
    final TareaService tareaService = TareaService();

    //Crear modelo de la nueva tarea
    NuevaTareaModel tarea = NuevaTareaModel(
      tarea: 0,
      descripcion: tituloController.text,
      // fechaIni: construirFechaCompleta(nuevaFechaInicial!, _horaInicial!),
      fechaIni: fechaInicial,
      // fechaFin: construirFechaCompleta(nuevaFechaFinal!, _horaFinal!),
      fechaFin: fechaFinal,
      referencia: idReferencia!.referencia,
      userName: user,
      observacion1: observacionController.text,
      tipoTarea: tipoTarea!.tipoTarea,
      cuentaCorrentista: 1110,
      cuentaCta: null,
      cantidadContacto: null,
      nombreContacto: null,
      tipoDocumento: null,
      idDocumento: null,
      refSerie: null,
      fechaDocumento: null,
      elementoAsignado: null,
      actividadPaso: null,
      ejecutado: null,
      ejecutadoPor: null,
      ejecutadoFecha: null,
      ejecutadoFechaHora: null,
      producto: null,
      estado: estado!.estado,
      empresa: empresa,
      nivelPrioridad: prioridad!.nivelPrioridad,
      tareaPadre: null,
      tiempoEstimadoTipoPeriocidad: periodicidad!.tipoPeriodicidad,
      tiempoEstimado: tiempoController.text,
      mUserName: null,
      observacion2: null,
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
    NuevaTareaModel creada = res.message[0];

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
      backColor: "#000",
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
    ResNuevoUsuarioModel seleccionado = resResponsable.message[0];

    //Asignar responsable a la propiedad de la tarea
    resCreada.usuarioResponsable =
        responsable != null ? responsable!.name : seleccionado.userName;

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

        print(usuarioInvitado.userResInvi);

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

    //insertar tarea al inicio de la lista de tareas
    vmTarea.insertarTarea(resCreada);
    //mostrra mensaje
    NotificationService.showSnackbar(
      "Tarea creada correctamente.",
    );

    isLoading = false; //detener carga

    return;
  }

  //Abrir picker de fecha inicial
  Future<void> abrirFechaInicial(BuildContext context) async {
    //abrir picker de la fecha inicial con la fecha actual
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: fechaInicial,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100), //puede cambiar
    );

    if (pickedDate == null) return;

    fechaInicial = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      fechaInicial.hour,
      fechaInicial.minute,
    );

    if (fechaInicial.isAfter(fechaFinal)) {
      fechaFinal = addDate10Min(fechaInicial);
    }

    notifyListeners();


  }

  //para la final
  Future<void> abrirFechaFinal(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: fechaFinal,
      //fecha minima la fecha actual o lafecha inicial seleciconada
      firstDate: fechaInicial,
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;
    // Verifica si el usuario seleccionó una fecha
    fechaFinal = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      fechaFinal.hour,
      fechaFinal.minute,
    );
    
    notifyListeners();

  }

  //Abrir y seleccionar hora inicial
  Future<void> abrirHoraInicial(BuildContext context) async {
    

    TimeOfDay? initialTime = TimeOfDay(
      hour: fechaInicial.hour,
      minute: fechaInicial.minute,
    );

    //abre el time picker con la hora en que se abrio le formulario
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime, //hora inicial
    );

    if (pickedTime == null) return;

    fechaInicial = DateTime(
      fechaInicial.year,
      fechaInicial.month,
      fechaInicial.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (fechaInicial.isAfter(fechaFinal)) {
      fechaFinal = addDate10Min(fechaInicial);
    }

    
    notifyListeners();
    // }
  }


  //Verifica si las fechas son iguales en día mes y año (iguales = true) (diferentes = false)
  bool compararFechas(DateTime fechaInicio, DateTime fechaFinal) {
    return fechaInicio.year == fechaFinal.year &&
        fechaInicio.month == fechaFinal.month &&
        fechaInicio.day == fechaFinal.day;
  }

  //Abrir picker de la fecha final
  Future<void> abrirHoraFinal(BuildContext context) async {
    TimeOfDay? initialTime = TimeOfDay(
      hour: fechaFinal.hour,
      minute: fechaFinal.minute,
    );

    //abre el time picker con la hora en que se abrio le formulario
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime, //hora inicial
    );

    if (pickedTime == null) return;

    final DateTime fechaTemp = DateTime(
      fechaFinal.year,
      fechaFinal.month,
      fechaFinal.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    // Verifica si las fechas son iguales (mismo día, mes y año).
    if (compararFechas(fechaInicial, fechaTemp)) {
      if (fechaTemp.isBefore(fechaInicial)) {
        NotificationService.showSnackbar(
          'La hora final no puede ser menor que la fecha y hora inicial. Modifique primero la fecha final.',
        );
        return;
      }
    }

    fechaFinal = DateTime(
      fechaFinal.year,
      fechaFinal.month,
      fechaFinal.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    notifyListeners();

   
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
    tiposTarea.addAll(res.message);

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
    estados.addAll(res.message);

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
    prioridades.addAll(res.message);

    //Recorrer la lista y asignar a la variable prioridad: "Normal"
    for (var i = 0; i < prioridades.length; i++) {
      PrioridadModel p = prioridades[i];
      if (p.nombre.toLowerCase() == "normal") {
        prioridad = p;
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
    periodicidades.addAll(res.message);

    //Recorrer la lista de periodicidades y asignar a la variable periodicidad : "Minutos"
    for (var i = 0; i < periodicidades.length; i++) {
      PeriodicidadModel t = periodicidades[i];
      if (t.descripcion.toLowerCase() == "minutos") {
        periodicidad = t;
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

  Future agregarResponsable(
    BuildContext context,
    TareaModel tarea,
  ) async {
    //View model del Login para obtener el usuario y token
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String user = vmLogin.user;
    String token = vmLogin.token;

    //Instancia del servicio
    final TareaService tareaService = TareaService();

    //Crear modelo de usuario responsable
    NuevoUsuarioModel usuarioResponsable = NuevoUsuarioModel(
      tarea: tarea.iDTarea,
      userResInvi: responsable!.userName,
      user: user,
    );

    isLoading = true; //cargar pantalla

    //consumo de api
    final ApiResModel res = await tareaService.postResponsable(
      token,
      usuarioResponsable,
    );

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

      //Abrir dialogo de error
      // NotificationService.showErrorView(context, res);

      ApiResModel responsable = ApiResModel(
        message: res.message,
        succes: false,
        url: "",
        storeProcedure: '',
      );

      return responsable;
    }

    //obtener respuesta del api
    ResponsableModel seleccionado = res.message;

    //Crear modelo del responsable
    ResponsableModel reponsableSeleccionado = ResponsableModel(
      tUserName: responsable!.email,
      estado: "activo",
      userName: seleccionado.userName,
      fechaHora: seleccionado.fechaHora,
      mUserName: seleccionado.mUserName,
      mFechaHora: seleccionado.mFechaHora,
      dHm: seleccionado.dHm,
      consecutivoInterno: seleccionado.consecutivoInterno,
    );

    //agregar responsable a la porpiedad responsable de la tarea
    tarea.usuarioResponsable = reponsableSeleccionado.userName;

    notifyListeners();

    isLoading = false; //detener carga
  }

}
