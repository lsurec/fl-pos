// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/calendario/models/dia_model.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class Calendario2ViewModel extends ChangeNotifier {
  //cargar pantalla
  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

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
          name: diasSemana[primerDiaIndex -1],
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
}
