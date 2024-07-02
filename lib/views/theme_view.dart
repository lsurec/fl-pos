// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/providers/providers.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context);

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
                    RadioListTile<ThemeMode>(
                      title: Text('Claro'),
                      value: ThemeMode.light,
                      groupValue: themeProvider.themeMode,
                      onChanged: (ThemeMode? value) => themeProvider.setLigth(),
                    ),
                    RadioListTile<ThemeMode>(
                      title: Text('Oscuro'),
                      value: ThemeMode.dark,
                      groupValue: themeProvider.themeMode,
                      onChanged: (ThemeMode? value) => themeProvider.setDark(),
                    ),
                    RadioListTile<ThemeMode>(
                      title: Text('Sistema'),
                      value: ThemeMode.system,
                      groupValue: themeProvider.themeMode,
                      onChanged: (ThemeMode? value) =>
                          themeProvider.setSystem(),
                    ),
                    SizedBox(
                      width: 350,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.home,
                            "tema",
                          ),
                          style: AppTheme.style(
                            context,
                            Styles.blueTitle,
                          ),
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
                        return Column(
                          children: [
                            CardWidget(
                              color: theme.id == Preferences.theme
                                  ? AppTheme.color(
                                      context,
                                      Styles.primary,
                                    )
                                  : AppTheme.color(
                                      context,
                                      Styles.secondBackground,
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
                                        )
                                      : AppTheme.style(
                                          context,
                                          Styles.bold,
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
                        style: AppTheme.button(
                          context,
                          Styles.buttonStyle,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.botones,
                            "continuar",
                          ),
                          style: AppTheme.style(
                            context,
                            Styles.whiteBoldStyle,
                          ),
                        ),
                      ),
                    if (AppTheme.cambiarTema == 1)
                      SizedBox(
                        width: 350,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.translate(
                                BlockTranslate.preferencias,
                                'nota',
                              ),
                              style: AppTheme.style(
                                context,
                                Styles.bold,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.translate(
                                BlockTranslate.preferencias,
                                'reiniciarTema',
                              ),
                              style: AppTheme.style(
                                context,
                                Styles.normal,
                              ),
                            ),
                          ],
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
              Styles.loading,
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
