import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/language_service.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:provider/provider.dart';

class SearchTask extends StatelessWidget {
  final int keyType;

  const SearchTask({
    super.key,
    required this.keyType,
  });

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TareasViewModel>(context);

    return Column(
      children: [
        Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: vm.getGlobalKey(keyType),
          child: TextFormField(
            onFieldSubmitted: (value) => vm.buscarTareas(
              context,
              value,
              keyType,
            ),
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
              hintText: AppLocalizations.of(context)!.translate(
                BlockTranslate.tareas,
                'buscar',
              ),
              labelText: AppLocalizations.of(context)!.translate(
                BlockTranslate.tareas,
                'buscar',
              ),
              suffixIcon: IconButton(
                tooltip: AppLocalizations.of(context)!.translate(
                  BlockTranslate.tareas,
                  'buscar',
                ),
                icon: Icon(
                  Icons.search,
                  color: AppTheme.color(
                    context,
                    Styles.darkPrimary,
                  ),
                ),
                onPressed: () => vm.buscarTareas(
                  context,
                  vm.searchController.text,
                  keyType,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "${AppLocalizations.of(context)!.translate(
                BlockTranslate.general,
                'registro',
              )} (${vm.tareas.length})",
              style: AppTheme.style(
                context,
                Styles.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
