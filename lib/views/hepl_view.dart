import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';

class HelpView extends StatelessWidget {
  const HelpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ayuda",
          style: AppTheme.titleStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HelpSection(),
            ClientSection(),
          ],
        ),
      ),
    );
  }
}

class HelpSection extends StatelessWidget {
  const HelpSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: ListTile(
          title: const Text(
            'Configuré mi impresora pero no logro imprimir',
            style: AppTheme.normalBoldStyle,
          ),
          subtitle: const Text(
            'Esto podría deberse a que tu impresora no opera en modo ESC/POS o no está vinculada en la lista de dispositivos Bluetooth.',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            // Aquí puedes agregar la lógica para abrir la sección de ayuda
            // o mostrar información adicional.
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Problema de Impresora'),
                  content: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          'Si configuraste tu impresora pero no imprime, sigue estos pasos:'),
                      SizedBox(height: 8),
                      Text('1. Verifica que tu impresora esté encendida.'),
                      Text(
                          '2. Asegúrate de que la impresora esté en modo ESC/POS.'),
                      Text(
                          '3. Comprueba que la impresora esté vinculada en la lista de dispositivos Bluetooth de tu dispositivo.'),
                      Text(
                          '4. Asegúrate de que la impresora tenga papel disponible para imprimir.'),
                      Text(
                          '5. Comprueba que no se esté obstruyendo la salida del papel al momento de imprimir.'),
                      Text(
                          '6. Verifica que otro dispositvo no esté usando la impresora a la que intentas imprimir.'),
                      Text(
                          '7. Asegurate que la impresora que intentas usar es la correcta.'),
                      Text(
                          '8. Verifica que el dispositivo vinculado sea la impresora que intentas usar.'),
                      SizedBox(height: 16),
                      Text(
                        'Si el problema persiste, comunícate con nuestro soporte técnico para obtener ayuda adicional.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cerrar'),
                    ),
                    // TextButton(
                    //   onPressed: () {
                    //     // Aquí puedes agregar lógica adicional, como redirigir a la sección de soporte.
                    //     Navigator.of(context).pop();
                    //   },
                    //   child: Text('Contactar Soporte'),
                    // ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ClientSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: ListTile(
          title: const Text(
            'No encuentro el cliente que busco',
            style: AppTheme.normalBoldStyle,
          ),
          subtitle: const Text(
            'Es posible que el cliente que buscas no esté registrado. Ve al mantenimiento de cuentas y crea un nuevo cliente, o intenta hacer una búsqueda por otros parámetros. Recuerda que puedes buscar por nombre o NIT.',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            // Lógica específica para la pregunta sobre la búsqueda de clientes
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Información Adicional'),
                  content: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          'Si no encuentras al cliente que buscas, sigue estos pasos:'),
                      SizedBox(height: 8),
                      Text(
                          '1. Verifica que el cliente esté registrado en la aplicación.'),
                      Text(
                          '2. Ve al mantenimiento de cuentas y crea un nuevo cliente si es necesario.'),
                      Text(
                          '3. Intenta hacer una búsqueda por otros parámetros como nombre o NIT.'),
                      SizedBox(height: 16),
                      Text(
                        'Si necesitas asistencia adicional, no dudes en contactar a nuestro servicio de soporte.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cerrar'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
