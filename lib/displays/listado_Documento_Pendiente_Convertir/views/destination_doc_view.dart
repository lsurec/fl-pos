import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/models.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class DestinationDocView extends StatelessWidget {
  const DestinationDocView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OriginDocModel document =
        ModalRoute.of(context)!.settings.arguments as OriginDocModel;

    final vm = Provider.of<DestinationDocViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text(
              "Destino",
              style: AppTheme.titleStyle,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: RefreshIndicator(
              onRefresh: () => vm.loadData(context, document),
              child: ListView(
                children: [
                  Column(
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
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: vm.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          final DestinationDocModel doc = vm.documents[index];

                          return GestureDetector(
                            onTap: () =>
                                vm.navigateConvert(context, document, doc),
                            child: CardWidget(
                              color: AppTheme.grayAppBar,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Documento:",
                                      style: AppTheme.normalBoldStyle,
                                    ),
                                    Text(
                                      doc.documento,
                                      style: AppTheme.normalStyle,
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      "Serie:",
                                      style: AppTheme.normalBoldStyle,
                                    ),
                                    Text(
                                      doc.serie,
                                      style: AppTheme.normalStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
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
