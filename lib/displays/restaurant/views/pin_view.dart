import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class PinView extends StatelessWidget {
  const PinView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PinViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 150),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      AppLocalizations.of(context)!.translate(
                        BlockTranslate.restaurante,
                        'mesero',
                      ),
                      style: StyleApp.title,
                    ),
                  ),
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
                              decoration: InputDecoration(
                                hintText:
                                    AppLocalizations.of(context)!.translate(
                                  BlockTranslate.restaurante,
                                  'pin',
                                ),
                                labelText:
                                    AppLocalizations.of(context)!.translate(
                                  BlockTranslate.restaurante,
                                  'pin',
                                ),
                              ),
                              onChanged: (value) => {
                                vm.pinMesero = value,
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .translate(
                                    BlockTranslate.notificacion,
                                    'requerido',
                                  );
                                }
                                return null;
                              },
                              obscureText: true,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)!.translate(
                                          BlockTranslate.botones,
                                          'cancelar',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => vm.validatePin(context),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)!.translate(
                                          BlockTranslate.botones,
                                          'aceptar',
                                        ),
                                        style: StyleApp.whiteBold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
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
            color: AppTheme.isDark()
                ? AppTheme.darkBackroundColor
                : AppTheme.backroundColor,
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}
