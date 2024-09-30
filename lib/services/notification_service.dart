// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class NotificationService {
  //Key dcaffkod global
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  //Mostrar snack bar
  static showSnackbar(String message) {
    final vmTheme = Provider.of<ThemeViewModel>(
      messengerKey.currentContext!,
      listen: false,
    );

    final snackBar = SnackBar(
      content: Text(
        message,
        style: StyleApp.whiteNormal,
      ),
      backgroundColor: vmTheme.colorPref(
        AppTheme.idColorTema,
      ),
      // action: SnackBarAction(
      //   label: 'Aceptar',
      //   onPressed: () => Navigator.pop(context),
      // ),
    );

    //mosttar snack
    messengerKey.currentState!.showSnackBar(snackBar);
  }

  //Mostrar snack bar
  static showSnackbarAction(
    BuildContext context,
    String message,
    String textButton,
    Function action,
  ) {
    final vmTheme = Provider.of<ThemeViewModel>(
      messengerKey.currentContext!,
      listen: false,
    );

    final snackBar = SnackBar(
      duration: const Duration(seconds: 10),
      content: Text(
        message,
        style: StyleApp.whiteNormal,
      ),
      backgroundColor: vmTheme.colorPref(
        AppTheme.idColorTema,
      ),
      action: SnackBarAction(
        label: textButton,
        textColor:  AppTheme.white,
        onPressed: () => action(),
      ),
    );

    //mosttar snack
    messengerKey.currentState!.showSnackBar(snackBar);
  }

  static showInfoPrint(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.translate(
              BlockTranslate.impresora,
              "problema",
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.impresora,
                  "pasos",
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.impresora,
                  "encendida",
                ),
              ),
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.impresora,
                  "modo",
                ),
              ),
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.impresora,
                  "vinculada",
                ),
              ),
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.impresora,
                  "papel",
                ),
              ),
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.impresora,
                  "salidaPapel",
                ),
              ),
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.impresora,
                  "usarCorrecta",
                ),
              ),
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.impresora,
                  "correcta",
                ),
              ),
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.impresora,
                  "dispositivo",
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.impresora,
                  "soporte",
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.botones,
                  "cerrar",
                ),
              ),
            ),
            // TextButton(
            //   onPressed: () {
            //     // Aquí puedes agregar lógica adicional, como redirigir a la sección de soporte.
            //     Navigator.of(context).pop();
            //   },
            //   child: Text('Contactar Soporte'),
            // ),
          ],
        );
      },
    );
  }

  static showMessage(
    BuildContext context,
    List<String> mensajes,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.translate(
              BlockTranslate.notificacion,
              "advertencia",
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.notificacion,
                  "productosNoDisponibles",
                ),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                itemCount: mensajes.length,
                itemBuilder: (BuildContext context, int index) {
                  final String mensaje = mensajes[index];
                  return Text(
                    mensaje,
                  );
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.botones,
                  "cerrar",
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Aquí puedes agregar lógica adicional, como redirigir a la sección de soporte.
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.botones,
                  'informe',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static showMessageValidations(
    BuildContext context,
    List<ValidateProductModel> validaciones,
  ) {
    final vmShare = Provider.of<ShareDocViewModel>(context, listen: false);

    final ValidateProductModel validacion = validaciones[0];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Text(
                AppLocalizations.of(context)!
                    .translate(
                      BlockTranslate.notificacion,
                      "advertencia",
                    )
                    .toUpperCase(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.notificacion,
                  "productosNoDisponibles",
                ),
                style: StyleApp.normal,
              ),
              const Divider(),
            ],
          ),
          titlePadding: const EdgeInsets.only(
            // bottom: 10,
            top: 15,
          ),
          contentPadding: const EdgeInsets.only(
            top: 5,
            bottom: 0,
            left: 25,
            right: 25,
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "(${validacion.sku}) ${validacion.productoDesc}",
                style: StyleApp.normalBold,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.translate(
                          BlockTranslate.general,
                          'serie',
                        )}:",
                        style: StyleApp.normal,
                      ),
                      Text(
                        validacion.serie,
                        style: StyleApp.normal,
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.translate(
                          BlockTranslate.factura,
                          'tipoDoc',
                        )}:",
                        style: StyleApp.normal,
                      ),
                      Text(
                        validacion.tipoDoc,
                        style: StyleApp.normal,
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 5),
              const Divider(),
              const SizedBox(height: 5),
              SizedBox(
                height: 120.0, // Limita la altura máxima del área de mensajes
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: validacion.mensajes
                        .map(
                          (mensaje) => Column(
                            children: [
                              const SizedBox(height: 5),
                              Text(
                                mensaje,
                                style: StyleApp.normal,
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.botones,
                  "aceptar",
                ),
              ),
            ),
            TextButton(
              onPressed: () => vmShare.sharedDocInformeAyO(
                context,
                validaciones,
              ),
              child: Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.botones,
                  'compartirInforme',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showErrorView(
    BuildContext context,
    ApiResModel res,
  ) async {
    ErrorModel error = ErrorModel(
      date: DateTime.now(),
      description: res.response,
      url: res.url,
      storeProcedure: res.storeProcedure,
    );

    bool result = await showDialog(
          context: context,
          builder: (context) => AlertWidget(
            title: AppLocalizations.of(context)!.translate(
              BlockTranslate.notificacion,
              'salioMal',
            ),
            description: AppLocalizations.of(context)!.translate(
              BlockTranslate.notificacion,
              'error',
            ),
            onOk: () => Navigator.of(context).pop(true),
            onCancel: () => Navigator.of(context).pop(false),
            textCancel: AppLocalizations.of(context)!.translate(
              BlockTranslate.botones,
              'informe',
            ),
            textOk: AppLocalizations.of(context)!.translate(
              BlockTranslate.botones,
              'aceptar',
            ),
          ),
        ) ??
        true;

    //Si quiere verse el error
    if (!result) {
      //navegar a pantalla para ver el error
      Navigator.pushNamed(
        context,
        "error",
        arguments: error,
      );
    }
  }

  static Future<bool> editTerm(
    BuildContext context,
    int index,
  ) async {
    final facturaVM = Provider.of<DocumentoViewModel>(context, listen: false);

    // Controlador de texto para el TextField
    TextEditingController controller = TextEditingController();

    if (index == -1) {
      //iniciaulzar el controlador vacio
      controller.text = "";
    } else {
      // Inicializar el controlador con el valor existente en la lista
      controller.text = facturaVM.terminosyCondiciones[index];
    }

    bool result = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: index != -1
                      ? const Text(
                          "Modificar termino",
                          style: StyleApp.normal,
                        )
                      : const Text(
                          "Agregar Término",
                          style: StyleApp.normal,
                        ),
                  content: TextField(
                    maxLines: null,
                    controller: controller,
                    decoration: InputDecoration(
                      labelText:
                          index != -1 ? "Editar Término." : "Escribir Término.",
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.botones,
                          "cancelar",
                        ),
                      ),
                    ),
                    if (index != -1)
                      ElevatedButton(
                        onPressed: () {
                          // Guardar el nuevo valor y cerrar el diálogo
                          facturaVM.modificar(
                            context,
                            index,
                            controller.text,
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.botones,
                            "guardar",
                          ),
                        ),
                      ),
                    if (index == -1)
                      ElevatedButton(
                        onPressed: () {
                          // Guardar el nuevo valor y cerrar el diálogo
                          facturaVM.modificar(
                            context,
                            -1,
                            controller.text,
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.botones,
                            "agregar",
                          ),
                        ),
                      ),
                  ],
                )) ??
        false;

    // Verificar el resultado del diálogo y actualizar el estado si es necesario
    if (result) return true;

    return false;
  }

  static Future<void> changeLang(
    BuildContext context,
  ) async {
    final vmLang = Provider.of<LangViewModel>(
      context,
      listen: false,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(
            left: 0,
            bottom: 20,
            right: 20,
            top: 20,
          ),
          backgroundColor: AppTheme.isDark()
              ? AppTheme.backroundDarkSecondary
              : AppTheme.backroundSecondary,
          content: SizedBox(
            height: 220, // Limitar la altura del diálogo
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: vmLang.languages.length,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                final LanguageModel lang = vmLang.languages[index];

                return RadioListTile<int>(
                  title: Text(
                    vmLang.getNameLang(
                      lang,
                    )!,
                  ),
                  // Puedes ajustar cómo mostrar el nombre
                  value: index,
                  groupValue: Preferences.idLanguage,
                  // Asegúrate de manejar el valor seleccionado
                  onChanged: (int? value) {
                    if (value != null) {
                      vmLang.cambiarLenguaje(
                        context,
                        Locale(lang.lang),
                        index,
                      );
                    }
                  },
                  activeColor: AppTheme.hexToColor(
                    Preferences.valueColor,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  static Future<void> changeTheme(
    BuildContext context,
  ) async {
    final vmTheme = Provider.of<ThemeViewModel>(
      context,
      listen: false,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(
            left: 0,
            bottom: 20,
            right: 20,
            top: 20,
          ),
          backgroundColor: AppTheme.isDark()
              ? AppTheme.backroundDarkSecondary
              : AppTheme.backroundSecondary,
          content: SizedBox(
            height: 160, // Limitar la altura del diálogo
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: vmTheme.temasApp(context).length,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      final ThemeModel tema = vmTheme.temasApp(context)[index];

                      return RadioListTile<int>(
                        title: Text(
                          tema.descripcion,
                        ),
                        // Puedes ajustar cómo mostrar el nombre
                        value: index,
                        groupValue: AppTheme.idTema,
                        activeColor: AppTheme.hexToColor(
                          Preferences.valueColor,
                        ),
                        // Asegúrate de manejar el valor seleccionado
                        onChanged: (int? value) {
                          if (value != null) {
                            vmTheme.validarColorTema(
                              context,
                              tema.id,
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
