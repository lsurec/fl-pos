// ignore_for_file: avoid_print

import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/calendario/models/models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/lang_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

  static List<String> diasIngles = [
    "SUNDAY",
    "MONDAY",
    "TUESDAY",
    "WEDNESDAY",
    "THURSDAY",
    "FRIDAY",
    "SATURDAY",
  ];

  static List<String> diasFrances = [
    "DIMANCHE",
    "LUNDI",
    "MARDI",
    "MERCREDI",
    "JEUDI",
    "VENDREDI",
    "SAMEDI"
  ];

  static List<String> diasAleman = [
    "SONNTAG",
    "MONTAG",
    "DIENSTAG",
    "MITTWOCH",
    "DONNERSTAG",
    "FREITAG",
    "SAMSTAG"
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

  //meses ingles
  static List<String> mesesIngles = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

//meses freances
  static List<String> mesesFrances = [
    "Janvier",
    "Février",
    "Mars",
    "Avril",
    "Mai",
    "Juin",
    "Juillet",
    "Août",
    "Septembre",
    "Octobre",
    "Novembre",
    "Décembre",
  ];

  //meses aleman

  static List<String> mesesAleman = [
    "Januar",
    "Februar",
    "März",
    "April",
    "Mai",
    "Juni",
    "Juli",
    "August",
    "September",
    "Oktober",
    "November",
    "Dezember",
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

  static String formatearFechaHora(DateTime fecha) {
    // Asegurarse de que la fecha esté en la zona horaria local
    fecha = fecha.toLocal();

    // Formatear la fecha en el formato dd/MM/yyyy
    String fechaFormateada = DateFormat('dd/MM/yyyy').format(fecha);

    // Formatear la hora en formato hh:mm a AM/PM
    String horaFormateada = DateFormat('hh:mm a').format(fecha);

    // Unir fecha y hora en el formato deseado
    String fechaHoraFormateada = '$fechaFormateada  $horaFormateada';

    return fechaHoraFormateada;
  }

  static String formatoFechaString(String? fechaHora) {
    DateTime dateTime = DateTime.parse(fechaHora ?? "");
    return '${dateTime.day.toString().padLeft(2, '0')}/'
        '${dateTime.month.toString().padLeft(2, '0')}/'
        '${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}:'
        '${dateTime.second.toString().padLeft(2, '0')}';
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
  static String nombreMes(BuildContext context, int mes) {
    final vmLang = Provider.of<LangViewModel>(context, listen: false);

    if (mes <= 0) {
      return loadMonthView(vmLang.languages[Preferences.idLanguage])[0];
    }
    return loadMonthView(vmLang.languages[Preferences.idLanguage])[mes - 1];
  }

  static loadMonthView(LanguageModel lang) {
    if (lang.lang == 'es') return nombreMeses;
    if (lang.lang == 'en') return mesesIngles;
    if (lang.lang == 'fr') return mesesFrances;
    if (lang.lang == 'de') return mesesAleman;
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

  static copyToClipboard(BuildContext context, String value) {
    FlutterClipboard.copy(value).then(
      (value) {
        NotificationService.showSnackbar(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.notificacion,
            "copiado",
          ),
        );
      },
    );
  }

  static bool fechaIgualOMayorSinSegundos(DateTime date1, DateTime date2) {
    // Crear nuevas instancias de fechas sin segundos
    DateTime dateWithoutSeconds1 = DateTime(
      date1.year,
      date1.month,
      date1.day,
      date1.hour,
      date1.minute,
    );

    DateTime dateWithoutSeconds2 = DateTime(
      date2.year,
      date2.month,
      date2.day,
      date2.hour,
      date2.minute,
    );

    // Comparar las fechas
    return dateWithoutSeconds1.isAtSameMomentAs(dateWithoutSeconds2) ||
        dateWithoutSeconds1.isAfter(dateWithoutSeconds2);
  }
}
