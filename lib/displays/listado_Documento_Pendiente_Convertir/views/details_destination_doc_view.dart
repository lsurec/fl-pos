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

    return WillPopScope(
      onWillPop: () => vm.backPage(context),
      child: Stack(
        children: [
          Scaffold(
            bottomNavigationBar: _PrintActions(
              document: document,
            ),
            appBar: AppBar(
              title: const Text(
                "Documento Procesado",
                style: AppTheme.titleStyle,
              ),
              actions: [
                IconButton(
                  onPressed: () => vm.shareDoc(context, document),
                  icon: const Icon(Icons.share),
                ),
              ],
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
                        TextsWidget(
                          title: "ID del Documento: ",
                          text: "${document.data.documento}",
                        ),
                        const SizedBox(height: 3),
                        TextsWidget(
                          title: "Tipo Documento: ",
                          text:
                              "(${document.serie}) ${document.desTipoDocumento.toUpperCase()}",
                        ),
                        const SizedBox(height: 3),
                        TextsWidget(
                          title: "Serie Documento: ",
                          text:
                              "(${document.serie}) ${document.desSerie.toUpperCase()}",
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Transacciones (${vm.detalles.length})",
                              style: AppTheme.normalBoldStyle,
                            ),
                          ],
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: vm.detalles.length,
                          itemBuilder: (BuildContext context, int index) {
                            DestinationDetailModel detalle = vm.detalles[index];

                            return CardWidget(
                              color: AppTheme.grayAppBar,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextsWidget(
                                      title: "Cantidad: ",
                                      text: "${detalle.cantidad}",
                                    ),
                                    const SizedBox(height: 5),
                                    TextsWidget(
                                      title: "Id: ",
                                      text: detalle.id,
                                    ),
                                    const SizedBox(height: 5),
                                    TextsWidget(
                                      title: "Producto: ",
                                      text: detalle.producto,
                                    ),
                                    const SizedBox(height: 5),
                                    TextsWidget(
                                      title: "Bodega: ",
                                      text: detalle.bodega,
                                    ),
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
          ),
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

class _PrintActions extends StatelessWidget {
  const _PrintActions({
    super.key,
    required this.document,
  });

  final DocDestinationModel document;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DetailsDestinationDocViewModel>(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 75,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => vm.backPage(context),
              child: Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  right: 10,
                ),
                color: AppTheme.primary,
                child: const Center(
                  child: Text(
                    "Listo",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => vm.printDoc(context, document),
              child: Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 10,
                ),
                color: AppTheme.primary,
                child: const Center(
                  child: Text(
                    "Imprimir",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
