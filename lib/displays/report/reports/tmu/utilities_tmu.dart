import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_post_printer_example/displays/report/models/models.dart';
import 'package:intl/intl.dart';

class UtilitiesTMU {
  //Author data (DEMOSOFT)
  static AuthorModel author = AuthorModel(
    nombre: "Desarrollo Moderno de Software S.A.",
    website: "demosoft.com.gt",
  );

  //get date now in format dd-MM-yyyy HH:mm:ss
  static String getDateDDMMYYYY() {
    //get date now
    DateTime now = DateTime.now();

    // Format the date and time
    String formattedDate = DateFormat('dd-MM-yyyy HH:mm:ss').format(now);

    //return formated date
    return formattedDate;
  }

  //style for center text
  static PosStyles center = const PosStyles(
    align: PosAlign.center,
  );

  //syle for center and bold text
  static PosStyles centerBold = const PosStyles(
    align: PosAlign.center,
    bold: true,
  );

  //bold an left or start text
  static PosStyles startBold = const PosStyles(
    align: PosAlign.left,
    bold: true,
  );
}
