import 'package:intl/intl.dart';

class Utilities {
  static String strDate(String dateStr) {
    // Convierte la cadena a un objeto DateTime
    DateTime dateTime = DateTime.parse(dateStr);

    // Formatea la fecha en el formato dd/MM/yyyy
    String formattedDate = DateFormat('dd/MM/yyyy hh:mm').format(dateTime);

    return formattedDate;
  }

  static String formatComplete(DateTime dateTime) {
    // Convierte la cadena a un objeto DateTime

    // Formatea la fecha en el formato dd/MM/yyyy
    String formattedDate = DateFormat('dd/MM/yyyy hh:mm').format(dateTime);

    return formattedDate;
  }

  //Formatear fecha
  static String formatearFecha(DateTime fecha) {
    // Asegurarse de que la fecha esté en la zona horaria local
    fecha = fecha.toLocal();

    // Formatear la fecha en el formato dd-mm-yyyy
    String fechaFormateada = DateFormat('dd/MM/yyyy').format(fecha);

    return fechaFormateada;
  }

  static //Formatear hora
      String formatearHora(DateTime fecha) {
    // Asegurarse de que la fecha esté en la zona horaria local
    fecha = fecha.toLocal();

    // Formatear la hora en formato hh:mm a AM/PM
    String horaFormateada = DateFormat('hh:mm a').format(fecha);

    return horaFormateada;
  }
}
