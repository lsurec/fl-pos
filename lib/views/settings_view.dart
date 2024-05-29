import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SettingsViewModel>(context);
    final vmSplash = Provider.of<SplashViewModel>(context);
    final vmLang = Provider.of<LangViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.home,
            'configuracion',
          ),
          style: AppTheme.styleTheme(
            Styles.title,
            Preferences.theme,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.print_outlined),
                title: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.impresora,
                    'impresora',
                  ),
                  style: AppTheme.styleTheme(
                    Styles.normal,
                    Preferences.theme,
                  ),
                ),
                trailing: const Icon(Icons.arrow_right),
                onTap: () => vm.navigatePrint(context),
              ),
              ListTile(
                leading: const Icon(Icons.vpn_lock_outlined),
                title: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.home,
                    'origen',
                  ),
                  style: AppTheme.styleTheme(
                    Styles.normal,
                    Preferences.theme,
                  ),
                ),
                subtitle: Text(
                  Preferences.urlApi,
                  style: AppTheme.styleTheme(
                    Styles.subTitle,
                    Preferences.theme,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.botones,
                    'ayuda',
                  ),
                  style: AppTheme.styleTheme(
                    Styles.normal,
                    Preferences.theme,
                  ),
                ),
                trailing: const Icon(Icons.arrow_right),
                onTap: () => Navigator.pushNamed(context, "help"),
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.home,
                    'idioma',
                  ),
                  style: AppTheme.styleTheme(
                    Styles.normal,
                    Preferences.theme,
                  ),
                ),
                //Nombre del idioma seleccionado en el idioma seleccionado
                subtitle: Text(
                  vmLang.getNameLang(vmLang.languages[Preferences.idLanguage])!,
                  style: AppTheme.styleTheme(
                    Styles.subTitle,
                    Preferences.theme,
                  ),
                ),
                trailing: const Icon(Icons.arrow_right),
                onTap: () => vm.navigateLang(context),
              ),
              ListTile(
                leading: const Icon(Icons.cloud_outlined),
                title: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.home,
                    'versionActual',
                  ),
                  style: AppTheme.styleTheme(
                    Styles.normal,
                    Preferences.theme,
                  ),
                ),
                subtitle: Text(
                  vmSplash.versionLocal,
                  style: AppTheme.styleTheme(
                    Styles.subTitle,
                    Preferences.theme,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
