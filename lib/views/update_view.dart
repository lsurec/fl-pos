import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/models/version_model.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class UpdateView extends StatelessWidget {
  const UpdateView({Key? key, required this.versionRemote}) : super(key: key);

  final VersionModel versionRemote;

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
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.home,
                  'nuevaVersion',
                ),
                style: StyleApp.title,
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.home,
                  'continuar',
                ),
                style: StyleApp.normal,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    vmSplash.versionLocal,
                    style: StyleApp.normal,
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_forward),
                  const SizedBox(width: 10),
                  Text(
                    vmSplash.versionRemota,
                    style: StyleApp.normalBold,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: AppTheme.button(
                  context,
                  Styles.buttonStyle,
                ),
                // onPressed: () => vm.openLink(),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.translate(
                        BlockTranslate.botones,
                        'actualizar',
                      ),
                      style: StyleApp.whiteNormal,
                    ),
                    const Icon(
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
