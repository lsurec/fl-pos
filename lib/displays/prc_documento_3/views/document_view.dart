import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/utilities/utilities.dart';
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
                Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.cotizacion,
                    'docIdRef',
                  ),
                  style: AppTheme.style(
                    context,
                    Styles.title,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  vmConfirm.idDocumentoRef.toString(),
                  style: AppTheme.style(
                    context,
                    Styles.normal,
                  ),
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
                    ),
                    hint: Text(
                      AppLocalizations.of(context)!.translate(
                        BlockTranslate.factura,
                        'opcion',
                      ),
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
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.addClient,
                      ),
                      icon: const Icon(
                        Icons.person_add_outlined,
                      ),
                      tooltip: AppLocalizations.of(context)!.translate(
                        BlockTranslate.cuenta,
                        'nueva',
                      ),
                    ),
                    // IconButton(
                    //   onPressed: () => vm.restaurarFechas(),
                    //   icon: const Icon(
                    //     Icons.refresh,
                    //   ),
                    // )
                  ],
                ),
                if (vm.clienteSelect == null) const SizedBox(height: 20),
                if (vm.clienteSelect == null)
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
                            ),
                          ),
                          if (!vm.cf)
                            IconButton(
                              onPressed: () => Navigator.pushNamed(
                                context,
                                AppRoutes.updateClient,
                                arguments: vm.clienteSelect,
                              ),
                              icon: Icon(
                                Icons.edit_outlined,
                                color: AppTheme.color(
                                  context,
                                  Styles.grey,
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
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        vm.clienteSelect!.facturaNombre,
                        style: AppTheme.style(
                          context,
                          Styles.normal,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        vm.clienteSelect!.facturaDireccion,
                        style: AppTheme.style(
                          context,
                          Styles.normal,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "(${vm.clienteSelect!.desCuentaCta})",
                        style: AppTheme.style(
                          context,
                          Styles.inactive,
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
                        ),
                      ),
                      DropdownButton<SellerModel>(
                        isExpanded: true,
                        dropdownColor: AppTheme.color(
                          context,
                          Styles.background,
                        ),
                        hint: Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.factura,
                            'opcion',
                          ),
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
                //Mostrar tipos de eventos
                if (vm.valueParametro(58))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.factura,
                          'evento',
                        ),
                        style: AppTheme.style(
                          context,
                          Styles.title,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.cotizacion,
                          'tipoRef',
                        ),
                        style: AppTheme.style(
                          context,
                          Styles.title,
                        ),
                      ),
                      DropdownButton<TipoReferenciaModel>(
                        isExpanded: true,
                        dropdownColor: AppTheme.color(
                          context,
                          Styles.background,
                        ),
                        hint: Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.factura,
                            'opcion',
                          ),
                        ),
                        value: vm.referenciaSelect,
                        onChanged: (value) => vm.changeRef(value),
                        items: vm.referencias.map(
                          (tipoRef) {
                            return DropdownMenuItem<TipoReferenciaModel>(
                              value: tipoRef,
                              child: Text(
                                tipoRef.descripcion,
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ],
                  ),
                const SizedBox(height: 10),
                // const Divider(),
//Fecha Entrega
                if (vm.valueParametro(381))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.fecha,
                          'entrega',
                        ),
                        style: AppTheme.style(
                          context,
                          Styles.title,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: () => vm.abrirFechaEntrega(context),
                            icon: Icon(
                              Icons.calendar_today_outlined,
                              color: AppTheme.color(
                                context,
                                Styles.darkPrimary,
                              ),
                            ),
                            label: Text(
                              "${AppLocalizations.of(context)!.translate(
                                BlockTranslate.fecha,
                                'fecha',
                              )} ${Utilities.formatearFecha(vm.fechaRefIni)}",
                              style: AppTheme.style(
                                context,
                                Styles.normal,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => vm.abrirHoraEntrega(context),
                            icon: Icon(
                              Icons.schedule_outlined,
                              color: AppTheme.color(
                                context,
                                Styles.darkPrimary,
                              ),
                            ),
                            label: Text(
                              "${AppLocalizations.of(context)!.translate(
                                BlockTranslate.fecha,
                                'hora',
                              )} ${Utilities.formatearHora(vm.fechaRefIni)}",
                              style: AppTheme.style(
                                context,
                                Styles.normal,
                              ),
                            ),
                          )
                        ],
                      ),
                      const Divider(),
                    ],
                  ),
