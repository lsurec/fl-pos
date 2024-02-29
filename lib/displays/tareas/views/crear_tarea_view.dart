import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:provider/provider.dart';

import '../view_models/view_models.dart';

class CrearTareaView extends StatelessWidget {
  const CrearTareaView({super.key});

  // @override
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CrearTareaViewModel>(context);

    final List<String> estados = vm.estados;

    final List<String> tipos = vm.tipos;

    final List<String> prioridades = vm.prioridades;
    final List<PeriodicidadModel> tiemposEstimados = vm.tiempos;

    final List<UsuarioModel> usuariosEncontrados = vm.invitados;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nueva Tarea',
          style: AppTheme.titleStyle,
        ),
        actions: <Widget>[
          Row(
            children: [
              IconButton(
                onPressed: () => vm.crear(),
                icon: const Icon(Icons.save),
                tooltip: "Crear Tarea",
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.attach_file_outlined),
                tooltip: "Adjuntar Archivos",
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          print("Volver a ceagar");
        },
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: vm.formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text(
                          "Titulo",
                          style: AppTheme.normalBoldStyle,
                        ),
                        Text(
                          "*",
                          style: AppTheme.obligatoryBoldStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo requerido.';
                        }
                        return null;
                      },
                      controller: vm.tituloController,
                      onChanged: (value) {
                        vm.titulo = value;
                      },
                      decoration: const InputDecoration(
                          labelText: "Añada un titulo para la tarea."),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Fecha y hora inicial",
                      style: AppTheme.normalBoldStyle,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () async {
                            vm.abrirFechaInicial(context);
                          },
                          icon: const Icon(Icons.calendar_today_outlined),
                          label: Text(
                            "Fecha: ${vm.fechaInicial.text}",
                            style: AppTheme.normalStyle,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () async {
                            vm.abrirHoraInicial(context);
                          },
                          icon: const Icon(Icons.schedule_outlined),
                          label: Text(
                            "Hora: ${vm.horaInicial.text}",
                            style: AppTheme.normalStyle,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Divider(),
                    const SizedBox(height: 5),
                    const Text(
                      "Fecha y hora final",
                      style: AppTheme.normalBoldStyle,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () async {
                            vm.abrirFechaFinal(context);
                          },
                          icon: const Icon(Icons.calendar_today_outlined),
                          label: Text(
                            "Fecha: ${vm.fechaFinal.text}",
                            style: AppTheme.normalStyle,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () async {
                            vm.abrirHoraFinal(context);
                          },
                          icon: const Icon(Icons.schedule_outlined),
                          label: Text(
                            "Hora: ${vm.horaFinal.text}",
                            style: AppTheme.normalStyle,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Divider(),
                    const SizedBox(height: 5),

                    const Text(
                      "Tiempo estimado: ",
                      style: AppTheme.normalBoldStyle,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 150,
                          child: TextFormField(
                            controller: vm.tiempoController,
                            onChanged: (value) {
                              vm.tiempo = value;
                            },
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 16,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 250,
                          child: _TiempoEstimado(tiempos: tiemposEstimados),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Text(
                          "Tipo",
                          style: AppTheme.normalBoldStyle,
                        ),
                        Padding(padding: EdgeInsets.only(left: 5)),
                        Text(
                          "*",
                          style: AppTheme.obligatoryBoldStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _TipoTarea(tipos: tipos),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Estado",
                              style: AppTheme.normalBoldStyle,
                            ),
                            Padding(padding: EdgeInsets.only(left: 5)),
                            Text(
                              "*",
                              style: AppTheme.obligatoryBoldStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _EstadoTarea(estados: estados),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Text(
                          "Prioridad",
                          style: AppTheme.normalBoldStyle,
                        ),
                        Padding(padding: EdgeInsets.only(left: 5)),
                        Text(
                          "*",
                          style: AppTheme.obligatoryBoldStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _PrioridadTarea(prioridades: prioridades),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Text(
                          "Observación",
                          style: AppTheme.normalBoldStyle,
                        ),
                        Padding(padding: EdgeInsets.only(left: 5)),
                        Text(
                          "*",
                          style: AppTheme.obligatoryBoldStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const _ObservacionTarea(),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => vm.irIdReferencia(context),
                      child: const ListTile(
                        title: Row(
                          children: [
                            Text(
                              "Id referencia :",
                              style: AppTheme.normalStyle,
                            ),
                            Text(
                              " * ",
                              style: AppTheme.obligatoryBoldStyle,
                            ),
                            SizedBox(width: 30),
                            Text(
                              "IL - 1",
                              style: AppTheme.normalBoldStyle,
                            ),
                          ],
                        ),
                        leading: Icon(Icons.search),
                        contentPadding: EdgeInsets.all(0),
                      ),
                    ),
                    const Divider(),

                    // const SizedBox(height: 5),
                    TextButton(
                      onPressed: () => vm.irUsuarios(context),
                      child: const ListTile(
                        title: Text(
                          "Añadir responsable",
                          style: AppTheme.normalStyle,
                        ),
                        leading: Icon(Icons.person_add_alt_1_outlined),
                        contentPadding: EdgeInsets.all(0),
                      ),
                    ),
                    const ListTile(
                      title: Text(
                        "Karina Ortega (DLCASA01)",
                        style: AppTheme.normalBoldStyle,
                      ),
                      subtitle: Text(
                        "kortega@delacasa.com.gt",
                        style: AppTheme.normalStyle,
                      ),
                      leading: Icon(Icons.person),
                      trailing: Icon(Icons.close),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    const Divider(),
                    TextButton(
                      onPressed: () => vm.irUsuarios(context),
                      child: const ListTile(
                        title: Text(
                          "Añadir invitados",
                          style: AppTheme.normalStyle,
                        ),
                        leading: Icon(Icons.person_add_alt_1_outlined),
                        contentPadding: EdgeInsets.all(0),
                      ),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: vm.invitados.length,
                      itemBuilder: (BuildContext context, int index) {
                        final UsuarioModel usuario = usuariosEncontrados[index];
                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                usuario.name,
                                style: AppTheme.normalBoldStyle,
                              ),
                              subtitle: Text(
                                usuario.email,
                                style: AppTheme.normalStyle,
                              ),
                              leading: const Icon(Icons.person),
                              trailing: const Icon(Icons.close),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TiempoEstimado extends StatelessWidget {
  const _TiempoEstimado({
    super.key,
    required this.tiempos,
  });

  final List<PeriodicidadModel> tiempos;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CrearTareaViewModel>(context);

    return DropdownButtonFormField2<PeriodicidadModel>(
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color.fromRGBO(0, 0, 0, 0.12),
          ),
        ),
      ),
      hint: const Text(
        'Seleccione el tiempo de periodicidad de la tarea.',
        style: TextStyle(fontSize: 14),
      ),
      items: tiempos
          .map((item) => DropdownMenuItem<PeriodicidadModel>(
                value: item,
                child: Text(
                  item.descripcion,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
          .toList(),
      onChanged: (value) {
        vm.periodicidad = value!;
      },
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
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
    );
  }
}

class _ObservacionTarea extends StatelessWidget {
  const _ObservacionTarea({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CrearTareaViewModel>(context);

    return TextFormField(
      controller: vm.observacionController,
      onChanged: (value) {
        vm.observacion = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Campo requerido.';
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Escriba una descripción o agregue notas aquí.",
      ),
      maxLines: 5,
      minLines: 2,
    );
  }
}

class _PrioridadTarea extends StatelessWidget {
  const _PrioridadTarea({
    super.key,
    required this.prioridades,
  });

  final List<String> prioridades;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CrearTareaViewModel>(context);

    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color.fromRGBO(0, 0, 0, 0.12),
          ),
        ),
      ),
      hint: const Text(
        'Seleccione el nivel de prioridad de la tarea.',
        style: TextStyle(fontSize: 14),
      ),
      items: prioridades
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
          .toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Seleccione el nivel de prioridad para continuar.';
        }
        return null;
      },
      onChanged: (value) {
        vm.prioridad = value;
      },
      onSaved: (value) {
        vm.prioridad = value;
      },
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
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
    );
  }
}

class _EstadoTarea extends StatelessWidget {
  const _EstadoTarea({
    super.key,
    required this.estados,
  });

  final List<String> estados;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CrearTareaViewModel>(context);

    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color.fromRGBO(0, 0, 0, 0.12),
          ),
        ),
      ),
      hint: const Text(
        'Seleccione el estado de la tarea.',
        style: TextStyle(fontSize: 14),
      ),
      items: estados
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
          .toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Seleccione un estado para continuar.';
        }
        return null;
      },
      onChanged: (value) {
        vm.estado = value;
      },
      onSaved: (value) {
        vm.estado = value;
      },
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
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
    );
  }
}

class _TipoTarea extends StatelessWidget {
  const _TipoTarea({
    super.key,
    required this.tipos,
  });

  final List<String> tipos;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CrearTareaViewModel>(context);

    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color.fromRGBO(0, 0, 0, 0.12),
          ), // Cambia el color del borde inferior aquí
        ),
        // Add more decoration..
      ),
      hint: const Text(
        'Seleccione el tipo de tarea.',
        style: TextStyle(fontSize: 14),
      ),
      items: tipos
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
          .toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Seleccione un tipo tarea para continuar.';
        }
        return null;
      },
      onChanged: (value) {
        vm.tipo = value;
      },
      onSaved: (value) {
        vm.tipo = value;
      },
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
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
    );
  }
}
