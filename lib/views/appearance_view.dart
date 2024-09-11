import 'package:flutter/material.dart';

class AppearenceView extends StatelessWidget {
  const AppearenceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Apariencia",
          ),
        ),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50),
              ListTile(
                title: Text("Lenguaje"),
                subtitle: Text("Definido por el sistema."),
              ),
              ListTile(
                title: Text("Tema"),
                subtitle: Text("Definido por el sistema."),
              ),
              ListTile(
                title: Text("Color"),
                subtitle: Text("Definido por el sistema."),
              ),
              ListTile(
                title: Text("Tamaño de fuente"),
                subtitle: Text("Normal."),
              ),
            ],
          ),
        ));
  }
}
