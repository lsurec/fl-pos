// ignore_for_file: deprecated_member_use

import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/utilities/utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ConfirmDocView extends StatelessWidget {
  const ConfirmDocView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final docVM = Provider.of<DocumentViewModel>(context);
    final vm = Provider.of<ConfirmDocViewModel>(context);
    final int screen = ModalRoute.of(context)!.settings.arguments as int;
    final vmDoc = Provider.of<DocumentoViewModel>(context);
    final paymentsVM = Provider.of<PaymentViewModel>(context);

    return WillPopScope(
      onWillPop: () => vmDoc.backTabs(context),
      child: Stack(
        children: [
          Scaffold(
            key: vm.scaffoldKey,
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.factura,
                  'resumenDoc',
                ),
                style: StyleApp.title,
              ),
              actions: [
                if (vm.showPrint)
                  IconButton(
                    onPressed: () => vm.sheredDoc(
                      context,
                    ),
                    icon: const Icon(
                      Icons.share,
                    ),
                  ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (vm.showPrint)
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.cotizacion,
                          'consecutivoInter',
                        ),
                        style: StyleApp.title,
                      ),
                    if (vm.showPrint)
                      Text(
                        "${vm.consecutivoDoc}",
                        style: StyleApp.normal,
                      ),
                    if (vm.showPrint) const SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        style: StyleApp.normal.copyWith(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                        children: [
                          TextSpan(
                            text: AppLocalizations.of(context)!.translate(
                              BlockTranslate.cotizacion,
                              'docIdRef',
                            ),
                            style: StyleApp.normalBold,
                          ),
                          TextSpan(
                            text: vm.idDocumentoRef.toString(),
                            style: StyleApp.normal,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Divider(),
                    const SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        style: StyleApp.normal.copyWith(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                        children: [
                          TextSpan(
                            text: AppLocalizations.of(context)!.translate(
                              BlockTranslate.tiket,
                              'latitud',
                            ),
                            style: StyleApp.normalBold,
                          ),
                          TextSpan(
                            text: vm.currentPosition?.latitude.toString() ??
                                AppLocalizations.of(context)!.translate(
                                  BlockTranslate.tiket,
                                  'sinObtener',
                                ),
                            style: StyleApp.normal,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        style: StyleApp.normal.copyWith(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                        children: [
                          TextSpan(
                            text: AppLocalizations.of(context)!.translate(
                              BlockTranslate.tiket,
                              'longitud',
                            ),
                            style: StyleApp.normalBold,
                          ),
                          TextSpan(
                            text: vm.currentPosition?.longitude.toString() ??
                                AppLocalizations.of(context)!.translate(
                                  BlockTranslate.tiket,
                                  'sinObtener',
                                ),
                            style: StyleApp.normal,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Divider(),
                    const SizedBox(height: 5),
                    _DataUser(
                      title: AppLocalizations.of(context)!.translate(
                        BlockTranslate.cuenta,
                        'cliente',
                      ),
                      user: DataUserModel(
                        name: docVM.clienteSelect?.facturaNombre ?? "",
                        nit: docVM.clienteSelect?.facturaNit ?? "",
                        adress: docVM.clienteSelect?.facturaDireccion ?? "",
                        desCtaCta: docVM.clienteSelect?.desCuentaCta ?? "",
                      ),
                    ),
                    if (docVM.cuentasCorrentistasRef.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          const Divider(),
                          const SizedBox(height: 5),
                          Text(
                            AppLocalizations.of(context)!.translate(
                              BlockTranslate.factura,
                              'vendedor',
                            ),
                            style: StyleApp.title,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            docVM.vendedorSelect?.nomCuentaCorrentista ?? "",
                            style: StyleApp.normal,
                          ),
                        ],
                      ),
                    if (docVM.referenciaSelect?.descripcion != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          const Divider(),
                          const SizedBox(height: 5),
                          Text(
                            AppLocalizations.of(context)!.translate(
                              BlockTranslate.tiket,
                              'tipoRef',
                            ),
                            style: StyleApp.title,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            docVM.referenciaSelect?.descripcion ?? "",
                            style: StyleApp.normal,
                          ),
                        ],
                      ),
//Contacto: 385
                    if (docVM.refContactoParam385.text.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          const Divider(),
                          const SizedBox(height: 5),
                          Text(
                            docVM.getTextParam(385) ??
                                AppLocalizations.of(context)!.translate(
                                  BlockTranslate.factura,
                                  'contacto',
                                ),
                            style: StyleApp.title,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            docVM.refContactoParam385.text,
                            style: StyleApp.normal,
                          ),
                        ],
                      ),
//Descripcion: 383
                    if (docVM.refDescripcionParam383.text.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          const Divider(),
                          const SizedBox(height: 5),
                          Text(
                            docVM.getTextParam(383) ??
                                AppLocalizations.of(context)!.translate(
                                  BlockTranslate.general,
                                  'descripcion',
                                ),
                            style: StyleApp.title,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            docVM.refDescripcionParam383.text,
                            style: StyleApp.normal,
                          ),
                        ],
                      ),
//Direccion Entrega: 386
                    if (docVM.refDirecEntregaParam386.text.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          const Divider(),
                          const SizedBox(height: 5),
                          Text(
                            docVM.getTextParam(386) ??
                                AppLocalizations.of(context)!.translate(
                                  BlockTranslate.cotizacion,
                                  'direEntrega',
                                ),
                            style: StyleApp.title,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            docVM.refDirecEntregaParam386.text,
                            style: StyleApp.normal,
                          ),
                        ],
                      ),
//Observacion: 384
                    if (docVM.refObservacionParam384.text.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          const Divider(),
                          const SizedBox(height: 5),
                          Text(
                            docVM.getTextParam(384) ??
                                AppLocalizations.of(context)!.translate(
                                  BlockTranslate.general,
                                  'observacion',
                                ),
                            style: StyleApp.title,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            docVM.refObservacionParam384.text,
                            style: StyleApp.normal,
                          ),
                        ],
                      ),
                    if (docVM.valueParametro(381) || docVM.valueParametro(382))
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
//Fecha Ref Ini
                          const SizedBox(height: 5),
                          const Divider(),
                          const SizedBox(height: 5),
                          Text(
                            docVM.getTextParam(381) ??
                                AppLocalizations.of(context)!.translate(
                                  BlockTranslate.fecha,
                                  'entrega',
                                ),
                            style: StyleApp.title,
                          ),
                          Text(
                            Utilities.formatearFechaHora(
                              docVM.fechaRefIni,
                            ),
                            style: StyleApp.normal,
                          ),
//Fecha Ref Fin
                          const SizedBox(height: 5),
                          const Divider(),
                          const SizedBox(height: 5),
                          Text(
                            docVM.getTextParam(382) ??
                                AppLocalizations.of(context)!.translate(
                                  BlockTranslate.fecha,
                                  'entrega',
                                ),
                            style: StyleApp.title,
                          ),
                          Text(
                            Utilities.formatearFechaHora(
                              docVM.fechaRefFin,
                            ),
                            style: StyleApp.normal,
                          ),
                        ],
                      ),
                    if (docVM.valueParametro(44))
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
//Fecha Ini
                          const SizedBox(height: 5),
                          const Divider(),
                          const SizedBox(height: 5),
                          Text(
                            AppLocalizations.of(context)!.translate(
                              BlockTranslate.fecha,
                              'inicio',
                            ),
                            style: StyleApp.title,
                          ),
                          Text(
                            Utilities.formatearFechaHora(
                              docVM.fechaInicial,
                            ),
                            style: StyleApp.normal,
                          ),
//Fecha Fin
                          const SizedBox(height: 5),
                          const Divider(),
                          const SizedBox(height: 5),
                          Text(
                            AppLocalizations.of(context)!.translate(
                              BlockTranslate.fecha,
                              'fin',
                            ),
                            style: StyleApp.title,
                          ),
                          Text(
                            Utilities.formatearFechaHora(
                              docVM.fechaFinal,
                            ),
                            style: StyleApp.normal,
                          ),
                        ],
                      ),
                    const SizedBox(height: 5),
                    const Divider(),
                    const SizedBox(height: 5),
                    Text(
                      AppLocalizations.of(context)!.translate(
                        BlockTranslate.factura,
                        'productos',
                      ),
                      style: StyleApp.title,
                    ),
                    const SizedBox(height: 5),
                    _Transaction(),
                    const SizedBox(height: 5),
                    const Divider(),
                    if (paymentsVM.paymentList.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            AppLocalizations.of(context)!.translate(
                              BlockTranslate.factura,
                              'formasPago',
                            ),
                            style: StyleApp.title,
                          ),
                          const SizedBox(height: 5),
                          _Pyments(),
                          const SizedBox(height: 5),
                          const Divider(),
                          const SizedBox(height: 5),
                        ],
                      ),
                    _Totals(),
                    const SizedBox(height: 5),
                    _TotalsPayment(),
                    const SizedBox(height: 10),
                    if (!vm.showPrint) _Observacion(),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      activeColor: AppTheme.color(
                        context,
                        Styles.darkPrimary,
                      ),
                      value: vm.directPrint,
                      onChanged: (value) => vm.directPrint = value,
                      title: Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.tiket,
                          'imprimir',
                        ),
                        style: StyleApp.normal,
                      ),
                    ),
                    if (!vm.showPrint)
                      _Options(
                        screen: screen,
                      ),
                    if (vm.showPrint) _Print(screen: screen),
                  ],
                ),
              ),
            ),
          ),
          if (vm.isLoadingDTE || vm.isLoading)
            ModalBarrier(
              dismissible: false,
              // color: Colors.black.withOpacity(0.3),
              color: AppTheme.color(
                context,
                Styles.loading,
              ),
            ),
          if (vm.isLoading) const LoadWidget(),
          if (vm.isLoadingDTE)
            // const LoadWidget(),
            Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/logo_demosoft.png",
                          height: 150,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.translate(
                              BlockTranslate.general,
                              'tareasCompletas',
                            )} ${vm.stepsSucces}/${vm.steps.length}",
                            style: StyleApp.greyText,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: vm.steps.length,
                        separatorBuilder: (_, __) {
                          return const Column(
                            children: [
                              SizedBox(height: 5),
                              Divider(),
                              SizedBox(height: 5),
                            ],
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          final LoadStepModel step = vm.steps[index];

                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    step.text,
                                    style: StyleApp.normal,
                                  ),
                                  if (step.status == 1) //Cargando
                                    Icon(
                                      Icons.pending_outlined,
                                      color: AppTheme.color(
                                        context,
                                        Styles.grey,
                                      ),
                                    ),
                                  if (step.status == 2) //exitoso
                                    Icon(
                                      Icons.check_circle_outline,
                                      color: AppTheme.color(
                                        context,
                                        Styles.green,
                                      ),
                                    ),
                                  if (step.status == 3) //error
                                    Icon(
                                      Icons.cancel_outlined,
                                      color: AppTheme.color(
                                        context,
                                        Styles.red,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              if (step.isLoading)
                                LinearProgressIndicator(
                                  color: AppTheme.color(
                                    context,
                                    Styles.darkPrimary,
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      if (vm.viewMessage)
                        Text(
                          vm.error,
                          style: AppNewTheme.style(
                            StyleApp.red,
                            StyleApp.redDark,
                          ),
                        ),
                      if (vm.viewSucces)
                        Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.notificacion,
                            'docProcesado',
                          ),
                          style: AppNewTheme.style(
                            StyleApp.green,
                            StyleApp.greenDark,
                          ),
                        ),
                      if (vm.viewError)
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () => vm.navigateError(),
                            child: Text(
                              AppLocalizations.of(context)!.translate(
                                BlockTranslate.botones,
                                'verError',
                              ),
                              style: AppNewTheme.style(
                                StyleApp.blueText,
                                StyleApp.blueDarkText,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      if (vm.viewErrorFel) _OptionsError(),
                      if (vm.viewErrorProcess) _OptionsErrorAll(),
                      if (vm.viewSucces)
                        SizedBox(
                          height: 75,
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    vm.isLoadingDTE = false;
                                    vm.showPrint = true;
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      top: 10,
                                      bottom: 10,
                                      right: 10,
                                    ),
                                    color: AppTheme.color(
                                      context,
                                      Styles.primary,
                                    ),
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)!.translate(
                                          BlockTranslate.botones,
                                          'aceptar',
                                        ),
                                        style: StyleApp.whiteNormal,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Observacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ConfirmDocViewModel>(context);

    return TextField(
      controller: vm.observacion,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.translate(
          BlockTranslate.general,
          'observacion',
        ),
        hintText: AppLocalizations.of(context)!.translate(
          BlockTranslate.general,
          'observacion',
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.color(
              context,
              Styles.border,
            ),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class _Print extends StatelessWidget {
  final int screen;

  const _Print({required this.screen});
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ConfirmDocViewModel>(context);
    final vmDoc = Provider.of<DocumentoViewModel>(context);

    return SizedBox(
      height: 75,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => vmDoc.backTabs(context),
              child: Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  right: 10,
                ),
                color: AppTheme.color(
                  context,
                  Styles.primary,
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.botones,
                      'listo',
                    ),
                    style: StyleApp.whiteNormal,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => screen == 1
                  ? vm.navigatePrint(context)
                  : vm.printNetwork(context),
              child: Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 10,
                ),
                color: AppTheme.color(
                  context,
                  Styles.primary,
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.botones,
                      'imprimir',
                    ),
                    style: StyleApp.whiteNormal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionsError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ConfirmDocViewModel>(context);

    return SizedBox(
      height: 75,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => vm.printWithoutFel(context),
              child: Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  right: 10,
                ),
                color: AppTheme.color(
                  context,
                  Styles.primary,
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.botones,
                      'sinFirma',
                    ),
                    style: StyleApp.whiteNormal,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => vm.reloadCert(context),
              child: Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 10,
                ),
                color: AppTheme.color(
                  context,
                  Styles.primary,
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.botones,
                      'reintentar',
                    ),
                    style: StyleApp.whiteNormal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionsErrorAll extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ConfirmDocViewModel>(context);

    return SizedBox(
      height: 75,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => vm.isLoadingDTE = false,
              child: Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  right: 10,
                ),
                color: AppTheme.color(
                  context,
                  Styles.primary,
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.botones,
                      'aceptar',
                    ),
                    style: StyleApp.whiteNormal,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => vm.processDocument(context),
              child: Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 10,
                ),
                color: AppTheme.color(
                  context,
                  Styles.primary,
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.botones,
                      'reintentar',
                    ),
                    style: StyleApp.whiteNormal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Options extends StatelessWidget {
  final int screen;

  const _Options({required this.screen});
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ConfirmDocViewModel>(context);

    return SizedBox(
      height: 75,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  right: 10,
                ),
                color: AppTheme.color(
                  context,
                  Styles.primary,
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.botones,
                      'cancelar',
                    ),
                    style: StyleApp.whiteNormal,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              // onTap: () => vm.sendDocument(),
              onTap: () {
                vm.sendDoc(context, screen);
                // vm.isLoading = true
              },
              child: Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 10,
                ),
                color: AppTheme.color(
                  context,
                  Styles.primary,
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.botones,
                      'confirmar',
                    ),
                    style: StyleApp.whiteNormal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pyments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final paymentsVM = Provider.of<PaymentViewModel>(context);

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: paymentsVM.amounts.length,
      itemBuilder: (BuildContext context, int index) {
        final AmountModel amount = paymentsVM.amounts[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(
              color: AppTheme.color(
                context,
                Styles.border,
              ),
              width: 1.0,
            ),
          ),
          color: AppTheme.color(
            context,
            Styles.background,
          ),
          child: ListTile(
            title: Text(
              amount.payment.descripcion,
              style: StyleApp.normal,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (amount.authorization != "")
                  Text(
                    '${AppLocalizations.of(context)!.translate(
                      BlockTranslate.factura,
                      'autorizar',
                    )}: ${amount.authorization}',
                    style: StyleApp.normal,
                  ),
                if (amount.reference != "")
                  Text(
                    '${AppLocalizations.of(context)!.translate(
                      BlockTranslate.factura,
                      'referencia',
                    )}: ${amount.reference}',
                    style: StyleApp.normal,
                  ),
                if (amount.payment.banco)
                  Text(
                    '${AppLocalizations.of(context)!.translate(
                      BlockTranslate.factura,
                      'banco',
                    )}: ${amount.bank?.nombre}',
                    style: StyleApp.normal,
                  ),
                if (amount.account != null)
                  Text(
                    '${AppLocalizations.of(context)!.translate(
                      BlockTranslate.factura,
                      'cuenta',
                    )}: ${amount.account!.descripcion}',
                    style: StyleApp.normal,
                  ),
                Text(
                  '${AppLocalizations.of(context)!.translate(
                    BlockTranslate.calcular,
                    'monto',
                  )}: ${amount.amount.toStringAsFixed(2)}',
                  style: StyleApp.normal,
                ),
                // Text('Detalles: ${transaction.detalles}'),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TotalsPayment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final paymentsVM = Provider.of<PaymentViewModel>(context);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(
          color: AppTheme.color(
            context,
            Styles.border,
          ),
          width: 1.0,
        ), // Define el color y grosor del borde
      ),
      color: AppTheme.color(
        context,
        Styles.background,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            RowTotalWidget(
              title: AppLocalizations.of(context)!.translate(
                BlockTranslate.calcular,
                'contado',
              ),
              value: paymentsVM.pagado,
            ),
            RowTotalWidget(
              title: AppLocalizations.of(context)!.translate(
                BlockTranslate.calcular,
                'cambio',
              ),
              value: paymentsVM.cambio,
            ),
          ],
        ),
      ),
    );
  }
}

