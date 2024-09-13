import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';

class AppearenceView extends StatelessWidget {
  const AppearenceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Apariencia",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.preferencias,
                    'lenguaje',
                  ),
                ),
                subtitle: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.preferencias,
                    'sistema',
                  ),
                ),
                onTap: () {
                  NotificationService.changeLang(context);
                },
              ),
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.preferencias,
                    'tema',
                  ),
                ),
                subtitle: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.preferencias,
                    'sistema',
                  ),
                ),
                onTap: () {
                  NotificationService.changeTheme(context);
                },
              ),
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.preferencias,
                    'color',
                  ),
                ),
                subtitle: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.preferencias,
                    'sistema',
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.theme,
                  );
                },
              ),
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.preferencias,
                    'fuente',
                  ),
                ),
                subtitle: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.preferencias,
                    'sistema',
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
