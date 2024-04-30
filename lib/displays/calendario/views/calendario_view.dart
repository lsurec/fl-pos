// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/calendario/models/models.dart';
import 'package:flutter_post_printer_example/displays/calendario/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
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
        DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  const Text(
                    'Calendario',
                    style: AppTheme.titleStyle,
                  ),
                  IconButton(
                    onPressed: () => vm.abrirPickerCalendario(context),
                    icon: const Icon(Icons.calendar_month),
                  ),
                ],
              ),
              actions: <Widget>[
                const Text(
                  "Hoy",
                  style: AppTheme.normalBoldStyle,
                ),
                IconButton(
                  onPressed: () => vm.loadData(context),
                  icon: const Icon(Icons.today),
                  tooltip: "Nueva Tarea",
                ),
                const SizedBox(
                  width: 15,
                )
              ],
            ),
            drawer: const _DrawerCalendar(),
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
                                    onPressed: () => vm.diaAnterior(context),
                                    child: const Text(
                                      "Dia Anterior",
                                      style: AppTheme.normalBoldStyle,
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () => vm.diaSiguiente(context),
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
                                    onPressed: () => vm.mesAnterior(
                                      context,
                                    ),
                                    child: const Text(
                                      "Mes Anterior",
                                      style: AppTheme.normalBoldStyle,
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () => vm.mesSiguiente(
                                      context,
                                    ),
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
                                    onPressed: () => vm.semanaAnterior(
                                      context,
                                    ),
                                    child: const Text(
                                      "Semana Anterior",
                                      style: AppTheme.normalBoldStyle,
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () => vm.semanaSiguiente(
                                      context,
                                    ),
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
                          SwipeDetector(
                            onSwipeLeft: (offset) => vm.mesSiguiente(
                              context,
                            ),
                            onSwipeRight: (offset) => vm.mesAnterior(
                              context,
                            ),
                            child: _VistaMes(),
                          ),

                        if (vm.vistaSemana)
                          SwipeDetector(
                            //anterior
                            onSwipeRight: (offset) => vm.semanaAnterior(
                              context,
                            ),
                            //siguiente
                            onSwipeLeft: (offset) => vm.semanaSiguiente(
                              context,
                            ),
                            child: _VistaSemana(),
                          ),
                        //si lleva const no cambia los dias
                        if (vm.vistaDia)
                          SwipeDetector(
                            //anterior
                            onSwipeRight: (offset) => vm.diaAnterior(context),
                            //siguiente
                            onSwipeLeft: (offset) => vm.diaSiguiente(context),
                            // ignore: prefer_const_constructors
                            child: _VistaDia(),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
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

class _DrawerCalendar extends StatelessWidget {
  const _DrawerCalendar();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CalendarioViewModel>(context, listen: false);

    final screenSize = MediaQuery.of(context).size;
    return Drawer(
      width: screenSize.width * 0.8,
      backgroundColor: AppTheme.backroundColor,
      child: Column(
        children: [
          const SizedBox(height: 30.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: const Text(
                  "VISTAS",
                  style: AppTheme.normalBoldStyle,
                ),
                trailing: IconButton(
                  onPressed: () => vm.abrirPickerCalendario(context),
                  icon: const Icon(Icons.calendar_month),
                ),
              ),
              const Divider(),
              ListTile(
                title: const Text(
                  "Mes",
                  style: AppTheme.normalBoldStyle,
                ),
                leading: const Icon(Icons.calendar_month),
                onTap: () => vm.mostrarVistaMes(context),
              ),
              const Divider(),
              ListTile(
                title: const Text(
                  "Semana",
                  style: AppTheme.normalBoldStyle,
                ),
                leading: const Icon(Icons.date_range),
                onTap: () => vm.mostrarVistaSemana(context),
              ),
              const Divider(),
              ListTile(
                title: const Text(
                  "Día",
                  style: AppTheme.normalBoldStyle,
                ),
                leading: const Icon(Icons.today),
                onTap: () => vm.mostrarVistaDia(context, 0),
              ),
              const Divider(),
            ],
          ),
        ],
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
                  context,
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
                              dia.value,
                              vm.monthSelectView,
                              vm.yearSelect,
                            )
                            .length,
                        itemBuilder: (BuildContext context, int indexTarea) {
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
                                if (tareasDia.isNotEmpty)
                                  Text(
                                    tareasDia[indexTarea].tarea.toString(),
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
                onTap: () => vm.diaCorrectoMes(
                  context,
                  dia,
                  index,
                  vm.monthSelectView,
                  vm.yearSelect,
                ),
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
                            itemBuilder:
                                (BuildContext context, int indexTarea) {
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
                                      tareasDia[indexTarea].tarea.toString(),
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
                            padding: const EdgeInsets.all(5),
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
  const _VistaDia();

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
          if (vm.daySelect >= vm.today && vm.monthSelectView >= vm.month ||
              vm.monthSelectView > vm.month && vm.yearSelect >= vm.year ||
              vm.yearSelect > vm.year)
            Container(
              padding: const EdgeInsets.all(10),
              height: 45,
              alignment: Alignment.center,
              child: const Text(
                "Nueva",
                style: AppTheme.tareaStyle,
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
                      final List<int> colorTarea = Utilities.hexToRgb(
                        tarea.backColor,
                      );
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

                            vm.navegarDetalleTarea(context, tarea);
                          },
                          child: ListTile(
                            title: Text(
                              tarea.texto.substring(7),
                              style: AppTheme.normalBoldStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Icon(
                              Icons.circle,
                              color: Color.fromRGBO(
                                colorTarea[0],
                                colorTarea[1],
                                colorTarea[2],
                                1,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            if (vm.daySelect >= vm.today && vm.monthSelectView >= vm.month ||
                vm.monthSelectView > vm.month && vm.yearSelect >= vm.year ||
                vm.yearSelect > vm.year)
              Column(
                children: [
                  if (vm.daySelect == vm.today &&
                      horasDia[indexHora].hora24 < vm.fechaHoy.hour)
                    const SizedBox(),
                  if (vm.mostrarIconoHora(vm.daySelect, horasDia[indexHora]) &&
                          vm.daySelect >= vm.today &&
                          vm.monthSelectView >= vm.month ||
                      vm.monthSelectView > vm.month &&
                          vm.yearSelect >= vm.year ||
                      vm.yearSelect > vm.year)
                    IconButton(
                      onPressed: () => vm.navegarCrearTarea(
                        context,
                        horasDia[indexHora],
                        vm.daySelect,
                        vm.monthSelectView,
                        vm.yearSelect,
                      ),
                      icon: const Icon(Icons.add),
                    ),
                ],
              )

            //   if (horasDia[indexHora].hora24 < vm.fechaHoy.hour)
            //     const SizedBox(),
            // if (horasDia[indexHora].hora24 >= vm.fechaHoy.hour)
            // IconButton(
            //   onPressed: () => vm.navegarCrearTarea(
            //     context,
            //     horasDia[indexHora],
            //     vm.daySelect,
            //     vm.monthSelectView,
            //     vm.yearSelect,
            //   ),
            //   icon: const Icon(Icons.add),
            // ),
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
