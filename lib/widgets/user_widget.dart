import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
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
          color: AppTheme.primary,
          child: Center(
            child: Text(
              vmLogin.user.isNotEmpty ? vmLogin.user[0].toUpperCase() : "",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
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
        color: AppTheme.backroundColor,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "DMOSOFT S.A",
                style: AppTheme.titleStyle,
              ),
              const SizedBox(height: 10),
              Card(
                color: AppTheme.backroundColor,
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
                          style: AppTheme.normalStyle,
                        ),
                        leading: IconButton(
                          onPressed: () {},
                          icon: ClipOval(
                            child: Container(
                              width: 50,
                              height: 50,
                              color: AppTheme.primary,
                              child: Center(
                                child: Text(
                                  vmLogin.user[0].toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text(
                          "Empresa",
                          style: AppTheme.normalBoldStyle,
                        ),
                        subtitle: Text(
                          vmLocal.selectedEmpresa!.empresaNombre,
                          style: AppTheme.normalStyle,
                        ),
                      ),
                      ListTile(
                        title: const Text(
                          "Estacion de trabajo",
                          style: AppTheme.normalBoldStyle,
                        ),
                        subtitle: Text(
                          vmLocal.selectedEstacion!.nombre,
                          style: AppTheme.normalStyle,
                        ),
                      ),
                      ListTile(
                        title: const Text(
                          "Tipo cambio",
                          style: AppTheme.normalBoldStyle,
                        ),
                        subtitle: Text(
                          currencyFormat.format(vmHome.tipoCambio),
                          style: AppTheme.normalStyle,
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
