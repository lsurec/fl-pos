import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/permisions_view_model.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class PermisionsView extends StatelessWidget {
  const PermisionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int tipoAccion = ModalRoute.of(context)!.settings.arguments as int;
    final PermisionsViewModel vm = Provider.of<PermisionsViewModel>(context);

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
                      tipoAccion == 32
                          ? "Trasladar Mesa (Cuenta)"
                          : "Trasladar Transaccion",
                      style: const TextStyle(
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
                                  hintText: 'Usuario',
                                  labelText: 'Usuario',
                                  suffixIcon: Icons.person,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      hintText: 'Contraseña',
                                      labelText: 'Contraseña',
                                      suffixIcon: Icon(
                                        Icons.lock,
                                        color: AppTheme.primary,
                                      )),
                                  onChanged: (value) =>
                                      vm.formValues['pass'] = value,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Campo requerido.';
                                    }
                                    return null;
                                  },
                                  obscureText: true,
                                ),
                              ],
                            ),
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
                                      child: Text("Cancelar"),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => vm.login(context,
                                      tipoAccion), //32 trasladar mesa; 45 trasladar transaccion
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
