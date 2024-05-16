import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/row_total_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../view_models/view_models.dart';

class DetailsView extends StatelessWidget {
  const DetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DetailsViewModel>(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.general,
                          'filtros',
                        ),
                        style: AppTheme.normalStyle,
                      ),
                      const Spacer(),
                      _RadioFilter(),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Form(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          key: vm.formKeySearch,
                          child: TextFormField(
                            onFieldSubmitted: (value) =>
                                vm.performSearch(context),
                            textInputAction: TextInputAction.search,
                            controller: vm.searchController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.translate(
                                  BlockTranslate.notificacion,
                                  'requerido',
                                );
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Sku',
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.search,
                                  color: AppTheme.primary,
                                ),
                                onPressed: () => vm.performSearch(context),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 35,
                        child: IconButton(
                          onPressed: () => vm.scanBarcode(context),
                          icon: const Icon(
                            Icons.qr_code_scanner,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  MyExpansionTile(
                    title: "${AppLocalizations.of(context)!.translate(
                      BlockTranslate.calcular,
                      'cargo',
                    )}/${AppLocalizations.of(context)!.translate(
                      BlockTranslate.calcular,
                      'descuento',
                    )}",
                    content: Column(
                      children: [
                        _RadioCargo(),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Form(
                                key: vm.formKey,
                                child: TextFormField(
                                  onChanged: (value) => vm.changeMonto(value),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'^(\d+)?\.?\d{0,2}'),
                                    )
                                  ],
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .translate(
                                        BlockTranslate.notificacion,
                                        'requerido',
                                      );
                                    } else if (double.tryParse(value) == 0) {
                                      return AppLocalizations.of(context)!
                                          .translate(
                                        BlockTranslate.notificacion,
                                        'noCero',
                                      );
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: '00.00',
                                    labelText:
                                        "${AppLocalizations.of(context)!.translate(
                                      BlockTranslate.calcular,
                                      'cargo',
                                    )}/${AppLocalizations.of(context)!.translate(
                                      BlockTranslate.calcular,
                                      'descuento',
                                    )}",
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              onPressed: () => vm.cargoDescuento(1, context),
                              icon: const Icon(
                                Icons.add_circle,
                                color: Colors.green,
                              ),
                            ),
                            IconButton(
                              onPressed: () => vm.cargoDescuento(2, context),
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (vm.traInternas.isEmpty) const SizedBox(height: 20),
                  Row(
                    children: [
                      if (vm.traInternas.isNotEmpty) const SizedBox(width: 14),
                      if (vm.traInternas.isNotEmpty)
                        Checkbox(
                          activeColor: AppTheme.primary,
                          value: vm.selectAll,
                          onChanged: (value) => vm.selectAllTransactions(value),
                        ),
                      if (vm.traInternas.isNotEmpty) const SizedBox(width: 20),
                      Text(
                        "${AppLocalizations.of(context)!.translate(
                          BlockTranslate.general,
                          'numTransacciones',
                        )}: ${vm.traInternas.length}",
                        style: AppTheme.normalBoldStyle,
                      ),
                      const Spacer(),
                      if (vm.traInternas.isNotEmpty)
                        IconButton(
                          onPressed: () => vm.deleteTransaction(context),
                          icon: const Icon(
                            Icons.delete_outline,
                          ),
                        )
                    ],
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: vm.traInternas.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection
                            .startToEnd, // Deslizar solo hacia la izquierda
                        onDismissed: (direction) =>
                            vm.dismissItem(context, index),
                        background: Container(
                          color: Colors.red,
                          alignment:
                              Alignment.centerLeft, // Alineado a la izquierda
                          padding: const EdgeInsets.only(left: 16.0),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: GestureDetector(
                          onTap: () => vm.navigatorDetails(context, index),
                          child: _TransactionCard(
                            transaction: vm.traInternas[index],
                            indexTransaction: index,
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
              'subTotal',
            ),
            value: vm.subtotal,
            color: AppTheme.primary,
          ),
          RowTotalWidget(
            title: AppLocalizations.of(context)!.translate(
              BlockTranslate.calcular,
              'cargo',
            ),
            value: vm.cargo,
            color: AppTheme.primary,
          ),
          RowTotalWidget(
            title: AppLocalizations.of(context)!.translate(
              BlockTranslate.calcular,
              'descuento',
            ),
            value: vm.descuento,
            color: AppTheme.primary,
          ),
          const Divider(),
          RowTotalWidget(
            title: AppLocalizations.of(context)!.translate(
              BlockTranslate.calcular,
              'total',
            ),
            value: vm.total,
            color: AppTheme.primary,
          ),
        ],
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final TraInternaModel transaction;
  final int indexTransaction;

  const _TransactionCard({
    required this.transaction,
    required this.indexTransaction,
  });

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DetailsViewModel>(context);

    final homeVM = Provider.of<HomeViewModel>(context, listen: false);

    // Crear una instancia de NumberFormat para el formato de moneda
    final currencyFormat = NumberFormat.currency(
      symbol: homeVM
          .moneda, // Símbolo de la moneda (puedes cambiarlo según tu necesidad)
      decimalDigits: 2, // Número de decimales a mostrar
    );

    return Card(
      color: AppTheme.grayAppBar,
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${transaction.cantidad} x ${transaction.producto.desProducto}',
              style: AppTheme.normalBoldStyle,
            ),
            Text(
              'SKU: ${transaction.producto.productoId}',
              style: AppTheme.normalBoldStyle,
            )
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
                style: AppTheme.normalStyle,
              ),

            Text(
              '${AppLocalizations.of(context)!.translate(
                BlockTranslate.calcular,
                'precioT',
              )}: ${currencyFormat.format(transaction.total)}',
              style: AppTheme.normalStyle,
            ),
            if (transaction.cargo != 0)
              Text(
                '${AppLocalizations.of(context)!.translate(
                  BlockTranslate.calcular,
                  'cargo',
                )}: ${currencyFormat.format(transaction.cargo)}',
                style: AppTheme.normalStyle,
              ),

            if (transaction.descuento != 0)
              Text(
                '${AppLocalizations.of(context)!.translate(
                  BlockTranslate.calcular,
                  'descuento',
                )}: ${currencyFormat.format(transaction.descuento)}',
                style: AppTheme.normalStyle,
              ),
            // Text('Detalles: ${transaction.detalles}'),
          ],
        ),
        leading: Checkbox(
          activeColor: AppTheme.primary,
          value: transaction.isChecked,
          onChanged: (value) => vm.changeChecked(value, indexTransaction),
        ),
      ),
    );
  }
}

