import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PaymentViewModel>(context);
    final vmDetails = Provider.of<DetailsViewModel>(context);
    final homeVM = Provider.of<HomeViewModel>(context, listen: false);

    // Crear una instancia de NumberFormat para el formato de moneda
    final currencyFormat = NumberFormat.currency(
      symbol: homeVM
          .moneda, // Símbolo de la moneda (puedes cambiarlo según tu necesidad)
      decimalDigits: 2, // Número de decimales a mostrar
    );
    //tra

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => vm.loadPayments(context),
              child: ListView(
                children: [
                  if (vm.paymentList.isEmpty)
                    const NotFoundWidget(
                        text: "No hay elementos",
                        icon: Icon(
                          Icons.browser_not_supported_outlined,
                          size: 250,
                        )),
                  if (vm.paymentList.isNotEmpty)
                    const Text(
                      "Agregar pago",
                      style: AppTheme.titleStyle,
                    ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: vm.paymentList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final PaymentModel payment = vm.paymentList[index];

                      return GestureDetector(
                        onTap: () => vm.navigateAmount(context, payment),
                        child: PaymentCard(
                          payment: payment,
                        ),
                      );
                    },
                  ),
                  if (vm.amounts.isNotEmpty) const SizedBox(height: 20),
                  if (vm.amounts.isNotEmpty) const Divider(),
                  if (vm.amounts.isNotEmpty) const SizedBox(height: 10),
                  if (vm.amounts.isNotEmpty)
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        Checkbox(
                          activeColor: AppTheme.primary,
                          value: vm.selectAllAmounts,
                          onChanged: (value) => vm.selectAllMounts(value),
                        ),
                        Text(
                          "Pagos agregados (${vm.amounts.length})",
                          style: AppTheme.normalBoldStyle,
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => vm.deleteAmounts(context),
                          icon: const Icon(Icons.delete_outline),
                        )
                      ],
                    ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: vm.amounts.length,
                    itemBuilder: (BuildContext context, int index) {
                      final AmountModel amount = vm.amounts[index];

                      return Card(
                        color: AppTheme.grayAppBar,
                        elevation: 2.0,
                        child: ListTile(
                          leading: Checkbox(
                            activeColor: AppTheme.primary,
                            value: amount.checked,
                            onChanged: (value) =>
                                vm.changeCheckedamount(value, index),
                          ),
                          title: Text(
                            amount.payment.descripcion,
                            style: AppTheme.normalBoldStyle,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (amount.payment.autorizacion)
                                Text('Autorización: ${amount.authorization}',
                                    style: AppTheme.normalStyle),
                              if (amount.payment.referencia)
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
                                  'Monto: ${currencyFormat.format(amount.amount)}',
                                  style: AppTheme.normalStyle),
                              if (amount.diference > 0)
                                Text(
                                    'Diferencia: ${currencyFormat.format(amount.diference)}',
                                    style: AppTheme.normalStyle),
                              if (amount.diference > 0)
                                Text(
                                    'Pago total: ${currencyFormat.format(amount.diference + amount.amount)}',
                                    style: AppTheme.normalStyle),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          RowTotalWidget(
            title: "Total",
            value: vmDetails.total,
            color: AppTheme.primary,
          ),
          RowTotalWidget(
            title: "Saldo",
            value: vm.saldo,
            color: AppTheme.primary,
          ),
          RowTotalWidget(
            title: "Cambio",
            value: vm.cambio,
            color: AppTheme.primary,
          ),
        ],
      ),
    );
  }
}

class PaymentCard extends StatelessWidget {
  const PaymentCard({super.key, required this.payment});
  final PaymentModel payment;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.grayAppBar,
      elevation: 2.0,
      child: ListTile(
        trailing: const Icon(Icons.arrow_right),
        title: Text(
          payment.descripcion,
          style: AppTheme.normalStyle,
        ),
      ),
    );
  }
}
