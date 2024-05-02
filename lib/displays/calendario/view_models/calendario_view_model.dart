// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:async';

import 'package:flutter_post_printer_example/displays/calendario/models/models.dart';
import 'package:flutter_post_printer_example/displays/calendario/serivices/services.dart';
import 'package:flutter_post_printer_example/displays/calendario/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/notification_service.dart';
import 'package:flutter_post_printer_example/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CalendarioViewModel extends ChangeNotifier {
  //cargar pantalla
  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //Variables a utlizar en e calendario

  bool vistaMes = true;
  bool vistaSemana = false;
  bool vistaDia = false;

  List<DiaModel> diasDelMes = [];

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
  //Lista que tiene las horas del dia
  List<HorasModel> horasDelDia = Utilities.horasDelDia;
  //Lista que tiene los nombres de los dias
  List<String> diasSemana = Utilities.diasSemana;
  //Contiene los dias del mes con semanas completas
  List<DiaModel> mesCompleto = [];
  //Contiene las tareas del usuario
  List<TareaCalendarioModel> tareas = [];

  // Encontrar el índice del primer día del mes
  int primerDiaIndex = 0;
  int ultimoDiaIndex = 0;
  int numSemanas = 0;

  Future<void> loadData(BuildContext context) async {
    fechaHoy = DateTime.now();
    fechaPicker = DateTime.now();

    today = fechaHoy.day;
    month = fechaHoy.month;
    year = fechaHoy.year;
    diasDelMes = obtenerDiasDelMes(month, year);

    mesCompleto = armarMes(month, year);

    monthSelectView = month; //mes
    yearSelect = year; //año
    daySelect = today; //hoy

    semanasDelMes = agregarSemanas(month, year);

    if (vistaSemana) {
      //Buscar la semana que tiene el día de hoy
      for (var i = 0; i < semanasDelMes.length; i++) {
        List<DiaModel> semana = semanasDelMes[i];
        for (var j = 0; j < semana.length; j++) {
          if (semana[j].value == today) {
            indexWeekActive = i;
            notifyListeners();
            break;
          }
        }
      }
    } else {
      indexWeekActive = 0;
    }

    obtenerTareasRango(context, monthSelectView, yearSelect);

    notifyListeners();
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

  mesSiguiente(
    BuildContext context,
  ) async {
    //cambiar año y mes si es necesario
    yearSelect = monthSelectView == 12 ? yearSelect + 1 : yearSelect; //año
    monthSelectView = monthSelectView == 12 ? 1 : monthSelectView + 1; //mes

    await obtenerTareasRango(context, monthSelectView, yearSelect);
    notifyListeners();
  }

  mesAnterior(
    BuildContext context,
  ) async {
    //cambiar año y mes si es necesario
    yearSelect = monthSelectView == 1 ? yearSelect - 1 : yearSelect; //año
    monthSelectView = monthSelectView == 1 ? 12 : monthSelectView - 1; //mes
    await obtenerTareasRango(context, monthSelectView, yearSelect);

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

    isLoading = false; //detener carga
  }

  obtenerTareasRango(BuildContext context, int mes, int anio) async {
    int anioInicial = mes == 1 ? anio - 1 : anio;
    int mesInicial = mes == 1 ? 12 : mes - 1;

    int anioFinal = mes == 12 ? anio + 1 : anio;
    int mesFinal = mes == 12 ? 1 : mes + 1;

    // Agregamos un cero delante si el número del mes es menor que 10
    String mesIniCero =
        mesInicial < 10 ? '0$mesInicial' : mesInicial.toString();
    String mesFinCero = mesFinal < 10 ? '0$mesFinal' : mesFinal.toString();

    int ultimoDia = obtenerUltimoDiaMes(anioFinal, mesFinal);

    String mesAnterior = '$anioInicial$mesIniCero${"01"} 00:00:00';
    String mesSiguiente = '$anioFinal$mesFinCero$ultimoDia 23:59:59';

    tareas.clear(); //limpiar lista

    //obtener token y usuario
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.user;

    //instancia del servicio
    final CalendarioTareaService tareaService = CalendarioTareaService();

    isLoading = true; //cargar pantalla

    //consumo de api
    final ApiResModel res = await tareaService.getRangoTareasCalendario(
      user,
      token,
      mesAnterior,
      mesSiguiente,
    );
    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;
      NotificationService.showErrorView(context, res);
      return;
    }
    //agregar tareas encontradas a la lista de tareas
    tareas.addAll(res.message);
    isLoading = false; //detener carga
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

  //Verificar si una fecha es del mes seleccionado del (1 al 31 o fin de mes)
  bool monthCurrent(int date, int i) {
    //lista de los dias del mes completo semanas completas
    List<DiaModel> dias = armarMes(monthSelectView, yearSelect);
    semanasDelMes = agregarSemanas(monthSelectView, yearSelect);
    //evaluar primera semana
    if (i >= 0 && i < 7 && date > semanasDelMes[0][6].value) {
      return false;
    }
    //evaluar ultima semana
    if (i >= dias.length - 6 &&
        i < dias.length &&
        date < semanasDelMes[semanasDelMes.length - 1][0].value) {
      return false;
    }

    //son dias del mes
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

  mostrarVistaMes(BuildContext context) {
    vistaMes = true;
    vistaDia = false;
    vistaSemana = false;
    Navigator.pop(context);
    notifyListeners();
  }

  mostrarVistaSemana(BuildContext context) async {
    //Buscar la semana que tiene el día de hoy
    for (var i = 0; i < semanasDelMes.length; i++) {
      List<DiaModel> semana = semanasDelMes[i];
      for (var j = 0; j < semana.length; j++) {
        if (semana[j].value == today) {
          indexWeekActive = i;
          notifyListeners();
          break;
        }
      }
    }

    //mostrar la vista y ocultar las demás
    vistaSemana = true;
    vistaMes = false;
    vistaDia = false;

    //cargar las tareas cuando se selecciona la vista por semana
    await obtenerTareasRango(context, monthSelectView, yearSelect);
    Navigator.pop(context);
    notifyListeners();
  }

  mostrarVistaDia(BuildContext context, int navegar) {
    vistaDia = true;
    vistaSemana = false;
    vistaMes = false;

    if (navegar == 0) {
      Navigator.pop(context);
    }
    notifyListeners();
  }

  //Navegar a vista Dia desde la vista del mes de manera correcta
  diaCorrectoMes(BuildContext context, DiaModel diaSeleccionado, int indexDay,
      int mes, int anio) {
    List<List<DiaModel>> semanas = agregarSemanas(mes, anio);

    List<DiaModel> primeraSemana = semanas[0];
    List<DiaModel> ultimaSemana = semanas[semanas.length - 1];

    //Para almacenar el dia numero 1 del mes
    DiaModel? inicoMes;

    //obtener el ultimo dia mayor de la ultima semana
    DiaModel finMes = ultimaSemana.reduce(
      (currentMax, dia) => dia.value > currentMax.value ? dia : currentMax,
    );

    // Recorrer la primera semana para encontrar el primer día del mes (día 1)
    for (int i = 0; i < primeraSemana.length; i++) {
      DiaModel dia = primeraSemana[i];
      if (dia.value == 1) {
        inicoMes = dia; // Asignar el día encontrado a la variable inicioMes
        break; // Salir del bucle una vez encontrado el primer día del mes
      }
    }

    if (indexDay >= 0 && indexDay <= 6) {
      if (diaSeleccionado.indexWeek < inicoMes!.indexWeek) {
        anio = mes == 1 ? anio - 1 : anio; //año
        mes = mes == 1 ? 12 : mes - 1; //mes

        //asignar valores a la fecha del dia que se visualizará
        daySelect = diaSeleccionado.value;
        monthSelectView = mes;
        yearSelect = anio;
        mostrarVistaDia(context, 1);
      }
    }

    //si la semana seleccionada es la utima
    if (indexDay >= (mesCompleto.length - 7) &&
        indexDay >= semanas[semanas.length - 1].length - 1) {
      // los dias siguientes son del mes siguienete

      if (diaSeleccionado.indexWeek > finMes.indexWeek) {
        //cambiar año y mes si es necesario
        anio = monthSelectView == 12 ? anio + 1 : anio; //año
        mes = mes == 12 ? 1 : mes + 1; //mes

        //asignar valores a la fecha del dia que se visualizará
        daySelect = diaSeleccionado.value;
        monthSelectView = mes;
        yearSelect = anio;
        mostrarVistaDia(context, 1);
      }
    }

    //asignar valores a la fecha del dia que se visualizará
    daySelect = diaSeleccionado.value;
    monthSelectView = mes;
    yearSelect = anio;

    //fecha picker
    fechaPicker = DateTime(yearSelect, monthSelectView, daySelect);
    mostrarVistaDia(context, 1);
  }

  diaCorrectoSemana(
      BuildContext context, DiaModel diaSeleccionado, int mes, int anio) {
    List<List<DiaModel>> semanas = agregarSemanas(mes, anio);

    List<DiaModel> primeraSemana = semanas[0];
    List<DiaModel> ultimaSemana = semanas[semanas.length - 1];

    //obtener el ultimo dia mayor de la ultima semana
    DiaModel finMes = ultimaSemana.reduce(
      (currentMax, dia) => dia.value > currentMax.value ? dia : currentMax,
    );

    //Para almacenar el dia numero 1 del mes
    DiaModel? inicioMes;

    //recorrer semana para encontrar el primer dia del mes (dia 1)
    for (int i = 0; i < primeraSemana.length; i++) {
      DiaModel dia = primeraSemana[i];
      if (dia.value == 1) {
        inicioMes = dia;
      }
    }

    //Si estamos en la primera semana
    if (indexWeekActive == 0) {
      if (diaSeleccionado.indexWeek < inicioMes!.indexWeek) {
        anio = mes == 1 ? anio - 1 : anio; //año
        mes = mes == 1 ? 12 : mes - 1; //mes

        //asignar valores a la fecha del dia que se visualizará
        daySelect = diaSeleccionado.value;
        monthSelectView = mes;
        yearSelect = anio;
        mostrarVistaDia(context, 1);
      }
    }

    //si estamos en la ultima semana
    if (indexWeekActive == semanas.length - 1) {
      if (diaSeleccionado.indexWeek > finMes.indexWeek) {
        //cambiar año y mes si es necesario
        anio = monthSelectView == 12 ? anio + 1 : anio; //año
        mes = mes == 12 ? 1 : mes + 1; //mes

        //asignar valores a la fecha del dia que se visualizará
        daySelect = diaSeleccionado.value;
        monthSelectView = mes;
        yearSelect = anio;
        mostrarVistaDia(context, 1);
      }
    }

    //si estamos en los dias del mes:
    daySelect = diaSeleccionado.value;
    monthSelectView = mes;
    yearSelect = anio;
    //fecha picker
    fechaPicker = DateTime(yearSelect, monthSelectView, daySelect);
    mostrarVistaDia(context, 1);
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

  semanaSiguiente(
    BuildContext context,
  ) async {
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

    await obtenerTareasRango(context, monthSelectView, yearSelect);
  }

  semanaAnterior(
    BuildContext context,
  ) async {
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
    await obtenerTareasRango(context, monthSelectView, yearSelect);
  }

  //Devuelve un mes dependiedo de las semanas
  //si hay dias en una semana que pertenecen a un mes distinto
  int resolveMonth(int indexDay) {
    //si la semnaa seleccionada es 0 es la primer semana
    // los dias anterirores son del mes anterrior
    if (indexWeekActive == 0) {
      int inicioMes = indicediaMenor(semanasDelMes[0]);
      if (indexDay < inicioMes) {
        return monthSelectView == 1 ? 12 : monthSelectView - 1;
      } else {
        return monthSelectView;
      }
    } else if (indexWeekActive == semanasDelMes.length - 1) {
      //si la semana seleccionada es la utima
      // los dias siguientes son del mes siguienete
      int finMes = indicediaMayor(semanasDelMes[semanasDelMes.length - 1]);
      if (indexDay > finMes) {
        return monthSelectView == 12 ? 1 : monthSelectView + 1;
      } else {
        return monthSelectView;
      }
    } else {
      return monthSelectView;
    }
  }

  int indicediaMenor(List<DiaModel> primeraSemana) {
    int indexPrimerDia = 0;
    for (var i = 0; i < primeraSemana.length; i++) {
      DiaModel primerDia = primeraSemana[i];
      if (primerDia.value == 1) {
        indexPrimerDia = primerDia.indexWeek;
        return indexPrimerDia;
      }
    }
    return indexPrimerDia;
  }

  int indicediaMayor(List<DiaModel> ultimaSemana) {
    int indexUltimoDia = 0;
    for (var i = 0; i < ultimaSemana.length; i++) {
      DiaModel ultimoDia = ultimaSemana[i];
      if (ultimoDia.value == obtenerUltimoDiaMes(yearSelect, monthSelectView)) {
        indexUltimoDia = ultimoDia.indexWeek;
        return indexUltimoDia;
      }
    }
    return indexUltimoDia;
  }

  //Devuelve un año dependiedo de las semanas
  //si hay dias en una semana que pertenecen a un año distinto
  int resolveYear(int indexDay) {
    if (indexWeekActive == 0) {
      int inicioMes = indicediaMenor(semanasDelMes[0]);
      if (indexDay < inicioMes) {
        return monthSelectView == 1 ? yearSelect - 1 : yearSelect;
      } else {
        return yearSelect;
      }
    } else if (indexWeekActive == semanasDelMes.length - 1) {
      //si la semana seleccionada es la utima
      // los dias siguientes son del mes siguienete
      int finMes = indicediaMayor(semanasDelMes[semanasDelMes.length - 1]);
      if (indexDay > finMes) {
        return monthSelectView == 12 ? yearSelect + 1 : yearSelect;
      } else {
        return yearSelect;
      }
    } else {
      return yearSelect;
    }
  }

  diaSiguiente(BuildContext context) async {
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

      notifyListeners();
    } else {
      if (daySelect == ultimodia) {
        //cambio de fechas por nuvas
        daySelect = 1;
        monthSelectView++;
        //obtner dias del mes y semanas
        mesCompleto = armarMes(yearSelect, monthSelectView);
        semanasDelMes = addWeeks(mesCompleto);

        notifyListeners();
      } else {
        //sumar un doa al dia seleccionado
        daySelect++;

        notifyListeners();
      }
    }
  }

  diaAnterior(BuildContext context) async {
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

  //Consumo de servicios para navegar a los detalles de la tarea
  navegarDetalleTarea(
    BuildContext context,
    TareaCalendarioModel tarea,
  ) async {
    isLoading = true; //cargar pantalla
    //view model de Detalle
    final vmDetalle = Provider.of<DetalleTareaCalendarioViewModel>(
      context,
      listen: false,
    );

    vmDetalle.tarea = tarea; //guardar la tarea
    final ApiResModel succesResponsables = await vmDetalle.obtenerResponsable(
      context,
      tarea.tarea,
    ); //obtener responsable activo de la tarea

    if (!succesResponsables.succes) {
      isLoading = false;
      return;
    }

    final ApiResModel succesInvitados = await vmDetalle.obtenerInvitados(
      context,
      tarea.tarea,
    ); //obtener invitados de la tarea

    if (!succesInvitados.succes) {
      isLoading = false;
      return;
    }

    //viwe model de Crear tarea
    final vmCrear = Provider.of<CrearTareaViewModel>(context, listen: false);
    final bool succesEstados = await vmCrear.obtenerEstados(
      context,
    ); //obtener estados de tarea

    if (!succesEstados) {
      isLoading = false;
      return;
    }
    final bool succesPrioridades = await vmCrear.obtenerPrioridades(
      context,
    ); //obtener prioridades de la tarea

    if (!succesPrioridades) {
      isLoading = false;
      return;
    }

    //Mostrar estado actual de la tarea en ls lista de estados
    for (var i = 0; i < vmCrear.estados.length; i++) {
      EstadoModel estado = vmCrear.estados[i];
      if (estado.estado == tarea.estado) {
        vmDetalle.estadoAtual = estado;
        break;
      }
    }
    //Mostrar prioridad actual de la tarea en ls lista de prioridades
    for (var i = 0; i < vmCrear.prioridades.length; i++) {
      PrioridadModel prioridad = vmCrear.prioridades[i];
      if (prioridad.nivelPrioridad == tarea.nivelPrioridad) {
        vmDetalle.prioridadActual = prioridad;
        break;
      }
    }

    //validar resppuesta de los comentarios
    final bool succesComentarios = await armarComentario(context);

    //sino se realizo el consumo correctamente retornar
    if (!succesComentarios) {
      isLoading = false;
      return;
    }

    //Navegar a detalles
    Navigator.pushNamed(context, AppRoutes.detailsTaskCalendar);
    isLoading = false; //detener carga
  }

  //Armar comentarios con objetos adjuntos
  Future<bool> armarComentario(BuildContext context) async {
    final vmComentario =
        Provider.of<ComentariosViewModel>(context, listen: false);
    vmComentario.comentarioDetalle.clear(); //limpiar lista de detalleComentario

    //View model de Detalle tarea para obtener el id de la tarea
    final vmTarea =
        Provider.of<DetalleTareaCalendarioViewModel>(context, listen: false);

    //Obtener comentarios de la tarea
    ApiResModel comentarios =
        await vmTarea.obtenerComentario(context, vmTarea.tarea!.tarea);

    //Sino encontró comentarios retornar false
    if (!comentarios.succes) return false;

    //Recorrer lista de comentarios para obtener los objetos de los comentarios
    for (var i = 0; i < comentarios.message.length; i++) {
      final ComentarioModel coment = comentarios.message[i];

      //Obtener los objetos del comentario
      ApiResModel objeto = await vmTarea.obtenerObjetoComentario(
        context,
        vmTarea.tarea!.tarea,
        coment.tareaComentario,
      );

      //comentario completo (comentario y objetos)
      vmComentario.comentarioDetalle.add(ComentarioDetalleModel(
        comentario: comentarios.message[i],
        objetos: objeto.message,
      ));
    }

    //si todo está bien retornar true
    return true;
  }

  //Realizar consumos y navegar a crear tarea
  navegarCrearTarea(
    BuildContext context,
    HorasModel hora,
    int dia,
    int mes,
    int anio,
  ) async {
    DateTime fechaHoraActual = DateTime.now();

    DateTime fechaEnviar;

    if (anio == yearSelect &&
        mes == monthSelectView &&
        dia == today &&
        hora.hora24 == fechaHoraActual.hour) {
      //si es la misma hora dia mes y anio enviar los minutos actuales
      fechaEnviar = DateTime(
        anio,
        mes,
        dia,
        hora.hora24,
        fechaHoy.minute,
      );
    } else {
      //Armar fecha para la tarea con los parametros recibidos y minutos en cero :00
      fechaEnviar = DateTime(
        anio,
        mes,
        dia,
        hora.hora24,
        0,
      );
    }

    //view models Crear Tarea
    final vmCrear = Provider.of<CrearTareaViewModel>(context, listen: false);
    vmCrear.idPantalla = 2; //desde calendario

    isLoading = true; //cargar pantalla
    //consumos
    final bool succesTipos =
        await vmCrear.obtenerTiposTarea(context); //tipos de tarea

    if (!succesTipos) {
      isLoading = false;
      return;
    }

    final bool succesEstados =
        await vmCrear.obtenerEstados(context); //estados de tarea
    if (!succesEstados) {
      isLoading = false;
      return;
    }
    final bool succesPrioridades =
        await vmCrear.obtenerPrioridades(context); //prioridades de tarea
    if (!succesPrioridades) {
      isLoading = false;
      return;
    }

    final bool succesPeriodicidades =
        await vmCrear.obtenerPeriodicidad(context); //periodicidades
    if (!succesPeriodicidades) {
      isLoading = false;
      return;
    }

    vmCrear.fechaInicial = fechaEnviar;
    vmCrear.fechaFinal = vmCrear.addDate10Min(vmCrear.fechaInicial);

    vmCrear.files.clear();

    //Navegar a la vista de crear tareas
    Navigator.pushNamed(context, AppRoutes.createTask);

    isLoading = false; //Detener carga
  }

  //mostrra icono en la vista del dia en las horas correspondientes
  mostrarIconoHora(int dia, HorasModel hora) {
    //en el dia de hoy solo mostrar el icono en las horas posteriores a la hora actual del dia de hoy
    if (today == dia && hora.hora24 >= fechaHoy.hour) {
      return true;
    }
    //sino es el dia de hoy mostrar el icono en todas las horas
    if (dia > today) {
      return true;
    }

    return false;
  }

  DateTime fechaPicker = DateTime.now();

  Future<void> abrirPickerCalendario(BuildContext context) async {
    //abrir picker de la fecha inicial con la fecha actual
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: fechaPicker,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    //si la fecha es null, no realiza nada
    if (pickedDate == null) return;

    if (vistaMes) {
      yearSelect = pickedDate.year;
      monthSelectView = pickedDate.month;
      daySelect = pickedDate.day;
      fechaPicker = DateTime(yearSelect, monthSelectView, daySelect);
      notifyListeners();
    }

    List<List<DiaModel>> nuevasSemanas = agregarSemanas(
      pickedDate.month,
      pickedDate.year,
    );

    if (vistaSemana) {
      //Buscar la semana que tiene el día de hoy
      for (var i = 0; i < nuevasSemanas.length; i++) {
        List<DiaModel> semana = nuevasSemanas[i];
        for (var j = 0; j < semana.length; j++) {
          if (semana[j].value == pickedDate.day) {
            indexWeekActive = i;
            notifyListeners();
            break;
          }
        }
      }

      yearSelect = pickedDate.year;
      monthSelectView = pickedDate.month;
      daySelect = pickedDate.day;
      fechaPicker = DateTime(yearSelect, monthSelectView, daySelect);

      notifyListeners();
    }

    if (vistaDia) {
      yearSelect = pickedDate.year;
      monthSelectView = pickedDate.month;
      daySelect = pickedDate.day;
      fechaPicker = DateTime(yearSelect, monthSelectView, daySelect);
      notifyListeners();
    }

    notifyListeners();
  }

  Timer? timer; // Temporizador

  void buscarRefTemp(BuildContext context) {
    timer?.cancel(); // Cancelar el temporizador existente si existe
    timer = Timer(const Duration(milliseconds: 1000), () {
      // Función de filtrado que consume el servicio
      FocusScope.of(context).unfocus(); //ocultar teclado
      diaAnterior(context);
    }); // Establecer el período de retardo en milisegundos (en este caso, 1000 ms o 1 segundo)
  }
}
