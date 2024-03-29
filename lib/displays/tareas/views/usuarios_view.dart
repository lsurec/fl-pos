// ignore_for_file: avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class UsuariosView extends StatelessWidget {
  const UsuariosView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<UsuariosViewModel>(context);
    final vmDetalle = Provider.of<DetalleTareaViewModel>(context);

    return WillPopScope(
      onWillPop: () => vm.back(),
      child: Stack(
        children: [
          Scaffold(
            //Mostrar boton solo cuando se buscan invitados
            floatingActionButton: vm.tipoBusqueda == 2 || vm.tipoBusqueda == 4
                ? FloatingActionButton(
                    onPressed: () => vmDetalle.invitadosButton(context),
                    child: const Icon(
                      Icons.group_add_rounded,
                      color: Colors.white,
                    ),
                  )
                : null,
            appBar: AppBar(
              title: Text(
                vm.tipoBusqueda == 1
                    ? 'Agregar responsable'
                    : 'Agregar invitados',
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
                          controller: vm.buscar,
                          onChanged: (criterio) =>
                              vm.buscarUsuarioTemp(context),
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
                        const _UsuariosEncontados()
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
      ),
    );
  }
}

class _UsuariosEncontados extends StatelessWidget {
  const _UsuariosEncontados();

  @override
  Widget build(BuildContext context) {
    final vmCrear = Provider.of<CrearTareaViewModel>(context);
    final vm = Provider.of<UsuariosViewModel>(context);

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: vm.usuarios.length,
      itemBuilder: (BuildContext context, int index) {
        final UsuarioModel usuario = vm.usuarios[index];
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
              onTap: () => vmCrear.seleccionarResponsable(context, usuario),
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
                    if (vm.tipoBusqueda == 2 || vm.tipoBusqueda == 4)
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
