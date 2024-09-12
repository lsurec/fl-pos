import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

//Pantalla agregar monto
class AmountView extends StatelessWidget {
  const AmountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //argumentos
    final PaymentModel payment =
        ModalRoute.of(context)!.settings.arguments as PaymentModel;

    final vmPayment = Provider.of<PaymentViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(),
          body: _Body(payment: payment),
        ),
        if (vmPayment.isLoading)
          ModalBarrier(
            dismissible: false,
            // color: Colors.black.withOpacity(0.3),
            color: AppNewTheme.isDark()
                ? AppNewTheme.darkBackroundColor
                : AppNewTheme.backroundColor,
          ),
        if (vmPayment.isLoading) const LoadWidget(),
      ],
    );
  }
}

//contenido de la pantalla
class _Body extends StatelessWidget {
  const _Body({
    required this.payment,
  });

  final PaymentModel payment;

  @override
  Widget build(BuildContext context) {
    //vier models
    final vm = Provider.of<AmountViewModel>(context);
    final vmPayment = Provider.of<PaymentViewModel>(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: vm.formKey,
                //inputs
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      payment.descripcion,
                      style: StyleApp.title,
                    ),
                    const SizedBox(height: 20),
                    //monto
                    TextFormField(
                      controller: vm.montoController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}'),
                        ),
                      ],
                      keyboardType: TextInputType.number,
                      onChanged: (value) => vm.formValues["monto"] = value,
                      decoration: InputDecoration(
                        //counter: const Text('Caracteres'),
                        labelText: AppLocalizations.of(context)!.translate(
                          BlockTranslate.tiket,
                          'monto',
                        ),
                        hintText: "00.00",
                        suffixIcon: IconButton(
                          onPressed: () => vm.montoController.clear(),
                          icon: Icon(
                            Icons.close,
                            color: AppTheme.color(
                              context,
                              Styles.darkPrimary,
                            ),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.translate(
                            BlockTranslate.notificacion,
                            'requerido',
                          );
                        }
                        if ((double.tryParse(value) ?? 0) == 0) {
                          return AppLocalizations.of(context)!.translate(
                            BlockTranslate.notificacion,
                            'mayorDeCero',
                          );
                        }
                        return null;
                      },
                    ),
                    if (payment.autorizacion) const SizedBox(height: 5),
                    if (payment.autorizacion)
                      //autorizacion
                      InputWidget(
                        formProperty: 'autorizacion',
                        formValues: vm.formValues,
                        maxLines: 1,
                        hintText: AppLocalizations.of(context)!.translate(
                          BlockTranslate.factura,
                          'autorizar',
                        ),
                        labelText: AppLocalizations.of(context)!.translate(
                          BlockTranslate.factura,
                          'autorizar',
                        ),
                      ),
                    if (payment.referencia) const SizedBox(height: 5),
                    if (payment.referencia)
                      //refrencia
                      InputWidget(
                        formProperty: 'referencia',
                        formValues: vm.formValues,
                        maxLines: 1,
                        hintText: AppLocalizations.of(context)!.translate(
                          BlockTranslate.factura,
                          'referencia',
                        ),
                        labelText: AppLocalizations.of(context)!.translate(
                          BlockTranslate.factura,
                          'referencia',
                        ),
                      ),
                    if (payment.banco) const SizedBox(height: 10),
                    if (payment.banco)
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.factura,
                          'banco',
                        ),
                        style: StyleApp.normalBold,
                      ),
                    if (payment.banco) const SizedBox(height: 10),
                    if (payment.banco)
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: vmPayment.banks.length,
                        itemBuilder: (BuildContext context, int index) {
                          SelectBankModel bank = vmPayment.banks[index];
                          return Card(
                            color: AppTheme.color(
                              context,
                              Styles.transaction,
                            ),
                            elevation: 2.0,
                            child: RadioListTile(
                              activeColor: AppTheme.color(
                                context,
                                Styles.darkPrimary,
                              ),
                              title: Text(
                                bank.bank.nombre,
                                style: StyleApp.normal,
                              ),
                              value: index,
                              groupValue: vmPayment.banks
                                  .indexWhere((bank) => bank.isSelected),
                              onChanged: (int? value) =>
                                  vmPayment.changeBankSelect(
                                value,
                                context,
                                payment,
                              ),
                            ),
                          );
                        },
                      ),
                    if (vmPayment.accounts.isNotEmpty)
                      const SizedBox(height: 10),
                    if (vmPayment.accounts.isNotEmpty)
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.factura,
                          'cuentas',
                        ),
                        style: StyleApp.normalBold,
                      ),
                    if (vmPayment.accounts.isNotEmpty)
                      const SizedBox(height: 10),
                    if (vmPayment.accounts.isNotEmpty)
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: vmPayment.accounts.length,
                        itemBuilder: (BuildContext context, int index) {
                          SelectAccountModel account =
                              vmPayment.accounts[index];
                          return Card(
                            color: AppTheme.color(
                              context,
                              Styles.transaction,
                            ),
                            elevation: 2.0,
                            child: RadioListTile(
                              activeColor: AppTheme.color(
                                context,
                                Styles.darkPrimary,
                              ),
                              title: Text(
                                account.account.descripcion,
                                style: StyleApp.normal,
                              ),
                              value: index,
                              groupValue: vmPayment.accounts
                                  .indexWhere((acc) => acc.isSelected),
                              onChanged: (int? value) =>
                                  vmPayment.changeAccountSelect(value, context),
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 20),
                    //boton confirmar
                    _ButtonConfirm(payment: payment),
                  ],
                ),
              ),
            ),
          ),
          //totales
          _Footer(),
        ],
      ),
    );
  }
}

//Boton confirmar monto
class _ButtonConfirm extends StatelessWidget {
  const _ButtonConfirm({
    required this.payment,
  });

  final PaymentModel payment;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AmountViewModel>(context);

    return SizedBox(
      height: 55,
      child: GestureDetector(
        onTap: () => vm.addAmount(payment, context),
        child: Container(
          color: AppTheme.color(
            context,
            Styles.primary,
          ),
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.translate(
                BlockTranslate.factura,
                'agregarPago',
              ),
              style: StyleApp.whiteNormal,
            ),
          ),
        ),
      ),
    );
  }
}

//totales (footer)
class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vmDetails = Provider.of<DetailsViewModel>(context);
    final vmPayment = Provider.of<PaymentViewModel>(context);

    return Column(
      children: [
        const SizedBox(height: 15),
        RowTotalWidget(
          title: AppLocalizations.of(context)!.translate(
            BlockTranslate.calcular,
            'total',
          ),
          value: vmDetails.total,
          color: AppTheme.color(
            context,
            Styles.darkPrimary,
          ),
        ),
        RowTotalWidget(
          title: AppLocalizations.of(context)!.translate(
            BlockTranslate.calcular,
            'saldo',
          ),
          value: vmPayment.saldo,
          color: AppTheme.color(
            context,
            Styles.darkPrimary,
          ),
        ),
        RowTotalWidget(
          title: AppLocalizations.of(context)!.translate(
            BlockTranslate.calcular,
            'cambio',
          ),
          value: vmPayment.cambio,
          color: AppTheme.color(
            context,
            Styles.darkPrimary,
          ),
        ),
      ],
    );
  }
}
