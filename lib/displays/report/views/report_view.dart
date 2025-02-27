import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/report/models/models.dart';
import 'package:flutter_post_printer_example/displays/report/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:provider/provider.dart';

class ReportView extends StatelessWidget {
  const ReportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ReportViewModel vm = Provider.of<ReportViewModel>(context);
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            //TODO:Nombre display
            title: Text("Reportes"),
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
          body: TabBarView(
            children: [
              // Contenido de la primera pestaña
              Text("data"),
              // Contenido de la segunda pestaña
              ListView.separated(
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
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.printer,
                              arguments: PrintDocSettingsModel(
                                opcion: report!.id,
                                report: report,
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.print,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.share,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
