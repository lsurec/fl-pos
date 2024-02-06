import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/app_Menu_Grid_01/models/models.dart';
import 'package:flutter_post_printer_example/displays/app_Menu_Grid_01/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class PendingDocsView extends StatelessWidget {
  const PendingDocsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vmMenu = Provider.of<MenuViewModel>(context);
    final vm = Provider.of<PendingDocsViewModel>(context);

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
            onRefresh: () => vm.laodData(context),
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
                          return _CardDoc(
                            document: vm.documents[index],
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
    );
  }
}

class _CardDoc extends StatelessWidget {
  const _CardDoc({
    super.key,
    required this.document,
  });

  final PendingDocModel document;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PendingDocsViewModel>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Id documento: ${document.iDDocumento}",
                style: AppTheme.normalBoldStyle,
              ),
              Text(
                "Usuario: ${document.usuario}",
                style: AppTheme.normalBoldStyle,
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () => vm.navigateDestination(context, document),
          child: CardWidget(
            color: AppTheme.grayAppBar,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      document.documentoDecripcion,
                      style: AppTheme.normalBoldStyle,
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Fecha documento:",
                        style: AppTheme.normalBoldStyle,
                      ),
                      Text(
                        document.fechaDocumento,
                        style: AppTheme.normalStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Fecha hora:",
                        style: AppTheme.normalBoldStyle,
                      ),
                      Text(
                        vm.formatDate(document.fechaHora),
                        style: AppTheme.normalStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Serie documento:",
                    style: AppTheme.normalBoldStyle,
                  ),
                  Text(
                    document.serie,
                    style: AppTheme.normalStyle,
                  ),

                  // Text(
                  //   "Bodega origen:",
                  //   style: AppTheme.normalBoldStyle,
                  // ),
                  // Text(
                  //   "Dolore irure eiusmod laboris quis.",
                  //   style: AppTheme.normalStyle,
                  // ),
                  // SizedBox(height: 5),
                  // Text(
                  //   "Bodega destino:",
                  //   style: AppTheme.normalBoldStyle,
                  // ),
                  // Text(
                  //   "Anim cupidatat adipisicing adipisicing.",
                  //   style: AppTheme.normalStyle,
                  // ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Divider(),
      ],
    );
  }
}
