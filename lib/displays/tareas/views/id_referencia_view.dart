import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class IdReferenciaView extends StatelessWidget {
  const IdReferenciaView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<IdReferenciaViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text(
              'Buscar ID Referencia',
              style: AppTheme.titleStyle,
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              print("Volver a ceagar");
            },
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: vm.buscarIdReferencia,
                        onChanged: (criterio) {
                          // vm.filtrarLista(criterio);
                          vm.buscarIdRefencia(context, criterio);
                        },
                        decoration: const InputDecoration(
                          labelText:
                              "Ingrese un caracter para iniciar la busqueda.",
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Registros (${vm.idReferencias.length})",
                            style: AppTheme.normalBoldStyle,
                          ),
                        ],
                      ),
                      const Divider(),
                      _ReferenciasEncontradas(
                        referenciasEncontradas: vm.idReferencias,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        //importarte para mostrar la pantalla de carga
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

class _ReferenciasEncontradas extends StatelessWidget {
  const _ReferenciasEncontradas({
    super.key,
    required this.referenciasEncontradas,
  });

  final List<IdReferenciaModel> referenciasEncontradas;

  @override
  Widget build(BuildContext context) {
    final vmCrear = Provider.of<CrearTareaViewModel>(context, listen: false);

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: referenciasEncontradas.length,
      itemBuilder: (BuildContext context, int index) {
        final IdReferenciaModel referencia = referenciasEncontradas[index];
        return Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom:
                  BorderSide(width: 1.5, color: Color.fromRGBO(0, 0, 0, 0.12)),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: GestureDetector(
              onTap: () {
                // Tu lógica cuando se hace tap en el Texto o en la Columna completa
                print(
                    'Se hizo tap en la referencia: ${referencia.descripcion}');

                vmCrear.seleccionarIdRef(context, referencia);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(
                    referencia.descripcion,
                    style: AppTheme.normalStyle,
                  ),
                  Row(
                    children: [
                      const Text(
                        "ID Referencia: ",
                        style: AppTheme.normalStyle,
                      ),
                      Text(
                        referencia.referenciaId,
                        style: AppTheme.normalBoldStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