//Fecha Recoger
                if (vm.valueParametro(382))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.fecha,
                          'recoger',
                        ),
                        style: AppTheme.style(
                          context,
                          Styles.title,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: () => vm.abrirFechaRecoger(context),
                            icon: Icon(
                              Icons.calendar_today_outlined,
                              color: AppTheme.color(
                                context,
                                Styles.darkPrimary,
                              ),
                            ),
                            label: Text(
                              "${AppLocalizations.of(context)!.translate(
                                BlockTranslate.fecha,
                                'fecha',
                              )} ${Utilities.formatearFecha(vm.fechaRefFin)}",
                              style: AppTheme.style(
                                context,
                                Styles.normal,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => vm.abrirHoraRecoger(context),
                            icon: Icon(
                              Icons.schedule_outlined,
                              color: AppTheme.color(
                                context,
                                Styles.darkPrimary,
                              ),
                            ),
                            label: Text(
                              "${AppLocalizations.of(context)!.translate(
                                BlockTranslate.fecha,
                                'hora',
                              )} ${Utilities.formatearHora(vm.fechaRefFin)}",
                              style: AppTheme.style(
                                context,
                                Styles.normal,
                              ),
                            ),
                          )
                        ],
                      ),
                      const Divider(),
                    ],
                  ),
//Fecha Inicio
                if (vm.valueParametro(44))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.fecha,
                          'inicio',
                        ),
                        style: AppTheme.style(
                          context,
                          Styles.title,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: () => vm.abrirFechaInicial(context),
                            icon: Icon(
                              Icons.calendar_today_outlined,
                              color: AppTheme.color(
                                context,
                                Styles.darkPrimary,
                              ),
                            ),
                            label: Text(
                              "${AppLocalizations.of(context)!.translate(
                                BlockTranslate.fecha,
                                'fecha',
                              )} ${Utilities.formatearFecha(vm.fechaInicial)}",
                              style: AppTheme.style(
                                context,
                                Styles.normal,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => vm.abrirHoraInicial(context),
                            icon: Icon(
                              Icons.schedule_outlined,
                              color: AppTheme.color(
                                context,
                                Styles.darkPrimary,
                              ),
                            ),
                            label: Text(
                              "${AppLocalizations.of(context)!.translate(
                                BlockTranslate.fecha,
                                'hora',
                              )} ${Utilities.formatearHora(vm.fechaInicial)}",
                              style: AppTheme.style(
                                context,
                                Styles.normal,
                              ),
                            ),
                          )
                        ],
                      ),
                      const Divider(),
                    ],
                  ),
//Fecha Fin
                if (vm.valueParametro(381))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.fecha,
                          'fin',
                        ),
                        style: AppTheme.style(
                          context,
                          Styles.title,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: () => vm.abrirFechaFinal(context),
                            icon: Icon(
                              Icons.calendar_today_outlined,
                              color: AppTheme.color(
                                context,
                                Styles.darkPrimary,
                              ),
                            ),
                            label: Text(
                              "${AppLocalizations.of(context)!.translate(
                                BlockTranslate.fecha,
                                'fecha',
                              )} ${Utilities.formatearFecha(vm.fechaFinal)}",
                              style: AppTheme.style(
                                context,
                                Styles.normal,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => vm.abrirHoraFinal(context),
                            icon: Icon(
                              Icons.schedule_outlined,
                              color: AppTheme.color(
                                context,
                                Styles.darkPrimary,
                              ),
                            ),
                            label: Text(
                              "${AppLocalizations.of(context)!.translate(
                                BlockTranslate.fecha,
                                'hora',
                              )} ${Utilities.formatearHora(vm.fechaFinal)}",
                              style: AppTheme.style(
                                context,
                                Styles.normal,
                              ),
                            ),
                          )
                        ],
                      ),
                      const Divider(),
                    ],
                  ),
//Fin fechas
//parametro 385 = Contacto
                if (vm.valueParametro(385))
                  _Observacion(
                    controller: vm.contacto,
                    labelText: vm.getTextParam(385) ??
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.factura,
                          'contacto',
                        ),
                  ),
//parametro 383 = Descripcion
                if (vm.valueParametro(383))
                  _Observacion(
                    controller: vm.contacto,
                    labelText: vm.getTextParam(383) ??
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.general,
                          'descripcion',
                        ),
                  ),
//parametro 386 = Direccion de entrega
                if (vm.valueParametro(386))
                  _Observacion(
                    controller: vm.contacto,
                    labelText: vm.getTextParam(386) ??
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.cotizacion,
                          'direEntrega',
                        ),
                  ),
//parametro 384 = Observacion
                if (vm.valueParametro(384))
                  _Observacion(
                    controller: vm.contacto,
                    labelText: vm.getTextParam(384) ??
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.general,
                          'observacion',
                        ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class _Observacion extends StatelessWidget {
//   final TextEditingController controller;
//   final String labelText;

//   const _Observacion({
//     required this.controller,
//     required this.labelText,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       maxLines: 3,
//       decoration: InputDecoration(
//         labelText: labelText,
//         hintText: labelText,
//       ),
//     );
//   }
// }

class _Observacion extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const _Observacion({
    required this.controller,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        maxLines: 3,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: labelText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.color(
                context,
                Styles.border,
              ),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.color(
                context,
                Styles.border,
              ),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
