import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
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
            title: const Text("Resumen Documento", style: AppTheme.titleStyle),
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
                  _DataUser(
                    title: "Cliente",
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
                        const Text(
                          "Vendedor",
                          style: AppTheme.titleStyle,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          docVM.vendedorSelect!.nomCuentaCorrentista,
                          style: AppTheme.normalStyle,
                        ),
                      ],
                    ),
                  const SizedBox(height: 5),
                  const Divider(),
                  const SizedBox(height: 5),
                  const Text(
                    "Productos",
                    style: AppTheme.titleStyle,
                  ),
                  const SizedBox(height: 5),
                  _Transaction(),
                  const SizedBox(height: 5),
                  const Divider(),
                  const SizedBox(height: 5),
                  const Text(
                    "Forma de pago",
                    style: AppTheme.titleStyle,
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
                  _Observacion(),
                  const SizedBox(height: 10),
                  SwitchListTile(
                    activeColor: AppTheme.primary,
                    value: vm.directPrint,
                    onChanged: (value) => vm.directPrint = value,
                    title: const Text(
                      "Imprimir documento después de confirmar",
                      style: AppTheme.normalStyle,
                    ),
                  ),
                  if (!vm.showPrint) _Options(),
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
            color: AppTheme.backroundColor,
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
                          "Tareas completadas ${vm.stepsSucces}/${vm.steps.length}",
                          style: const TextStyle(
                            color: Colors.black45,
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
                                  style: AppTheme.normalStyle,
                                ),
                                if (step.status == 1) //Cargando
                                  const Icon(
                                    Icons.pending_outlined,
                                    color: Colors.grey,
                                  ),
                                if (step.status == 2) //exitoso
                                  const Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.green,
                                  ),
                                if (step.status == 3) //error
                                  const Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.red,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            if (step.isLoading)
                              const LinearProgressIndicator(
                                color: AppTheme.primary,
                              ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    if (vm.viewMessage)
                      Text(
                        vm.error,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.red,
                        ),
                      ),
                    if (vm.viewSucces)
                      const Text(
                        "Documento procesado correctamente.",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.green,
                        ),
                      ),
                    if (vm.viewError)
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => vm.navigateError(),
                          child: const Text(
                            "Ver informe de errores",
                            style: TextStyle(
                              color: AppTheme.primary,
                              decoration: TextDecoration.underline,
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
                                  color: AppTheme.primary,
                                  child: const Center(
                                    child: Text(
                                      "Aceptar",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
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
      decoration: const InputDecoration(
        labelText: 'Observación',
        hintText: "Observación",
      ),
    );
  }
}

class _Print extends StatelessWidget {
  final int screen;

  const _Print({super.key, required this.screen});
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
                color: AppTheme.primary,
                child: const Center(
                  child: Text(
                    "Listo",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () =>
                  screen == 1 ? vm.navigatePrint(context) : vm.printNetwork(),
              child: Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 10,
                ),
                color: AppTheme.primary,
                child: const Center(
                  child: Text(
                    "Imprimir",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
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
              onTap: () => vm.printWithoutFel(),
              child: Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  right: 10,
                ),
                color: AppTheme.primary,
                child: const Center(
                  child: Text(
                    "Continuar sin firma",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => vm.reloadCert(),
              child: Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 10,
                ),
                color: AppTheme.primary,
                child: const Center(
                  child: Text(
                    "Reintentar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
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
                color: AppTheme.primary,
                child: const Center(
                  child: Text(
                    "Aceptar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => vm.processDocument(),
              child: Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 10,
                ),
                color: AppTheme.primary,
                child: const Center(
                  child: Text(
                    "Reintentar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
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
                color: AppTheme.primary,
                child: const Center(
                  child: Text(
                    "Cancelar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
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
                vm.sendDoc(context);
                // vm.isLoading = true
              },
              child: Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 10,
                ),
                color: AppTheme.primary,
                child: const Center(
                  child: Text(
                    "Confirmar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
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
                color: Colors.grey[400]!,
                width: 1.0), // Define el color y grosor del borde
          ),
          color: AppTheme.backroundColor,
          child: ListTile(
            title: Text(
              amount.payment.descripcion,
              style: AppTheme.normalStyle,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (amount.authorization != "")
                  Text(
                    'Autorización: ${amount.authorization}',
                    style: AppTheme.normalStyle,
                  ),
                if (amount.reference != "")
                  Text(
                    'Referencia: ${amount.reference}',
                    style: AppTheme.normalStyle,
                  ),
                if (amount.payment.banco)
                  Text(
                    'Banco: ${amount.bank?.nombre}',
                    style: AppTheme.normalStyle,
                  ),
                if (amount.account != null)
                  Text(
                    'Cuenta: ${amount.account!.descripcion}',
                    style: AppTheme.normalStyle,
                  ),
                Text(
                  'Monto: ${amount.amount.toStringAsFixed(2)}',
                  style: AppTheme.normalStyle,
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
            color: Colors.grey[400]!,
            width: 1.0), // Define el color y grosor del borde
      ),
      color: AppTheme.backroundColor,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            RowTotalWidget(
              title: "Contado",
              value: paymentsVM.pagado,
            ),
            RowTotalWidget(
              title: "Cambio",
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
            color: Colors.grey[400]!,
            width: 1.0), // Define el color y grosor del borde
      ),
      color: AppTheme.backroundColor,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            RowTotalWidget(
              title: "Subtotal",
              value: detailsVM.subtotal,
            ),
            RowTotalWidget(
              title: "(+) Cargo",
              value: detailsVM.cargo,
            ),
            RowTotalWidget(
              title: "(-) Descuento",
              value: detailsVM.descuento,
            ),
            const Divider(),
            RowTotalWidget(
              title: "Total",
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
                color: Colors.grey[400]!,
                width: 1.0), // Define el color y grosor del borde
          ),
          color: AppTheme.backroundColor,
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${transaction.cantidad} x ${transaction.producto.desProducto}',
                  style: AppTheme.normalStyle,
                ),
                Text(
                  'SKU: ${transaction.producto.productoId}',
                  style: AppTheme.normalStyle,
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (transaction.precio != null)
                  Text(
                    'Precio Unitario: ${currencyFormat.format(transaction.precio!.precioU)}',
                    style: AppTheme.normalStyle,
                  ),

                Text(
                  'Total: ${transaction.total.toStringAsFixed(2)}',
                  style: AppTheme.normalStyle,
                ),
                if (transaction.cargo != 0)
                  Text(
                    'Cargo: ${transaction.cargo.toStringAsFixed(2)}',
                    style: AppTheme.normalStyle,
                  ),

                if (transaction.descuento != 0)
                  Text(
                    'Descuento: ${transaction.descuento.toStringAsFixed(2)}',
                    style: AppTheme.normalStyle,
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
          style: AppTheme.titleStyle,
        ),
        const SizedBox(height: 5),
        Text(
          "Nit: ${user.nit}",
          style: AppTheme.normalStyle,
        ),
        Text(
          "Nombre: ${user.name}",
          style: AppTheme.normalStyle,
        ),
        Text(
          "Dirección: ${user.adress}",
          style: AppTheme.normalStyle,
        )
      ],
    );
  }
}
