import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';

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
                onPressed: () => Navigator.pushNamed(context, AppRoutes.order),
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
