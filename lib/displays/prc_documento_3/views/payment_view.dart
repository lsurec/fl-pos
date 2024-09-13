import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
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
      // Símbolo de la moneda (puedes cambiarlo según tu necesidad)
      symbol: homeVM.moneda,
      // Número de decimales a mostrar
      decimalDigits: 2,
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
                    NotFoundWidget(
                      text: AppLocalizations.of(context)!.translate(
                        BlockTranslate.notificacion,
                        'sinElementos',
                      ),
                      icon: const Icon(
                        Icons.browser_not_supported_outlined,
                        size: 250,
                      ),
                    ),
                  if (vm.paymentList.isNotEmpty)
                    Text(
                      AppLocalizations.of(context)!.translate(
                        BlockTranslate.factura,
                        'agregarPago',
                      ),
                      style: StyleApp.title,
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
                          activeColor: AppNewTheme.hexToColor(
                            Preferences.valueColor,
                          ),
                          value: vm.selectAllAmounts,
                          onChanged: (value) => vm.selectAllMounts(value),
                        ),
                        Text(
                          "${AppLocalizations.of(context)!.translate(
                            BlockTranslate.factura,
                            'pagosAgregados',
                          )} (${vm.amounts.length})",
                          style: StyleApp.normalBold,
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
                        color: AppNewTheme.isDark()
                            ? AppNewTheme.backroundDarkSecondary
                            : AppNewTheme.backroundSecondary,
                        elevation: 2.0,
                        child: ListTile(
                          leading: Checkbox(
                            activeColor: AppNewTheme.hexToColor(
                              Preferences.valueColor,
                            ),
                            value: amount.checked,
                            onChanged: (value) => vm.changeCheckedamount(
                              value,
                              index,
                            ),
                          ),
                          title: Text(
                            amount.payment.descripcion,
                            style: StyleApp.normalBold,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (amount.payment.autorizacion)
                                Text(
                                  '${AppLocalizations.of(context)!.translate(
                                    BlockTranslate.factura,
                                    'autorizar',
                                  )}: ${amount.authorization}',
                                  style: StyleApp.normal,
                                ),
                              if (amount.payment.referencia)
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
                                )}: ${currencyFormat.format(amount.amount)}',
                                style: StyleApp.normal,
                              ),
                              if (amount.diference > 0)
                                Text(
                                  '${AppLocalizations.of(context)!.translate(
                                    BlockTranslate.calcular,
                                    'diferencia',
                                  )}: ${currencyFormat.format(amount.diference)}',
                                  style: StyleApp.normal,
                                ),
                              if (amount.diference > 0)
                                Text(
                                  '${AppLocalizations.of(context)!.translate(
                                    BlockTranslate.calcular,
                                    'precioT',
                                  )}: ${currencyFormat.format(amount.diference + amount.amount)}',
                                  style: StyleApp.normal,
                                ),
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
            title: AppLocalizations.of(context)!.translate(
              BlockTranslate.calcular,
              'total',
            ),
            value: vmDetails.total,
            color: AppNewTheme.primary,
          ),
          RowTotalWidget(
            title: AppLocalizations.of(context)!.translate(
              BlockTranslate.calcular,
              'saldo',
            ),
            value: vm.saldo,
            color: AppNewTheme.primary,
          ),
          RowTotalWidget(
            title: AppLocalizations.of(context)!.translate(
              BlockTranslate.calcular,
              'cambio',
            ),
            value: vm.cambio,
            color: AppNewTheme.primary,
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
      color: AppNewTheme.isDark()
          ? AppNewTheme.backroundDarkSecondary
          : AppNewTheme.backroundSecondary,
      elevation: 2.0,
      child: ListTile(
        trailing: const Icon(Icons.arrow_right),
        title: Text(
          payment.descripcion,
          style: StyleApp.normal,
        ),
      ),
    );
  }
}
