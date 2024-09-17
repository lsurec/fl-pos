import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/language_service.dart';
import 'package:flutter_post_printer_example/themes/app_new_theme.dart';
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
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppNewTheme.greyBorder,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
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
                icon: const Icon(
                  Icons.search,
                  color: AppNewTheme.grey,
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
      ],
    );
  }
}

class SearchTasks extends StatelessWidget {
  const SearchTasks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TareasViewModel>(context);

    return Column(
      children: [
        Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: TextFormField(
            onFieldSubmitted: (value) => vm.buscarRangoTareas(
              context,
              value,
              0,
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
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppNewTheme.greyBorder,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
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
                icon: const Icon(
                  Icons.search,
                ),
                onPressed: () => vm.buscarRangoTareas(
                  context,
                  vm.searchController.text,
                  0,
                ),
              ),
            ),
          ),
        ),
        // const SizedBox(height: 10),
      ],
    );
  }
}

class BuscarTarea extends StatelessWidget {
  const BuscarTarea({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TareasViewModel>(context);

    return Column(
      children: [
        Form(
          key: vm.formKeySearch,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: TextFormField(
            onFieldSubmitted: (value) => vm.buscarRangoTareas(
              context,
              value,
              0,
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
              // Elimina los bordes del TextField
              border: InputBorder.none,
              // Elimina el borde al habilitar
              enabledBorder: InputBorder.none,
              // Elimina el borde al enfocar
              focusedBorder: InputBorder.none,
              suffixIcon: IconButton(
                tooltip: AppLocalizations.of(context)!.translate(
                  BlockTranslate.tareas,
                  'buscar',
                ),
                icon: const Icon(
                  Icons.search,
                ),
                onPressed: () => vm.buscarRangoTareas(
                  context,
                  vm.searchController.text,
                  0,
                ),
              ),
            ),
          ),
        ),
        // const SizedBox(height: 10),
      ],
    );
  }
}
