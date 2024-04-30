// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/calendario/models/calendario_tarea_model.dart';
import 'package:flutter_post_printer_example/displays/calendario/models/dia_model.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:quiver/time.dart';

class Calendario2ViewModel extends ChangeNotifier {
  //cargar pantalla
  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<TareaCalendarioModel> tareasHoraActual = [];

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<String> diasSemana = [
    "Domingo",
    "Lunes",
    "Martes",
    "Miércoles",
    "Jueves",
    "Viernes",
    "Sábado",
  ];

  //Vistas del calendario
  bool vistaMes = true; // ver el mes
  bool vistaSemana = false; //ver la semana
  bool vistaDia = false; // ver el día

  int numSemanas = 4;

  List<DiaModel> diasDelMes = []; //dias del mes seleccionado
  //dias del mes seleccionado (1 al 28, 29, 30 o 31)
  // List<DiaModel> soloDelMes = [];

  bool diasFueraMes = false; //confirmar si hay mpas dias que son fuera del mes

  //fecha de hoy (fecha de la maquina)
  DateTime fechaHoy = DateTime.now(); //fecha completa DateNow
  int today = 0; //fecha dia
  int month = 0; //fecha mesooo
  int year = 0; //fecha año

  //para cambiar las fechas
  //fecha vista usuario
  int monthSelectView = 0; //mes
  int yearSelect = 0; //año
  int daySelect = 0; //dia

  String mesNombre = "";

  Future<void> loadData(BuildContext context) async {
    //Asignar valores a las variables
    today = fechaHoy.day;
    month = fechaHoy.month;
    year = fechaHoy.year;

    // //dias del mes 1 al 28, 29, 30 o 31.
    // soloDelMes = obtenerDiasMes(month, year);

    //mes con semanas completas de 7 dias cada semana
    diasDelMes = armarMes(month, year);

    yearSelect = year;
    monthSelectView = month;
    daySelect = today;
    verResultados();
  }

  List<DiaModel> obtenerDiasMes(int mes, int anio) {
    List<DiaModel> diasEncontrados = [];

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

      //crear arreglo de cada dia
      DiaModel diaObjeto = DiaModel(
        name: nombreDia,
        value: dia,
        indexWeek: indiceDiaSemana,
      );
      diasEncontrados.add(diaObjeto);
    }

    return diasEncontrados;
  }

  List<DiaModel> armarMes(int mes, int anio) {
    List<DiaModel> diasMesActual = [];
    List<DiaModel> diasMesAnterior = [];
    final List<DiaModel> completarMes = [];
    // int mesAnterior = mes - 1;

    //Limpiar las listas
    diasMesActual.clear();
    diasMesAnterior.clear();
    completarMes.clear();

    diasMesActual = obtenerDiasMes(month, year);
    diasMesAnterior = obtenerDiasMes(mes - 1, anio);

    //indices que ocupan en la semana el primer y ultimo día del mes
    int primerDiaIndex = diasMesActual.first.indexWeek;
    int ultimoDiaIndex = diasMesActual.last.indexWeek;

    if (primerDiaIndex == 6 || ultimoDiaIndex == 0) {
      numSemanas = 6;
      notifyListeners();
    } else {
      numSemanas = 5;
      notifyListeners();
    }

    // Agregar los días del mes anterior a la lista
    for (int i = primerDiaIndex - 1; i >= 0; i--) {
      completarMes.insert(
        0,
        DiaModel(
          name: diasSemana[primerDiaIndex - 1],
          value: diasMesAnterior.length,
          indexWeek: i,
        ),
      );
      diasMesAnterior.length--;
    }

    completarMes.addAll(diasMesActual);

    // Calcular cuántos días faltan para completar la última semana
    int diasFaltantesFin = 7 - (completarMes.length % 7);

    // Agregar los primeros días del mes siguiente a la última semana
    for (int i = 0; i < diasFaltantesFin; i++) {
      completarMes.add(
        DiaModel(
          name: diasSemana[(ultimoDiaIndex + i) % 7],
          value: i + 1,
          indexWeek: (ultimoDiaIndex + i) % 7,
        ),
      );
    }
    return completarMes;
  }

  verResultados() {
    // Imprimir los días del mes
    for (var dia in diasDelMes) {
      print(
        "Nombre: ${dia.name}, Valor: ${dia.value}, Índice de la semana: ${dia.indexWeek}",
      );
    }

    // print(" $monthSelectView, $yearSelect");
  }

  mesSiguiente() {
    //cambiar año y mes si es necesario
    yearSelect = monthSelectView == 12 ? yearSelect + 1 : yearSelect; //año
    monthSelectView = monthSelectView == 12 ? 1 : monthSelectView + 1; //mes
    print(monthSelectView);
    diasDelMes = armarMes(monthSelectView, yearSelect);
    notifyListeners();
    verResultados();
    nombreMes(monthSelectView, yearSelect);
  }

  Future<void> nombreMes(int mes, int anio) async {
    // Inicializa el formato para español (España)
    await initializeDateFormatting('es_ES', null);
    //nombre del mes infresado
    mesNombre = DateFormat.MMMM('es_ES').format(DateTime(anio, mes));
    notifyListeners();
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
}
