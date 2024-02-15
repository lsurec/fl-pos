import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';

class TareasViewModel extends ChangeNotifier {

  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }


  GlobalKey<FormState> formKeySearch = GlobalKey<FormState>();
  final TextEditingController searchController = TextEditingController();

//Validar formulario barra busqueda
  bool isValidFormCSearch() {
    return formKeySearch.currentState?.validate() ?? false;
  }


  String buscar = ""; //para buscar tareas
  int? filtro = 1; //para filtro de busqueda Inicialmente por descripcion
  DateTime fecha = DateTime.now(); //obtener fecha actual

//Lista ejemplo de las tareas
  List<TareaModel> tareas = [
    TareaModel(
      iDTarea: 4500,
      referencia: 0123,
      descripcion: 'Tarea, titulo tarea, tarea tarea.',
      tareaEstado: 'Activo',
      tareaFechaIni: DateTime.now(),
      usuarioCreador: 'Usuario 1',
      usuarioResponsable: 'Usuario 2',
      tareaObservacion1:
          'Crear cuentas bancarias para emisión de cheques, conciliacion bancaria y orden contable.',
    ),
    TareaModel(
      iDTarea: 4000,
      referencia: 0123,
      descripcion: 'Tarea dos, titulo tarea, tarea tarea.',
      tareaEstado: 'Cerrado',
      tareaFechaIni: DateTime.now(),
      usuarioCreador: 'Usuario 3',
      usuarioResponsable: 'Usuario 4',
      tareaObservacion1:
          'Crear cuentas bancarias para emisión de cheques, conciliacion bancaria y orden contable.',
    ),
    TareaModel(
      iDTarea: 3000,
      referencia: 0123,
      descripcion: 'Tarea tres, titulo tarea, tarea tarea.',
      tareaEstado: 'Activo',
      tareaFechaIni: DateTime.now(),
      usuarioCreador: 'Usuario 1',
      usuarioResponsable: 'Usuario 2',
      tareaObservacion1:
          'Crear cuentas bancarias para emisión de cheques, conciliacion bancaria y orden contable.',
    ),
    TareaModel(
      iDTarea: 3500,
      referencia: 0123,
      descripcion: 'Tarea cuatro, titulo tarea, tarea tarea.',
      tareaEstado: 'Cerrado',
      tareaFechaIni: DateTime.now(),
      usuarioCreador: 'Usuario 3',
      usuarioResponsable: 'Usuario 4',
      tareaObservacion1:
          'Crear cuentas bancarias para emisión de cheques, conciliacion bancaria y orden contable.',
    ),
    TareaModel(
      iDTarea: 3100,
      referencia: 0123,
      descripcion: 'Tarea cinco, titulo tarea, tarea tarea.',
      tareaEstado: 'Activo',
      tareaFechaIni: DateTime.now(),
      usuarioCreador: 'Usuario 1',
      usuarioResponsable: 'Usuario 2',
      tareaObservacion1:
          'Crear cuentas bancarias para emisión de cheques, conciliacion bancaria y orden contable.',
    ),
    TareaModel(
      iDTarea: 4060,
      referencia: 0123,
      descripcion: 'Tarea seis, titulo tarea, tarea tarea.',
      tareaEstado: 'Cerrado',
      tareaFechaIni: DateTime.now(),
      usuarioCreador: 'Usuario 3',
      usuarioResponsable: 'Usuario 4',
      tareaObservacion1:
          'Crear cuentas bancarias para emisión de cheques, conciliacion bancaria y orden contable.',
    ),


  ];

  performSearch(){
    if(!isValidFormCSearch()) return;
    print("Formulario valido");
    //TODO:Funcion buscar
  }

  busqueda(int filtro) {
    this.filtro = filtro;
    notifyListeners();
  }

  crearTarea(BuildContext context) {
    

    Navigator.pushNamed(context, "nueva_tarea");
  }

  verDetalles(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.detailsTask);
  }
}
