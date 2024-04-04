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

  List<DiaModel> diasDelMes = [];

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

    nombreMes(month, year);
    // primerDiaSemana = 0;
  }
  // Encontrar el índice del primer día del mes
  int primerDiaIndex = 0;
  int ultimoDiaIndex = 0;
  int numSemanas = 5;

  String mesNombre = "";

  loadData(BuildContext context) async {
    // Inicializa el formato para español (España)
    await initializeDateFormatting('es_ES', null);
    //nombre del mes infresado
    mesNombre =
        DateFormat.MMMM('es_ES').format(DateTime(yearSelect, monthSelectView));

    diasDelMes = obtenerDiasDelMes(month, year);

    primerDiaIndex = diasDelMes.first.indexWeek;
    ultimoDiaIndex = diasDelMes.last.indexWeek;

    if (primerDiaIndex == 6 && ultimoDiaIndex == 0) {
      numSemanas = 6;
      notifyListeners();
    } else {
      numSemanas = 5;
      notifyListeners();
    }
    monthSelectView = month; //mes
    yearSelect = year; //año
    daySelect = today; //hoy

    armarMes(month, year);

    notifyListeners();
  }

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

  //Nuevooooooooo

  Future<void> nombreMes(int mes, int anio) async {
    // Inicializa el formato para español (España)
    await initializeDateFormatting('es_ES', null);
    //nombre del mes infresado
    mesNombre = DateFormat.MMMM('es_ES').format(DateTime(anio, mes));
  }

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

  armarSemanas(int mes, int anio) {
    List<DiaModel> dias = obtenerDiasDelMes(mes, anio);

    // Imprimir los días del mes
    for (var dia in dias) {
      print(
        "Nombre: ${dia.name}, Valor: ${dia.value}, Índice de la semana: ${dia.indexWeek}",
      );
    }
  }

  // Función para obtener los días de un mes dado el año y el mes
  List<DiaModel> obtenerDiasDelMes(int mes, int anio) {
    List<DiaModel> diasDelMes = [];

    // Obtener la cantidad de días en el mes dado
    int cantidadDias = DateTime(anio, mes + 1, 0).day;

    // Obtener el primer día del mes
    DateTime primerDiaMes = DateTime(anio, mes, 1);

    // Obtener el índice del primer día de la semana
    int primerDiaSemana = primerDiaMes.weekday;

    // Iterar sobre cada día del mes y crear el objeto DiaModel correspondiente
    for (int i = 0; i < cantidadDias; i++) {
      int dia = i + 1;
      int indiceDiaSemana = (primerDiaSemana + i) % 7;
      String nombreDia = diasSemana[indiceDiaSemana];
      DiaModel diaObjeto = DiaModel(
        name: nombreDia,
        value: dia,
        indexWeek: indiceDiaSemana,
      );
      diasDelMes.add(diaObjeto);
    }

    return diasDelMes;
  }

  mesSiguiente(int mes, int anio) {
    diasDelMes = obtenerDiasDelMes(mes++, anio);
    notifyListeners();
  }

  mesAnterior(int mes, int anio) {
    diasDelMes = obtenerDiasDelMes(mes--, anio);
    notifyListeners();
  }

  List<DiaModel> mesCompleto = [];

  armarMes(mes, anio) {
    int mesAnterior = month - 1;
    List<DiaModel> diasMesAnterior = obtenerDiasDelMes(mesAnterior, anio);

    primerDiaIndex = diasDelMes.first.indexWeek;
    ultimoDiaIndex = diasDelMes.last.indexWeek;

    // Limpiar la lista mesCompleto
    mesCompleto.clear();

    // Agregar los días del mes anterior a la lista
    for (int i = primerDiaIndex - 1; i >= 0; i--) {
      mesCompleto.insert(
        0,
        DiaModel(
          name: diasSemana[i],
          value: diasMesAnterior.length,
          indexWeek: i,
        ),
      );
      diasMesAnterior.length--;
    }

    mesCompleto.addAll(diasDelMes);

    // Calcular cuántos días faltan para completar la última semana
    int diasFaltantesFin = 7 - (mesCompleto.length % 7);

    // Agregar los primeros días del mes siguiente a la última semana
    for (int i = 0; i < diasFaltantesFin; i++) {
      mesCompleto.add(
        DiaModel(
          name: diasSemana[(ultimoDiaIndex + i) % 7],
          value: i + 1,
          indexWeek: (ultimoDiaIndex + i) % 7,
        ),
      );
    }

    // // Imprimir los días del mes
    // for (var dia in mesCompleto) {
    //   print(
    //     "Nombre: ${dia.name}, Valor: ${dia.value}, Índice de la semana: ${dia.indexWeek}",
    //   );
    // }
  }
}
