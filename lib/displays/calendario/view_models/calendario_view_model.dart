// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/calendario/models/models.dart';
import 'package:flutter_post_printer_example/displays/calendario/serivices/services.dart';
import 'package:flutter_post_printer_example/models/api_res_model.dart';
import 'package:flutter_post_printer_example/services/notification_service.dart';
import 'package:flutter_post_printer_example/view_models/login_view_model.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
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

  //Variables a utlizar en e calendario

  bool vistaMes = true; // ver el mes
  bool vistaSemana = false; //ver la semana
  bool vistaDia = false; // ver el día

  List<DiaModel> diasDelMes = []; //dias del mes seleccionado
  bool diasFueraMes = false; //confirmar si hay mpas dias que son fuera del mes

  List<DiaModel> mesCompleto = [];

  //fecha de hoy (fecha de la maquina)
  DateTime? fechaHoy; //fecha completa DateNow
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
    mesCompleto.clear();
    fechaHoy = DateTime.now();

    //obtener feccha de hoy y asignar
    today = fechaHoy!.day; //fecha del dia
    month = fechaHoy!.month; //mes
    year = fechaHoy!.year; // año

    nuevoMes(month, year);

    List<DiaModel> mesSeleccionado = armarMes(month, year);

    mesCompleto.addAll(mesSeleccionado);

    monthSelectView = month; //mes
    yearSelect = year; //año

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

    obtenerTareasCalendario(context);

    semanasDelMes = await addWeeks(mesCompleto);

    indexWeekActive = 0;

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

  List<DiaModel> armarMes(int mes, int anio) {
    List<DiaModel> completarMes = [];
    int mesAnterior = month - 1;
    List<DiaModel> diasMesAnterior = obtenerDiasDelMes(mesAnterior, anio);

    diasDelMes = obtenerDiasDelMes(monthSelectView, yearSelect);

    primerDiaIndex = diasDelMes.first.indexWeek;
    ultimoDiaIndex = diasDelMes.last.indexWeek;

    if (primerDiaIndex == 6 || ultimoDiaIndex == 0) {
      numSemanas = 6;
      notifyListeners();
    } else {
      numSemanas = 5;
      notifyListeners();
    }

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
    notifyListeners();

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
    // // Imprimir los días del mes
    // for (var dia in mesCompleto) {
    //   print(
    //     "Nombre: ${dia.name}, Valor: ${dia.value}, Índice de la semana: ${dia.indexWeek}",
    //   );
    // }
  }

  mesSiguiente() async {
    //cambiar año y mes si es necesario
    yearSelect = monthSelectView == 12 ? yearSelect + 1 : yearSelect; //año
    monthSelectView = monthSelectView == 12 ? 1 : monthSelectView + 1; //mes
    mesCompleto = await armarMes(monthSelectView, yearSelect);
    nombreMes(monthSelectView, yearSelect);

    notifyListeners();
  }

  mesAnterior() async {
    //cambiar año y mes si es necesario
    yearSelect = monthSelectView == 1 ? yearSelect - 1 : yearSelect; //año
    monthSelectView = monthSelectView == 1 ? 12 : monthSelectView - 1; //mes

    mesCompleto = await armarMes(monthSelectView, yearSelect);
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

  bool diasAnteriores(int dia, int index) {
    List<DiaModel> dias = obtenerDiasDelMes(monthSelectView, yearSelect);

    if (index >= 0 && index < 7 && dia > dias[6].value) {
      return true;
    }
    return false;
  }

  bool diasSiguientes(int dia, int index) {
    List<DiaModel> dias = [];

    dias.addAll(mesCompleto);

    final int ultimoDiaMes = dias.last.value;
    final List<DiaModel> diasUltimaSemana = dias.sublist(dias.length - 7);

    // print(
    //   "${diasUltimaSemana[0].value}  ${diasUltimaSemana[diasUltimaSemana.length - 1].value} ",
    // );

    if (index >= dias.length - 7 &&
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

    mesCompleto = await armarMes(monthSelectView, yearSelect);

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

    // print("tareas asigandas al usuario ${tareas.length}");

    // String nuevaFecha = convertDateFormat(tareas[0].fechaIni);
    // print(nuevaFecha);

    isLoading = false; //detener carga
  }

  String convertDateFormat(String inputDate) {
    print(inputDate);

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

    //para no mostrra en la ultima semana
    // if (i >= dias[dias.length - 5].indexWeek) {
    //   return false;
    // }

    return true;
  }

  //Dividir el mes por semanas (en semanas de 0..6)
  Future<List<List<DiaModel>>> addWeeks(List<DiaModel> diasDelMes) async {
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

  verrr() async {
    List<List<DiaModel>> semanass = await addWeeks(mesCompleto);
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


  //armar el mes

  List<DiaModel> nuevoMes(int mes, int anio) {
    mesCompleto.clear();
    int mesAnterior = month - 1;
    List<DiaModel> diasMesAnterior = obtenerDiasDelMes(mesAnterior, anio);

    diasDelMes = obtenerDiasDelMes(monthSelectView, yearSelect);

    primerDiaIndex = diasDelMes.first.indexWeek;
    ultimoDiaIndex = diasDelMes.last.indexWeek;

    if (primerDiaIndex == 6 || ultimoDiaIndex == 0) {
      numSemanas = 6;
      notifyListeners();
    } else {
      numSemanas = 5;
      notifyListeners();
    }

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
    notifyListeners();

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
    notifyListeners();

    return mesCompleto;
  }
}