class _Totals extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final detailsVM = Provider.of<DetailsViewModel>(context);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(
          color: AppTheme.color(
            context,
            Styles.border,
          ),
          width: 1.0,
        ), // Define el color y grosor del borde
      ),
      color: AppTheme.color(
        context,
        Styles.background,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            RowTotalWidget(
              title: AppLocalizations.of(context)!.translate(
                BlockTranslate.calcular,
                'subTotal',
              ),
              value: detailsVM.subtotal,
            ),
            RowTotalWidget(
              title: "(+) ${AppLocalizations.of(context)!.translate(
                BlockTranslate.calcular,
                'cargo',
              )}",
              value: detailsVM.cargo,
            ),
            RowTotalWidget(
              title: "(-) ${AppLocalizations.of(context)!.translate(
                BlockTranslate.calcular,
                'descuento',
              )}",
              value: detailsVM.descuento,
            ),
            const Divider(),
            RowTotalWidget(
              title: AppLocalizations.of(context)!.translate(
                BlockTranslate.calcular,
                'total',
              ),
              value: detailsVM.total,
            ),
          ],
        ),
      ),
    );
  }
}

class _Transaction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final detailsVM = Provider.of<DetailsViewModel>(context);

    final homeVM = Provider.of<HomeViewModel>(context, listen: false);
    final docVM = Provider.of<DocumentViewModel>(context, listen: false);

    // Crear una instancia de NumberFormat para el formato de moneda
    final currencyFormat = NumberFormat.currency(
      symbol: homeVM
          .moneda, // Símbolo de la moneda (puedes cambiarlo según tu necesidad)
      decimalDigits: 2, // Número de decimales a mostrar
    );

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: detailsVM.traInternas.length,
      itemBuilder: (BuildContext context, int index) {
        final TraInternaModel transaction = detailsVM.traInternas[index];

        return Card(
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(
              color: AppTheme.color(
                context,
                Styles.border,
              ),
              width: 1.0,
            ), // Define el color y grosor del borde
          ),
          color: AppTheme.color(
            context,
            Styles.background,
          ),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${transaction.cantidad} x ${transaction.producto.desProducto}',
                  style: StyleApp.normal,
                ),
                Text(
                  'SKU: ${transaction.producto.productoId}',
                  style: StyleApp.normal,
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (transaction.precio != null)
                  Text(
                    '${AppLocalizations.of(context)!.translate(
                      BlockTranslate.calcular,
                      'precioU',
                    )}: ${currencyFormat.format(transaction.precio!.precioU)}',
                    style: StyleApp.normal,
                  ),

