import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
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

    List<TareaModel> tareas = vm.tareas;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            //TODO:Nommbre del display
            title: const Text(
              'Tareas',
              style: AppTheme.titleStyle,
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () => vm.crearTarea(context),
                icon: const Icon(Icons.add),
                tooltip: "Nueva Tarea",
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
                      const _Filtros(),
                      const _InputSerach(),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Registros (${tareas.length})",
                            style: AppTheme.normalBoldStyle,
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
            color: AppTheme.backroundColor,
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}

class _CardTask extends StatelessWidget {
  const _CardTask({
    super.key,
    required this.tarea,
  });

  final TareaModel tarea;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TareasViewModel>(context);

    return GestureDetector(
      onTap: () {
        vm.detalleTarea(context, tarea);
        // vm.verDetalles(context); //ver detalle
        // Navigator.pushNamed(context, "detalle"); //Ruta xd
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextsWidget(title: "Tarea no: ", text: "${tarea.iDTarea}"),
                Text(
                  tarea.tareaEstado ?? "",
                  style: AppTheme.normalStyle,
                ),
              ],
            ),
          ),
          CardWidget(
            elevation: 0,
            borderWidth: 1.5,
            borderColor: const Color.fromRGBO(0, 0, 0, 0.12),
            raidus: 15,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      tarea.descripcion ?? "",
                      style: AppTheme.normalBoldStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Text("ID Referencia: ",
                          style: AppTheme.normalStyle),
                      Text('${tarea.iDReferencia}',
                          style: AppTheme.normalStyle),
                      const Spacer(),
                      Text(vm.formatearFecha(tarea.tareaFechaIni),
                          style: AppTheme.normalStyle),
                    ],
                  ),
                  Text("Creador: ${tarea.usuarioCreador}",
                      style: AppTheme.normalStyle),
                  Text(
                      "Responsable: ${tarea.usuarioResponsable ?? "No asignado"}",
                      style: AppTheme.normalStyle),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    alignment: Alignment.centerLeft,
                    child:
                        const Text("Observacion:", style: AppTheme.normalStyle),
                  ),
                  Text(
                    tarea.tareaObservacion1 ?? "",
                    style: AppTheme.normalStyle,
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
  const _InputSerach({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TareasViewModel>(context);

    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: vm.formKeySearch,
      child: TextFormField(
        onFieldSubmitted: (value) {
          if (vm.filtro == 1) {
            vm.buscarTareasDescripcion(context, vm.searchController.text);
          }

          if (vm.filtro == 2) {
            vm.buscarTareasIdReferencia(context, vm.searchController.text);
          }
        },
        textInputAction: TextInputAction.search,
        controller: vm.searchController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo requerido.';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: 'Buscar',
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.search,
              color: AppTheme.primary,
            ),
            // onPressed: () => vm.performSearch(),
            onPressed: () {
              if (vm.filtro == 1) {
                vm.buscarTareasDescripcion(context, vm.searchController.text);
              }
              if (vm.filtro == 2) {
                vm.buscarTareasIdReferencia(context, vm.searchController.text);
              }
            },
          ),
        ),
      ),
    );
  }
}

class _Filtros extends StatelessWidget {
  const _Filtros({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TareasViewModel>(context);

    return Row(children: [
      const Text(
        "Filtos",
        style: AppTheme.normalStyle,
      ),
      const Spacer(),
      Radio(
        value: 1,
        groupValue: vm.filtro,
        onChanged: (value) {
          vm.busqueda(value!);
        },
      ),
      const Text(
        "Descripcion",
        style: AppTheme.normalStyle,
      ),
      Radio(
        value: 2,
        groupValue: vm.filtro,
        onChanged: (value) {
          vm.busqueda(value!);
        },
      ),
      const Text(
        "ID Referencia",
        style: AppTheme.normalStyle,
      ),
    ]);
  }
}
