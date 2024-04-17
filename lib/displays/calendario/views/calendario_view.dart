// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/calendario/models/models.dart';
import 'package:flutter_post_printer_example/displays/calendario/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
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
            actions: <Widget>[
              Row(
                children: [
                  IconButton(
                    onPressed: () => vm.mostrarVistaMes(),
                    icon: const Icon(
                      Icons.calendar_month,
                      size: 40,
                    ),
                    tooltip: "Vista Mes",
                  ),
                  IconButton(
                    onPressed: () => vm.mostrarVistaSemana(),
                    icon: const Icon(
                      Icons.date_range,
                      size: 40,
                    ),
                    tooltip: "Vista Semana",
                  ),
                  IconButton(
                    onPressed: () => vm.mostrarVistaDia(),
                    icon: const Icon(
                      Icons.today,
                      size: 40,
                    ),
                    tooltip: "Vista Día",
                  ),
                ],
              )
            ],
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
                      if (vm.vistaDia)
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
                      if (vm.vistaMes)
                        Column(
                          children: [
                            Text(
                              "${Utilities.nombreMes(vm.monthSelectView)} ${vm.yearSelect}",
                              style: AppTheme.normalBoldStyle,
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () => vm.mesAnterior(),
                                  child: const Text(
                                    "Mes Anterior",
                                    style: AppTheme.normalBoldStyle,
                                  ),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () => vm.mesSiguiente(),
                                  child: const Text(
                                    "Mes Siguiente",
                                    style: AppTheme.normalBoldStyle,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      if (vm.vistaSemana)
                        Column(
                          children: [
                            Text(
                              vm.generateNameWeeck(),
                              style: AppTheme.normalBoldStyle,
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () => vm.semanaAnterior(),
                                  child: const Text(
                                    "Semana Anterior",
                                    style: AppTheme.normalBoldStyle,
                                  ),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () => vm.semanaSiguiente(),
                                  child: const Text(
                                    "Semana Siguiente",
                                    style: AppTheme.normalBoldStyle,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                      const SizedBox(height: 10),
                      if (vm.vistaMes || vm.vistaSemana) _NombreDias(),
                      if (vm.vistaMes)
                        // ignore: prefer_const_constructors
                        _VistaMes(),

                      if (vm.vistaSemana) _VistaSemana(),
                      // const HorasTareaDia(),
                      //si lleva const no cambia los dias
                      if (vm.vistaDia)
                        // ignore: prefer_const_constructors
                        _VistaDia(),
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

class _VistaSemana extends StatelessWidget {
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
              child: GestureDetector(
                onTap: () => vm.diaCorrectoSemana(
                  dia,
                  vm.monthSelectView,
                  vm.yearSelect,
                ),
                child: Column(
                  children: [
                    Container(
                      height: 30,
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
                    Container(
                      height: 850,
                      padding: const EdgeInsets.all(5),
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
                          return Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(bottom: 2),
                            child: Column(
                              children: [
                                Text(
                                  tareasDia[index].tarea.toString(),
                                  style: AppTheme.taskStyle,
                                ),
                                const Divider(),
                              ],
                            ),
                          );
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
              return GestureDetector(
                onTap: () =>
                    vm.diaCorrecto(dia, vm.monthSelectView, vm.yearSelect),
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
                    // if (vm.monthCurrent(dia.value, dia.indexWeek))
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          height: 135,
                          color: Colors.transparent,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: vm
                                        .tareaDia(
                                          dia.value,
                                          vm.monthSelectView,
                                          vm.yearSelect,
                                        )
                                        .length >=
                                    5
                                ? 4
                                : vm
                                    .tareaDia(
                                      dia.value,
                                      vm.monthSelectView,
                                      vm.yearSelect,
                                    )
                                    .length,
                            itemBuilder: (BuildContext context, int index) {
                              final List<TareaCalendarioModel> tareasDia =
                                  vm.tareaDia(
                                dia.value,
                                vm.monthSelectView,
                                vm.yearSelect,
                              );
                              return Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(bottom: 2),
                                child: Column(
                                  children: [
                                    Text(
                                      tareasDia[index].tarea.toString(),
                                      style: AppTheme.taskStyle,
                                    ),
                                    const Divider(height: 5),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        if (vm
                                .tareaDia(
                                  dia.value,
                                  vm.monthSelectView,
                                  vm.yearSelect,
                                )
                                .length >
                            4)
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Ver (+ ${vm.tareaDia(dia.value, vm.monthSelectView, vm.yearSelect).length - 4})",
                              textAlign: TextAlign.end,
                              style: AppTheme.tareaStyle,
                            ),
                          )
                      ],
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

class _VistaDia extends StatefulWidget {
  const _VistaDia({super.key});

  @override
  State<_VistaDia> createState() => _VistaDiaState();
}

class _VistaDiaState extends State<_VistaDia> {
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
              width: 100,
              child: Center(
                child: Text(
                  horasDia[indexHora].hora12,
                  style: AppTheme.normalBoldStyle,
                ),
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
                      //Lista de Tareas del dia
                      final List<TareaCalendarioModel> tareasDia = vm.tareaDia(
                        vm.daySelect,
                        vm.monthSelectView,
                        vm.yearSelect,
                      );
                      //Lista de Tareas por hora
                      final List<TareaCalendarioModel> tareasHoraDia =
                          vm.tareaHora(
                        horasDia[indexHora].hora24,
                        tareasDia,
                      );
                      //Tarea completa
                      final TareaCalendarioModel tarea = tareasHoraDia[index];
                      return CardWidget(
                        margin: const EdgeInsets.only(bottom: 5),
                        elevation: 0.3,
                        borderWidth: 1.5,
                        borderColor: const Color.fromRGBO(0, 0, 0, 0.12),
                        raidus: 10,
                        child: GestureDetector(
                          onTap: () {
                            print(
                              "ver detalles tarea ${tarea.tarea}",
                            );

                            vm.detalleTarea(context, tarea);
                          },
                          child: ListTile(
                            title: Text(
                              tarea.texto.substring(7),
                              style: AppTheme.normalBoldStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      );
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
        ), // Bo, // Sin borde abajo
        horizontalInside: BorderSide(
          color: Color.fromRGBO(0, 0, 0, 0.12),
        ), // Borde horizontal dentro de la tabla
        verticalInside: BorderSide(
          color: Color.fromRGBO(0, 0, 0, 0.12),
        ), // Borde vertical dentro de la tabla
      ),
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
