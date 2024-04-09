// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/calendario/models/models.dart';
import 'package:flutter_post_printer_example/displays/calendario/serivices/services.dart';
import 'package:flutter_post_printer_example/models/api_res_model.dart';
import 'package:flutter_post_printer_example/services/notification_service.dart';
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

  DateTime? hoy;

  //Variables a utlizar en e calendario

  bool vistaMes = true;
  bool vistaSemana = false;
  bool vistaDia = false;

  List<DiaModel> diasDelMes = [];
  bool diasFueraMes = false;

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
  List<List<DiaModel>> semanasDelMes = [];

  // Encontrar el índice del primer día del mes
  int primerDiaIndex = 0;
  int ultimoDiaIndex = 0;
  int numSemanas = 5;

  String mesNombre = "";

  Future<void> loadData(BuildContext context) async {
    fechaHoy = DateTime.now();

    today = fechaHoy.day;
    month = fechaHoy.month;
    year = fechaHoy.year;

    diasDelMes = obtenerDiasDelMes(month, year);

    mesCompleto = armarMes(month, year);

    monthSelectView = month; //mes
    yearSelect = year; //año
    daySelect = today; //hoy

    semanasDelMes = addWeeks(mesCompleto);

    primerDiaIndex = diasDelMes.first.indexWeek;
    ultimoDiaIndex = diasDelMes.last.indexWeek;

    if (primerDiaIndex == 6 && ultimoDiaIndex == 0) {
      numSemanas = 6;
      notifyListeners();
    } else {
      numSemanas = 5;
      notifyListeners();
    }
    nombreMes(monthSelectView, yearSelect);

    primerDiaIndex = diasDelMes.first.indexWeek;
    ultimoDiaIndex = diasDelMes.last.indexWeek;

    calcularSemanas(monthSelectView, primerDiaIndex, ultimoDiaIndex);

    semanasDelMes = addWeeks(mesCompleto);

    indexWeekActive = 0;

    obtenerTareasCalendario(context);

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
    notifyListeners();
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

  List<DiaModel> mesCompleto = [];

  List<DiaModel> armarMes(int mes, int anio) {
    print("$mes mes, $anio año ");
    List<DiaModel> completarMes = [];
    int mesAnterior = mes - 1;
    List<DiaModel> diasMesAnterior = obtenerDiasDelMes(mesAnterior, anio);

    diasDelMes = obtenerDiasDelMes(mes, anio);

    primerDiaIndex = diasDelMes.first.indexWeek;
    ultimoDiaIndex = diasDelMes.last.indexWeek;

    // Limpiar la lista mesCompleto
    completarMes.clear();

    // Agregar los días del mes anterior a la lista
    for (int i = primerDiaIndex - 1; i >= 0; i--) {
      completarMes.insert(
        0,
        DiaModel(
          name: diasSemana[i],
          value: diasMesAnterior.length,
          indexWeek: i,
        ),
      );
      diasMesAnterior.length--;
    }

    completarMes.addAll(diasDelMes);

    // Calcular cuántos días faltan para completar la última semana
    int diasFaltantesFin = 7 - (completarMes.length % 7);

    if (diasFaltantesFin == 7) return completarMes;
    // Agregar los primeros días del mes siguiente a la última semana
    for (int i = 0; i < diasFaltantesFin; i++) {
      completarMes.add(
        DiaModel(
          name: diasSemana[(ultimoDiaIndex + i) % 7 + 1],
          value: i + 1,
          indexWeek: (ultimoDiaIndex + i) % 7 + 1,
        ),
      );
    }
    return completarMes;
  }

  calcularSemanas(int mes, int indexPrimerDia, int indexUktimoDia) {
    if (primerDiaIndex == 6 || ultimoDiaIndex == 0) {
      numSemanas = 6;
      notifyListeners();
    } else {
      numSemanas = 5;
      notifyListeners();
    }

    if (mes == 2 && primerDiaIndex == 6 && ultimoDiaIndex <= 6) {
      numSemanas = 5;
      notifyListeners();
    }

    if (mes == 2 && primerDiaIndex == 0 && ultimoDiaIndex == 6) {
      numSemanas = 4;
      notifyListeners();
    }
  }

  mesSiguiente() async {
    //cambiar año y mes si es necesario
    yearSelect = monthSelectView == 12 ? yearSelect + 1 : yearSelect; //año
    monthSelectView = monthSelectView == 12 ? 1 : monthSelectView + 1; //mes
    mesCompleto = armarMes(monthSelectView, yearSelect);
    nombreMes(monthSelectView, yearSelect);

    notifyListeners();
    // verrr();
  }

  mesAnterior() async {
    //cambiar año y mes si es necesario
    yearSelect = monthSelectView == 1 ? yearSelect - 1 : yearSelect; //año
    monthSelectView = monthSelectView == 1 ? 12 : monthSelectView - 1; //mes

    mesCompleto = armarMes(monthSelectView, yearSelect);
    notifyListeners();

    nombreMes(monthSelectView, yearSelect);
  }

  //encontrar el dia de hoy
  bool diaHoy(int dia, int index) {
    if (today == dia && monthSelectView == month && yearSelect == year) {
      if (dia == today && dia >= mesCompleto[0].value ||
          dia <= mesCompleto[6].value && index >= 0 && index <= 7) {
        return true;
      }
      return false;
    }
    return false;
  }

  bool siEsHoy = false;
  bool siguientes = false;

  buscarHoy(List<DiaModel> dias) {
    for (var i = 0; i < dias.length; i++) {
      DiaModel diaRecorrido = dias[i];
      if (today == diaRecorrido.value &&
          monthSelectView == month &&
          yearSelect == year) {
        if (diaRecorrido.value == today &&
                diaRecorrido.value >= mesCompleto[0].value ||
            diaRecorrido.value <= mesCompleto[6].value &&
                diaRecorrido.indexWeek >= 0 &&
                diaRecorrido.indexWeek <= 7) {
          siEsHoy = true;
          notifyListeners();
        }
        siEsHoy = false;
        notifyListeners();
      }
      siEsHoy = false;
      notifyListeners();
    }
  }

  bool diasAnteriores(int dia, int index) {
    List<DiaModel> dias = obtenerDiasDelMes(monthSelectView, yearSelect);

    if (index >= 0 && index < 7 && dia > dias[6].value) {
      return true;
    }
    return false;
  }

  bool diasSiguientes(int dia, int index) {
    List<DiaModel> diasMesHoy = [];
    diasMesHoy.clear();
    diasMesHoy = armarMes(month, year);

    final int ultimoDiaMes = diasMesHoy.last.value;
    final List<DiaModel> diasUltimaSemana =
        diasMesHoy.sublist(diasMesHoy.length - 7);

    if (index >= diasMesHoy.length - 7 &&
        dia <= ultimoDiaMes &&
        diasUltimaSemana.any((diaModel) => diaModel.value == dia)) {
      return true;
    }
    return false;
  }

  regresarHoy() async {
    diasDelMes = obtenerDiasDelMes(month, year);

    monthSelectView = month; //mes
    yearSelect = year; //año
    daySelect = today; //hoy

    mesCompleto = armarMes(monthSelectView, yearSelect);

    primerDiaIndex = diasDelMes.first.indexWeek;
    ultimoDiaIndex = diasDelMes.last.indexWeek;

    if (primerDiaIndex == 6 && ultimoDiaIndex == 0) {
      numSemanas = 6;
      notifyListeners();
    } else {
      numSemanas = 5;
      notifyListeners();
    }
    nombreMes(monthSelectView, yearSelect);
    notifyListeners();
  }

  List<TareaCalendarioModel> tareas = [];

  obtenerTareasCalendario(BuildContext context) async {
    tareas.clear(); //limpiar lista

    //obtener token y usuario
    // final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    // String token = vmLogin.token;
    // String user = vmLogin.user;

    //instancia del servicio
    final CalendarioTareaService tareaService = CalendarioTareaService();

    isLoading = true; //cargar pantalla

    //consumo de api
    final ApiResModel res = await tareaService.getTareaCalendario("desa026",
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiJkZXNhMDAxIiwibmJmIjoxNzEwODg2NDMwLCJleHAiOjE3NDE5OTA0MzAsImlhdCI6MTcxMDg4NjQzMH0.dpsc7-kj0Lsxm9QAPVJLTM7IGdjvrG6NOBYtnIgprwM");

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;
      NotificationService.showErrorView(context, res);
      return;
    }
    //agregar tareas encontradas a la lista de tareas
    tareas.addAll(res.message);

    print("tareas asigandas al usuario ${tareas.length}");

    isLoading = false; //detener carga
  }

  String convertDateFormat(String inputDate) {

    // Parse the input date string
    DateTime parsedDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").parse(inputDate);

    // Format the parsed date to the desired output format
    String formattedDate =
        DateFormat('EEE MMM dd yyyy HH:mm:ss \'GMT\'Z (zzzz)')
            .format(parsedDate);

    return formattedDate;
  }

  List<TareaCalendarioModel> tareaDia(int day, int month, int year) {
    final fechaBusqueda = DateTime(year, month, day);
    final fechaBusquedaFormateada =
        DateFormat('yyyy-MM-dd').format(fechaBusqueda);

    // Filtra las tareas por fecha
    return tareas.where((objeto) {
      final fechaObjeto = objeto.fechaIni.toString().split('T')[0];
      return fechaObjeto == fechaBusquedaFormateada;
    }).toList();
  }

  //Verificar si una fecha es del mes seleccionado
  bool monthCurrent(int date, int i) {
    List<DiaModel> dias = obtenerDiasDelMes(monthSelectView, yearSelect);

    if (i >= 0 && i < 7 && date > dias[6].value) return false;
    if (i >= dias.length - 6 &&
        i < dias.length &&
        date < dias[dias.length - 1].value) {
      // print(" indiece $i dia $date");
      return false;
    }
    return true;
  }

  //Dividir el mes por semanas (en semanas de 0..6)
  List<List<DiaModel>> addWeeks(List<DiaModel> diasDelMes) {
    //lista con sublistas de semanas
    List<List<DiaModel>> semanas = [];
    semanas.clear();

    for (int i = 0; i < diasDelMes.length; i += 7) {
      List<DiaModel> sublista = diasDelMes.sublist(i, i + 7);
      semanas.add(sublista);
    }

    for (int i = 0; i < semanas.length; i++) {
      for (int j = 0; j < semanas[i].length; j++) {
        semanas[i][j].indexWeek = j;
      }
    }
    return semanas;
  }

  verrr() {
    // for (var dia in mesCompleto) {
    //   print(
    //     "Nombre: ${dia.name}, Valor: ${dia.value}, Índice de la semana: ${dia.indexWeek}",
    //   );
    // }

    List<List<DiaModel>> semanass = addWeeks(mesCompleto);
    for (int i = 0; i < semanass.length; i++) {
      print("Semana ${i + 1}:");
      for (int j = 0; j < semanass[i].length; j++) {
        print("Día ${semanass[i][j].value}: ${semanass[i][j].name}");
        // Asegúrate de reemplazar 'nombreDelDia' con el nombre de tu atributo que contiene el nombre del día
      }
      print(""); // Para separar las semanas
    }
  }

  semanaAnterior() {
    indexWeekActive = indexWeekActive - 1;
    notifyListeners();
  }

  semanaSiguiente() {
    indexWeekActive = indexWeekActive + 1;
    notifyListeners();
  }

  //verificar si un dia es del mes
  bool isToday(int date, int i) {
    List<DiaModel> diasMesHoy = [];
    List<List<DiaModel>> semanas = [];
    diasMesHoy = armarMes(month, year);

    semanas = addWeeks(diasMesHoy);

    //verificar mes y año de la fecha de hpy
    if (today == date && monthSelectView == month && yearSelect == year) {
      if (i >= 0 && i < 7 && date > semanas[0][6].value) {
        return false;
      }
      if (i >= mesCompleto.length - 6 &&
          i < mesCompleto.length &&
          date < semanas[semanas.length - 1][0].value) {
        return false;
      }
      return true;
    }
    return false;
  }
}
