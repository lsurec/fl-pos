import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';

class PrintModel {
  PrintModel({
    required this.bytes,
    required this.generator,
  });

  List<int> bytes;
  Generator generator;
}
