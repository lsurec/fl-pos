import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class AppearenceView extends StatelessWidget {
  const AppearenceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vmLang = Provider.of<LangViewModel>(context);
    final vmTheme = Provider.of<ThemeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Apariencia",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.preferencias,
                    'lenguaje',
                  ),
                  style: StyleApp.normal,
                ),
                subtitle: Text(
                  vmLang.getNameLang(
                    vmLang.languages[Preferences.idLanguage],
                  )!,
                ),
                onTap: () {
                  NotificationService.changeLang(context);
                },
              ),
              ListTile(
                leading: AppTheme.isDark()
                    ? const Icon(
                        Icons.dark_mode_outlined,
                      )
                    : const Icon(
                        Icons.light_mode_outlined,
                      ),
                title: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.preferencias,
                    'tema',
                  ),
                  style: StyleApp.normal,
                ),
                subtitle: Text(
                  vmTheme.temasApp(context)[AppTheme.idTema].descripcion,
                ),
                onTap: () {
                  NotificationService.changeTheme(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.color_lens_outlined),
                title: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.preferencias,
                    'color',
                  ),
                  style: StyleApp.normal,
                ),
                subtitle: Text(
                  vmTheme.temaColor(Preferences.idColor).nombre,
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.theme,
                  );
                },
              ),
              // ListTile(
              //   title: Text(
              //     AppLocalizations.of(context)!.translate(
              //       BlockTranslate.preferencias,
              //       'fuente',
              //     ),
              //     style: StyleApp.normal,
              //   ),
              //   subtitle: Text(
              //     AppLocalizations.of(context)!.translate(
              //       BlockTranslate.preferencias,
              //       'sistema',
              //     ),
              //   ),
              //   onTap: () {},
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
