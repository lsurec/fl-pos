import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/models.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class DetailsDestinationDocView extends StatelessWidget {
  const DetailsDestinationDocView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DetailsDestinationDocViewModel>(context);
    final DocDestinationModel document =
        ModalRoute.of(context)!.settings.arguments as DocDestinationModel;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
              // actions: const [_Actions()],
              ),
          body: RefreshIndicator(
            onRefresh: () => vm.loadData(context, document),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ColorTextCardWidget(
                        color: Colors.red,
                        text:
                            "DESTINO - (${document.tipoDocumento}) ${document.desTipoDocumento} - (${document.serie}) ${document.desSerie}.",
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Registros (${vm.detalles.length})",
                            style: AppTheme.normalBoldStyle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: vm.detalles.length,
                        itemBuilder: (BuildContext context, int index) {
                          DestinationDetailModel detallle = vm.detalles[index];

                          return CardWidget(child: Container());
                        },
                      ),
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
