// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/calendario/models/models.dart';

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
  int primerDiaSemana = 3; // Puedes cambiar el valor según tu necesidad

  CalendarioViewModel() {
    hoy = DateTime.now();
    crearArregloDias();
  }

  List<int> obtenerDiasDelMes(int year, int month) {
    // Lista que contendrá los días del mes
    List<int> daysInMonth = [];

    // Obtiene la cantidad de días en el mes y año dados
    int daysInThisMonth = DateTime(year, month + 1, 0).day;

    // Llena la lista con los días del mes
    for (int i = 1; i <= daysInThisMonth; i++) {
      daysInMonth.add(i);
    }
    print(daysInMonth.length);

    diasMes.addAll(daysInMonth);
    return daysInMonth;
  }

  armarSemanas(dias) {}

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

  primerDia(int inicioMes) {
    print(inicioMes);
  }

  List<String> diasSemana = [
    "Lunes",
    "Martes",
    "Miércoles",
    "Jueves",
    "Viernes",
    "Sábado",
    "Domingo"
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
    DateTime primerDia = DateTime(anio, mes - 1, 1);
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
    DateTime fecha = DateTime(anio, mes - 1, 1);
    //dias encontrados
    List<DiaModel> diasMes = [];

    //bucar cantidad de dias deseados en el mes
    for (var i = 0; i < cantidad; i++) {
      int diaSemana =
          (fecha.day + 7) % 7; // Aseguramos que el resultado esté entre 0 y 6
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

  //Dividir el mes por semanas (en semanas de 0..6)
  List<List<DiaModel>> addWeeks(List<DiaModel> diasDelMes) {
    // Lista con sublistas de semanas
    List<List<DiaModel>> semanas = [];

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
}
