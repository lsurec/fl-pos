import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class PinView extends StatelessWidget {
  const PinView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PinViewModel>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 150),
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "Mesero", //TODO:Translate
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: vm.formKey,
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
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const SizedBox(
                                width: double.infinity,
                                child: Center(
                                  child: Text("Cancelar"),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => vm.validatePin(),
                              child: const SizedBox(
                                width: double.infinity,
                                child: Center(
                                  child: Text("Aceptar"),
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
    );
  }
}
