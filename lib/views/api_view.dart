import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes/app_theme.dart';

//Vista configurar api
class ApiView extends StatelessWidget {
  const ApiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vmSplash = Provider.of<SplashViewModel>(context);
    final vm = Provider.of<ApiViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (Preferences.urlApi.isEmpty)
                          Text(
                            AppLocalizations.of(context)!.translate(
                              BlockTranslate.url,
                              "url",
                            ),
                            style: AppTheme.style(
                              context,
                              Styles.bold30Style,
                              Preferences.idTheme,
                            ),
                          ),
                        if (Preferences.urlApi.isEmpty)
                          const SizedBox(height: 10),
                        if (Preferences.urlApi.isEmpty)
                          Text(
                            AppLocalizations.of(context)!.translate(
                              BlockTranslate.url,
                              "ingresar",
                            ),
                            style: AppTheme.style(
                              context,
                              Styles.normal20Style,
                              Preferences.idTheme,
                            ),
                          ),
                        if (Preferences.urlApi.isNotEmpty)
                          const SizedBox(height: 20),
                        if (Preferences.urlApi.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.translate(
                                  BlockTranslate.url,
                                  "actual",
                                ),
                                style: AppTheme.style(
                                  context,
                                  Styles.bold30Style,
                                  Preferences.idTheme,
                                ),
                              ),
                              IconButton(
                                tooltip:
                                    AppLocalizations.of(context)!.translate(
                                  BlockTranslate.url,
                                  "copiar",
                                ),
                                onPressed: () => vm.copyToClipboard(context),
                                icon: const Icon(
                                  Icons.copy_outlined,
                                ),
                              )
                            ],
                          ),
                        if (Preferences.urlApi.isNotEmpty)
                          const SizedBox(height: 10),
                        if (Preferences.urlApi.isNotEmpty)
                          Text(
                            Preferences.urlApi,
                            style: AppTheme.style(
                              context,
                              Styles.normal20Style,
                              Preferences.idTheme,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  CardWidget(
                    color: AppTheme.color(
                      context,
                      Styles.secondBackground,
                      Preferences.idTheme,
                    ),
                    width: double.infinity,
                    raidus: 18,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Form(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            key: vm.formKey,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'https://ds.demosoftonline.com/api/',
                                labelText: 'Url',
                              ),
                              onChanged: (value) => {
                                vm.url = value,
                              },
                              validator: (value) {
                                String pattern =
                                    r"^https?:\/\/[\w\-]+(\.[\w\-]+)+[/#?]?.*$";
                                RegExp regExp = RegExp(pattern);

                                return regExp.hasMatch(value ?? '')
                                    ? null
                                    : AppLocalizations.of(context)!.translate(
                                        BlockTranslate.url,
                                        "invalida",
                                      );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (Preferences.urlApi.isNotEmpty)
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: AppTheme.button(
                                      context,
                                      Styles.buttonStyle,
                                      Preferences.idTheme,
                                    ),
                                    // onPressed: () => Preferences.clearUrl(),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .translate(
                                            BlockTranslate.botones,
                                            "cancelar",
                                          ),
                                          style: AppTheme.style(
                                            context,
                                            Styles.whiteBoldStyle,
                                            Preferences.idTheme,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => vm.connectService(context),
                                    style: AppTheme.button(
                                      context,
                                      Styles.buttonStyle,
                                      Preferences.idTheme,
                                    ),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .translate(
                                            BlockTranslate.botones,
                                            "cambiar",
                                          ),
                                          style: AppTheme.style(
                                            context,
                                            Styles.whiteBoldStyle,
                                            Preferences.idTheme,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (Preferences.urlApi.isEmpty)
                            ElevatedButton(
                              onPressed: () => vm.connectService(context),
                              style: AppTheme.button(
                                context,
                                Styles.primary,
                                Preferences.idTheme,
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.translate(
                                      BlockTranslate.botones,
                                      "aceptar",
                                    ),
                                    style: AppTheme.style(
                                      context,
                                      Styles.whiteBoldStyle,
                                      Preferences.idTheme,
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.translate(
                          BlockTranslate.url,
                          "version",
                        )}: ${vmSplash.versionLocal}",
                        style: AppTheme.style(
                          context,
                          Styles.versionStyle,
                          Preferences.idTheme,
                        ),
                      ),
                      const SizedBox(width: 10)
                    ],
                  ),
                ],
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
              Preferences.idTheme,
            ),
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}
