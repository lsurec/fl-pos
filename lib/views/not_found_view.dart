import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotFoundView extends StatelessWidget {
  const NotFoundView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final vmMenu = Provider.of<MenuViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          vmMenu.name,
          style: AppTheme.titleStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset("assets/pagenotfound.png"),
            Text(
              AppLocalizations.of(context)!.translate(
                BlockTranslate.home,
                "pagNoDisponible",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.botones,
                  "regresar",
                ),
                style: AppTheme.whiteBoldStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
