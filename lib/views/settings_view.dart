import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SettingsViewModel>(context);
    final vmSplash = Provider.of<SplashViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Configuraciones",
          style: AppTheme.titleStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.print_outlined),
                title: const Text("Impresora"),
                trailing: const Icon(Icons.arrow_right),
                onTap: () => vm.navigatePrint(context),
              ),
              ListTile(
                leading: const Icon(Icons.vpn_lock_outlined),
                title: const Text("Origen de datos"),
                subtitle: Text(Preferences.urlApi),
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text("Ayuda"),
                trailing: const Icon(Icons.arrow_right),
                onTap: () => Navigator.pushNamed(context, "help"),
              ),
              ListTile(
                leading: const Icon(Icons.cloud_outlined),
                title: const Text("Versión actual"),
                subtitle: Text(vmSplash.versionLocal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
