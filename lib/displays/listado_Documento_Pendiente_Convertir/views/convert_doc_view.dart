import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/models.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ConvertDocView extends StatelessWidget {
  const ConvertDocView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;

    final OriginDocModel docOrigen = arguments[0];
    final DestinationDocModel docDestino = arguments[1];

    final vm = Provider.of<ConvertDocViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text(
              'Convertir Documento',
              style: AppTheme.titleStyle,
            ),
            // actions: const [_Actions()],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => vm.convertirDocumento(
              context,
              docOrigen,
              docDestino,
            ),
            child: const Icon(Icons.check),
          ),
          body: RefreshIndicator(
            onRefresh: () => vm.loadData(context, docOrigen),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextsWidget(
                        title: "Id del Documento: ",
                        text: "${docOrigen.iDDocumento}",
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      ColorTextCardWidget(
                        color: Colors.green,
                        text:
                            "ORIGEN - (${docOrigen.documento}) ${docOrigen.documentoDecripcion} - (${docOrigen.serieDocumento}) ${docOrigen.serie}.",
                      ),
                      ColorTextCardWidget(
                        color: Colors.red,
                        text:
                            "DESTINO - (${docDestino.fTipoDocumento}) ${docDestino.documento} - (${docDestino.fSerieDocumento}) ${docDestino.serie}.",
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 13),
                            child: Checkbox(
                              activeColor: AppTheme.primary,
                              value: vm.selectAllTra,
                              onChanged: (value) => vm.selectAllTra = value!,
                            ),
                          ),
                          Text(
                            "Registros (${vm.detalles.length})",
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
                          OriginDetailInterModel detallle = vm.detalles[index];

                          return _CardDetalle(
                            detalle: detallle,
                            index: index,
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

class _Actions extends StatelessWidget {
  const _Actions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              color: AppTheme.backroundColor,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: const SingleChildScrollView(
                child: Column(
                  children: [
                    TextsWidget(
                      title: "Id. del Documento: ",
                      text: "10",
                    ),
                    SizedBox(height: 10),
                    TextsWidget(
                      title: "NIT: ",
                      text: "10151515",
                    ),
                    TextsWidget(
                      title: "Nombre: ",
                      text: "Nombre del cliente",
                    ),
                    TextsWidget(
                      title: "Direccion: ",
                      text: "Ciudad",
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      icon: const Icon(Icons.info_outline),
    );
  }
}

class _CardDetalle extends StatelessWidget {
  const _CardDetalle({
    required this.detalle,
    required this.index,
  });

  final OriginDetailInterModel detalle;
  final int index;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ConvertDocViewModel>(context);

    return GestureDetector(
      onTap: () {
        if (vm.detalles[index].disponible == 0) {
          NotificationService.showSnackbar(
              "No puede marcarse una transaccion con disponibilidad 0");
          return;
        }

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: AppTheme.backroundColor,
              title: const Text('Autorizar'),
              content: TextFormField(
                decoration: const InputDecoration(
                  labelText: "Cantidad",
                  hintText: "Cantidad",
                ),
                initialValue: "${detalle.disponibleMod}",
                onChanged: (value) => vm.textoInput = value,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo requerido.';
                  } else if (double.tryParse(value) == 0) {
                    return 'El valor no puede ser 0';
                  }
                  return null;
                },
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => vm.modificarDisponible(context, index),
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      },
      child: CardWidget(
        color: AppTheme.grayAppBar,
        child: ListTile(
          leading: Checkbox(
            value: detalle.checked,
            onChanged: (value) => vm.selectTra(index, value!),
            activeColor: AppTheme.primary,
          ),
          contentPadding: const EdgeInsets.all(10),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextsWidget(title: "Id: ", text: detalle.id),
              // const SizedBox(height: 5),
              // TextsWidget(title: "Clase: ", text: detalle.clase),
              // const SizedBox(height: 5),
              // TextsWidget(title: "Marca: ", text: detalle.marca ?? "SIN MARCA"),
              // const SizedBox(height: 5),
              // TextsWidget(title: "Bodega: ", text: detalle.bodega),
              const SizedBox(height: 5),
              TextsWidget(title: "Producto: ", text: detalle.producto),
              const SizedBox(height: 5),
              TextsWidget(title: "Cantidad: ", text: "${detalle.cantidad}"),
              const SizedBox(height: 5),
              TextsWidget(title: "Disponible: ", text: "${detalle.disponible}"),
              const SizedBox(height: 5),
              TextsWidget(
                  title: "Autorizar: ", text: "${detalle.disponibleMod}"),
            ],
          ),
        ),
      ),
    );
  }
}
