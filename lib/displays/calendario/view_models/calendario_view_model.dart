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

  final List<int> dias = [];
  DateTime? hoy;

  CalendarioViewModel() {
    hoy = DateTime.now();

    List<int> dias = obtenerDiasDelMes(hoy!.year, hoy!.month);
    print(dias.length);
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

    return daysInMonth;
  }

}
