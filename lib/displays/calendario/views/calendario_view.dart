// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/calendario/models/models.dart';
import 'package:flutter_post_printer_example/displays/calendario/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/utilities.dart';
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
              onPressed: () => vm.loadData(context),
              icon: const Icon(Icons.calendar_today_outlined),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              vm.loadData(context);
            },
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Text(
                            " ${vm.daySelect} de ${Utilities.nombreMes(vm.monthSelectView)} de ${vm.yearSelect}",
                            style: AppTheme.normalBoldStyle,
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () => vm.diaAnterior(),
                                child: const Text(
                                  "Dia Anterior",
                                  style: AppTheme.normalBoldStyle,
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () => vm.diaSiguiente(),
                                child: const Text(
                                  "Dia Siguiente",
                                  style: AppTheme.normalBoldStyle,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Column(
                      //   children: [
                      //     Text(
                      //       "${Utilities.nombreMes(vm.monthSelectView)} ${vm.yearSelect}",
                      //       style: AppTheme.normalBoldStyle,
                      //     ),
                      //     Row(
                      //       children: [
                      //         TextButton(
                      //           onPressed: () => vm.mesAnterior(),
                      //           child: const Text(
                      //             "Mes Anterior",
                      //             style: AppTheme.normalBoldStyle,
                      //           ),
                      //         ),
                      //         const Spacer(),
                      //         TextButton(
                      //           onPressed: () => vm.mesSiguiente(),
                      //           child: const Text(
                      //             "Mes Siguiente",
                      //             style: AppTheme.normalBoldStyle,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ],
                      // ),
                      // Column(
                      //   children: [
                      //     Text(
                      //       vm.generateNameWeeck(),
                      //       style: AppTheme.normalBoldStyle,
                      //     ),
                      //     Row(
                      //       children: [
                      //         TextButton(
                      //           onPressed: () => vm.semanaAnterior(),
                      //           child: const Text(
                      //             "Semana Anterior",
                      //             style: AppTheme.normalBoldStyle,
                      //           ),
                      //         ),
                      //         const Spacer(),
                      //         TextButton(
                      //           onPressed: () => vm.semanaSiguiente(),
                      //           child: const Text(
                      //             "Semana Siguiente",
                      //             style: AppTheme.normalBoldStyle,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ],
                      // ),

                      const SizedBox(height: 10),
                      // const HorasTareaDia(),
                      TablaTareasHora(),
                      // _HourTableWidget(),
                      // _NombreDias(),
                      // _Semanasss()
                      // _VistaMes(),
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
    );
  }
}

class _Semanasss extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CalendarioViewModel>(context, listen: false);

    vm.semanasDelMes = vm.agregarSemanas(vm.monthSelectView, vm.yearSelect);
    List<List<DiaModel>> semanas = vm.semanasDelMes;

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
        bottom: BorderSide(
          color: Color.fromRGBO(0, 0, 0, 0.12),
        ), // Sin borde abajo
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
          children: semanas[vm.indexWeekActive].map((dia) {
            return TableCell(
              child: Container(
                height: 400,
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
                      height: 25,
                      decoration: BoxDecoration(
                        color: dia.value == vm.today &&
                                vm.monthSelectView == vm.month &&
                                vm.yearSelect == vm.year
                            ? Colors.blue.shade300
                            : null,
                        border: const Border(
                          bottom: BorderSide(
                            color: Color.fromRGBO(0, 0, 0, 0.12),
                          ),
                        ), // Agregar borde inferior
                      ),
                      child: Center(
                        child: Text(
                          "${dia.value}",
                          style: AppTheme.normalBoldStyle,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: vm
                            .tareaDia(
                                dia.value, vm.monthSelectView, vm.yearSelect)
                            .length,
                        itemBuilder: (BuildContext context, int index) {
                          final List<TareaCalendarioModel> tareasDia =
                              vm.tareaDia(
                            dia.value,
                            vm.resolveMonth(index),
                            vm.resolveYear(index),
                          );
                          if (tareasDia.isNotEmpty) {
                            return Text(tareasDia[index].tarea.toString());
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _NombreDiasSemana extends StatelessWidget {
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
      children: [
        for (int i = 0; i < vm.diasSemana.length; i++)
          TableRow(
            children: [
              TableCell(
                child: Container(
                  height: 25,
                  width: 30, // Ancho corto para la primera columna
                  alignment: Alignment.topCenter,
                  child: Text(
                    // Para obtener solo las tres primeras letras del día
                    vm.diasSemana[i].substring(0, 3),
                    style: AppTheme.normalBoldStyle,
                  ),
                ),
              ),
              // _SemanasCalendario(vm: vm),
              TableCell(
                child: Container(
                  height: 25,
                  width: 50,
                  alignment: Alignment.topCenter,
                  child: Text(
                    '${i + 1}tareas que corresponden al dia',
                    style: AppTheme.normalStyle,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _VistaMes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CalendarioViewModel>(context, listen: false);

    List<DiaModel> diasMesSeleccionado =
        vm.armarMes(vm.monthSelectView, vm.yearSelect);
    //Calcular numero de semanas correctamente
    int semanasNum = (diasMesSeleccionado.length / 7).ceil();

    return Table(
      border: TableBorder.all(color: const Color.fromRGBO(0, 0, 0, 0.12)),
      children: List.generate(
        semanasNum,
        (rowIndex) => TableRow(
          children: List.generate(
            7,
            (columnIndex) {
              final index = rowIndex * 7 + columnIndex;
              DiaModel dia = diasMesSeleccionado[index];
              final backgroundColor = vm.nuevaIsToday(dia.value, index)
                  ? Colors.blue.shade300
                  : null;
              final dias = vm.diasOtroMes(dia, index, diasMesSeleccionado)
                  ? AppTheme.diasFueraMes
                  : AppTheme.normalBoldStyle;
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
                      height: 30,
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
                          "${dia.value}",
                          style: dias,
                        ),
                      ),
                    ),
                    if (vm.monthCurrent(dia.value, dia.indexWeek))
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: vm
                              .tareaDia(
                                  dia.value, vm.monthSelectView, vm.yearSelect)
                              .length,
                          itemBuilder: (BuildContext context, int index) {
                            final List<TareaCalendarioModel> tareasDia =
                                vm.tareaDia(dia.value, vm.monthSelectView,
                                    vm.yearSelect);
                            if (tareasDia.isNotEmpty) {
                              return Text(tareasDia[index].tarea.toString());
                            }
                            return null;
                          },
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

class TablaTareasHora extends StatefulWidget {
  const TablaTareasHora({super.key});

  @override
  State<TablaTareasHora> createState() => _TablaTareasHoraState();
}

class _TablaTareasHoraState extends State<TablaTareasHora> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CalendarioViewModel>(context, listen: false);
    List<HorasModel> horasDia = Utilities.horasDelDia;
    List<TableRow> filasTabla = [];

    // Añadir fila de encabezado
    filasTabla.add(
      TableRow(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            height: 45,
            child: const Text(
              "Horario",
              style: AppTheme.normalBoldStyle,
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.top,
            child: Container(
              padding: const EdgeInsets.all(10),
              width: 32,
              child: const Text(
                "Tareas",
                style: AppTheme.normalBoldStyle,
              ),
            ),
          ),
        ],
      ),
    );

    // Iterar sobre las horas del día y agregar filas correspondientes
    for (int indexHora = 0; indexHora < horasDia.length; indexHora++) {
      filasTabla.add(
        TableRow(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              width: 128,
              child: Text(
                horasDia[indexHora].hora12,
                style: AppTheme.normalBoldStyle,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: vm
                        .tareaHora(
                          horasDia[indexHora].hora24,
                          vm.tareaDia(
                            vm.daySelect,
                            vm.monthSelectView,
                            vm.yearSelect,
                          ),
                        )
                        .length,
                    itemBuilder: (BuildContext context, int index) {
                      final List<TareaCalendarioModel> tareasDia = vm.tareaDia(
                        vm.daySelect,
                        vm.monthSelectView,
                        vm.yearSelect,
                      );
                      final List<TareaCalendarioModel> tareasHoraDia =
                          vm.tareaHora(
                        horasDia[indexHora].hora24,
                        tareasDia,
                      );
                      if (tareasHoraDia.isNotEmpty) {
                        return Text(tareasHoraDia[index].tarea.toString());
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Table(
      border: TableBorder.all(),
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(),
        2: FixedColumnWidth(64),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: filasTabla,
    );
  }
}