class _RadioCargo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DetailsViewModel>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () => vm.changeOption('Porcentaje'),
          child: Row(
            children: [
              Radio<String>(
                activeColor: AppTheme.primary,
                value: 'Porcentaje',
                groupValue: vm.selectedOption,
                onChanged: (value) => vm.changeOption(value),
              ),
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.calcular,
                  'porcentaje',
                ),
                style: AppTheme.normalStyle,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => vm.changeOption('Monto'),
          child: Row(
            children: [
              Radio<String>(
                activeColor: AppTheme.primary,
                value: 'Monto',
                groupValue: vm.selectedOption,
                onChanged: (value) => vm.changeOption(value),
              ),
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.calcular,
                  'monto',
                ),
                style: AppTheme.normalStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RadioFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DetailsViewModel>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () => vm.changeOptionFilter('SKU'),
          child: Row(
            children: [
              Radio<String>(
                activeColor: AppTheme.primary,
                value: 'SKU',
                groupValue: vm.filterOption,
                onChanged: (value) => vm.changeOptionFilter(value),
              ),
              const Text(
                'SKU',
                style: AppTheme.normalStyle,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => vm.changeOptionFilter('Descripcion'),
          child: Row(
            children: [
              Radio<String>(
                activeColor: AppTheme.primary,
                value: 'Descripcion',
                groupValue: vm.filterOption,
                onChanged: (value) => vm.changeOptionFilter(value),
              ),
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.general,
                  'descripcion',
                ),
                style: AppTheme.normalStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MyExpansionTile extends StatelessWidget {
  const MyExpansionTile({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.symmetric(vertical: 10),
      iconColor: AppTheme.disableStepLine,
      textColor: Colors.black,
      title: Text(
        title,
        style: AppTheme.titleStyle,
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: content,
        ),
      ],
    );
  }
}
