import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/models.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class TypesDocView extends StatelessWidget {
  const TypesDocView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vmMenu = Provider.of<MenuViewModel>(context);
    final vm = Provider.of<TypesDocViewModel>(context);

    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              title: Text(
                vmMenu.name,
                style: AppTheme.titleStyle,
              ),
            ),
            body: RefreshIndicator(
              onRefresh: () => vm.loadData(context),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Registros(${vm.documents.length})",
                              style: AppTheme.normalBoldStyle,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: vm.documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            final TypeDocModel doc = vm.documents[index];
                            return CardWidget(
                              child: ListTile(
                                onTap: () => vm.navigatePendDocs(context, doc),
                                trailing: const Icon(Icons.arrow_right),
                                title: Text(
                                  "${doc.fDesTipoDocumento} (${doc.tipoDocumento})",
                                  style: AppTheme.normalStyle,
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
            )),
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
