import 'package:flutter_post_printer_example/displays/shr_local_config/models/models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
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
                          style: StyleApp.title,
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
                            style: StyleApp.normalBold,
                          ),
                          Text(
                            '${AppLocalizations.of(context)!.translate(
                              BlockTranslate.general,
                              'registro',
                            )} (${vm.empresas.length})',
                            style: StyleApp.normal,
                          ),
                        ],
                      ),
                      if (vm.empresas.isNotEmpty)
                        CardWidget(
                          raidus: 10,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton<EmpresaModel>(
                              isExpanded: true,
                              dropdownColor: AppTheme.isDark()
                                  ? AppTheme.darkBackroundColor
                                  : AppTheme.backroundColor,
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
                            style: StyleApp.normalBold,
                          ),
                          Text(
                            '${AppLocalizations.of(context)!.translate(
                              BlockTranslate.general,
                              'registro',
                            )} (${vm.estaciones.length})',
                            style: StyleApp.normal,
                          ),
                        ],
                      ),
                      if (vm.estaciones.isNotEmpty)
                        CardWidget(
                          raidus: 10,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton<EstacionModel>(
                              isExpanded: true,
                              dropdownColor: AppTheme.isDark()
                                  ? AppTheme.darkBackroundColor
                                  : AppTheme.backroundColor,
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
                                style: StyleApp.whiteBold,
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
            color: AppTheme.isDark()
                ? AppTheme.darkBackroundColor
                : AppTheme.backroundColor,
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}
