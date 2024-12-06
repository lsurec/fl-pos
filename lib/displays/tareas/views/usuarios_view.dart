// ignore_for_file: avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class UsuariosView extends StatelessWidget {
  const UsuariosView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<UsuariosViewModel>(context);
    final vmDetalle = Provider.of<DetalleTareaViewModel>(context);
    final vmCalendarioDetalle = Provider.of<DetalleTareaViewModel>(context);
    final vmCrear = Provider.of<CrearTareaViewModel>(context);
    final vmTarea = Provider.of<TareasViewModel>(context);

    final String titulo = ModalRoute.of(context)!.settings.arguments as String;

    return WillPopScope(
      onWillPop: () => vm.back(context),
      child: Stack(
        children: [
          Scaffold(
            //Mostrar boton solo cuando se buscan invitados
            floatingActionButton: vm.tipoBusqueda == 2 || vm.tipoBusqueda == 4
                ? FloatingActionButton(
                    onPressed: () => vm.tipoBusqueda == 2
                        ? vmCrear.guardarInvitados(context)
                        : vmDetalle.guardarInvitados(context),
                    child: const Icon(
                      Icons.group_add_rounded,
                    ),
                  )
                : null,
            appBar: AppBar(
              title: Text(
                titulo,
                style: StyleApp.title,
              ),
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: vm.buscar,
                        onFieldSubmitted: (criterio) => vm.buscarUsuario(
                          context,
                        ),
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.translate(
                            BlockTranslate.tareas,
                            'buscar',
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppTheme.grey,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppTheme.grey,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.search,
                            ),
                            onPressed: () => vm.buscarUsuario(context),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment:
                            vm.tipoBusqueda == 2 || vm.tipoBusqueda == 4
                                ? MainAxisAlignment.spaceBetween
                                : MainAxisAlignment.end,
                        children: [
                          if (vm.tipoBusqueda == 2 || vm.tipoBusqueda == 4)
                            Text(
                              "${AppLocalizations.of(context)!.translate(
                                BlockTranslate.general,
                                'seleccionados',
                              )} (${vmCrear.invitados.length})",
                              style: StyleApp.normalBold,
                            ),
                          if (vm.tipoBusqueda == 4)
                            Text(
                              "${AppLocalizations.of(context)!.translate(
                                BlockTranslate.general,
                                'agregados',
                              )} (${vmTarea.vistaDetalle == 1 ? vmDetalle.invitados.length : vmCalendarioDetalle.invitados.length})",
                              style: StyleApp.normalBold,
                            ),
                          Text(
                            "${AppLocalizations.of(context)!.translate(
                              BlockTranslate.general,
                              'registro',
                            )} (${vm.usuarios.length})",
                            style: StyleApp.normalBold,
                          ),
                        ],
                      ),
                      const Divider(),
                      if (vm.tipoBusqueda == 2 || vm.tipoBusqueda == 4)
                        const _InvitadosEncontrados(),
                      if (vm.tipoBusqueda == 1 || vm.tipoBusqueda == 3 || vm.tipoBusqueda == 5)
                        const _ResponsablesEncontrados()
                    ],
                  ),
                ),
              ],
            ),
          ),
          //importarte para mostrar la pantalla de carga
          if (vm.isLoading)
            ModalBarrier(
              dismissible: false,
              // color: Colors.black.withOpacity(0.3),
              color: AppTheme.isDark()
                  ? AppTheme.darkBackroundColor
                  : AppTheme.backroundColor,
            ),
          if (vm.isLoading) const LoadWidget(),
        ],
      ),
    );
  }
}

class _InvitadosEncontrados extends StatelessWidget {
  const _InvitadosEncontrados();

  @override
  Widget build(BuildContext context) {
    // final vmCrear = Provider.of<CrearTareaViewModel>(context);
    final vm = Provider.of<UsuariosViewModel>(context);

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: vm.usuarios.length,
      itemBuilder: (BuildContext context, int index) {
        final UsuarioModel usuario = vm.usuarios[index];

        return CheckboxListTile(
          activeColor: AppTheme.hexToColor(Preferences.valueColor),
          value: usuario.select,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Text(usuario.name, style: StyleApp.normal),
              RichText(
                text: TextSpan(
                  style: StyleApp.normal.copyWith(
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)!.translate(
                        BlockTranslate.cuenta,
                        'correo',
                      ),
                    ),
                    const TextSpan(text: ": "),
                    TextSpan(
                      text: usuario.email,
                      style: StyleApp.normalBold.copyWith(
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
          onChanged: (value) => vm.changeChecked(context, value, index),
        );
      },
    );
  }
}

// class _InvitadosEncontrados extends StatelessWidget {
//   const _InvitadosEncontrados();

//   @override
//   Widget build(BuildContext context) {
//     final vmCrear = Provider.of<CrearTareaViewModel>(context);
//     final vm = Provider.of<UsuariosViewModel>(context);

//     return ListView.builder(
//       physics: const NeverScrollableScrollPhysics(),
//       scrollDirection: Axis.vertical,
//       shrinkWrap: true,
//       itemCount: vm.usuarios.length,
//       itemBuilder: (BuildContext context, int index) {
//         final UsuarioModel usuario = vm.usuarios[index];
//         return Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 5),
//               child: GestureDetector(
//                 onTap: () => vmCrear.seleccionarUsuario(
//                   context,
//                   usuario,
//                   vm.tipoBusqueda,
//                 ),
//                 child: ListTile(
//                   title: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: 5),
//                       Text(
//                         usuario.name,
//                         style: StyleApp.normal,
//                       ),
//                       RichText(
//                         text: TextSpan(
//                           style: StyleApp.normal.copyWith(
//                             color: Theme.of(context).textTheme.bodyText1!.color,
//                           ),
//                           children: [
//                             TextSpan(
//                               text: AppLocalizations.of(context)!.translate(
//                                 BlockTranslate.cuenta,
//                                 'correo',
//                               ),
//                             ),
//                             const TextSpan(text: ": "),
//                             TextSpan(
//                               text: usuario.email,
//                               style: StyleApp.normalBold.copyWith(
//                                 color: Theme.of(context)
//                                     .textTheme
//                                     .bodyText1!
//                                     .color,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                     ],
//                   ),
//                   leading: Column(
//                     children: [
//                       Checkbox(
//                         activeColor: AppTheme.hexToColor(
//                           Preferences.valueColor,
//                         ),
//                         value: usuario.select,
//                         onChanged: (value) => vm.changeChecked(
//                           context,
//                           value,
//                           index,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             const Divider(),
//           ],
//         );
//       },
//     );
//   }
// }

class _ResponsablesEncontrados extends StatelessWidget {
  const _ResponsablesEncontrados();

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
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                onTap: () => vmCrear.seleccionarUsuario(
                  context,
                  usuario,
                  vm.tipoBusqueda,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      usuario.name,
                      style: StyleApp.normal,
                    ),
                    RichText(
                      text: TextSpan(
                        style: StyleApp.normal.copyWith(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                        children: [
                          TextSpan(
                            text: AppLocalizations.of(context)!.translate(
                              BlockTranslate.cuenta,
                              'correo',
                            ),
                          ),
                          const TextSpan(text: ": "),
                          TextSpan(
                            text: usuario.email,
                            style: StyleApp.normalBold.copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
            const Divider(),
          ],
        );
      },
    );
  }
}
