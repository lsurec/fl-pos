import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:provider/provider.dart';

class ComentariosView extends StatelessWidget {
  const ComentariosView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ComentariosViewModel>(context);

    // List<ComentarioModel> comentarios = vm.comentarioDetalle.comentario;

    return Scaffold(
      // bottomNavigationBar: Container(color: Colors.red, height: 50,),
      appBar: AppBar(
        title: const Text(
          'Comentarios Tarea: 310',
          style: AppTheme.titleStyle,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          print("Volver a ceagar");
        },
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Observación",
                    style: AppTheme.normalBoldStyle,
                  ),
                  Text(
                    "sss",
                    style: AppTheme.normalStyle,
                    textAlign: TextAlign.justify,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Comentarios (4)",
                        style: AppTheme.normalBoldStyle,
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: vm.comentarioDetalle.length,
                    itemBuilder: (BuildContext context, int index) {
                      final ComentarioDetalleModel comentario =
                          vm.comentarioDetalle[index];
                      return _Comentario(
                        comentario: comentario,
                        index: index,
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  const _NuevoComentario(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NuevoComentario extends StatelessWidget {
  const _NuevoComentario({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ComentariosViewModel>(context);

    return TextFormField(
      controller: vm.comentarioController,
      onChanged: (value) {
        vm.comentText = value;
      },
      decoration: InputDecoration(
        labelText: 'Nuevo comentario',
        suffixIcon: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              tooltip: "Adjuntar Archivos",
              onPressed: () {
                print("Abrir explorador de archivos");
              },
              icon: const Icon(Icons.attach_file_outlined),
            ),
            IconButton(
              tooltip: "Enviar comentario.",
              onPressed: () {
                vm.comentar(context);
              },
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}

class _Comentario extends StatelessWidget {
  const _Comentario({
    super.key,
    required this.comentario,
    required this.index,
  });

  final ComentarioDetalleModel comentario;
  final int index;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ComentariosViewModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(width: 1.5, color: Color.fromRGBO(0, 0, 0, 0.12)),
              left:
                  BorderSide(width: 1.5, color: Color.fromRGBO(0, 0, 0, 0.12)),
              right:
                  BorderSide(width: 1.5, color: Color.fromRGBO(0, 0, 0, 0.12)),
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                comentario.comentario.nameUser,
                style: AppTheme.normalBoldStyle,
              ),
              Text(
                vm.formatearFecha(comentario.comentario.fechaHora),
                style: AppTheme.normalStyle,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
                width: 1.5, color: const Color.fromRGBO(0, 0, 0, 0.12)),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${comentario.comentario}",
                style: AppTheme.normalStyle,
                textAlign: TextAlign.justify,
              ),
              const Column(
                children: [
                  ListTile(
                    title: Text(
                      "archivo1.png",
                      style: AppTheme.normalStyle,
                    ),
                    leading: Icon(Icons.insert_photo_outlined),
                    contentPadding: EdgeInsets.zero,
                  ),
                  ListTile(
                    title: Text(
                      "archivo1.png",
                      style: AppTheme.normalStyle,
                    ),
                    leading: Icon(Icons.insert_photo_outlined),
                    contentPadding: EdgeInsets.all(0),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (index != vm.comentarios.length - 1)
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Container(
              color: const Color.fromRGBO(0, 0, 0, 0.12),
              height: 20,
              width: 3,
            ),
          ),
      ],
    );
  }
}
