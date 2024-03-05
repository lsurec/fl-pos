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
    final vmCrear = Provider.of<CrearTareaViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Buscar Invitados y Responsable',
          style: AppTheme.titleStyle,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => vmCrear.guardarUsuarios(context),
            icon: const Icon(Icons.group_add_rounded),
            tooltip: "Guardar cambios",
          ),
        ],
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
                    controller: vm.buscar,
                    onChanged: (criterio) {
                      vm.buscarUsuario(context, criterio);
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
                        "Registros (${vm.usuarios.length})",
                        style: AppTheme.normalBoldStyle,
                      ),
                    ],
                  ),
                  const Divider(),
                  _UsuariosEncontados(usuariosEncontrados: vm.usuarios)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UsuariosEncontados extends StatelessWidget {
  const _UsuariosEncontados({
    super.key,
    required this.usuariosEncontrados,
  });

  final List<UsuarioModel> usuariosEncontrados;

  @override
  Widget build(BuildContext context) {
    final vmCrear = Provider.of<CrearTareaViewModel>(context, listen: false);
    final vm = Provider.of<UsuariosViewModel>(context, listen: false);

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: usuariosEncontrados.length,
      itemBuilder: (BuildContext context, int index) {
        final UsuarioModel usuario = usuariosEncontrados[index];
        return Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom:
                  BorderSide(width: 1.5, color: Color.fromRGBO(0, 0, 0, 0.12)),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: GestureDetector(
              onTap: () {
                vmCrear.seleccionarResponsable(context, usuario);
              },
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      usuario.name,
                      style: AppTheme.normalStyle,
                    ),
                    RichText(
                      text: TextSpan(
                        style: AppTheme.normalStyle,
                        children: [
                          const TextSpan(text: "Email: "),
                          TextSpan(
                              text: usuario.email,
                              style: AppTheme.normalBoldStyle),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
                leading: Column(
                  children: [
                    if (vm.tipoBusqueda == 2)
                      Checkbox(
                        activeColor: AppTheme.primary,
                        value: usuario.select,
                        onChanged: (value) => vm.changeChecked(value, index),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
