// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/calendario/models/models.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:quiver/time.dart'; // Importa esta línea

class CalendarioViewModel extends ChangeNotifier {
  //cargar pantalla
  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final List<int> diasMes = [];
  DateTime? hoy;

  //Variables a utlizar en e calendario

  List<DiaModel> monthSelect = []; //dias del mes seleccionado
  List<String> diasSemanaEspaniol = []; //Nombres de los dias de la semana
  int primerDiaSemana = 0; // 0 = domingo, 1 = lunes, ..., 6 = sábado

  //fecha de hoy (fecha de la maquina)
  DateTime fechaHoy = DateTime.now(); //fecha completa DateNow
  int today = 0; //fecha dia
  int month = 0; //fecha mesooo
  int year = 0; //fecha año

  //fecha vista usuario
  int monthSelectView = 0; //mes
  int yearSelect = 0; //año
  int daySelect = 0; //dia

  //semena seleccionada
  int indexWeekActive = 0;

  //semanas del mes actual
  List<List<DiaModel>> semanas = [];

  //Constructor
  CalendarioViewModel() {
    // hoy = DateTime.now();

    //obtener feccha de hoy y asignar
    today = fechaHoy.day; //fecha del dia
    month = fechaHoy.month; //mes
    year = fechaHoy.year; //año

    // primerDiaSemana = 0;
  }

  loadData(BuildContext context) async {
    // //primer dia
    // primerDiaSemana = 4;

    //Ordenar dia semmana por el primer dia asigando  0 = domingo, 1 = lunes, ..., 6 = sábado
    diasSemana = crearArregloDias();
    //obtener mes actual
    monthSelect = obtenerDiasMes(year, month, primerDiaSemana);
    //asiganr semanas del mes
    semanas = addWeeks(monthSelect);
    //fecha de hoy
    monthSelectView = month; //mes
    yearSelect = year; //año
    daySelect = today; //dia

    notifyListeners();
  }

  List<String> inicialDia = [
    "L",
    "M",
    "M",
    "J",
    "V",
    "S",
    "D",
  ];

