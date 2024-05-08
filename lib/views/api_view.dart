import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
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
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
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
                            style: const TextStyle(
                              fontSize: 20,
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
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                tooltip:
                                    AppLocalizations.of(context)!.translate(
                                  BlockTranslate.url,
                                  "copiar",
                                ),
                                onPressed: () => vm.copyToClipboard(context),
                                icon: const Icon(Icons.copy_outlined),
                              )
                            ],
                          ),
                        if (Preferences.urlApi.isNotEmpty)
                          const SizedBox(height: 10),
                        if (Preferences.urlApi.isNotEmpty)
                          Text(
                            Preferences.urlApi,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  CardWidget(
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
                                          style: AppTheme.whiteBoldStyle,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => vm.connectService(context),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .translate(
                                            BlockTranslate.botones,
                                            "cambiar",
                                          ),
                                          style: AppTheme.whiteBoldStyle,
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
                              child: SizedBox(
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.translate(
                                      BlockTranslate.botones,
                                      "aceptar",
                                    ),
                                    style: AppTheme.whiteBoldStyle,
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
                        style: const TextStyle(
                          color: Colors.black54,
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
            color: AppTheme.backroundColor,
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}
