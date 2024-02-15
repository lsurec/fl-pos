import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/models.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class PendingDocsView extends StatelessWidget {
  const PendingDocsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PendingDocsViewModel>(context);
    final TypeDocModel tipoDoc =
        ModalRoute.of(context)!.settings.arguments as TypeDocModel;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              "${tipoDoc.fDesTipoDocumento} (Origen)",
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
                        children: [
                          TextButton.icon(
                            onPressed: () async {
                              vm.showPickerDate(context);
                            },
                            icon: const Icon(Icons.calendar_today_outlined),
                            label: Text(
                              "Fecha: ${vm.fechaInicial.text}",
                              style: AppTheme.normalStyle,
                            ),
                          ),
                        ],
                      ),
                      Text(vm.fechaIni),
                      Text(vm.fechaFin),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Registros(${vm.documents.length})",
                            style: AppTheme.normalBoldStyle,
                          ),
                          // DropdownButton<SellerModel>(
                          //   isExpanded: true,
                          //   dropdownColor: AppTheme.backroundColor,
                          //   value: vm.vendedorSelect,
                          //   onChanged: (value) => vm.changeSeller(value),
                          //   items: vm.cuentasCorrentistasRef.map((seller) {
                          //     return DropdownMenuItem<SellerModel>(
                          //       value: seller,
                          //       child: Text(seller.nomCuentaCorrentista),
                          //     );
                          //   }).toList(),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
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

  final OriginDocModel document;

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
        GestureDetector(
          onTap: () => vm.navigateDestination(context, document),
          child: CardWidget(
            color: AppTheme.grayAppBar,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  TextsWidget(
                      title: "Serie documento: ",
                      text: "${document.serie} (${document.serieDocumento})"),
                  const SizedBox(height: 5),
                  if (document.observacion.isNotEmpty)
                    TextsWidget(
                        title: "Observacion: ", text: document.observacion),
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
