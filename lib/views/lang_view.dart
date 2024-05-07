import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/services/language_service.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/card_widget.dart';
import 'package:flutter_post_printer_example/widgets/load_widget.dart';
import 'package:provider/provider.dart';

class LangView extends StatelessWidget {
  const LangView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LangViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text(
              "IDIOMA DE LA APLICACION",
              style: AppTheme.titleStyle,
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {},
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                      child: Text(
                        "Seleccione el idioma de su preferencia.",
                        style: AppTheme.normalBoldStyle,
                      ),
                    ),
                    CardWidget(
                      width: 400,
                      margin: const EdgeInsets.only(bottom: 25),
                      child: ListTile(
                        title: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.language_outlined),
                            SizedBox(width: 10),
                            Text(
                              "Ingles (Estados Unidos)",
                              style: AppTheme.normalBoldStyle,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        onTap: () => vm.cambiarIdioma(const Locale("en")),
                      ),
                    ),
                    CardWidget(
                      width: 400,
                      margin: const EdgeInsets.only(bottom: 25),
                      child: ListTile(
                        title: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.language_outlined),
                            SizedBox(width: 10),
                            Text(
                              "Español (Guatemala)",
                              style: AppTheme.normalBoldStyle,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        onTap: () => vm.cambiarIdioma(const Locale("es")),
                      ),
                    ),
                    CardWidget(
                      width: 400,
                      margin: const EdgeInsets.only(bottom: 25),
                      child: ListTile(
                        title: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.language_outlined),
                            SizedBox(width: 10),
                            Text(
                              "Francés (Francia)",
                              style: AppTheme.normalBoldStyle,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        onTap: () => vm.cambiarIdioma(const Locale("fr")),
                      ),
                    ),
                    CardWidget(
                      width: 400,
                      margin: const EdgeInsets.only(bottom: 25),
                      child: ListTile(
                        title: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.language_outlined),
                            SizedBox(width: 10),
                            Text(
                              "Alemán (Alemania)",
                              style: AppTheme.normalBoldStyle,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        onTap: () => vm.cambiarIdioma(const Locale("de")),
                      ),
                    ),
                    Text(
                      "IDIOMA SELECCIONADO : ${AppLocalizations.idioma}",
                      style: AppTheme.normalBoldStyle,
                    ),
                    ElevatedButton(
                      onPressed: () => vm.guardarReiniciar(context),
                      child: const Text(
                        'Guardar',
                        style: AppTheme.whiteBoldStyle,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context)!.translate('seleccionado'),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.translate('fechaIni'),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.translate('fechaFin'),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.translate('idDoc'),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.translate('usuario'),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    if (Preferences.language.isNotEmpty)
                      Text(
                        "${Preferences.language}, Idioma",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (vm.isLoading)
          ModalBarrier(
            dismissible: false,
            // color: Colors.black.withOpacity(0.3),
            color: AppTheme.backroundColor,
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}
