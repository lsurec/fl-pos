import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/client_model.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class UpdateClientView extends StatelessWidget {
  const UpdateClientView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AddClientViewModel>(context);
    final ClientModel cuenta =
        ModalRoute.of(context)!.settings.arguments as ClientModel;

    return Stack(
      children: [
        Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => vm.createClinet(
              context,
              cuenta.cuentaCorrentista,
            ),
            child: const Icon(Icons.save_outlined),
          ),
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.translate(
                BlockTranslate.cuenta,
                'actualizar',
              ),
              style: AppTheme.style(
                Styles.title,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: vm.formKey,
                child: Column(
                  children: [
                    InputWidget(
                      initialValue: cuenta.facturaNombre,
                      maxLines: 1,
                      formProperty: "nombre",
                      formValues: vm.formValues,
                      hintText: AppLocalizations.of(context)!.translate(
                        BlockTranslate.cuenta,
                        'nombre',
                      ),
                      labelText: AppLocalizations.of(context)!.translate(
                        BlockTranslate.cuenta,
                        'nombre',
                      ),
                    ),
                    InputWidget(
                      initialValue: cuenta.facturaDireccion,
                      maxLines: 1,
                      formProperty: "direccion",
                      formValues: vm.formValues,
                      hintText: AppLocalizations.of(context)!.translate(
                        BlockTranslate.cuenta,
                        'direccion',
                      ),
                      labelText: AppLocalizations.of(context)!.translate(
                        BlockTranslate.cuenta,
                        'direccion',
                      ),
                    ),
                    InputWidget(
                      initialValue: cuenta.facturaNit,
                      maxLines: 1,
                      formProperty: "nit",
                      formValues: vm.formValues,
                      hintText: "Nit",
                      labelText: "Nit",
                    ),
                    InputWidget(
                      initialValue: cuenta.telefono,
                      maxLines: 1,
                      formProperty: "telefono",
                      formValues: vm.formValues,
                      hintText: AppLocalizations.of(context)!.translate(
                        BlockTranslate.cuenta,
                        'telefono',
                      ),
                      labelText: AppLocalizations.of(context)!.translate(
                        BlockTranslate.cuenta,
                        'telefono',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: TextFormField(
                        initialValue: cuenta.eMail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.translate(
                            BlockTranslate.cuenta,
                            'correo',
                          ),
                          labelText: AppLocalizations.of(context)!.translate(
                            BlockTranslate.cuenta,
                            'correo',
                          ),
                        ),
                        onChanged: (value) => vm.formValues["correo"] = value,
                        validator: (value) {
                          String pattern =
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regExp = RegExp(pattern);
                          return regExp.hasMatch(value ?? '')
                              ? null
                              : AppLocalizations.of(context)!.translate(
                                  BlockTranslate.cuenta,
                                  'invalido',
                                );
                        },
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
              Styles.loading,
            ),
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}