//Cantidad dias
                if (docVM.valueParametro(44))
                  Text(
                    '${AppLocalizations.of(context)!.translate(
                      BlockTranslate.calcular,
                      'cantDias',
                    )}: ${transaction.cantidadDias}',
                    style: StyleApp.normal,
                  ),

                if (transaction.cargo != 0)
                  Text(
                    '${AppLocalizations.of(context)!.translate(
                      BlockTranslate.calcular,
                      'cargo',
                    )}: ${transaction.cargo.toStringAsFixed(2)}',
                    style: StyleApp.normal,
                  ),

                if (transaction.descuento != 0)
                  Text(
                    '${AppLocalizations.of(context)!.translate(
                      BlockTranslate.calcular,
                      'descuento',
                    )}: ${transaction.descuento.toStringAsFixed(2)}',
                    style: StyleApp.normal,
                  ),
//Total por cantidad
                if (docVM.valueParametro(44))
                  Text(
                    '${AppLocalizations.of(context)!.translate(
                      BlockTranslate.calcular,
                      'precioTotalCant',
                    )}: ${currencyFormat.format(transaction.precioCantidad)}',
                    style: StyleApp.normal,
                  ),
                Text(
                  '${AppLocalizations.of(context)!.translate(
                    BlockTranslate.calcular,
                    'total',
                  )}: ${transaction.total.toStringAsFixed(2)}',
                  style: StyleApp.normal,
                ),
                // Text('Detalles: ${transaction.detalles}'),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DataUser extends StatelessWidget {
  const _DataUser({
    required this.user,
    required this.title,
  });

  final DataUserModel user;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: StyleApp.title,
        ),
        const SizedBox(height: 5),
        Text(
          "Nit: ${user.nit}",
          style: StyleApp.normal,
        ),
        Text(
          "${AppLocalizations.of(context)!.translate(
            BlockTranslate.general,
            'nombre',
          )}: ${user.name}",
          style: StyleApp.normal,
        ),
        Text(
          "${AppLocalizations.of(context)!.translate(
            BlockTranslate.general,
            'direccion',
          )}: ${user.adress}",
          style: StyleApp.normal,
        ),
        Text(
          "${AppLocalizations.of(context)!.translate(
            BlockTranslate.cuenta,
            'cuentaCta',
          )} ${user.desCtaCta}",
          style: StyleApp.normal,
        )
      ],
    );
  }
}
