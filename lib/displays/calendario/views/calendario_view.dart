// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/calendario/models/models.dart';
import 'package:flutter_post_printer_example/displays/calendario/view_models/view_models.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:provider/provider.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';

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
    final vmMenu = Provider.of<MenuViewModel>(context);

    return Stack(
      children: [
        DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                vmMenu.name,
                style: StyleApp.title,
              ),
              actions: <Widget>[
                Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.calendario,
                    'hoy',
                  ),
                  style: StyleApp.normalBold,
                ),
                IconButton(
                  onPressed: () => vm.loadData(context),
                  icon: const Icon(Icons.today),
                  tooltip: AppLocalizations.of(context)!.translate(
                    BlockTranslate.botones,
                    'nueva',
                  ),
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
                    // padding: const EdgeInsets.all(20),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        if (vm.vistaDia)
                          ListTile(
                            leading: IconButton(
                              onPressed: () => vm.diaAnterior(context),
                              icon: const Icon(
                                Icons.arrow_left,
                              ),
                              tooltip: AppLocalizations.of(context)!.translate(
                                BlockTranslate.calendario,
                                'anterior',
                              ),
                            ),
                            title: GestureDetector(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${vm.daySelect} ${Utilities.nombreMes(
                                      context,
                                      vm.monthSelectView,
                                    )} ${vm.yearSelect}",
                                    style: StyleApp.normalBold,
                                  ),
                                  const SizedBox(width: 5),
                                  const Icon(
                                    Icons.arrow_drop_down,
                                  ),
                                ],
                              ),
                              onTap: () => vm.abrirPickerCalendario(
                                context,
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () => vm.diaSiguiente(context),
                              icon: const Icon(
                                Icons.arrow_right,
                              ),
                              tooltip: AppLocalizations.of(context)!.translate(
                                BlockTranslate.calendario,
                                'siguiente',
                              ),
                            ),
                          ),
                        if (vm.vistaMes)
                          ListTile(
                            leading: IconButton(
                              onPressed: () => vm.mesAnterior(context),
                              icon: const Icon(
                                Icons.arrow_left,
                              ),
                              tooltip: AppLocalizations.of(context)!.translate(
                                BlockTranslate.calendario,
                                'anterior',
                              ),
                            ),
                            title: GestureDetector(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${Utilities.nombreMes(
                                      context,
                                      vm.monthSelectView,
                                    )} ${vm.yearSelect}",
                                    style: StyleApp.normalBold,
                                  ),
                                  const SizedBox(width: 5),
                                  const Icon(
                                    Icons.arrow_drop_down,
                                  ),
                                ],
                              ),
                              onTap: () => vm.abrirPickerCalendario(
                                context,
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () => vm.mesSiguiente(context),
                              icon: const Icon(
                                Icons.arrow_right,
                              ),
                              tooltip: AppLocalizations.of(context)!.translate(
                                BlockTranslate.calendario,
                                'siguiente',
                              ),
                            ),
                          ),
                        if (vm.vistaSemana)
                          ListTile(
                            leading: IconButton(
                              onPressed: () => vm.semanaAnterior(context),
                              icon: const Icon(
                                Icons.arrow_left,
                              ),
                              tooltip: AppLocalizations.of(context)!.translate(
                                BlockTranslate.calendario,
                                'anterior',
                              ),
                            ),
                            title: GestureDetector(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    vm.generateNameWeeck(context),
                                    style: StyleApp.normalBold,
                                  ),
                                  const SizedBox(width: 5),
                                  const Icon(
                                    Icons.arrow_drop_down,
                                  ),
                                ],
                              ),
                              onTap: () => vm.abrirPickerCalendario(
                                context,
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () => vm.semanaSiguiente(context),
                              icon: const Icon(
                                Icons.arrow_right,
                              ),
                              tooltip: AppLocalizations.of(context)!.translate(
                                BlockTranslate.calendario,
                                'siguiente',
                              ),
                            ),
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

class _DrawerCalendar extends StatelessWidget {
  const _DrawerCalendar();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CalendarioViewModel>(context, listen: false);

