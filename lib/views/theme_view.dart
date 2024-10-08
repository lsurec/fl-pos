// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class ThemeView extends StatelessWidget {
  const ThemeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ThemeViewModel>(context);

    List<ThemeModel> themes = vm.temasApp(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(),
          body: RefreshIndicator(
            onRefresh: () async {},
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 350,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.home,
                            "tema",
                          ),
                          style: StyleApp.normalBold,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: themes.length,
                      itemBuilder: (BuildContext context, int index) {
                        final ThemeModel theme = themes[index];
                        return RadioListTile(
                          activeColor: AppTheme.idTema == 0
                              ? AppTheme.primary
                              : AppTheme.hexToColor(
                                  Preferences.valueColor,
                                ),
                          title: Text(
                            theme.descripcion,
                            style: StyleApp.normal,
                          ),
                          value: index,
                          groupValue: AppTheme.idTema,
                          onChanged: (int? value) => vm.validarColorTema(
                            context,
                            theme.id,
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    //Navegar a API
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => vm.navegarApi(
                          context,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.calendario,
                            "siguiente",
                          ),
                          style: StyleApp.whiteBold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
        if (vm.isLoading)
          Center(
            child: Image.asset(
              'assets/logo_demosoft.png',
              height: 275,
            ),
          ),
      ],
    );
  }
}
