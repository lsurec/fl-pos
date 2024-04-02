// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

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

  CalendarioViewModel() {
    hoy = DateTime.now();
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

  primerDiaSemana(int inicioMes) {
    print(inicioMes);
  }
}
