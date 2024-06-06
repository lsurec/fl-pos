import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
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

    return Stack(
      children: [
        Scaffold(
          key: vm.scaffoldKey,
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.translate(
                BlockTranslate.factura,
                'resumenDoc',
              ),
              style: AppTheme.style(
                context,
                Styles.title,
                Preferences.idTheme,
              ),
            ),
            actions: [
              if (vm.showPrint)
                IconButton(
                  onPressed: () => vm.sheredDoc(context),
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
                      "Consecutivo interno",
                      style: AppTheme.style(
                        context,
                        Styles.title,
                        Preferences.idTheme,
                      ),
                    ),
                  if (vm.showPrint)
                    Text(
                      "${vm.consecutivoDoc}",
                      style: AppTheme.style(
                        context,
                        Styles.normal,
                        Preferences.idTheme,
                      ),
                    ),
                  if (vm.showPrint) const SizedBox(height: 5),
                  _DataUser(
                    title: AppLocalizations.of(context)!.translate(
                      BlockTranslate.cuenta,
                      'cliente',
                    ),
                    user: DataUserModel(
                      name: docVM.clienteSelect!.facturaNombre,
                      nit: docVM.clienteSelect!.facturaNit,
                      adress: docVM.clienteSelect!.facturaDireccion,
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
                          style: AppTheme.style(
                            context,
                            Styles.title,
                            Preferences.idTheme,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          docVM.vendedorSelect!.nomCuentaCorrentista,
                          style: AppTheme.style(
                            context,
                            Styles.normal,
                            Preferences.idTheme,
                          ),
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
                    style: AppTheme.style(
                      context,
                      Styles.title,
                      Preferences.idTheme,
                    ),
                  ),
                  const SizedBox(height: 5),
                  _Transaction(),
                  const SizedBox(height: 5),
                  const Divider(),
                  const SizedBox(height: 5),
                  Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.factura,
                      'formasPago',
                    ),
                    style: AppTheme.style(
                      context,
                      Styles.title,
                      Preferences.idTheme,
                    ),
                  ),
                  const SizedBox(height: 5),
                  _Pyments(),
                  const SizedBox(height: 5),
                  const Divider(),
                  const SizedBox(height: 5),
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
                      Preferences.idTheme,
                    ),
                    value: vm.directPrint,
                    onChanged: (value) => vm.directPrint = value,
                    title: Text(
                      AppLocalizations.of(context)!.translate(
                        BlockTranslate.tiket,
                        'imprimir',
                      ),
                      style: AppTheme.style(
                        context,
                        Styles.normal,
                        Preferences.idTheme,
                      ),
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
              Styles.background,
              Preferences.idTheme,
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
                          style: AppTheme.style(
                            context,
                            Styles.versionStyle,
                            Preferences.idTheme,
                          ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  step.text,
                                  style: AppTheme.style(
                                    context,
                                    Styles.normal,
                                    Preferences.idTheme,
                                  ),
                                ),
                                if (step.status == 1) //Cargando
                                  Icon(
                                    Icons.pending_outlined,
                                    color: AppTheme.color(
                                      context,
                                      Styles.grey,
                                      Preferences.idTheme,
                                    ),
                                  ),
                                if (step.status == 2) //exitoso
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: AppTheme.color(
                                      context,
                                      Styles.green,
                                      Preferences.idTheme,
                                    ),
                                  ),
                                if (step.status == 3) //error
                                  Icon(
                                    Icons.cancel_outlined,
                                    color: AppTheme.color(
                                      context,
                                      Styles.red,
                                      Preferences.idTheme,
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
                                  Preferences.idTheme,
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
                        style: AppTheme.style(
                          context,
                          Styles.red,
                          Preferences.idTheme,
                        ),
                      ),
                    if (vm.viewSucces)
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.notificacion,
                          'docProcesado',
                        ),
                        style: AppTheme.style(
                          context,
                          Styles.green,
                          Preferences.idTheme,
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
                            style: AppTheme.style(
                              context,
                              Styles.blue,
                              Preferences.idTheme,
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
                                    Preferences.idTheme,
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.translate(
                                        BlockTranslate.botones,
                                        'aceptar',
                                      ),
                                      style: AppTheme.style(
                                        context,
                                        Styles.whiteStyle,
                                        Preferences.idTheme,
                                      ),
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

    return SizedBox(
      height: 75,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => vm.backButton(context),
              child: Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  right: 10,
                ),
                color: AppTheme.color(
                  context,
                  Styles.primary,
                  Preferences.idTheme,
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.botones,
                      'listo',
                    ),
                    style: AppTheme.style(
                      context,
                      Styles.whiteStyle,
                      Preferences.idTheme,
                    ),
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
                  Preferences.idTheme,
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.botones,
                      'imprimir',
                    ),
                    style: AppTheme.style(
                      context,
                      Styles.whiteStyle,
                      Preferences.idTheme,
                    ),
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
                  Preferences.idTheme,
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.botones,
                      'sinFirma',
                    ),
                    style: AppTheme.style(
                      context,
                      Styles.whiteStyle,
                      Preferences.idTheme,
                    ),
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
                  Preferences.idTheme,
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.botones,
                      'reintentar',
                    ),
                    style: AppTheme.style(
                      context,
                      Styles.whiteStyle,
                      Preferences.idTheme,
                    ),
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
                  Preferences.idTheme,
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.botones,
                      'aceptar',
                    ),
                    style: AppTheme.style(
                      context,
                      Styles.whiteStyle,
                      Preferences.idTheme,
                    ),
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
                  Preferences.idTheme,
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.botones,
                      'reintentar',
                    ),
                    style: AppTheme.style(
                      context,
                      Styles.whiteStyle,
                      Preferences.idTheme,
                    ),
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
                  Preferences.idTheme,
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.botones,
                      'cancelar',
                    ),
                    style: AppTheme.style(
                      context,
                      Styles.whiteStyle,
                      Preferences.idTheme,
                    ),
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
                  Preferences.idTheme,
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.botones,
                      'confirmar',
                    ),
                    style: AppTheme.style(
                      context,
                      Styles.normal,
                      Preferences.idTheme,
                    ),
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
                Preferences.idTheme,
              ),
              width: 1.0,
            ),
          ),
          color: AppTheme.color(
            context,
            Styles.background,
            Preferences.idTheme,
          ),
          child: ListTile(
            title: Text(
              amount.payment.descripcion,
              style: AppTheme.style(
                context,
                Styles.normal,
                Preferences.idTheme,
              ),
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
                    style: AppTheme.style(
                      context,
                      Styles.normal,
                      Preferences.idTheme,
                    ),
                  ),
                if (amount.reference != "")
                  Text(
                    '${AppLocalizations.of(context)!.translate(
                      BlockTranslate.factura,
                      'referencia',
                    )}: ${amount.reference}',
                    style: AppTheme.style(
                      context,
                      Styles.normal,
                      Preferences.idTheme,
                    ),
                  ),
                if (amount.payment.banco)
                  Text(
                    '${AppLocalizations.of(context)!.translate(
                      BlockTranslate.factura,
                      'banco',
                    )}: ${amount.bank?.nombre}',
                    style: AppTheme.style(
                      context,
                      Styles.normal,
                      Preferences.idTheme,
                    ),
                  ),
                if (amount.account != null)
                  Text(
                    '${AppLocalizations.of(context)!.translate(
                      BlockTranslate.factura,
                      'cuenta',
                    )}: ${amount.account!.descripcion}',
                    style: AppTheme.style(
                      context,
                      Styles.normal,
                      Preferences.idTheme,
                    ),
                  ),
                Text(
                  '${AppLocalizations.of(context)!.translate(
                    BlockTranslate.calcular,
                    'monto',
                  )}: ${amount.amount.toStringAsFixed(2)}',
                  style: AppTheme.style(
                    context,
                    Styles.normal,
                    Preferences.idTheme,
                  ),
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
            Preferences.idTheme,
          ),
          width: 1.0,
        ), // Define el color y grosor del borde
      ),
      color: AppTheme.color(
        context,
        Styles.background,
        Preferences.idTheme,
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
            Preferences.idTheme,
          ),
          width: 1.0,
        ), // Define el color y grosor del borde
      ),
      color: AppTheme.color(
        context,
        Styles.background,
        Preferences.idTheme,
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
                Preferences.idTheme,
              ),
              width: 1.0,
            ), // Define el color y grosor del borde
          ),
          color: AppTheme.color(
            context,
            Styles.background,
            Preferences.idTheme,
          ),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${transaction.cantidad} x ${transaction.producto.desProducto}',
                  style: AppTheme.style(
                    context,
                    Styles.normal,
                    Preferences.idTheme,
                  ),
                ),
                Text(
                  'SKU: ${transaction.producto.productoId}',
                  style: AppTheme.style(
                    context,
                    Styles.normal,
                    Preferences.idTheme,
                  ),
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
                    style: AppTheme.style(
                      context,
                      Styles.normal,
                      Preferences.idTheme,
                    ),
                  ),

                Text(
                  '${AppLocalizations.of(context)!.translate(
                    BlockTranslate.calcular,
                    'total',
                  )}: ${transaction.total.toStringAsFixed(2)}',
                  style: AppTheme.style(
                    context,
                    Styles.normal,
                    Preferences.idTheme,
                  ),
                ),
                if (transaction.cargo != 0)
                  Text(
                    '${AppLocalizations.of(context)!.translate(
                      BlockTranslate.calcular,
                      'cargo',
                    )}: ${transaction.cargo.toStringAsFixed(2)}',
                    style: AppTheme.style(
                      context,
                      Styles.normal,
                      Preferences.idTheme,
                    ),
                  ),

                if (transaction.descuento != 0)
                  Text(
                    '${AppLocalizations.of(context)!.translate(
                      BlockTranslate.calcular,
                      'descuento',
                    )}: ${transaction.descuento.toStringAsFixed(2)}',
                    style: AppTheme.style(
                      context,
                      Styles.normal,
                      Preferences.idTheme,
                    ),
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
          style: AppTheme.style(
            context,
            Styles.title,
            Preferences.idTheme,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "Nit: ${user.nit}",
          style: AppTheme.style(
            context,
            Styles.normal,
            Preferences.idTheme,
          ),
        ),
        Text(
          "${AppLocalizations.of(context)!.translate(
            BlockTranslate.general,
            'nombre',
          )}: ${user.name}",
          style: AppTheme.style(
            context,
            Styles.normal,
            Preferences.idTheme,
          ),
        ),
        Text(
          "${AppLocalizations.of(context)!.translate(
            BlockTranslate.general,
            'direccion',
          )}: ${user.adress}",
          style: AppTheme.style(
            context,
            Styles.normal,
            Preferences.idTheme,
          ),
        )
      ],
    );
  }
}
