import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/utilities/utilities.dart';

class ErrorInfoViewModel extends ChangeNotifier {
  copyPa(
    BuildContext context,
    ApiResponseModel data,
  ) {
    // Convertir los parámetros en formato SQL
    String paramString = data.parameters!.entries.map((e) {
      String value = (e.value is String) ? "'${e.value}'" : e.value.toString();
      return "${e.key} = $value";
    }).join(", ");

    Utilities.copyToClipboard(
        context, "EXEC ${data.storeProcedure} $paramString;");
  }
}
