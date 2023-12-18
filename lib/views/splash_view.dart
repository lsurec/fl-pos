import 'package:flutter_post_printer_example/view_models/splash_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SplashViewModel>(context);

    vm.loadData(context);

    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/logo_demosoft.png',
          height: 275,
        ), // Ruta de la imagen del logotipo
      ),
    );
  }
}
