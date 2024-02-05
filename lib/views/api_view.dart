import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
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
                          const Text(
                            "Url Apis",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (Preferences.urlApi.isEmpty)
                          const SizedBox(height: 10),
                        if (Preferences.urlApi.isEmpty)
                          const Text(
                            "Para poder utilizar nuestros servicios, por favor, introduce una URL válida. ",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        if (Preferences.urlApi.isNotEmpty)
                          const SizedBox(height: 20),
                        if (Preferences.urlApi.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Url Actual",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                tooltip: "Copiar url",
                                onPressed: () => vm.copyToClipboard(),
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
                                    : 'Url invalida';
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
                                    onPressed: () => vm.connectService(context),
                                    child: const SizedBox(
                                      width: double.infinity,
                                      child: Center(
                                        child: Text("Cambiar"),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (Preferences.urlApi.isEmpty)
                            ElevatedButton(
                              onPressed: () => vm.connectService(context),
                              child: const SizedBox(
                                width: double.infinity,
                                child: Center(
                                  child: Text("Aceptar"),
                                ),
                              ),
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
            color: AppTheme.backroundColor,
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}
