import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
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
                      "Mesero", //TODO:Translate
                      style: AppTheme.style(
                        context,
                        Styles.title,
                      ),
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
                            //TODO: Translate elemnts
                            child: TextFormField(
                                decoration: const InputDecoration(
                                  hintText: 'Pin',
                                  labelText: 'Pin',
                                ),
                                onChanged: (value) => {
                                      vm.pinMesero = value,
                                    },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Campo requerido.';
                                  }
                                  return null;
                                },
                                obscureText: true),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const SizedBox(
                                    width: double.infinity,
                                    child: Center(
                                      child: Text("Cancelar"), //TODO:Translate
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => vm.validatePin(context),
                                  child: const SizedBox(
                                    width: double.infinity,
                                    child: Center(
                                      child: Text("Aceptar"), //TODO:Translate
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
            color: AppTheme.color(
              context,
              Styles.loading,
            ),
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}
