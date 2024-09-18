// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:provider/provider.dart';

class TermsConditionsView extends StatelessWidget {
  const TermsConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final facturaVM = Provider.of<DocumentoViewModel>(context);
    final int screen = ModalRoute.of(context)!.settings.arguments as int;

    return WillPopScope(
      onWillPop: () => facturaVM.backModify(),
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              //Traducir
              title: const Text(
                "TERMINOS Y CONDICIONES",
                style: StyleApp.title,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(
                top: 0,
                bottom: 20,
                left: 20,
                right: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.translate(
                          BlockTranslate.general,
                          'registro',
                        )} (${facturaVM.terminosyCondiciones.length})",
                        style: StyleApp.normalBold,
                      ),
                    ],
                  ),
                  const Divider(
                    color: AppNewTheme.border,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: facturaVM.terminosyCondiciones.length,
                      itemBuilder: (context, index) {
                        final String mensaje =
                            facturaVM.terminosyCondiciones[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 10,
                          ),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: AppNewTheme.border,
                                width: 1, // Ancho del borde
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, // Separar texto y botones
                            children: [
                              Expanded(
                                // Para asegurar que el texto ocupe el espacio disponible
                                child: Text(
                                  "${index + 1}.  $mensaje",
                                  style: StyleApp.normal,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      facturaVM.editar(
                                        context,
                                        index,
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // Acción para cerrar
                                      facturaVM.eliminar(index);
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Positioned(
                  bottom: 75,
                  right: 10,
                  child: FloatingActionButton(
                    heroTag: 'button1', // Tag único para el primer botón
                    onPressed: () {
                      facturaVM.editar(
                        context,
                        -1,
                      );
                    },
                    child: const Icon(
                      Icons.add,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: FloatingActionButton(
                    heroTag: 'button2', // Tag único para el segundo botón
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.confirm,
                        arguments: screen,
                      );
                    },
                    child: const Icon(
                      Icons.check,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
