import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:provider/provider.dart';

class UsuariosView extends StatelessWidget {
  const UsuariosView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<UsuariosViewModel>(context);

    final List<UsuariosModel> usuariosEncontrados = vm.usuariosEncontrados;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Buscar Invitados y Responsable',
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
                    controller: vm.buscarUsuario,
                    onChanged: (criterio) {
                      vm.buscar(criterio);
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
                        "Registros (${usuariosEncontrados.length})",
                        style: AppTheme.normalBoldStyle,
                      ),
                    ],
                  ),
                  const Divider(),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: usuariosEncontrados.length,
                    itemBuilder: (BuildContext context, int index) {
                      final UsuariosModel usuario = usuariosEncontrados[index];
                      return Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                width: 1.5,
                                color: Color.fromRGBO(0, 0, 0, 0.12)),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Text(
                                usuario.name,
                                style: AppTheme.normalStyle,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Email: ",
                                    style: AppTheme.normalStyle,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    usuario.email,
                                    style: AppTheme.normalBoldStyle,
                                  )
                                ],
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
