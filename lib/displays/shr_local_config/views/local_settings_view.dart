import 'package:flutter_post_printer_example/displays/shr_local_config/models/models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocalSettingsView extends StatefulWidget {
  const LocalSettingsView({super.key});

  @override
  State<LocalSettingsView> createState() => _LocalSettingsViewState();
}

class _LocalSettingsViewState extends State<LocalSettingsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData(context));
  }

  loadData(BuildContext context) {
    final vm = Provider.of<LocalSettingsViewModel>(context, listen: false);
    if (vm.resApis != null) {
      NotificationService.showErrorView(context, vm.resApis!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LocalSettingsViewModel>(context);
    final vmHome = Provider.of<HomeViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () => vmHome.logout(context),
                icon: const Icon(
                  Icons.logout,
                ),
              )
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => vm.loadData(context),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.localConfig,
                            'configuracion',
                          ),
                          style: AppTheme.style(
                            context,
                            Styles.title,
                            Preferences.idTheme,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.translate(
                              BlockTranslate.localConfig,
                              'empresa',
                            ),
                            style: AppTheme.style(
                              context,
                              Styles.bold,
                              Preferences.idTheme,
                            ),
                          ),
                          Text(
                            '${AppLocalizations.of(context)!.translate(
                              BlockTranslate.general,
                              'registro',
                            )} (${vm.empresas.length})',
                            style: AppTheme.style(
                              context,
                              Styles.normal,
                              Preferences.idTheme,
                            ),
                          ),
                        ],
                      ),
                      if (vm.empresas.isNotEmpty)
                        CardWidget(
                          color: AppTheme.color(
                            context,
                            Styles.background,
                            Preferences.idTheme,
                          ),
                          raidus: 10,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton<EmpresaModel>(
                              isExpanded: true,
                              dropdownColor: AppTheme.color(
                                context,
                                Styles.background,
                                Preferences.idTheme,
                              ),
                              value: vm.selectedEmpresa,
                              onChanged: (value) => vm.changeEmpresa(value),
                              items: vm.empresas.map((empresa) {
                                return DropdownMenuItem<EmpresaModel>(
                                  value: empresa,
                                  child: Text(empresa.empresaNombre),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.translate(
                              BlockTranslate.localConfig,
                              'estaciones',
                            ),
                            style: AppTheme.style(
                              context,
                              Styles.bold,
                              Preferences.idTheme,
                            ),
                          ),
                          Text(
                            '${AppLocalizations.of(context)!.translate(
                              BlockTranslate.general,
                              'registro',
                            )} (${vm.estaciones.length})',
                            style: AppTheme.style(
                              context,
                              Styles.normal,
                              Preferences.idTheme,
                            ),
                          ),
                        ],
                      ),
                      if (vm.estaciones.isNotEmpty)
                        CardWidget(
                          color: AppTheme.color(
                            context,
                            Styles.background,
                            Preferences.idTheme,
                          ),
                          raidus: 10,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton<EstacionModel>(
                              isExpanded: true,
                              dropdownColor: AppTheme.color(
                                context,
                                Styles.background,
                                Preferences.idTheme,
                              ),
                              value: vm.selectedEstacion,
                              onChanged: (value) => vm.changeEstacion(value),
                              items: vm.estaciones.map((estacion) {
                                return DropdownMenuItem<EstacionModel>(
                                  value: estacion,
                                  child: Text(estacion.nombre),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          style: AppTheme.button(
                            context,
                            Styles.buttonStyle,
                            Preferences.idTheme,
                          ),
                          onPressed:
                              vm.estaciones.isEmpty || vm.empresas.isEmpty
                                  ? null
                                  : () => vm.navigateHome(context),
                          child: SizedBox(
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.translate(
                                  BlockTranslate.botones,
                                  'continuar',
                                ),
                                style: AppTheme.style(
                                  context,
                                  Styles.whiteBoldStyle,
                                  Preferences.idTheme,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (vm.isLoading)
          ModalBarrier(
            dismissible: false,
            color: AppTheme.color(
              context,
              Styles.loading,
              Preferences.idTheme,
            ),
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}
