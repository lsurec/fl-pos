import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SettingsViewModel>(context);
    final vmSplash = Provider.of<SplashViewModel>(context);
    final vmLang = Provider.of<LangViewModel>(context);
    final vmTheme = Provider.of<ThemeViewModel>(context);

    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    final vmLocal = Provider.of<LocalSettingsViewModel>(context, listen: false);
    final vmHome = Provider.of<HomeViewModel>(context, listen: false);
    final vmMenu = Provider.of<MenuViewModel>(context, listen: false);

    // Crear una instancia de NumberFormat para el formato de moneda
    final currencyFormat = NumberFormat.currency(
      symbol: vmHome
          .moneda, // Símbolo de la moneda (puedes cambiarlo según tu necesidad)
      decimalDigits: 2, // Número de decimales a mostrar
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.home,
            'configuracion',
          ),
          style: AppTheme.style(
            context,
            Styles.title,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      vmLogin.user.toUpperCase(),
                      style: AppTheme.style(
                        context,
                        Styles.normal,
                      ),
                    ),
                    leading: IconButton(
                      onPressed: () {},
                      icon: ClipOval(
                        child: Container(
                          width: 45,
                          height: 50,
                          color: AppTheme.color(
                            context,
                            Styles.primary,
                          ),
                          child: Center(
                            child: Text(
                              vmLogin.user[0].toUpperCase(),
                              style: AppTheme.style(
                                context,
                                Styles.user,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      AppLocalizations.of(context)!.translate(
                        BlockTranslate.localConfig,
                        'empresa',
                      ),
                      style: AppTheme.style(
                        context,
                        Styles.bold,
                      ),
                    ),
                    subtitle: Text(
                      vmLocal.selectedEmpresa!.empresaNombre,
                      style: AppTheme.style(
                        context,
                        Styles.normal,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      AppLocalizations.of(context)!.translate(
                        BlockTranslate.localConfig,
                        'estaciones',
                      ),
                      style: AppTheme.style(
                        context,
                        Styles.bold,
                      ),
                    ),
                    subtitle: Text(
                      vmLocal.selectedEstacion!.nombre,
                      style: AppTheme.style(
                        context,
                        Styles.normal,
                      ),
                    ),
                  ),
                  if (vmMenu.tipoCambio != 0)
                    ListTile(
                      title: Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.localConfig,
                          'cambioTipo',
                        ),
                        style: AppTheme.style(
                          context,
                          Styles.bold,
                        ),
                      ),
                      subtitle: Text(
                        currencyFormat.format(vmMenu.tipoCambio),
                        style: AppTheme.style(
                          context,
                          Styles.normal,
                        ),
                      ),
                    ),
                ],
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.print_outlined),
                title: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.impresora,
                    'impresora',
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
                ),
                subtitle: Text(Preferences.urlApi),
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.home,
                    'idioma',
                  ),
                  style: AppTheme.style(
                    context,
                    Styles.normal,
                  ),
                ),
                //Nombre del idioma seleccionado en el idioma seleccionado
                subtitle: Text(
                  vmLang.getNameLang(vmLang.languages[Preferences.idLanguage])!,
                ),
                trailing: const Icon(Icons.arrow_right),
                onTap: () => vm.navigateLang(context),
              ),
              ListTile(
                leading: vmTheme.getThemeIcon(context, Preferences.idTheme),
                title: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.home,
                    'tema',
                  ),
                ),
                //Nombre del idioma seleccionado en el idioma seleccionado
                subtitle: Text(
                  vmTheme.temasApp(context)[AppNewTheme.idTema].descripcion,
                ),
                trailing: const Icon(Icons.arrow_right),
                onTap: () => vm.navigateTheme(context),
              ),
              ListTile(
                leading: const Icon(Icons.palette_outlined),
                title: const Text("Apariencia" //TODO:Translate
                    ),
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.appearance,
                ),
                trailing: const Icon(Icons.arrow_right),
                // onTap: () => vm.navigateTheme(context),
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.botones,
                    'ayuda',
                  ),
                ),
                trailing: const Icon(Icons.arrow_right),
                onTap: () => Navigator.pushNamed(context, "help"),
              ),
              ListTile(
                leading: const Icon(Icons.cloud_outlined),
                title: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.home,
                    'versionActual',
                  ),
                ),
                subtitle: Text(vmSplash.versionLocal),
              ),
              ListTile(
                onTap: () => vmHome.logout(context),
                leading: const Icon(Icons.logout_outlined),
                title: Text("Cerrar sesión"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
