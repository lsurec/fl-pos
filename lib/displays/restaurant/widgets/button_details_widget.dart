import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/order_view_model.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/tables_view_model.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/notification_service.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:provider/provider.dart';

class ButtonDetailsWidget extends StatelessWidget {
  const ButtonDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color.fromARGB(255, 228, 225, 225),
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      height: 80,
      child: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final TablesViewModel tablesVM =
                      Provider.of<TablesViewModel>(context, listen: false);

                  final OrderViewModel orderVM =
                      Provider.of<OrderViewModel>(context, listen: false);

                  if (tablesVM.table!.orders!.length == 1) {
                    if (orderVM.orders[tablesVM.table!.orders!.first]
                        .transacciones.isEmpty) {
                      NotificationService.showSnackbar(
                        "No hay transacciones para mostrar",
                      );
                      return;
                    }

                    Navigator.pushNamed(
                      context,
                      AppRoutes.order,
                      arguments: tablesVM.table!.orders!.first,
                    );
                  } else {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.selectAccount,
                      arguments: {
                        "screen": 2,
                        "action": 0,
                      },
                    );
                  }
                },
                style: AppTheme.button(
                  context,
                  Styles.buttonStyle,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      "Detalles", //TODO:Translate
                      style: AppTheme.style(
                        context,
                        Styles.whiteBoldStyle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
