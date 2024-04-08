// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/calendario/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:provider/provider.dart';

class Calendario2View extends StatefulWidget {
  const Calendario2View({super.key});

  @override
  State<Calendario2View> createState() => _Calendario2ViewState();
}

class _Calendario2ViewState extends State<Calendario2View> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData(context));
  }

  loadData(BuildContext context) async {
    final vm = Provider.of<Calendario2ViewModel>(context, listen: false);
    vm.loadData(context);
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<Calendario2ViewModel>(context, listen: false);

    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          title: const Text(
            'Calendario nuevoooo',
            style: AppTheme.titleStyle,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextButton(
                onPressed: () => vm.mesSiguiente(),
                child: const Text(
                  "siquiente",
                  style: AppTheme.normalBoldStyle,
                ),
              ),
              const Text("holo", style: AppTheme.normalBoldStyle),
            ],
          ),
        ),
      )
    ]);
  }
}
