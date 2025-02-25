import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/report/view_models/view_models.dart';
import 'package:provider/provider.dart';

class ReportView extends StatelessWidget {
  const ReportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ReportViewModel vm = Provider.of<ReportViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reportes",
        ),
      ),
      body: ListView.separated(
        itemCount: vm.reports.length,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () => vm.navigatePrintScreen(context, vm.reports[index]),
            title: Text(
              vm.reports[index],
            ),
            trailing: const Icon(Icons.arrow_right),
          );
        },
      ),
    );
  }
}
