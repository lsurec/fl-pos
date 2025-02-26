import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/report/view_models/view_models.dart';
import 'package:provider/provider.dart';

class PrintReportView extends StatelessWidget {
  const PrintReportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PrintReportViewModel vm = Provider.of<PrintReportViewModel>(context);

    return Scaffold(
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Positioned(
            bottom: 80.0, // Espaciado entre los botones
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () => vm.print(context),
              child: const Icon(Icons.print),
            ),
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.share),
            ),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text(vm.report!.name),
      ),
      body: Center(
        child: Text('PrintReportView'),
      ),
    );
  }
}
