import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserWidget extends StatelessWidget {
  const UserWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final vmLogin = Provider.of<LoginViewModel>(context);

    return IconButton(
      iconSize: 50,
      onPressed: () => _showUserInfoModal(context, child),
      icon: ClipOval(
        child: Container(
          width: 35,
          height: 35,
          color: AppNewTheme.hexToColor(
            Preferences.valueColor,
          ),
          child: Center(
            child: Text(
              vmLogin.user.isNotEmpty ? vmLogin.user[0].toUpperCase() : "",
              style: StyleApp.user,
            ),
          ),
        ),
      ),
    );
  }
}

void _showUserInfoModal(
  BuildContext context,
  Widget child,
) {
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
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        color: AppNewTheme.isDark()
            ? AppNewTheme.darkBackroundColor
            : AppNewTheme.backroundSecondary,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "DMOSOFT S.A",
                style: StyleApp.title,
              ),
              const SizedBox(height: 10),
              Card(
                color: AppNewTheme.isDark()
                    ? AppNewTheme.darkBackroundColor
                    : AppNewTheme.backroundSecondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          vmLogin.user.toUpperCase(),
                          style: StyleApp.normal,
                        ),
                        leading: IconButton(
                          onPressed: () {},
                          icon: ClipOval(
                            child: Container(
                              width: 45,
                              height: 50,
                              color: AppNewTheme.hexToColor(
                                Preferences.valueColor,
                              ),
                              child: Center(
                                child: Text(
                                  vmLogin.user[0].toUpperCase(),
                                  style: StyleApp.user,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(),
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
                ),
              ),
              child,
            ],
          ),
        ),
      );
    },
  );
}
