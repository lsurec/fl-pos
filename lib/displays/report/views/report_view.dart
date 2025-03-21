import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/report/models/models.dart';
import 'package:flutter_post_printer_example/displays/report/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReportView extends StatefulWidget {
  const ReportView({Key? key}) : super(key: key);

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  @override
  void initState() {
    super.initState();

    final vm = Provider.of<ReportViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => vm.loadData(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ReportViewModel vm = Provider.of<ReportViewModel>(context);
    final MenuViewModel menuVM = Provider.of<MenuViewModel>(context);
    return Stack(
      children: [
        DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              //TODO:Nombre display
              title: Text(menuVM.name),
              bottom: TabBar(
                indicatorColor: AppTheme.hexToColor(
                  Preferences.valueColor,
                ),
                tabs: [
                  Tab(text: "Filtros"),
                  Tab(text: "Reportes"),
                ],
              ),
            ),
            body: const TabBarView(
              children: [
                // Contenido de la primera pestaña
                _Filters(),
                // Contenido de la segunda pestaña
                _Reports(),
              ],
            ),
          ),
        ),
        if (vm.isLoading)
          ModalBarrier(
            dismissible: false,
            // color: Colors.black.withOpacity(0.3),
            color: AppTheme.isDark()
                ? AppTheme.darkBackroundColor
                : AppTheme.backroundColor,
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}

class _Reports extends StatelessWidget {
  const _Reports({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ReportViewModel vm = Provider.of<ReportViewModel>(context);

    return ListView.separated(
      itemCount: vm.reports.length,
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
      itemBuilder: (BuildContext context, int index) {
        final ReportModel report = vm.reports[index];
        return ListTile(
          title: Text(
            report.name,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.share,
                ),
              ),
              IconButton(
                onPressed: () => vm.navigatePrint(
                  context,
                  report,
                ),
                icon: Icon(
                  Icons.print,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ReportViewModel vm = Provider.of<ReportViewModel>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Fecha de Inicio
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Fecha Inicio:"),
              subtitle: Text(
                vm.startDate != null
                    ? DateFormat('dd/MM/yyyy').format(vm.startDate!)
                    : 'Seleccionar',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => vm.selectDate(context, true),
            ),

            // Fecha Fin
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Fecha Fin:"),
              subtitle: Text(
                vm.endDate != null
                    ? DateFormat('dd/MM/yyyy').format(vm.endDate!)
                    : 'Seleccionar',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => vm.selectDate(context, false),
            ),
            const SizedBox(height: 20),
            // Select Serie
            // DropdownButtonFormField<String>(
            //   value: vm.selectedSerie,
            //   decoration: const InputDecoration(labelText: 'Serie'),
            //   items: vm.series.map((serie) {
            //     return DropdownMenuItem(
            //       value: serie,
            //       child: Text(serie),
            //     );
            //   }).toList(),
            //   onChanged: (value) => vm.changeSerie(value!),
            // ),
            const SizedBox(height: 20),
            // Select Bodega
            DropdownButtonFormField<BodegaUserModel>(
              value: vm.bodega,
              decoration: const InputDecoration(labelText: 'Bodega'),
              items: vm.bodegas.map((bodega) {
                return DropdownMenuItem(
                  value: bodega,
                  child: Text(bodega.nombre),
                );
              }).toList(),
              onChanged: (value) => vm.changeBodega(value!),
            ),
          ],
        ),
      ),
    );
  }
}
