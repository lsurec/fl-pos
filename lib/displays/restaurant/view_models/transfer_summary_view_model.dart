import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';

class TransferSummaryViewModel extends ChangeNotifier {
  LocationModel? locationOrigin;
  LocationModel? locationDest;
  TableModel? tableOrigin;
  TableModel? tableDest;

  int indexOrderOrigin = -1;
  int indexOrderDesr = -1;
}
