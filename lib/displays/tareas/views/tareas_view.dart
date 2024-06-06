import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/utilities/utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TareasView extends StatefulWidget {
  const TareasView({super.key});

  @override
  State<TareasView> createState() => _TareasViewState();
}

class _TareasViewState extends State<TareasView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData(context));
  }

  loadData(BuildContext context) async {
    final vm = Provider.of<TareasViewModel>(context, listen: false);
    vm.loadData(context);
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TareasViewModel>(context);
    final vmMenu = Provider.of<MenuViewModel>(context);

    List<TareaModel> tareas = vm.tareas;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              vmMenu.name,
              style: AppTheme.style(
                context,
                Styles.title,
                Preferences.idTheme,
              ),
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () => vm.crearTarea(context),
                icon: const Icon(Icons.add),
                tooltip: AppLocalizations.of(context)!.translate(
                  BlockTranslate.botones,
                  'nueva',
                ),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => vm.loadData(context),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _RadioFilter(),
                      const _InputSerach(),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.translate(
                              BlockTranslate.general,
                              'registro',
                            )} (${tareas.length})",
                            style: AppTheme.style(
                              context,
                              Styles.bold,
                              Preferences.idTheme,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: tareas.length,
                        itemBuilder: (BuildContext context, int index) {
                          final TareaModel tarea = tareas[index];
                          return _CardTask(tarea: tarea);
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (vm.isLoading)
          ModalBarrier(
            dismissible: false,
            // color: Colors.black.withOpacity(0.3),
            color: AppTheme.color(
              context,
              Styles.background,
              Preferences.idTheme,
            ),
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}

class _CardTask extends StatelessWidget {
  const _CardTask({
    required this.tarea,
  });

  final TareaModel tarea;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TareasViewModel>(context);
    //color de la tarea
    final List<int> colorTarea = Utilities.hexToRgb(tarea.backColor!);
    return GestureDetector(
      onTap: () => vm.detalleTarea(context, tarea),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextsWidget(
                  title: AppLocalizations.of(context)!.translate(
                    BlockTranslate.tareas,
                    'numTarea',
                  ),
                  text: "${tarea.iDTarea}",
                ),
                const Spacer(),
                Text(
                  tarea.tareaEstado ??
                      AppLocalizations.of(context)!.translate(
                        BlockTranslate.general,
                        'noDisponible',
                      ),
                  style: AppTheme.style(
                    context,
                    Styles.normal,
                    Preferences.idTheme,
                  ),
                ),
                const SizedBox(width: 20),
                Icon(
                  Icons.circle,
                  color: Color.fromRGBO(
                    colorTarea[0],
                    colorTarea[1],
                    colorTarea[2],
                    1,
                  ),
                ),
              ],
            ),
          ),
          CardWidget(
            color: AppTheme.color(
              context,
              Styles.secondBackground,
              Preferences.idTheme,
            ),
            elevation: 0,
            borderWidth: 1.5,
            borderColor: AppTheme.color(
              context,
              Styles.tareaBorder,
              Preferences.idTheme,
            ),
            raidus: 15,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      tarea.descripcion ??
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.general,
                            'noDisponible',
                          ),
                      style: AppTheme.style(
                        context,
                        Styles.bold,
                        Preferences.idTheme,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.translate(
                          BlockTranslate.tareas,
                          'idRef',
                        )}: ",
                        style: AppTheme.style(
                          context,
                          Styles.normal,
                          Preferences.idTheme,
                        ),
                      ),
                      Text(
                        '${tarea.iDReferencia}',
                        style: AppTheme.style(
                          context,
                          Styles.normal,
                          Preferences.idTheme,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        Utilities.formatearFecha(
                          tarea.tareaFechaIni,
                        ),
                        style: AppTheme.style(
                          context,
                          Styles.normal,
                          Preferences.idTheme,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${AppLocalizations.of(context)!.translate(
                      BlockTranslate.tareas,
                      'creador',
                    )} ${tarea.usuarioCreador}",
                    style: AppTheme.style(
                      context,
                      Styles.normal,
                      Preferences.idTheme,
                    ),
                  ),
                  Text(
                    "${AppLocalizations.of(context)!.translate(
                      BlockTranslate.tareas,
                      'responsable',
                    )} ${tarea.usuarioResponsable ?? AppLocalizations.of(context)!.translate(
                          BlockTranslate.tareas,
                          'noAsignado',
                        )}",
                    style: AppTheme.style(
                      context,
                      Styles.normal,
                      Preferences.idTheme,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${AppLocalizations.of(context)!.translate(
                        BlockTranslate.general,
                        'observacion',
                      )}:",
                      style: AppTheme.style(
                        context,
                        Styles.normal,
                        Preferences.idTheme,
                      ),
                    ),
                  ),
                  Text(
                    tarea.tareaObservacion1 ??
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.general,
                          'noDisponible',
                        ),
                    style: AppTheme.style(
                      context,
                      Styles.normal,
                      Preferences.idTheme,
                    ),
                    textAlign: TextAlign.justify,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          const Divider(),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}

class _InputSerach extends StatelessWidget {
  const _InputSerach();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TareasViewModel>(context);

    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: vm.formKeySearch,
      child: TextFormField(
        onFieldSubmitted: (value) => vm.searchText(context),
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
                Preferences.idTheme,
              ),
            ),
            onPressed: () => vm.searchText(context),
          ),
        ),
      ),
    );
  }
}

class _RadioFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TareasViewModel>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () => vm.busqueda(1),
          child: Row(
            children: [
              Radio(
                value: 1,
                groupValue: vm.filtro,
                onChanged: (value) => vm.busqueda(value!),
                activeColor: AppTheme.color(
                  context,
                  Styles.darkPrimary,
                  Preferences.idTheme,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.general,
                  'descripcion',
                ),
                style: AppTheme.style(
                  context,
                  Styles.normal,
                  Preferences.idTheme,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => vm.busqueda(2),
          child: Row(
            children: [
              Radio(
                value: 2,
                groupValue: vm.filtro,
                onChanged: (value) => vm.busqueda(value!),
                activeColor: AppTheme.color(
                  context,
                  Styles.darkPrimary,
                  Preferences.idTheme,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.tareas,
                  'idRef',
                ),
                style: AppTheme.style(
                  context,
                  Styles.normal,
                  Preferences.idTheme,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
