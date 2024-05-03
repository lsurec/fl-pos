// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter_post_printer_example/displays/calendario/models/models.dart';
import 'package:intl/intl.dart';

class Utilities {
  //Nombre Dias Semana
  static List<String> diasSemana = [
    "Domingo",
    "Lunes",
    "Martes",
    "Miércoles",
    "Jueves",
    "Viernes",
    "Sábado",
  ];

  //Nombre de los meses del año
  static List<String> nombreMeses = [
    "Enero",
    "Febrero",
    "Marzo",
    "Abril",
    "Mayo",
    "Junio",
    "Julio",
    "Agosto",
    "Septiembre",
    "Octubre",
    "Noviembre",
    "Diciembre",
  ];
  //Lista de horas
  static List<HorasModel> horasDelDia = [
    HorasModel(
      hora24: 0,
      hora12: "12:00 am",
      visible: true,
    ),
    HorasModel(
      hora24: 1,
      hora12: "1:00 am",
      visible: true,
    ),
    HorasModel(
      hora24: 2,
      hora12: "2:00 am",
      visible: true,
    ),
    HorasModel(
      hora24: 3,
      hora12: "3:00 am",
      visible: true,
    ),
    HorasModel(
      hora24: 4,
      hora12: "4:00 am",
      visible: true,
    ),
    HorasModel(
      hora24: 5,
      hora12: "5:00 am",
      visible: true,
    ),
    HorasModel(
      hora24: 6,
      hora12: "6:00 am",
      visible: true,
    ),
    HorasModel(
      hora24: 7,
      hora12: "7:00 am",
      visible: true,
    ),
    HorasModel(
      hora24: 8,
      hora12: "8:00 am",
      visible: true,
    ),
    HorasModel(
      hora24: 9,
      hora12: "9:00 am",
      visible: true,
    ),
    HorasModel(
      hora24: 10,
      hora12: "10:00 am",
      visible: true,
    ),
    HorasModel(
      hora24: 11,
      hora12: "11:00 am",
      visible: true,
    ),
    HorasModel(
      hora24: 12,
      hora12: "12:00 pm",
      visible: true,
    ),
    HorasModel(
      hora24: 13,
      hora12: "1:00 pm",
      visible: true,
    ),
    HorasModel(
      hora24: 14,
      hora12: "2:00 pm",
      visible: true,
    ),
    HorasModel(
      hora24: 15,
      hora12: "3:00 pm",
      visible: true,
    ),
    HorasModel(
      hora24: 16,
      hora12: "4:00 pm",
      visible: true,
    ),
    HorasModel(
      hora24: 17,
      hora12: "5:00 pm",
      visible: true,
    ),
    HorasModel(
      hora24: 18,
      hora12: "6:00 pm",
      visible: true,
    ),
    HorasModel(
      hora24: 19,
      hora12: "7:00 pm",
      visible: true,
    ),
    HorasModel(
      hora24: 20,
      hora12: "8:00 pm",
      visible: true,
    ),
    HorasModel(
      hora24: 21,
      hora12: "9:00 pm",
      visible: true,
    ),
    HorasModel(
      hora24: 22,
      hora12: "10:00 pm",
      visible: true,
    ),
    HorasModel(
      hora24: 23,
      hora12: "11:00 pm",
      visible: true,
    )
  ];

  //Formatear fecha
  static String formatearFecha(DateTime fecha) {
    // Asegurarse de que la fecha esté en la zona horaria local
    fecha = fecha.toLocal();

    // Formatear la fecha en el formato dd-mm-yyyy
    String fechaFormateada = DateFormat('dd/MM/yyyy').format(fecha);

    return fechaFormateada;
  }

  //Formatear hora
  static String formatearHora(DateTime fecha) {
    // Asegurarse de que la fecha esté en la zona horaria local
    fecha = fecha.toLocal();

    // Formatear la hora en formato hh:mm a AM/PM
    String horaFormateada = DateFormat('hh:mm a').format(fecha);

    return horaFormateada;
  }

  static String formatearFechaString(String fecha) {
    // Parsear la cadena de fecha
    DateTime fechaParseada = DateTime.parse(fecha);

    // Formatear la fecha según el formato deseado
    String fechaFormateada = DateFormat('dd/MM/yyyy').format(fechaParseada);

    return fechaFormateada;
  }

  static String formatearHoraString(String fecha) {
    // Parsear la cadena de fecha
    DateTime fechaParseada = DateTime.parse(fecha);

    // Formatear la hora en formato de 12 horas (AM/PM)
    String horaAMPM = DateFormat('h:mm a').format(fechaParseada);

    return horaAMPM;
  }

  //Nombre mes
  static String nombreMes(int mes) {
    if (mes <= 0) {
      return nombreMeses[0];
    }
    return nombreMeses[mes - 1];
  }

  // Función para convertir un color hexadecimal en formato RGB
  static List<int> hexToRgb(String hexColor) {
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

    static String nombreArchivo(File archivo) {
    // Obtener el path del archivo
    String path = archivo.path;

    // Utilizar la función basename para obtener solo el nombre del archivo
    String nombreArchivo = File(path).path.split('/').last;

    return nombreArchivo;
  }
}
