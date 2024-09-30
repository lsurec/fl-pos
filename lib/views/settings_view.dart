import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
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
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    final vmLocal = Provider.of<LocalSettingsViewModel>(context, listen: false);
    final vmHome = Provider.of<HomeViewModel>(context, listen: false);
    final vmMenu = Provider.of<MenuViewModel>(context, listen: false);
    final vmTheme = Provider.of<ThemeViewModel>(context);

    // Crear una instancia de NumberFormat para el formato de moneda
    final currencyFormat = NumberFormat.currency(
      // Símbolo de la moneda (puedes cambiarlo según tu necesidad)
      symbol: vmHome.moneda,
      // Número de decimales a mostrar
      decimalDigits: 2,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.home,
            'configuracion',
          ),
          style: StyleApp.title,
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
                    title: Text(
                      vmLogin.user.toUpperCase(),
                      style: StyleApp.normal,
                    ),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: vmTheme.colorPref(
                          AppTheme.idColorTema,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          vmLogin.user[0].toUpperCase(),
                          style: StyleApp.user.copyWith(
                            fontSize: 30,
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
                      style: StyleApp.normalBold,
                    ),
                    subtitle: Text(
                      vmLocal.selectedEmpresa!.empresaNombre,
                      style: StyleApp.normal,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      AppLocalizations.of(context)!.translate(
                        BlockTranslate.localConfig,
                        'estaciones',
                      ),
                      style: StyleApp.normalBold,
                    ),
                    subtitle: Text(
                      vmLocal.selectedEstacion!.nombre,
                      style: StyleApp.normal,
                    ),
                  ),
                  if (vmMenu.tipoCambio != 0)
                    ListTile(
                      title: Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.localConfig,
                          'cambioTipo',
                        ),
                        style: StyleApp.normalBold,
                      ),
                      subtitle: Text(
                        currencyFormat.format(vmMenu.tipoCambio),
                        style: StyleApp.normal,
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
                leading: const Icon(Icons.palette_outlined),
                title: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.preferencias,
                    'apariencia',
                  ),
                ),
                subtitle: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.preferencias,
                    'cambios',
                  ),
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
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.help,
                ),
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
                title: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.botones,
                    'salir',
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
