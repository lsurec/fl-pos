// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/calendario/models/models.dart';
import 'package:flutter_post_printer_example/displays/calendario/serivices/services.dart';
import 'package:flutter_post_printer_example/models/api_res_model.dart';
import 'package:flutter_post_printer_example/services/notification_service.dart';
import 'package:flutter_post_printer_example/utilities/utilities.dart';
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
  //Tareas de la hora actual
  List<TareaCalendarioModel> tareasHoraActual = [];

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

    // today = 27;
    // month = 9;
    // year = 2023;

    // print("${tareaHora(10, tareaDia(today, month, year)).length}");

    diasDelMes = obtenerDiasDelMes(month, year);

    mesCompleto = armarMes(month, year);

    monthSelectView = month; //mes
    yearSelect = year; //año
    daySelect = today; //hoy

    semanasDelMes = agregarSemanas(month, year);
    indexWeekActive = 0;

    //cargar(27, 9, 2023);
    obtenerTareasCalendario(context);

    mostrarVistaMes();

    notifyListeners();
  }

  List<HorasModel> horasDelDia = Utilities.horasDelDia;

  List<String> diasSemana = Utilities.diasSemana;

  //Nuevooooooooo

  Future<String> nombreDelMes(int mes, int anio) async {
    // Inicializa el formato para español (España)
    await initializeDateFormatting('es_ES', null);
    //nombre del mes infresado
    return DateFormat.MMMM('es_ES').format(DateTime(anio, mes));
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
    notifyListeners();
  }

  mesAnterior() async {
    //cambiar año y mes si es necesario
    yearSelect = monthSelectView == 1 ? yearSelect - 1 : yearSelect; //año
    monthSelectView = monthSelectView == 1 ? 12 : monthSelectView - 1; //mes
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
    final ApiResModel res = await tareaService.getTareaCalendario("desa029",
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiJkZXNhMDI5IiwibmJmIjoxNzEzMjA0OTY0LCJleHAiOjE3NDQzMDg5NjQsImlhdCI6MTcxMzIwNDk2NH0.N0-ioXGBJ485Waco_0mPwWXP-A_JZk0Uu5Un77yhJJE");

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

  diasOtraSemana() {
    if (indexWeekActive == 0) {
      //Es la primera semana del mes
    }

    if (indexWeekActive == semanasDelMes.length - 1) {
      //Es la ultima semana del mes
    }
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

  semanaAnterior() {
    if (indexWeekActive == 0) {
      yearSelect = monthSelectView == 1 ? yearSelect - 1 : yearSelect; //año
      monthSelectView = monthSelectView == 1 ? 12 : monthSelectView - 1; //mes

      // Obtener todas las semanas del mes anterior
      List<List<DiaModel>> semanasDelMesAnterior =
          agregarSemanas(monthSelectView, yearSelect);

      // Encontrar la última semana del mes anterior
      int indexUltimaSemana = semanasDelMesAnterior.length - 1;

      if (semanasDelMesAnterior[indexUltimaSemana][0].value ==
          semanasDelMes[indexWeekActive][0].value) {
        indexWeekActive = indexUltimaSemana - 1;
        notifyListeners();
        return;
      }
      // Establecer el índice de la semana activa como la última semana del mes anterior
      indexWeekActive = indexUltimaSemana;
      notifyListeners();
    } else {
      indexWeekActive--;
      notifyListeners();
    }
  }

  //Devuelve un mes dependiedo de las semanas
  //si hay dias en una semana que pertenecen a un mes distinto
  int resolveMonth(int indexDay) {
    //si la semnaa seleccionada es 0 es la primer semana
    // los dias anterirores son del mes anterrior
    if (indexWeekActive == 0) {
      int inicioMes = semanasDelMes[indexWeekActive].first.value;
      if (indexDay < inicioMes) {
        return monthSelectView == 1 ? 12 : monthSelectView - 1;
      } else {
        return monthSelectView;
      }
    } else if (indexWeekActive == semanasDelMes.length - 1) {
      //si la semana seleccionada es la utima
      // los dias siguientes son del mes siguienete
      int finMes = semanasDelMes[indexWeekActive].last.value;
      if (indexDay > finMes) {
        return monthSelectView == 12 ? 1 : monthSelectView + 1;
      } else {
        return monthSelectView;
      }
    } else {
      return monthSelectView;
    }
  }

  //Devuelve un año dependiedo de las semanas
  //si hay dias en una semana que pertenecen a un año distinto
  int resolveYear(int indexDay) {
    if (indexWeekActive == 0) {
      int inicioMes = semanasDelMes[indexWeekActive].first.value;
      if (indexDay < inicioMes) {
        return monthSelectView == 1 ? yearSelect - 1 : yearSelect;
      } else {
        return yearSelect;
      }
    } else if (indexWeekActive == semanasDelMes.length - 1) {
      //si la semana seleccionada es la utima
      // los dias siguientes son del mes siguienete

      int finMes = semanasDelMes[indexWeekActive].last.value;

      if (indexDay > finMes) {
        return monthSelectView == 12 ? yearSelect + 1 : yearSelect;
      } else {
        return yearSelect;
      }
    } else {
      return yearSelect;
    }
  }

  diaSiguiente() {
    //ontener ultimo dia del mes
    int ultimodia = obtenerUltimoDiaMes(yearSelect, monthSelectView);
    // cambiar el mes y anio cuando sea el ultimo dia del mes 12
    if (monthSelectView == 12 && daySelect == ultimodia) {
      //cambio de fechas por nuvas
      monthSelectView = 1;
      yearSelect++;
      daySelect = 1;

      //obtner dias del mes y semanas
      mesCompleto = armarMes(yearSelect, monthSelectView);
      semanasDelMes = addWeeks(mesCompleto);
      // cargar(daySelect, monthSelectView, yearSelect);

      notifyListeners();
    } else {
      if (daySelect == ultimodia) {
        //cambio de fechas por nuvas
        daySelect = 1;
        monthSelectView++;
        //obtner dias del mes y semanas
        mesCompleto = armarMes(yearSelect, monthSelectView);
        semanasDelMes = addWeeks(mesCompleto);
        // cargar(daySelect, monthSelectView, yearSelect);

        notifyListeners();
      } else {
        //sumar un doa al dia seleccionado
        daySelect++;
        // cargar(daySelect, monthSelectView, yearSelect);

        notifyListeners();
      }
    }
    print("$daySelect $monthSelectView $yearSelect siguiente");
  }

  diaAnterior() {
    //buscar el ultimo dia del mes
    int ultimodia = obtenerUltimoDiaMes(yearSelect, monthSelectView - 1);

    //cambiar mes y anio si es necesario en el cambio de dia
    if (monthSelectView == 1 && daySelect == 1) {
      monthSelectView = 12;
      yearSelect--;
      daySelect = ultimodia;

      mesCompleto = armarMes(yearSelect, monthSelectView);
      //cambiar el indice de las semanas del mes correspondiente
      semanasDelMes = addWeeks(mesCompleto);

      notifyListeners();
    } else {
      if (daySelect == 1) {
        daySelect = ultimodia;
        monthSelectView--;
        mesCompleto = armarMes(yearSelect, monthSelectView);
        //cambiar el indeice de las semanas del mes que corresponda
        semanasDelMes = addWeeks(mesCompleto);
        notifyListeners();
      } else {
        //restar un dia al dia seleccionado
        daySelect--;
        notifyListeners();
      }
    }

    print(" $daySelect $monthSelectView $yearSelect regresando");
  }

  int obtenerUltimoDiaMes(int anio, int mes) {
    // Crear un objeto DateTime para el primer día del siguiente mes
    DateTime primerDiaMesSiguiente = DateTime(anio, mes + 1, 1);
    // Restar 1 día al primer día del siguiente mes para obtener el último día del mes actual
    DateTime ultimoDiaMes =
        primerDiaMesSiguiente.subtract(const Duration(days: 1));
    // Retornar el número del día del último día del mes
    return ultimoDiaMes.day;
  }

  //crear nombre de la semanas por rango
  String generateNameWeeck() {
    semanasDelMes = agregarSemanas(monthSelectView, yearSelect);
    //año seleccionado
    yearSelect;
    //dias
    int dayStart = semanasDelMes[indexWeekActive][0].value; //dia inicio
    int dayEnd = semanasDelMes[indexWeekActive][6].value; //dia fin
    //mes inicio
    int monthStart = indexWeekActive == 0 &&
            semanasDelMes[indexWeekActive][0].value >
                semanasDelMes[indexWeekActive][6].value
        ? monthSelectView == 1
            ? 12
            : monthSelectView - 1
        : monthSelectView;

    //mes fin
    int monthEnd = indexWeekActive == semanasDelMes.length - 1 &&
            semanasDelMes[indexWeekActive][6].value <
                semanasDelMes[indexWeekActive][0].value
        ? monthSelectView == 12
            ? 1
            : monthSelectView + 1
        : monthSelectView;

    //año seleccionado
    int yearStart = yearSelect; //año inicio
    int yearEnd = yearSelect; //año fin

    //solo en el mes 12 (diciembre) solo en la ultima semana
    if (monthSelectView == 12 && indexWeekActive == semanasDelMes.length - 1) {
      //si el ultimo dia es menor al primero
      if (semanasDelMes[indexWeekActive][6].value <
          semanasDelMes[indexWeekActive][0].value) {
        yearEnd = yearEnd + 1;
      }
    }

    //solo en el mes 1 (enero) solo en la primer semana
    if (monthSelectView == 1 && indexWeekActive == 0) {
      if (semanasDelMes[indexWeekActive][0].value >
          semanasDelMes[indexWeekActive][6].value) {
        yearStart = yearStart - 1;
      }
    }

    if (monthStart > monthEnd && yearStart < yearEnd) {
      return "${Utilities.nombreMes(monthStart).substring(0, 3)} de $yearStart - ${Utilities.nombreMes(monthEnd).substring(0, 3)} de $yearEnd";
    }
    if (indexWeekActive == 0 && dayStart > dayEnd ||
        indexWeekActive == semanasDelMes.length - 1 && dayStart > dayEnd) {
      return "${Utilities.nombreMes(monthStart).substring(0, 3)} - ${Utilities.nombreMes(monthEnd).substring(0, 3)}  $yearEnd";
    } else {
      return "${Utilities.nombreMes(monthSelectView).substring(0, 3)} - $yearStart";
    }
  }

  //Filtro de tareas por hora
  List<TareaCalendarioModel> tareaHorax(
      int hora, List<TareaCalendarioModel> tareas) {
    return tareas.where((objeto) {
      DateTime fechaObjeto = DateTime.parse(objeto.fechaIni);
      print(fechaObjeto);
      int horaObjeto = fechaObjeto.hour;
      return horaObjeto == hora;
    }).toList();
  }

  DateTime convertirStringADateTime(String fechaString) {
    // Formato de la fecha
    DateFormat formato = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");

    // Convertir el string a DateTime
    return formato.parse(fechaString);
  }

  // Filtro de tareas por hora
  List<TareaCalendarioModel> tareaHora(
    int hora,
    List<TareaCalendarioModel> tareas,
  ) {
    int horaTarea;
    // Filtrar la lista de tareas
    return tareas.where((tarea) {
      String fecha = tarea.fechaIni;
      horaTarea = obtenerHora(fecha);
      return hora == horaTarea;
    }).toList();
  }

  int obtenerHora(String fechaHora) {
    // Parsear la cadena de fecha y hora a un objeto DateTime
    DateTime dateTime = DateTime.parse(fechaHora);

    // Obtener la hora de la fecha y hora analizadas
    int hora = dateTime.hour;

    return hora;
  }

  // cargar(int day, int mont, int year) {
  //   List<TareaCalendarioModel> tareasDia = []; //lista local de tareas del dia
  //   tareasDia.clear(); //Limpiar lista
  //   tareasHoraActual.clear(); //Limpiar lista
  //   tareasDia = tareaDia(day, mont, year); //obtener las tareas del dia

  //   //recorrer la lista de las horas del dia
  //   for (var i = 0; i < Utilities.horasDelDia.length; i++) {
  //     //Encontrar la hora de la lista
  //     int hora = Utilities.horasDelDia[i].hora24;
  //     //Agregar a la lista de tareas de la hora actual las tareas que pertenezcan a la hora recorrida
  //     tareasHoraActual.addAll(tareaHora(hora, tareasDia));
  //   }
  //   notifyListeners();
  //   print(tareasHoraActual.length);
  // }

  List<TareaCalendarioModel> cargar(int day, int mont, int year) {
    List<TareaCalendarioModel> tareasHora = [];
    // Obtener las tareas del día
    List<TareaCalendarioModel> tareasDia = [];
    // Limpiar lista de tareas de la hora actual
    tareasDia.clear();
    tareasHora.clear();

    tareasDia = tareaDia(day, mont, year);

    // Filtrar las tareas del día por hora y agregarlas a la lista de tareas de la hora actual
    for (var tarea in tareasDia) {
      int hora = obtenerHora(tarea.fechaIni);
      if (Utilities.horasDelDia
          .any((horaDelDia) => horaDelDia.hora24 == hora)) {
        tareasHora.add(tarea);
        notifyListeners();
      }
    }
    notifyListeners();

    print(" tareas hora del dia ${tareasHora.length}");
    return tareasHora;
  }

  //dia anterior

  List<TareaCalendarioModel> tareasDia = [];

  diaAnteriorTareas() {
    tareasDia.clear(); //Limpiar lista
    //buscar el ultimo dia del mes
    int ultimodia = obtenerUltimoDiaMes(yearSelect, monthSelectView - 1);

    //cambiar mes y anio si es necesario en el cambio de dia
    if (monthSelectView == 1 && daySelect == 1) {
      monthSelectView = 12;
      yearSelect--;
      daySelect = ultimodia;

      mesCompleto = armarMes(yearSelect, monthSelectView);
      //cambiar el indice de las semanas del mes correspondiente
      semanasDelMes = addWeeks(mesCompleto);
      // cargar(daySelect, monthSelectView, yearSelect);

      notifyListeners();
    } else {
      if (daySelect == 1) {
        daySelect = ultimodia;
        monthSelectView--;
        mesCompleto = armarMes(yearSelect, monthSelectView);
        //cambiar el indeice de las semanas del mes que corresponda
        semanasDelMes = addWeeks(mesCompleto);
        // cargar(daySelect, monthSelectView, yearSelect);

        notifyListeners();
      } else {
        //restar un dia al dia seleccionado
        daySelect--;
        // cargar(daySelect, monthSelectView, yearSelect);
        notifyListeners();
      }
    }

    tareasDia.addAll(cargar(daySelect, monthSelectView, yearSelect));

    print(" $daySelect $monthSelectView $yearSelect regresando");
  }

// Función para convertir un color hexadecimal en formato RGB
  List<int> hexToRgb(String hexColor) {
    // Elimina el carácter '#'
    if (hexColor[0] == '#') {
      hexColor = hexColor.substring(1);
    }

    // Divide el color en componentes r, g y b
    int r = int.parse(hexColor.substring(0, 2), radix: 16);
    int g = int.parse(hexColor.substring(2, 4), radix: 16);
    int b = int.parse(hexColor.substring(4, 6), radix: 16);

    return [r, g, b];
  }
}