    final screenSize = MediaQuery.of(context).size;
    return Drawer(
      width: screenSize.width * 0.8,
      backgroundColor: AppTheme.color(
        context,
        Styles.black,
      ),
      child: Column(
        children: [
          const SizedBox(height: 30.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: IconButton(
                  onPressed: () => vm.back(context),
                  icon: const Icon(Icons.arrow_back),
                ),
                title: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.calendario,
                    'vistas',
                  ),
                  style: StyleApp.normalBold,
                ),
                trailing: IconButton(
                  onPressed: () => vm.abrirPickerCalendario(context),
                  icon: const Icon(Icons.calendar_month),
                ),
              ),
              Divider(
                color: AppTheme.color(
                  context,
                  Styles.divider,
                ),
              ),
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.calendario,
                    'mes',
                  ),
                  style: StyleApp.normalBold,
                ),
                leading: const Icon(Icons.calendar_month),
                onTap: () => vm.mostrarVistaMes(context),
              ),
              Divider(
                color: AppTheme.color(
                  context,
                  Styles.divider,
                ),
              ),
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.calendario,
                    'semana',
                  ),
                  style: StyleApp.normalBold,
                ),
                leading: const Icon(Icons.date_range),
                onTap: () => vm.mostrarVistaSemana(context),
              ),
              Divider(
                color: AppTheme.color(
                  context,
                  Styles.divider,
                ),
              ),
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.calendario,
                    'dia',
                  ),
                  style: StyleApp.normalBold,
                ),
                leading: const Icon(Icons.today),
                onTap: () => vm.mostrarVistaDia(context, 0),
              ),
              Divider(
                color: AppTheme.color(
                  context,
                  Styles.divider,
                ),
              ),
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
    final vmLang = Provider.of<LangViewModel>(context, listen: false);

    List<String> diasSemana = vm.loadDiasView(
      vmLang.languages[Preferences.idLanguage],
    );

    return Table(
      border: TableBorder(
        top: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
          ),
        ), // Borde arriba
        left: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
          ),
        ), // Borde izquierdo
        right: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
          ),
        ), // Borde derecho
        bottom: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
          ),
        ), // Sin borde abajo
        horizontalInside: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
          ),
        ), // Borde horizontal dentro de la tabla
        verticalInside: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
          ),
        ), // Borde vertical dentro de la tabla
      ),
      children: List.generate(
        1,
        (index) => TableRow(
          children: diasSemana.map((dia) {
            return TableCell(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                alignment: Alignment.center,
                child: Text(
                  // Para obtener solo las tres primeras letras del día
                  dia.substring(0, 3),
                  style: StyleApp.normal,
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
      border: TableBorder(
        top: BorderSide.none, // Borde arriba
        left: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
          ),
        ), // Borde izquierdo
        right: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
          ),
        ), // Borde derecho
        bottom: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
          ),
        ), // Sin borde abajo
        horizontalInside: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
          ),
        ), // Borde horizontal dentro de la tabla
        verticalInside: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
          ),
        ), // Borde vertical dentro de la tabla
      ),
      children: List.generate(
        1,
        (index) => TableRow(
          children: semanas[vm.indexWeekActive].map((dia) {
            final color = dia.value == vm.today &&
                    vm.resolveMonth(dia.indexWeek) == vm.month &&
                    vm.resolveYear(dia.indexWeek) == vm.year
                ? AppTheme.color(
                    context,
                    Styles.primary,
                  )
                : null;

            final style = dia.value == vm.today &&
                    vm.resolveMonth(dia.indexWeek) == vm.month &&
                    vm.resolveYear(dia.indexWeek) == vm.year
                ? StyleApp.diaHoy
                : StyleApp.diasFueraMes;
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
                    _CirculoDia(
                      dia: dia.value,
                      color: color,
                      style: style,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: vm
                          .tareaDia(
                            dia.value,
                            vm.resolveMonth(dia.indexWeek),
                            vm.resolveYear(index),
                          )
                          .length,
                      itemBuilder: (BuildContext context, int indexTarea) {
                        final List<TareaCalendarioModel> tareasDia =
                            vm.tareaDia(
                          dia.value,
                          vm.resolveMonth(dia.indexWeek),
                          vm.resolveYear(index),
                        );
                        return Column(
                          children: [
                            if (tareasDia.isNotEmpty)
                              Text(
                                tareasDia[indexTarea].tarea.toString(),
                                style: StyleApp.task,
                              ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 5),
                            ),
                            // const Divider(),
                          ],
                        );
                      },
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

    vm.semanasDelMes = vm.agregarSemanas(vm.monthSelectView, vm.yearSelect);
    List<List<DiaModel>> semanas = vm.semanasDelMes;

    return Table(
      border: TableBorder(
        bottom: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
          ),
        ),
        // Mantenemos los bordes interiores y eliminamos el superior
        horizontalInside: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
          ),
        ),
        verticalInside: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
          ),
        ),
        top: BorderSide.none, // Eliminamos el borde superior
      ),
      children: List.generate(
        semanasNum,
        (rowIndex) => TableRow(
          children: List.generate(
            7,
            (columnIndex) {
              final index = rowIndex * 7 + columnIndex;
              DiaModel dia = diasMesSeleccionado[index];
              final backgroundColor = vm.nuevaIsToday(dia.value, index)
                  ? AppTheme.color(
                      context,
                      Styles.primary,
                    )
                  : null;
              final hoyColor = vm.nuevaIsToday(dia.value, index)
                  ? StyleApp.diaHoy
                  : vm.diasOtroMes(dia, index, diasMesSeleccionado)
                      ? StyleApp.diasFueraMes
                      : StyleApp.subTitle;
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
                    _CirculoDia(
                      dia: dia.value,
                      color: backgroundColor,
                      style: hoyColor,
                    ),
                    // if para slo mostrar las tareas de los dias del mes
                    Column(
                      children: [
//primera semana
                        if (index >= 0 &&
                            index < 7 &&
                            dia.value > semanas[0][6].value)
                          Column(
                            children: [
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: vm
                                            .tareaDia(
                                              dia.value,
                                              vm.monthSelectView == 1
                                                  ? 12
                                                  : vm.monthSelectView - 1,
                                              vm.monthSelectView == 1
                                                  ? vm.yearSelect - 1
                                                  : vm.yearSelect,
                                            )
                                            .length >=
                                        5
                                    ? 4
                                    : vm
                                        .tareaDia(
                                          dia.value,
                                          vm.monthSelectView == 1
                                              ? 12
                                              : vm.monthSelectView - 1,
                                          vm.monthSelectView == 1
                                              ? vm.yearSelect - 1
                                              : vm.yearSelect,
                                        )
                                        .length,
                                itemBuilder:
                                    (BuildContext context, int indexTarea) {
                                  final List<TareaCalendarioModel> tareasDia =
                                      vm.tareaDia(
                                    dia.value,
                                    vm.monthSelectView == 1
                                        ? 12
                                        : vm.monthSelectView - 1,
                                    vm.monthSelectView == 1
                                        ? vm.yearSelect - 1
                                        : vm.yearSelect,
                                  );
                                  return Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(bottom: 2),
                                    child: Column(
                                      children: [
                                        Text(
                                          tareasDia[indexTarea]
                                              .tarea
                                              .toString(),
                                          style: StyleApp.task,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              if (vm
                                      .tareaDia(
                                        dia.value,
                                        vm.monthSelectView == 1
                                            ? 12
                                            : vm.monthSelectView - 1,
                                        vm.monthSelectView == 1
                                            ? vm.yearSelect - 1
                                            : vm.yearSelect,
                                      )
                                      .length >
                                  4)
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "(+ ${vm.tareaDia(
                                          dia.value,
                                          vm.monthSelectView == 1
                                              ? 12
                                              : vm.monthSelectView - 1,
                                          vm.monthSelectView == 1
                                              ? vm.yearSelect - 1
                                              : vm.yearSelect,
                                        ).length - 4})",
                                    textAlign: TextAlign.end,
                                    style: StyleApp.verMas,
                                  ),
                                )
                            ],
                          ),
//Mostrar tareas solo en los dias que pertenecen al mes (1 al 31 dependiendo del mes)
                        if (vm.monthCurrent(dia.value, index))
                          Column(
                            children: [
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
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
                                          tareasDia[indexTarea]
                                              .tarea
                                              .toString(),
                                          style: StyleApp.task,
                                        ),
                                      ],
                                    ),
                                  );
                                },
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
                                    "(+ ${vm.tareaDia(dia.value, vm.monthSelectView, vm.yearSelect).length - 4})",
                                    textAlign: TextAlign.end,
                                    style: StyleApp.verMas,
                                  ),
                                ),
                            ],
                          ),
