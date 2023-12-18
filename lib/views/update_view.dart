import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class UpdateView extends StatelessWidget {
  const UpdateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vmSplash = Provider.of<SplashViewModel>(context);
    // final vm = Provider.of<UpdateViewModel>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  "assets/logo_demosoft.png",
                  height: 150,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Nueva version disponble.",
                style: AppTheme.titleStyle,
              ),
              const SizedBox(height: 10),
              const Text(
                "Actualiza para continuar.",
                style: AppTheme.normalStyle,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    vmSplash.versionLocal,
                    style: AppTheme.normalStyle,
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_forward),
                  const SizedBox(width: 10),
                  Text(
                    vmSplash.versionRemota,
                    style: AppTheme.normalBoldStyle,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                // onPressed: () => vm.openLink(),
                onPressed: () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Actualizar",
                      style: TextStyle(fontSize: 17),
                    ),
                    Icon(
                      Icons.upgrade,
                      size: 25,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
