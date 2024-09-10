import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/widgets/widgets.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class TablesView extends StatefulWidget {
  const TablesView({Key? key}) : super(key: key);

  @override
  State<TablesView> createState() => _TablesViewState();
}


class _TablesViewState extends State<TablesView> {


  late WebSocketChannel _channel;

  @override
  void initState() {
    super.initState();
    // Conexión al WebSocket cuando se entra a la pantalla
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.0.7:9192/ws'),
    );

    // Escucha los mensajes sin redibujar el widget
    _channel.stream.listen((message) {
      _handleMessage(message);
    });
  }

  // Función para manejar los mensajes recibidos
  void _handleMessage(String message) {
    // Ejecuta la función que necesites
    print('Mensaje recibido: $message');
    // Aquí puedes realizar cualquier operación, por ejemplo:
    // Llamar a otra función, actualizar una variable, etc.
  }
  
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TablesViewModel>(context);
    final vmLoc = Provider.of<LocationsViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              vmLoc.location!.descripcion,
              style: AppTheme.style(
                context,
                Styles.title,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              //TODO:Verificar estilos
                              child: const Text(
                                "Ubicaciones/", //TODO:Translate
                                //TODO;Styles
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black38,
                                ),
                              ),
                            ),
                            Text(
                              vmLoc.location!.descripcion,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      RegisterCountWidget(count: vm.tables.length),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => vm.loadData(context),
                    child: ListView.builder(
                      itemCount: vm.tables.length,
                      itemBuilder: (BuildContext context, int index) {
                        TableModel table = vm.tables[index];
                        return CardTableWidget(
                          mesa: table,
                          onTap: () => vm.navigateClassifications(
                            context,
                            table,
                            index,
                          ),
                        );
                      },
                    ),
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
            color: AppTheme.color(
              context,
              Styles.loading,
            ),
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}
