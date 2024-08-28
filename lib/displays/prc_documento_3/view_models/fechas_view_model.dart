// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/services/language_service.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';

class FechasViewModel extends ChangeNotifier {
  //fecha actual
  DateTime fechaActual = DateTime.now();

  //Fechas
  DateTime fechaEntrega = DateTime.now();
  DateTime fechaInicial = DateTime.now();
  DateTime fechaFinal = DateTime.now();
  DateTime fechaRecoger = DateTime.now();

  abrirFechaEntrega(BuildContext context) async {
    fechaActual = DateTime.now();
    //abrir picker de la fecha inicial con la fecha actual
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: fechaActual,
      firstDate: fechaEntrega,
      lastDate: DateTime(2100),
      confirmText: AppLocalizations.of(context)!.translate(
        BlockTranslate.botones,
        'aceptar',
      ),
    );

    //si la fecha es null, no realiza nada
    if (pickedDate == null) return;

    //armar fecha con la fecha seleccionada en el picker
    fechaEntrega = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      fechaEntrega.hour,
      fechaEntrega.minute,
    );

    notifyListeners();
  }

  abrirHoraEntrega(BuildContext context) async {
    //fecha actual
    fechaActual = DateTime.now();

    //inicializar picker de la hora con la hora recibida
    TimeOfDay? initialTime = TimeOfDay(
      hour: fechaEntrega.hour,
      minute: fechaEntrega.minute,
    );

    //abre el time picker con la hora inicial
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime, //hora inicial
      builder: (BuildContext context, Widget? child) {
        return Localizations.override(
          context: context,
          locale: const Locale('en', 'ES'),
          child: child,
        );
      },
    );

    //si la hora seleccionada es null, no hacer nada.
    if (pickedTime == null) return;

    if (verificarFechas(fechaActual, fechaEntrega)) {
      print(
          "aqui las fechas son iguales ${verificarHoras(fechaActual, fechaEntrega)}");

      if (verificarHoras(fechaActual, fechaEntrega)) {
        print("aqui ${verificarHoras(fechaActual, fechaEntrega)}");

        fechaEntrega = DateTime(
          fechaEntrega.year,
          fechaEntrega.month,
          fechaEntrega.day,
          fechaActual.hour,
          fechaActual.minute,
        );

        notifyListeners();
        return;
      }
    }

    //armar fecha inicial con la fecha inicial y hora seleccionada en los picker
    fechaEntrega = DateTime(
      fechaEntrega.year,
      fechaEntrega.month,
      fechaEntrega.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    notifyListeners();
  }

  abrirFechaRecoger(BuildContext context) async {
    //fechas
  }

  abrirHoraRecoger(BuildContext context) async {
    //fechas
  }

  bool verificarHoras(DateTime fecha1, DateTime fecha2) {
    // Obtener horas y minutos de fecha1
    int horasFecha1 = fecha1.hour;
    int minutosFecha1 = fecha1.minute;

    // Obtener horas y minutos de fecha2
    int horasFecha2 = fecha2.hour;
    int minutosFecha2 = fecha2.minute;

    print("$horasFecha1 : $minutosFecha1");
    print("$horasFecha2: $minutosFecha2");

    // Comparar horas y minutos
    if (horasFecha2 <= horasFecha1 && (minutosFecha2 < minutosFecha1)) {
      return false;
    }

    return true;
  }

  restaurarFechas() {
    fechaEntrega = DateTime.now();
    fechaRecoger = addDate30Min(fechaEntrega);
    // fechaInicial = DateTime.now();
    // fechaFinal = DateTime.now();
    // fechaRecoger = DateTime.now();

    notifyListeners();
  }

  //Recibe una fecha y le asigna 10 minutos más.
  DateTime addDate30Min(DateTime fecha) {
    return fecha.add(
      const Duration(
        minutes: 30,
      ),
    );
  }

  bool verificarFechas(DateTime fecha1, DateTime fecha2) {
    return fecha1.year == fecha2.year &&
        fecha1.month == fecha2.month &&
        fecha1.day == fecha2.day;
  }
}
