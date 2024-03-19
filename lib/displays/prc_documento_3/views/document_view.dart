import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DocumentView extends StatelessWidget {
  const DocumentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DocumentViewModel>(context);
    final vmFactura = Provider.of<DocumentoViewModel>(context);

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
                  "Serie",
                  style: AppTheme.titleStyle,
                ),
                if (vm.series.isEmpty)
                  const NotFoundWidget(
                    text: "No hay elementos",
                    icon: Icon(
                      Icons.browser_not_supported_outlined,
                      size: 50,
                    ),
                  ),
                if (vm.series.isNotEmpty)
                  DropdownButton<SerieModel>(
                    isExpanded: true,
                    dropdownColor: AppTheme.backroundColor,
                    value: vm.serieSelect,
                    onChanged: (value) => vm.changeSerie(value, context),
                    items: vm.series.map((serie) {
                      return DropdownMenuItem<SerieModel>(
                        value: serie,
                        child: Text(serie.descripcion!),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () async {
                        // vm.abrirFechaInicial(context);
                      },
                      icon: const Icon(Icons.calendar_today_outlined),
                      label: Text(
                        "",
                        // "Fecha: ${vm.fechaInicial.text}",
                        style: AppTheme.normalStyle,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        // vm.abrirHoraInicial(context);
                      },
                      icon: const Icon(Icons.schedule_outlined),
                      label: Text(
                        "",
                        // "Hora: ${vm.horaInicial.text}",
                        style: AppTheme.normalStyle,
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      vm.getTextCuenta(),
                      style: AppTheme.titleStyle,
                    ),
                    IconButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        "addClient",
                      ),
                      icon: const Icon(
                        Icons.person_add_outlined,
                      ),
                      tooltip: "Nueva Cuenta",
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
                      hintText: vm.getTextCuenta(),
                      suffixIcon: IconButton(
                        color: AppTheme.primary,
                        icon: const Icon(Icons.search),
                        onPressed: () => vm.performSearchClient(context),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo requerido.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SwitchListTile(
                  activeColor: AppTheme.primary,
                  contentPadding: EdgeInsets.zero,
                  value: vm.cf,
                  onChanged: (value) => vm.changeCF(value),
                  title: const Text(
                    "C/F",
                    style: AppTheme.titleStyle,
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
                            vm.getTextCuenta(),
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
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
                                color: Colors.grey[500],
                              ),
                              tooltip: "Editar cuenta",
                            )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        vm.clienteSelect!.facturaNit,
                        style: AppTheme.normalStyle,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        vm.clienteSelect!.facturaNombre,
                        style: AppTheme.normalStyle,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        vm.clienteSelect!.facturaDireccion,
                        style: AppTheme.normalStyle,
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
                      const Text(
                        "Vendedor",
                        style: AppTheme.titleStyle,
                      ),
                      DropdownButton<SellerModel>(
                        isExpanded: true,
                        dropdownColor: AppTheme.backroundColor,
                        value: vm.vendedorSelect,
                        onChanged: (value) => vm.changeSeller(value),
                        items: vm.cuentasCorrentistasRef.map((seller) {
                          return DropdownMenuItem<SellerModel>(
                            value: seller,
                            child: Text(seller.nomCuentaCorrentista),
                          );
                        }).toList(),
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
