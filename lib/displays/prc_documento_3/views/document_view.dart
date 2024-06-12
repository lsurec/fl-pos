import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DocumentView extends StatelessWidget {
  const DocumentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DocumentViewModel>(context);
    final vmFactura = Provider.of<DocumentoViewModel>(context);
    final vmConfirm = Provider.of<ConfirmDocViewModel>(context);

    return RefreshIndicator(
      onRefresh: () => vmFactura.loadData(context),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Id documento ref:",
                  style: AppTheme.titleStyle,
                ),
                const SizedBox(height: 3),
                Text(
                  vmConfirm.idDocumentoRef.toString(),
                  style: AppTheme.normalStyle,
                ),
                const SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.general,
                    'serie',
                  ),
                  style: AppTheme.style(
                    context,
                    Styles.title,
                    Preferences.idTheme,
                  ),
                ),
                if (vm.series.isEmpty)
                  NotFoundWidget(
                    text: AppLocalizations.of(context)!.translate(
                      BlockTranslate.notificacion,
                      'sinElementos',
                    ),
                    icon: const Icon(
                      Icons.browser_not_supported_outlined,
                      size: 50,
                    ),
                  ),
                if (vm.series.isNotEmpty)
                  DropdownButton<SerieModel>(
                    isExpanded: true,
                    dropdownColor: AppTheme.color(
                      context,
                      Styles.background,
                      Preferences.idTheme,
                    ),
                    value: vm.serieSelect,
                    onChanged: (value) => vm.changeSerie(value, context),
                    items: vm.series.map(
                      (serie) {
                        return DropdownMenuItem<SerieModel>(
                          value: serie,
                          child: Text(serie.descripcion!),
                        );
                      },
                    ).toList(),
                  ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      vm.getTextCuenta(context),
                      style: AppTheme.style(
                        context,
                        Styles.title,
                        Preferences.idTheme,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        "addClient",
                      ),
                      icon: const Icon(
                        Icons.person_add_outlined,
                      ),
                      tooltip: AppLocalizations.of(context)!.translate(
                        BlockTranslate.cuenta,
                        'nueva',
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: vm.formKeyClient,
                  child: TextFormField(
                    controller: vm.client,
                    onFieldSubmitted: (value) =>
                        vm.performSearchClient(context),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: vm.getTextCuenta(context),
                      suffixIcon: IconButton(
                        color: AppTheme.color(
                          context,
                          Styles.darkPrimary,
                          Preferences.idTheme,
                        ),
                        icon: const Icon(Icons.search),
                        onPressed: () => vm.performSearchClient(context),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.translate(
                          BlockTranslate.notificacion,
                          'requerido',
                        );
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SwitchListTile(
                  activeColor: AppTheme.color(
                    context,
                    Styles.darkPrimary,
                    Preferences.idTheme,
                  ),
                  contentPadding: EdgeInsets.zero,
                  value: vm.cf,
                  onChanged: (value) => vm.changeCF(
                    context,
                    value,
                  ),
                  title: Text(
                    "C/F",
                    style: AppTheme.style(
                      context,
                      Styles.title,
                      Preferences.idTheme,
                    ),
                  ),
                ),
                if (vm.clienteSelect != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            vm.getTextCuenta(context),
                            style: AppTheme.style(
                              context,
                              Styles.titlegrey,
                              Preferences.idTheme,
                            ),
                          ),
                          if (!vm.cf)
                            IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, "updateClient",
                                    arguments: vm.clienteSelect);
                              },
                              icon: Icon(
                                Icons.edit_outlined,
                                color: AppTheme.color(
                                  context,
                                  Styles.grey,
                                  Preferences.idTheme,
                                ),
                              ),
                              tooltip: AppLocalizations.of(context)!.translate(
                                BlockTranslate.cuenta,
                                'editar',
                              ),
                            )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        vm.clienteSelect!.facturaNit,
                        style: AppTheme.style(
                          context,
                          Styles.normal,
                          Preferences.idTheme,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        vm.clienteSelect!.facturaNombre,
                        style: AppTheme.style(
                          context,
                          Styles.normal,
                          Preferences.idTheme,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        vm.clienteSelect!.facturaDireccion,
                        style: AppTheme.style(
                          context,
                          Styles.normal,
                          Preferences.idTheme,
                        ),
                      ),
                    ],
                  ),
                if (vm.cuentasCorrentistasRef.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.factura,
                          'vendedor',
                        ),
                        style: AppTheme.style(
                          context,
                          Styles.title,
                          Preferences.idTheme,
                        ),
                      ),
                      DropdownButton<SellerModel>(
                        isExpanded: true,
                        dropdownColor: AppTheme.color(
                          context,
                          Styles.background,
                          Preferences.idTheme,
                        ),
                        value: vm.vendedorSelect,
                        onChanged: (value) => vm.changeSeller(value),
                        items: vm.cuentasCorrentistasRef.map(
                          (seller) {
                            return DropdownMenuItem<SellerModel>(
                              value: seller,
                              child: Text(
                                seller.nomCuentaCorrentista,
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
