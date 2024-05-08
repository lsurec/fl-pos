import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/services/language_service.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/card_widget.dart';
import 'package:provider/provider.dart';

class LangView extends StatelessWidget {
  const LangView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LangViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.translate(
                BlockTranslate.preferencias,
                "idiomaT",
              ),
              style: AppTheme.titleStyle,
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {},
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      child: Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.preferencias,
                          "idioma",
                        ),
                        style: AppTheme.normalBoldStyle,
                      ),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: vm.languages.length,
                      itemBuilder: (BuildContext context, int index) {
                        final LanguageModel lang = vm.languages[index];
                        return Column(
                          children: [
                            CardWidget(
                              color: index == Preferences.idLanguage
                                  ? AppTheme.primary
                                  : AppTheme.backroundColorSecondary,
                              width: 400,
                              margin: const EdgeInsets.only(bottom: 25),
                              child: ListTile(
                                title: Text(
                                  vm.getNameLang(lang)!,
                                  style: index == Preferences.idLanguage
                                      ? AppTheme.whiteBoldStyle
                                      : AppTheme.normalBoldStyle,
                                  textAlign: TextAlign.center,
                                ),
                                onTap: () => vm.cambiarIdioma(
                                  context,
                                  Locale(lang.lang),
                                  index,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    if (AppLocalizations.cambiarIdioma == 0)
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
            color: AppTheme.backroundColor,
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
