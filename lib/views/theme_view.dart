import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ThemeView extends StatelessWidget {
  const ThemeView({super.key});

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    final bool isDarkMode = brightness == Brightness.dark;

    final vm = Provider.of<ThemeViewModel>(context);

    List<ThemeModel> themes = vm.temasApp(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                child: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.preferencias,
                    "idioma",
                  ),
                  style: AppTheme.normalBoldStyle,
                ),
              ),
              Text(
                isDarkMode ? 'Dark Mode' : 'Light Mode',
                style: const TextStyle(fontSize: 24),
              ),
              Text(
                Preferences.themeName.isEmpty ? 'Tema Claro' : 'Tema Oscuro',
                style: const TextStyle(fontSize: 24),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: themes.length,
                itemBuilder: (BuildContext context, int index) {
                  final ThemeModel theme = themes[index];
                  return Column(
                    children: [
                      CardWidget(
                        width: 400,
                        margin: const EdgeInsets.only(bottom: 25),
                        child: ListTile(
                          title: Text(
                            theme.descripcion,
                            textAlign: TextAlign.center,
                            style: AppTheme.styleTheme(
                              Styles.whiteBoldStyle,
                              Preferences.theme,
                            ),
                          ),
                          onTap: () => vm.nuevoTema(
                            theme,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
