import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/services/language_service.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
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
            title: const Text("Titulo"),
          ),
          body: RefreshIndicator(
            onRefresh: () async {},
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => vm.cambiarIdioma(const Locale('en')),
                      child: const Text(
                        'English',
                        style: AppTheme.whiteBoldStyle,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => vm.cambiarIdioma(const Locale('es')),
                      child: const Text(
                        'Español',
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
                      AppLocalizations.of(context)!.translate('creador'),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => vm.reiniciarTemp(context),
                      child: const Text(
                        'Reiniciar',
                        style: AppTheme.whiteBoldStyle,
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
