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
                if (vm.valueParam(58))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vm.getTextParam(58) ?? "DATOS DE EVENTO",
                        style: AppTheme.titleStyle,
                      ),
                      const SizedBox(height: 5),
                      const Divider(),
                      const SizedBox(height: 5),
                      const Text(
                        "Tipo de referencia",
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
                    ],
                  ),
                if (vm.valueParam(381))
                  Row(
                    children: [
                      Text(
                        vm.getTextParam(381) ?? "Fecha Entrega:",
                        style: AppTheme.normalBoldStyle,
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () => vm.showDateEntrega(context),
                        icon: const Icon(Icons.calendar_today_outlined),
                        label: Text(
                          vm.getDateStr(vm.fechaEntrega),
                          style: AppTheme.normalStyle,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => vm.showTimeEntrega(context),
                        icon: const Icon(Icons.schedule_outlined),
                        label: Text(
                          vm.getTimeStr(vm.fechaEntrega),
                          style: AppTheme.normalStyle,
                        ),
                      )
                    ],
                  ),
                if (vm.valueParam(382))
                  Row(
                    children: [
                      Text(
                        vm.getTextParam(382) ?? "Fecha Recoger:",
                        style: AppTheme.normalBoldStyle,
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () => vm.showDateRecoger(context),
                        icon: const Icon(Icons.calendar_today_outlined),
                        label: Text(
                          vm.getDateStr(vm.fechaRecoger),
                          style: AppTheme.normalStyle,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => vm.showTimeRecoger(context),
                        icon: const Icon(Icons.schedule_outlined),
                        label: Text(
                          vm.getTimeStr(vm.fechaRecoger),
                          style: AppTheme.normalStyle,
                        ),
                      )
                    ],
                  ),
                if (vm.valueParam(382)) const Divider(),
                if (vm.valueParam(44))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Fecha Inicio:",
                            style: AppTheme.normalBoldStyle,
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () => vm.showDateInicio(context),
                            icon: const Icon(Icons.calendar_today_outlined),
                            label: Text(
                              vm.getDateStr(vm.fechaInicio),
                              style: AppTheme.normalStyle,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => vm.showTimeInicio(context),
                            icon: const Icon(Icons.schedule_outlined),
                            label: Text(
                              vm.getTimeStr(vm.fechaInicio),
                              style: AppTheme.normalStyle,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "Fecha Fin:",
                            style: AppTheme.normalBoldStyle,
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () => vm.showDateFin(context),
                            icon: const Icon(Icons.calendar_today_outlined),
                            label: Text(
                              vm.getDateStr(vm.fechaFin),
                              style: AppTheme.normalStyle,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => vm.showTimeFin(context),
                            icon: const Icon(Icons.schedule_outlined),
                            label: Text(
                              vm.getTimeStr(vm.fechaFin),
                              style: AppTheme.normalStyle,
                            ),
                          )
                        ],
                      ),
                      const Divider(),
                    ],
                  ),
                if (vm.valueParam(385))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      controller: vm.inputContacto,
                      decoration: InputDecoration(
                        hintText: vm.getTextParam(385),
                        labelText: vm.getTextParam(385),
                      ),
                    ),
                  ),
                if (vm.valueParam(383))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      controller: vm.inputDescripcion,
                      decoration: InputDecoration(
                        hintText: vm.getTextParam(383),
                        labelText: vm.getTextParam(383),
                      ),
                    ),
                  ),
                if (vm.valueParam(386))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      controller: vm.inputDireccionEntrega,
                      decoration: InputDecoration(
                        hintText: vm.getTextParam(386),
                        labelText: vm.getTextParam(386),
                      ),
                    ),
                  ),
                if (vm.valueParam(384))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      controller: vm.inputDireccionEntrega,
                      decoration: InputDecoration(
                        hintText: vm.getTextParam(384),
                        labelText: vm.getTextParam(384),
                      ),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      vm.getTextParam(57) ?? "Cuenta",
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
                      hintText: vm.getTextParam(57) ?? "Cuenta",
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
                            vm.getTextParam(57) ?? "Cuenta",
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
