import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/view_models/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RowTotalWidget extends StatelessWidget {
  const RowTotalWidget({
    super.key,
    required this.title,
    required this.value,
    this.color,
  });

  final String title;
  final double value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final homeVM = Provider.of<HomeViewModel>(context, listen: false);

    // Crear una instancia de NumberFormat para el formato de moneda
    final currencyFormat = NumberFormat.currency(
      symbol: homeVM
          .moneda, // Símbolo de la moneda (puedes cambiarlo según tu necesidad)
      decimalDigits: 2, // Número de decimales a mostrar
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: color ??
                AppTheme.color(
                  Styles.total,
                ),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          currencyFormat.format(value),
          style: TextStyle(
            color: color ??
                AppTheme.color(
                  Styles.total,
                ),
            fontSize: 17,
          ),
        ),
      ],
    );
  }
}