  List<String> horas = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12"
  ];

  List<String> diasSemana = [
    "Domingo",
    "Lunes",
    "Martes",
    "Miércoles",
    "Jueves",
    "Viernes",
    "Sábado",
  ];

  List<String> crearArregloDias() {
    List<String> arregloDias = [];

    // Encontramos el índice del día inicial en el arreglo díasSemana
    int indiceDiaInicial = primerDiaSemana % 7;
    // Agregamos los días de la semana en el orden configurado
    for (int i = 0; i < 7; i++) {
      int indiceDia = (indiceDiaInicial + i) % 7;
      arregloDias.add(diasSemana[indiceDia]);
    }
    // Retorna nueva semana ordenada
    return arregloDias;
  }

  List<DiaModel> obtenerDiasMes(
    int anio,
    int mes,
    int primerDiaSemana,
  ) {
    //almacenar dias del mes
    List<DiaModel> diasMes = [];
    // Obtenemos el primer día del mes
    DateTime primerDia = DateTime(anio, mes, 1);
    // Obtenemos el último día del mes sumando 1 al mes siguiente y restando 1 día
    DateTime ultimoDia = DateTime(anio, mes, 0);

    // Determinamos el desplazamiento necesario para el primer día de la semana
    int desplazamiento = (primerDia.day + 7 - primerDiaSemana) % 7;

    // Recorremos los días del mes, teniendo en cuenta el desplazamiento
    for (var dia = 1 - desplazamiento; dia <= ultimoDia.day; dia++) {
      DateTime fecha = DateTime(anio, mes - 1, dia);

      // Aseguramos que el resultado esté entre 0 y 6
      int diaSemana = (fecha.day + 7) % 7;

      // Creamos un objeto con la información del día
      DiaModel diaObjeto = DiaModel(
        name: diasSemana[diaSemana],
        value: fecha.day,
        indexWeek: diaSemana + 1,
      );

      print(
        "${diaObjeto.name} ${diaObjeto.value} indice: ${diaObjeto.indexWeek} ",
      );

      //insertar nuevo arreglo de dias
      diasMes.add(diaObjeto);
    }
    //ultimo dia del mes (fecha)
    int ultimaCoincidencia = -1;
    //buscar el ultimo dia del mes
    for (var index = 0; index < diasMes.length; index++) {
      DiaModel diaUltimoMes = diasMes[index];
      if (diaUltimoMes.value == ultimoDia.day) {
        ultimaCoincidencia = index;
      }
    }

    //buscar que dia de la semana es
    int ultimoIndice = diasSemana.lastIndexOf(
      diasMes[ultimaCoincidencia].name,
    );

    //cuantos dias me faltan
    int diasRestantes = (diasSemana.length - 1) - ultimoIndice;

    //buscar los días que faltan (cantidad) del siguiente mes
    diasMes.addAll(obtenerDiasMesCantidad(
      mes == 12 ? 1 : mes + 1,
      mes == 12 ? anio + 1 : anio,
      diasRestantes,
    ));

    //enumerar mes indexWeek
    for (var index = 0; index < diasMes.length; index++) {
      diasMes[index].indexWeek = index;
    }

    //retornar dias del mes buscado con los dias del mes anterior y siguiente
    //(completando todas las semanas)
    return diasMes;
  }

  //Obtner una cantidad de dias del mes
  //Ej: si busco 10 dias obtengo los primeros 10 dias del mes
  List<DiaModel> obtenerDiasMesCantidad(int mes, int anio, int cantidad) {
    // El mes en JavaScript comienza desde 0, por lo que se resta 1 al mes ingresado
    DateTime fecha = DateTime(anio, mes, 1);
    //dias encontrados
    List<DiaModel> diasMes = [];

    //bucar cantidad de dias deseados en el mes
    for (var i = 0; i < cantidad; i++) {
      // Aseguramos que el resultado esté entre 0 y 6
      int diaSemana = (fecha.day + 7) % 7;
      //objeto dias
      DiaModel diaObjeto = DiaModel(
        name: diasSemana[diaSemana],
        value: fecha.day,
        indexWeek: diaSemana + 1,
      );

      diasMes.add(diaObjeto);
      fecha = fecha.add(const Duration(days: 1));
    }
    //retornar dias requeridos
    return diasMes;
  }

  List<List<DiaModel>> addWeeks(List<DiaModel> diasDelMes) {
    List<List<DiaModel>> semanas = [];

    for (int i = 0; i < diasDelMes.length; i += 7) {
      int endIndex = (i + 7 <= diasDelMes.length) ? i + 7 : diasDelMes.length;
      final List<DiaModel> sublista = diasDelMes.sublist(i, endIndex);
      semanas.add(sublista);
    }

    for (int i = 0; i < semanas.length; i++) {
      for (int j = 0; j < semanas[i].length; j++) {
        semanas[i][j].indexWeek = j;
      }
    }

    return semanas;
  }

  //Nuevooooooooo

  dias() async {
    // Inicializa el formato para español (España)
    await initializeDateFormatting('es_ES', null);

    const year = 2024; //año
    const month = 5; // mes

    //primer dia del mes
    final primerDiaMes = DateTime(year, month, 1);

    //nombre del dia lun, mar... o dom.
    final nomDia = DateFormat('EEEE', 'es_ES').format(primerDiaMes);

    //nombre del mes infresado
    final nombreMes = DateFormat.MMMM('es_ES').format(DateTime(2024, month));

    // print('El primer dia del mes de $nombreMes del año $year fue el $nomDia');

    final int weekIndex = indiceEnSemanaPrimerDiaMes(nomDia);
    final int weekIndexFinal = indiceEnSemanaUltimoDiaMes(year, month);

    print(
      '$weekIndex es el indice de la semana del primer dia del mes $nombreMes.',
    );

    print(
      '$weekIndexFinal es el indice de la semana del ultomo dia del mes $nombreMes.',
    );

    final diasMes = daysInMonth(year, month);
    print('El mes de $nombreMes tiene $diasMes dias.');
  }

  int indiceEnSemanaPrimerDiaMes(String primerDiaSemana) {
    // Días de la semana en orden (0 = domingo, 6 = sábado)
    final List<String> daysOfWeek = [
      'domingo',
      'lunes',
      'martes',
      'miércoles',
      'jueves',
      'viernes',
      'sábado'
    ];

    // Encuentra el índice del primer día de la semana
    final int firstDayIndex = daysOfWeek.indexOf(primerDiaSemana.toLowerCase());

    return firstDayIndex;
  }

  int indiceEnSemanaUltimoDiaMes(int year, int month) {
    // Calcula la fecha del último día del mes
    final DateTime lastDayOfMonth = DateTime(year, month + 1, 0);

    // Obtiene el día de la semana (0 = domingo, 6 = sábado)
    final int lastDayOfWeek = lastDayOfMonth.weekday;

    return lastDayOfWeek;
  }

  armarSemanas() {}
}
