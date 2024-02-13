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
    final List<DocDestinationModel> documents =
        ModalRoute.of(context)!.settings.arguments as List<DocDestinationModel>;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              "Destino",
              style: AppTheme.titleStyle,
            ),
          ),
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Registros(${documents.length})",
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
                      itemCount: documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        final DocDestinationModel doc = documents[index];

                        return GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Id. Documento: ${doc.data.documento}",
                                      style: AppTheme.normalBoldStyle,
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.print_outlined),
                                    )
                                  ],
                                ),
                              ),
                              CardWidget(
                                margin: EdgeInsets.zero,
                                color: AppTheme.grayAppBar,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 5),
                                      const Text(
                                        "Tipo Documento:",
                                        style: AppTheme.normalBoldStyle,
                                      ),
                                      Text(
                                        "${doc.desTipoDocumento} (${doc.tipoDocumento})",
                                        style: AppTheme.normalStyle,
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        "Serie Documento:",
                                        style: AppTheme.normalBoldStyle,
                                      ),
                                      Text(
                                        "${doc.desSerie} (${doc.serie})",
                                        style: AppTheme.normalStyle,
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
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