//Mostrar las tareas de la ultima semana
                        if (index >= diasMesSeleccionado.length - 6 &&
                            index < diasMesSeleccionado.length &&
                            dia.value < semanas[semanas.length - 1][0].value)
                          Column(
                            children: [
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: vm
                                            .tareaDia(
                                              dia.value,
                                              vm.monthSelectView == 12
                                                  ? 1
                                                  : vm.monthSelectView + 1,
                                              vm.monthSelectView == 12
                                                  ? vm.yearSelect + 1
                                                  : vm.yearSelect,
                                            )
                                            .length >=
                                        5
                                    ? 4
                                    : vm
                                        .tareaDia(
                                          dia.value,
                                          vm.monthSelectView == 12
                                              ? 1
                                              : vm.monthSelectView + 1,
                                          vm.monthSelectView == 12
                                              ? vm.yearSelect + 1
                                              : vm.yearSelect,
                                        )
                                        .length,
                                itemBuilder:
                                    (BuildContext context, int indexTarea) {
                                  final List<TareaCalendarioModel> tareasDia =
                                      vm.tareaDia(
                                    dia.value,
                                    vm.monthSelectView == 12
                                        ? 1
                                        : vm.monthSelectView + 1,
                                    vm.monthSelectView == 12
                                        ? vm.yearSelect + 1
                                        : vm.yearSelect,
                                  );
                                  return Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(bottom: 2),
                                    child: Column(
                                      children: [
                                        Text(
                                          tareasDia[indexTarea]
                                              .tarea
                                              .toString(),
                                          style: StyleApp.task,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              if (vm
                                      .tareaDia(
                                        dia.value,
                                        vm.monthSelectView == 12
                                            ? 1
                                            : vm.monthSelectView + 1,
                                        vm.monthSelectView == 12
                                            ? vm.yearSelect + 1
                                            : vm.yearSelect,
                                      )
                                      .length >
                                  4)
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "(+ ${vm.tareaDia(
                                          dia.value,
                                          vm.monthSelectView == 12
                                              ? 1
                                              : vm.monthSelectView + 1,
                                          vm.monthSelectView == 12
                                              ? vm.yearSelect + 1
                                              : vm.yearSelect,
                                        ).length - 4})",
                                    textAlign: TextAlign.end,
                                    style: StyleApp.verMas,
                                  ),
                                ),
                            ],
                          ),
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
            child: Text(
              AppLocalizations.of(context)!.translate(
                BlockTranslate.calendario,
                'horario',
              ),
              style: StyleApp.normalBold,
            ),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.top,
            child: Container(
              transformAlignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              width: 32,
              child: Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.calendario,
                  'tareas',
                ),
                style: StyleApp.normalBold,
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
              transformAlignment: Alignment.center,
              child: Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.calendario,
                  'nueva',
                ),
                style: StyleApp.task,
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
              child: Center(
                child: Text(
                  horasDia[indexHora].hora12,
                  style: StyleApp.horaBold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
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
                        borderColor: AppTheme.color(
                          context,
                          Styles.greyBorder,
                        ),
                        raidus: 10,
                        child: GestureDetector(
                          onTap: () => vm.navegarDetalleTarea(
                            context,
                            tarea,
                          ),
                          child: ListTile(
                            title: Text(
                              tarea.texto.substring(7),
                              style: StyleApp.normalBold,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: EstadoColor(
                              colorTarea: colorTarea,
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
                      icon: const Icon(
                        Icons.add,
                        size: 20,
                      ),
                    ),
                ],
              )
          ],
        ),
      );
    }

    return Table(
      border: TableBorder(
        top: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
          ),
        ), // Borde arriba
        left: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
          ),
        ), // Borde izquierdo
        right: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
          ),
        ), // Borde derecho
        bottom: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
          ),
        ), // Bo, // Sin borde abajo
        horizontalInside: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
          ),
        ), // Borde horizontal dentro de la tabla
        verticalInside: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
          ),
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

class _CirculoDia extends StatelessWidget {
  const _CirculoDia({
    required this.dia,
    required this.color,
    required this.style,
  });

  final int dia;
  final Color? color;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 10),
      width: 25.0, // Anchura del círculo
      height: 25.0, // Altura del círculo
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.color(
            context,
            Styles.grey,
          ),
          width: 0.5,
        ),
        shape: BoxShape.circle, // Forma del contenedor
        color: color == color ? color : null,
      ),
      child: Center(
        child: Text(
          dia.toString(),
          style: style,
        ),
      ),
    );
  }
}

class EstadoColor extends StatelessWidget {
  const EstadoColor({
    super.key,
    required this.colorTarea,
  });

  final List<int> colorTarea;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24.0,
      height: 24.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromRGBO(
          colorTarea[0],
          colorTarea[1],
          colorTarea[2],
          1,
        ),
        border: Border.all(
          color: AppTheme.color(
            context,
            Styles.grey,
          ),
          width: 1.0,
        ),
      ),
    );
  }
}
