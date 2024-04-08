// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/calendario/models/dia_model.dart';

class CalendarioNuevoViewModel extends ChangeNotifier {
  //cargar pantalla
  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //Vistas del calendario
  bool vistaMes = true; // ver el mes
  bool vistaSemana = false; //ver la semana
  bool vistaDia = false; // ver el día

  List<DiaModel> diasDelMes = []; //dias del mes seleccionado
  bool diasFueraMes = false; //confirmar si hay mpas dias que son fuera del mes

  //fecha de hoy (fecha de la maquina)
  DateTime? fechaHoy; //fecha completa DateNow
  int today = 0; //fecha dia
  int month = 0; //fecha mesooo
  int year = 0; //fecha año

  Future<void> loadData(BuildContext context) async {
    fechaHoy = DateTime.now();

    print(fechaHoy);
  }
}
