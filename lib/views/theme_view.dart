// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
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
                            BlockTranslate.preferencias,
                            "tema",
                          ),
                          style: AppTheme.style(
                            context,
                            Styles.bold,
                            Preferences.idTheme,
                          ),
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
                        return Column(
                          children: [
                            CardWidget(
                              color: theme.id == Preferences.theme
                                  ? AppTheme.primary
                                  : AppTheme.color(
                                      context,
                                      Styles.secondBackground,
                                      Preferences.idTheme,
                                    ),
                              width: 400,
                              margin: const EdgeInsets.only(bottom: 25),
                              child: ListTile(
                                title: Text(
                                  theme.descripcion,
                                  style: index == Preferences.theme
                                      ? AppTheme.style(
                                          context,
                                          Styles.whiteBoldStyle,
                                          Preferences.idTheme,
                                        )
                                      : AppTheme.style(
                                          context,
                                          Styles.bold,
                                          Preferences.idTheme,
                                        ),
                                  textAlign: TextAlign.center,
                                ),
                                onTap: () => vm.nuevoTema(context, theme),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    if (AppTheme.cambiarTema == 0)
                      ElevatedButton(
                        onPressed: () => vm.reiniciarTemp(context),
                        child: Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.botones,
                            "continuar",
                          ),
                          style: AppTheme.whiteBoldStyle,
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
            color: AppTheme.color(
              context,
              Styles.background,
              Preferences.idTheme,
            ),
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
