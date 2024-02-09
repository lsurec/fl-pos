import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/models.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/widgets/card_widget.dart';
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

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    color: AppTheme.backroundColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    child: const SingleChildScrollView(
                      child: Column(
                        children: [
                          _Texts(
                            title: "Id. del Documento: ",
                            text: "10",
                          ),
                          SizedBox(height: 10),
                          _Texts(
                            title: "NIT: ",
                            text: "10151515",
                          ),
                          _Texts(
                            title: "Nombre: ",
                            text: "Nombre del cliente",
                          ),
                          _Texts(
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
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.check,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ColorCard(
                color: Colors.green,
                text:
                    "ORIGEN - (${docOrigen.documento}) ${docOrigen.documentoDecripcion} - (${docOrigen.serieDocumento}) ${docOrigen.serie}.",
              ),
              _ColorCard(
                color: Colors.red,
                text:
                    "DESTINO - (${docDestino.fTipoDocumento}) ${docDestino.documento} - (${docDestino.fSerieDocumento}) ${docDestino.serie}.",
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
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: vm.detalles.length,
                itemBuilder: (BuildContext context, int index) {
                  OriginDetailsModel detallle = vm.detalles[index];

                  return _CardDetalle();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorCard extends StatelessWidget {
  const _ColorCard({
    super.key,
    required this.color,
    required this.text,
  });

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      color: color,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}

class _CardDetalle extends StatelessWidget {
  const _CardDetalle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        String texto = '';
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Cantidad'),
              content: TextField(
                onChanged: (value) {
                  texto = value;
                },
                decoration: InputDecoration(hintText: 'Escriba aquí'),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cierra el diálogo
                  },
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    // Realiza alguna acción con el texto ingresado
                    print('Texto ingresado: $texto');
                    Navigator.of(context).pop(); // Cierra el diálogo
                  },
                  child: Text('Aceptar'),
                ),
              ],
            );
          },
        );
      },
      child: CardWidget(
        color: AppTheme.grayAppBar,
        child: ListTile(
          leading: Checkbox(value: false, onChanged: (value) {}),
          contentPadding: const EdgeInsets.all(10),
          subtitle: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Texts(title: "Cantidad: ", text: "1000"),
              SizedBox(height: 5),
              _Texts(title: "Disponible: ", text: "1000"),
              SizedBox(height: 5),
              _Texts(title: "Clase: ", text: "1000"),
              SizedBox(height: 5),
              _Texts(title: "Marca: ", text: "1000"),
              SizedBox(height: 5),
              _Texts(title: "Id: ", text: "1000"),
              SizedBox(height: 5),
              _Texts(title: "Bodega: ", text: "1000"),
              SizedBox(height: 5),
              _Texts(title: "Producto: ", text: "1000"),
            ],
          ),
        ),
      ),
    );
  }
}

class _Texts extends StatelessWidget {
  const _Texts({
    super.key,
    required this.title,
    required this.text,
  });

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppTheme.normalStyle,
        children: [
          TextSpan(text: title, style: AppTheme.normalBoldStyle),
          TextSpan(
            text: text,
          )
        ],
      ),
    );
  }
}
