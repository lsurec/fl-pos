import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes/app_theme.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LoginViewModel>(context);
    final vmSplash = Provider.of<SplashViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () => vm.navigateConfigApi(context),
                icon: const Icon(
                  Icons.vpn_lock_outlined,
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Center(
                    child: Image(
                      height: 125,
                      image: AssetImage("assets/empresa.png"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CardWidget(
                    width: double.infinity,
                    raidus: 18,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Form(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            key: vm.formKey,
                            child: Column(
                              children: [
                                InputWidget(
                                  formProperty: 'user',
                                  formValues: vm.formValues,
                                  maxLines: 1,
                                  initialValue: '',
                                  hintText:
                                      AppLocalizations.of(context)!.translate(
                                    BlockTranslate.general,
                                    "usuario",
                                  ),
                                  labelText:
                                      AppLocalizations.of(context)!.translate(
                                    BlockTranslate.general,
                                    "usuario",
                                  ),
                                  suffixIcon: Icons.person,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        decoration: InputDecoration(
                                            hintText:
                                                AppLocalizations.of(context)!
                                                    .translate(
                                              BlockTranslate.login,
                                              "contrasena",
                                            ),
                                            labelText:
                                                AppLocalizations.of(context)!
                                                    .translate(
                                              BlockTranslate.login,
                                              "contrasena",
                                            ),
                                            suffixIcon: IconButton(
                                              onPressed: vm.toggle,
                                              icon: Icon(
                                                vm.obscureText
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: AppTheme.primary,
                                              ),
                                            )),
                                        onChanged: (value) => {
                                          vm.formValues['pass'] = value,
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return AppLocalizations.of(context)!
                                                .translate(
                                              BlockTranslate.notificacion,
                                              "requerido",
                                            );
                                          }
                                          return null;
                                        },
                                        obscureText: vm.obscureText,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SwitchListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 0),
                            activeColor: AppTheme.primary,
                            title: Text(
                              AppLocalizations.of(context)!.translate(
                                BlockTranslate.login,
                                "recordar",
                              ),
                              style: const TextStyle(
                                color: AppTheme.primary,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            value: vm.isSliderDisabledSession,
                            onChanged: (value) => vm.disableSession(value),
                          ),
                          ElevatedButton(
                            onPressed: () => vm.login(context),
                            child: SizedBox(
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.translate(
                                    BlockTranslate.login,
                                    "iniciar",
                                  ),
                                  style: AppTheme.whiteBoldStyle,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.translate(
                          BlockTranslate.url,
                          "version",
                        )}  : ${vmSplash.versionLocal}",
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 10)
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Image(
                      height: 120,
                      image: AssetImage("assets/logo_demosoft.png"),
                    ),
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
