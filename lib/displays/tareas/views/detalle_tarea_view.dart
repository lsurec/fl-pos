import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class DetalleTareaView extends StatelessWidget {
  const DetalleTareaView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DetalleTareaViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              'Detalles Tarea: ${vm.idTarea}',
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
                        "Oservacion:",
                        style: AppTheme.normalBoldStyle,
                      ),
                      Text(
                        vm.observacion,
                        style: AppTheme.normalStyle,
                        textAlign: TextAlign.justify,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => vm.verComentarios(context),
                            child: const Text(
                              "Comentarios (4)",
                              style: AppTheme.normalBoldStyle,
                            ),
                          ),
                        ],
                      ),

                      const Divider(),
                      const SizedBox(height: 10),

                      //ACTUALIZAR ESTADO DE LA TAREA
                      const Text(
                        "Estado: ",
                        style: AppTheme.normalBoldStyle,
                      ),
                      const _ActualizarEstado(),

                      //ACTUALIZAR PRIORIDAD DE LA TAREA
                      const Text(
                        "Prioridad: ",
                        style: AppTheme.normalBoldStyle,
                      ),
                      const _ActualizarPrioridad(),

                      const Text(
                        "Fecha Inicial: ",
                        style: AppTheme.normalBoldStyle,
                      ),
                      const CardWidget(
                        elevation: 0,
                        borderWidth: 1.5,
                        borderColor: Color.fromRGBO(0, 0, 0, 0.12),
                        raidus: 10,
                        child: ListTile(
                          title: Text(
                            "20/02/2023",
                            style: AppTheme.normalStyle,
                          ),
                          leading: Icon(Icons.date_range),
                        ),
                      ),
                      const Text(
                        "Fecha Final: ",
                        style: AppTheme.normalBoldStyle,
                      ),
                      const CardWidget(
                        elevation: 0,
                        borderWidth: 1.5,
                        borderColor: Color.fromRGBO(0, 0, 0, 0.12),
                        raidus: 10,
                        child: ListTile(
                          title: Text(
                            "21/02/2023",
                            style: AppTheme.normalStyle,
                          ),
                          leading: Icon(Icons.date_range),
                        ),
                      ),
                      const Text(
                        "Tipo tarea: ",
                        style: AppTheme.normalBoldStyle,
                      ),
                      const CardWidget(
                        elevation: 0,
                        borderWidth: 1.5,
                        borderColor: Color.fromRGBO(0, 0, 0, 0.12),
                        raidus: 10,
                        child: ListTile(
                          title: Text(
                            "Ticket",
                            style: AppTheme.normalStyle,
                          ),
                          leading: Icon(Icons.arrow_circle_right_outlined),
                        ),
                      ),

                      const Text(
                        "ID Referencia: ",
                        style: AppTheme.normalBoldStyle,
                      ),
                      const CardWidget(
                        elevation: 0,
                        borderWidth: 1.5,
                        borderColor: Color.fromRGBO(0, 0, 0, 0.12),
                        raidus: 10,
                        child: ListTile(
                          title: Text(
                            "IL - 1",
                            style: AppTheme.normalStyle,
                          ),
                          leading: Icon(Icons.arrow_circle_right_outlined),
                        ),
                      ),
                      const Text(
                        "Responsable: ",
                        style: AppTheme.normalBoldStyle,
                      ),
                      const CardWidget(
                        elevation: 0,
                        borderWidth: 1.5,
                        borderColor: Color.fromRGBO(0, 0, 0, 0.12),
                        raidus: 10,
                        child: ListTile(
                          title: Text(
                            "Gerencia 1",
                            style: AppTheme.normalStyle,
                          ),
                          leading: Icon(Icons.arrow_circle_right_outlined),
                          trailing: Icon(Icons.person_add_alt_1_outlined),
                        ),
                      ),

                      const Text(
                        "Invitados: ",
                        style: AppTheme.normalBoldStyle,
                      ),
                      const CardWidget(
                        elevation: 0,
                        borderWidth: 1.5,
                        borderColor: Color.fromRGBO(0, 0, 0, 0.12),
                        raidus: 10,
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Gerencia 1",
                                style: AppTheme.normalStyle,
                              ),
                              Text(
                                "Usuario 2",
                                style: AppTheme.normalStyle,
                              ),
                              Text(
                                "Usuario 3",
                                style: AppTheme.normalStyle,
                              ),
                            ],
                          ),
                          leading: Icon(Icons.arrow_circle_right_outlined),
                          trailing: Icon(Icons.person_add_alt_1_outlined),
                        ),
                      ),

                      const Text(
                        "Creador: ",
                        style: AppTheme.normalBoldStyle,
                      ),
                      const CardWidget(
                        elevation: 0,
                        borderWidth: 1.5,
                        borderColor: Color.fromRGBO(0, 0, 0, 0.12),
                        raidus: 10,
                        child: ListTile(
                          title: Text(
                            "Gerencia 10",
                            style: AppTheme.normalStyle,
                          ),
                          leading: Icon(Icons.arrow_circle_right_outlined),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ActualizarEstado extends StatelessWidget {
  const _ActualizarEstado({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DetalleTareaViewModel>(context);

    return CardWidget(
      elevation: 0,
      borderWidth: 0,
      raidus: 10,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonFormField2<String>(
          isExpanded: true,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 16),
          ),
          hint: const Text(
            'Seleccione un nuevo estado',
            style: AppTheme.normalStyle,
          ),
          items: vm.estados
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: AppTheme.normalStyle),
                ),
              )
              .toList(),
          validator: (value) {
            if (value == null) {
              return 'Seleccione un nuevo estado o presione cancelar.';
            }
            return null;
          },
          onChanged: (value) {
            //Do something when selected item is changed.
          },
          onSaved: (value) {
            vm.nuevoEstado = value.toString();
          },
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.only(right: 15),
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.edit,
              color: Colors.black45,
            ),
            iconSize: 24,
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ),
    );
  }
}

class _ActualizarPrioridad extends StatelessWidget {
  const _ActualizarPrioridad({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DetalleTareaViewModel>(context);

    return CardWidget(
      elevation: 0,
      borderWidth: 0,
      raidus: 10,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonFormField2<String>(
          isExpanded: true,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 16),
          ),
          hint: const Text(
            'Seleccione una nueva prioridad',
            style: AppTheme.normalStyle,
          ),
          items: vm.prioridades
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: AppTheme.normalStyle),
                ),
              )
              .toList(),
          validator: (value) {
            if (value == null) {
              return 'Seleccione un nuevo estado o presione cancelar.';
            }
            return null;
          },
          onChanged: (value) {
            //Do something when selected item is changed.
          },
          onSaved: (value) {
            vm.nuevaPrioridad = value.toString();
          },
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.only(right: 15),
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.edit,
              color: Colors.black45,
            ),
            iconSize: 24,
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ),
    );
  }
}
