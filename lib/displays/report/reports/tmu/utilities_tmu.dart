import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_post_printer_example/displays/report/models/models.dart';
import 'package:intl/intl.dart';

class UtilitiesTMU {
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
