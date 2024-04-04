// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/calendario/models/models.dart';
import 'package:flutter_post_printer_example/displays/calendario/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/widgets/load_widget.dart';
import 'package:provider/provider.dart';

class CalendarioView extends StatefulWidget {
  const CalendarioView({super.key});

  @override
  State<CalendarioView> createState() => _CalendarioViewState();
}

class _CalendarioViewState extends State<CalendarioView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData(context));
  }

  loadData(BuildContext context) async {
    final vm = Provider.of<CalendarioViewModel>(context, listen: false);
    vm.loadData(context);
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CalendarioViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text(
              'Calendario',
              style: AppTheme.titleStyle,
            ),
            leading: IconButton(
                onPressed: () {
                  vm.armarSemanas(
                    DateTime.now().month,
                    DateTime.now().year,
                  );
                  // vm.obtenerDiasDelMes(2024, 11);
                  // vm.crearArregloDias();
                },
                icon: const Icon(Icons.home)),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              vm.loadData(context);
              // print("Volver a ceagar");
            },
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {},
                            // => vm.mesAnterior(vm.month, vm.year),
                            child: const Text(
                              "Anterior",
                              style: AppTheme.normalBoldStyle,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            // onPressed: () => vm.mesSiguiente(vm.month, vm.year),
                            child: const Text(
                              "Siguiente",
                              style: AppTheme.normalBoldStyle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _NombreDias(),
                      _TablaDiasMes(),
                      // _TablaDiasSemana(),
                      // _Horas()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        //importarte para mostrar la pantalla de carga
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

class _Dias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final vm = Provider.of<CalendarioViewModel>(context, listen: false);

    // final List<int> dias = vm.obtenerDiasDelMes(2024, 3);

    return Table(
      border: TableBorder.all(),
      children: List.generate(
        5,
        (index) => TableRow(
          children: List.generate(
            7,
            (index2) => TableCell(
              child: Container(
                height: 50,
                width: 50,
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${index * 7 + index2 + 1}',
                          style: AppTheme.normalBoldStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NombreDias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CalendarioViewModel>(context, listen: false);

    return Table(
      border: const TableBorder(
        top: BorderSide(
          color: Color.fromRGBO(0, 0, 0, 0.12),
        ), // Borde arriba
        left: BorderSide(
          color: Color.fromRGBO(0, 0, 0, 0.12),
        ), // Borde izquierdo
        right: BorderSide(
          color: Color.fromRGBO(0, 0, 0, 0.12),
        ), // Borde derecho
        bottom: BorderSide.none, // Sin borde abajo
        horizontalInside: BorderSide(
          color: Color.fromRGBO(0, 0, 0, 0.12),
        ), // Borde horizontal dentro de la tabla
        verticalInside: BorderSide(
          color: Color.fromRGBO(0, 0, 0, 0.12),
        ), // Borde vertical dentro de la tabla
      ),
      children: List.generate(
        1,
        (index) => TableRow(
          children: vm.diasSemana.map((dia) {
            return TableCell(
              child: Container(
                height: 25,
                width: 50,
                alignment: Alignment.topCenter,
                child: Text(
                  // Para obtener solo las tres primeras letras del día
                  dia.substring(0, 3),
                  style: AppTheme.normalBoldStyle,
                ),
              ),
            );
          }).toList(),
        ),
      ),
      // children: List.generate(
      //   1,
      //   (index) => TableRow(
      //     children: List.generate(
      //       7,
      //       (index2) => TableCell(
      //         child: Container(
      //           height: 25,
      //           width: 50,
      //           alignment: Alignment.topCenter,
      //           // Accediendo a la inicial del día correspondiente
      //           child: Text(
      //             vm.inicialDia[index2],
      //             style: AppTheme.normalBoldStyle,
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}

class _TablaDiasMes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CalendarioViewModel>(context, listen: false);

    // Encontrar el índice del primer día del mes
    int primerDiaIndex = vm.diasDelMes.first.indexWeek;

    return Table(
      border: TableBorder.all(color: const Color.fromRGBO(0, 0, 0, 0.12)),
      children: List.generate(
        5,
        (rowIndex) => TableRow(
          children: List.generate(
            7,
            (columnIndex) {
              final index = (rowIndex * 7 + columnIndex) - primerDiaIndex + 1;
              final dia = index > 0 && index <= vm.diasDelMes.length
                  ? '${vm.diasDelMes[index - 1].value}'
                  : '';
              final backgroundColor =
                  dia == '${vm.fechaHoy.day}' ? Colors.lightBlueAccent : null;
              return Container(
                height: 100,
                width: 50,
                padding: const EdgeInsets.only(
                  left: 0,
                  right: 0,
                  bottom: 10,
                  top: 0,
                ),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        border: const Border(
                          bottom: BorderSide(
                            color: Color.fromRGBO(0, 0, 0, 0.12),
                          ),
                        ), // Agregar borde inferior
                      ),
                      child: Center(
                        child: Text(
                          dia,
                          style: AppTheme.normalStyle,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        "Tarea 450 ",
                        style: AppTheme.tareaStyle,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TablaDiasMesOriginal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CalendarioViewModel>(context, listen: false);
    final List<DiaModel> dias = vm.obtenerDiasDelMes(
      2,
      // DateTime.now().month,
      DateTime.now().year,
    );

    // Encontrar el índice del primer día del mes
    int primerDiaIndex = dias.indexWhere((dia) => dia.value == 1);

    return Table(
      border: TableBorder.all(color: const Color.fromRGBO(0, 0, 0, 0.12)),
      children: List.generate(
        5,
        (rowIndex) => TableRow(
          children: List.generate(
            7,
            (columnIndex) {
              final index = (rowIndex * 7 + columnIndex) - primerDiaIndex;
              final dia = index >= 0 && index < dias.length
                  ? '${dias[index].value}'
                  : '';
              final backgroundColor =
                  dia == '2' ? Colors.lightBlueAccent : null;
              return Container(
                height: 100,
                width: 50,
                padding: const EdgeInsets.only(
                  left: 0,
                  right: 0,
                  bottom: 10,
                  top: 0,
                ),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        border: const Border(
                          bottom: BorderSide(
                            color: Color.fromRGBO(0, 0, 0, 0.12),
                          ),
                        ), // Agregar borde inferior
                      ),
                      child: Center(
                        child: Text(
                          dia,
                          style: AppTheme.normalStyle,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        "Tarea 450 ",
                        style: AppTheme.tareaStyle,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TablaDiasSemana extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CalendarioViewModel>(context, listen: false);
    final List<int> dias = vm.diasMes;

    return Table(
      border: TableBorder.all(color: const Color.fromRGBO(0, 0, 0, 0.12)),
      children: List.generate(
        1,
        (rowIndex) => TableRow(
          children: List.generate(
            7,
            (columnIndex) {
              final index = rowIndex * 7 + columnIndex;
              final dia = index < dias.length ? '${dias[index]}' : '';
              final backgroundColor =
                  dia == '14' ? Colors.lightBlueAccent : null;
              return Container(
                height: 100,
                width: 50,
                padding: const EdgeInsets.only(
                  left: 0,
                  right: 0,
                  bottom: 10,
                  top: 0,
                ),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        border: const Border(
                          bottom: BorderSide(
                            color: Color.fromRGBO(0, 0, 0, 0.12),
                          ),
                        ), // Agregar borde inferior
                      ),
                      child: Center(
                        child: Text(
                          dia,
                          style: AppTheme.normalStyle,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        "Tarea 450 ",
                        style: AppTheme.tareaStyle,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Horas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CalendarioViewModel>(context, listen: false);

    final List<String> hora = vm.horas;

    return Table(
      border: const TableBorder(
        top: BorderSide(
          color: Color.fromRGBO(0, 0, 0, 0.12),
        ), // Borde arriba
        left: BorderSide(
          color: Color.fromRGBO(0, 0, 0, 0.12),
        ), // Borde izquierdo
        right: BorderSide(
          color: Color.fromRGBO(0, 0, 0, 0.12),
        ), // Borde derecho
        bottom: BorderSide.none, // Sin borde abajo
        horizontalInside: BorderSide(
          color: Color.fromRGBO(0, 0, 0, 0.12),
        ), // Borde horizontal dentro de la tabla
        verticalInside: BorderSide(
          color: Color.fromRGBO(0, 0, 0, 0.12),
        ), // Borde vertical dentro de la tabla
      ),
      children: List.generate(
        12,
        (index) => TableRow(
          children: List.generate(
            1,
            (index2) => TableCell(
              child: Container(
                height: 25,
                width: 50,
                alignment: Alignment.topCenter,
                // Accediendo a la inicial del día correspondiente
                child: Text(
                  hora[index],
                  style: AppTheme.normalBoldStyle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
