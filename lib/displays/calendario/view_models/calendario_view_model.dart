// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/calendario/models/models.dart';
import 'package:flutter_post_printer_example/displays/calendario/serivices/services.dart';
import 'package:flutter_post_printer_example/models/api_res_model.dart';
import 'package:flutter_post_printer_example/services/notification_service.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

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

  // List<DiaModel> monthSelect = []; //dias del mes seleccionado
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
  int numSemanas = 0;

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

    semanasDelMes = agregarSemanas(month, year);
    indexWeekActive = 0;

    nombreMes(monthSelectView, yearSelect);

    // obtenerTareasCalendario(context);

    mostrarVistaMes();

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

  mesSiguiente() async {
    //cambiar año y mes si es necesario
    yearSelect = monthSelectView == 12 ? yearSelect + 1 : yearSelect; //año
    monthSelectView = monthSelectView == 12 ? 1 : monthSelectView + 1; //mes
    nombreMes(monthSelectView, yearSelect);
    notifyListeners();
  }

  mesAnterior() async {
    //cambiar año y mes si es necesario
    yearSelect = monthSelectView == 1 ? yearSelect - 1 : yearSelect; //año
    monthSelectView = monthSelectView == 1 ? 12 : monthSelectView - 1; //mes
    nombreMes(monthSelectView, yearSelect);
    notifyListeners();
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

  //Dividir el mes por semanas (en semanas de 0..6)
  List<List<DiaModel>> agregarSemanas(int mes, int anio) {
    List<DiaModel> dias = [];
    dias.clear();

    dias = armarMes(mes, anio);

    //lista con sublistas de semanas
    List<List<DiaModel>> semanas = [];
    semanas.clear();

    for (int i = 0; i < dias.length; i += 7) {
      List<DiaModel> sublista = dias.sublist(i, i + 7);
      semanas.add(sublista);
    }

    for (int i = 0; i < semanas.length; i++) {
      for (int j = 0; j < semanas[i].length; j++) {
        semanas[i][j].indexWeek = j;
      }
    }
    return semanas;
  }

  semanaAnterior() {
    if (indexWeekActive == 0) {
      yearSelect = monthSelectView == 1 ? yearSelect - 1 : yearSelect; //año
      monthSelectView = monthSelectView == 1 ? 12 : monthSelectView - 1; //mes
      nombreMes(monthSelectView, yearSelect);

      indexWeekActive = semanasDelMes.length - 1;
      notifyListeners();
    }

    indexWeekActive = indexWeekActive - 1;

    notifyListeners();
  }

  mostrarVistaMes() {
    vistaMes = true;
    vistaDia = false;
    vistaSemana = false;
    notifyListeners();
  }

  mostrarVistaSemana() {
    vistaSemana = true;
    vistaMes = false;
    vistaDia = false;
    notifyListeners();
  }

  mostrarVistaDia() {
    vistaDia = true;
    vistaSemana = false;
    vistaMes = false;
    notifyListeners();
  }

  irAlDia(int verDia) {
    print("IR A VER AL DIA $verDia");
  }

  //verificar si un dia es del mes
  bool nuevaIsToday(int date, int i) {
    //verificar mes y año de la fecha de hoy
    if (today == date && monthSelectView == month && yearSelect == year) {
      if (i >= 0 && i < 7 && date > semanasDelMes[0][6].value) {
        return false;
      }
      if (i >= mesCompleto.length - 6 &&
          i < mesCompleto.length &&
          date < semanasDelMes[semanasDelMes.length - 1][0].value) {
        return false;
      }
      return true;
    }
    return false;
  }

  bool diasOtroMes(DiaModel dia, int index, List<DiaModel> diasMes) {
    List<List<DiaModel>> semanas = [];

    semanas = nuevaAgregarSemanas(diasMes);

    if ((index >= 0 && index < 7 && dia.value > semanas[0][6].value)) {
      return true;
    }

    if ((index >= diasMes.length - 6 &&
        index < diasMes.length &&
        dia.value < semanas[semanas.length - 1][0].value)) {
      return true;
    }
    return false;
  }

  //Dividir el mes por semanas (en semanas de 0..6)
  List<List<DiaModel>> nuevaAgregarSemanas(List<DiaModel> dias) {
    //lista con sublistas de semanas
    List<List<DiaModel>> semanas = [];
    semanas.clear();

    for (int i = 0; i < dias.length; i += 7) {
      List<DiaModel> sublista = dias.sublist(i, i + 7);
      semanas.add(sublista);
    }

    for (int i = 0; i < semanas.length; i++) {
      for (int j = 0; j < semanas[i].length; j++) {
        semanas[i][j].indexWeek = j;
      }
    }
    return semanas;
  }

  int obtenerIndiceSemanaSiguiente(
    int indiceSemanaActual,
    int mesActual,
    int anioActual,
  ) {
    // Obtener las semanas del mes actual
    List<List<DiaModel>> semanasDelMesActual =
        agregarSemanas(mesActual, anioActual);

    // Verificar si la semana actual es la última del mes
    bool esUltimaSemanaDelMes =
        indiceSemanaActual == semanasDelMesActual.length - 1;

    if (esUltimaSemanaDelMes) {
      // Obtener las semanas del mes siguiente
      int mesSiguiente = mesActual + 1;
      int anioSiguiente = anioActual;
      if (mesSiguiente == 13) {
        mesSiguiente = 1;
        anioSiguiente++;
      }

      List<List<DiaModel>> semanasDelMesSiguiente =
          agregarSemanas(mesSiguiente, anioSiguiente);

      // Verificar si el primer día de la primera semana del mes siguiente es el día 1
      bool esPrimeraSemanaDelMesSiguiente =
          semanasDelMesSiguiente[0][0].value == 1 &&
              semanasDelMesSiguiente[0][0].indexWeek ==
                  0; // El primer día de la semana está en el índice 0

      if (esPrimeraSemanaDelMesSiguiente) {
        // Si la primera semana del mes siguiente comienza en el día 1, devolver el índice 0 para mostrar esta semana
        return 0;
      }
    }

    // Si no se cumple ninguna condición especial, avanzar al índice de la semana siguiente
    return indiceSemanaActual + 1;
  }

  semanaSiguiente() {
    if (indexWeekActive == semanasDelMes.length - 1) {
      yearSelect = monthSelectView == 12 ? yearSelect + 1 : yearSelect; //año
      monthSelectView = monthSelectView == 12 ? 1 : monthSelectView + 1; //mes
      nombreMes(monthSelectView, yearSelect);

      semanasDelMes = agregarSemanas(monthSelectView, yearSelect);

      if (semanasDelMes[0][0].value == 1) {
        // Cambiar a la primera semana del nuevo mes
        indexWeekActive = 0;
        notifyListeners();
        return;
      }

      // Obtener el índice de la semana siguiente del nuevo mes
      // Cambiar a la primera semana del nuevo mes
      indexWeekActive =
          obtenerIndiceSemanaSiguiente(0, monthSelectView, yearSelect);

      notifyListeners();
    } else {
      // Si no es la última semana del mes, simplemente avanzar a la siguiente semana
      indexWeekActive++;
      notifyListeners();
    }
  }
}
