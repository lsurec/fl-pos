// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/app_Menu_Grid_01/models/models.dart';
import 'package:flutter_post_printer_example/displays/app_Menu_Grid_01/services/services.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PendingDocsViewModel extends ChangeNotifier {
  //controlar procesos
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final List<PendingDocModel> documents = [];

  Future<void> laodData(BuildContext context) async {
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final menuVM = Provider.of<MenuViewModel>(context, listen: false);
    final String token = loginVM.token;
    final String user = loginVM.nameUser;
    final int doc = menuVM.documento!;

    final ReceptionService receptionService = ReceptionService();

    documents.clear();

    isLoading = true;

    final ApiResModel res = await receptionService.getPendindgDocs(
      user,
      token,
      doc,
    );

    isLoading = false;

    if (!res.succes) {
      ErrorModel error = res.message;

      NotificationService.showErrorView(
        context,
        error,
      );

      return;
    }

    documents.addAll(res.message);
  }

  // Función para formatear la fecha en el nuevo formato deseado
  String formatDate(String fechaString) {
    DateTime dateTime = DateTime.parse(fechaString);
    // Formatear la fecha y la hora en el nuevo formato "dd/MM/yyyy HH:mm:ss"
    String formattedDate =
        DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime.toLocal());
    return formattedDate;
  }
}
