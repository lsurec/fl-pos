// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/calendario/models/models.dart';
import 'package:flutter_post_printer_example/displays/calendario/view_models/view_models.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
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
                style: AppTheme.style(
                  context,
                  Styles.title,
                  Preferences.idTheme,
                ),
              ),
              actions: <Widget>[
                Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.calendario,
                    'hoy',
                  ),
                  style: AppTheme.style(
                    context,
                    Styles.bold,
                    Preferences.idTheme,
                  ),
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
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        if (vm.vistaDia)
                          ListTile(
                            leading: IconButton(
                              onPressed: () => vm.diaAnterior(context),
                              icon: const Icon(
                                Icons.arrow_back,
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
                                    style: AppTheme.style(
                                      context,
                                      Styles.bold,
                                      Preferences.idTheme,
                                    ),
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
                                Icons.arrow_forward,
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
                                Icons.arrow_back,
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
                                    style: AppTheme.style(
                                      context,
                                      Styles.bold,
                                      Preferences.idTheme,
                                    ),
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
                                Icons.arrow_forward,
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
                                Icons.arrow_back,
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
                                    style: AppTheme.style(
                                      context,
                                      Styles.bold,
                                      Preferences.idTheme,
                                    ),
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
                                Icons.arrow_forward,
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
              Preferences.idTheme,
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
        Preferences.idTheme,
      ),
      child: Column(
        children: [
          const SizedBox(height: 30.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.calendario,
                    'vistas',
                  ),
                  style: AppTheme.style(
                    context,
                    Styles.bold,
                    Preferences.idTheme,
                  ),
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
                  Preferences.idTheme,
                ),
              ),
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.calendario,
                    'mes',
                  ),
                  style: AppTheme.style(
                    context,
                    Styles.bold,
                    Preferences.idTheme,
                  ),
                ),
                leading: const Icon(Icons.calendar_month),
                onTap: () => vm.mostrarVistaMes(context),
              ),
              Divider(
                color: AppTheme.color(
                  context,
                  Styles.divider,
                  Preferences.idTheme,
                ),
              ),
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.calendario,
                    'semana',
                  ),
                  style: AppTheme.style(
                    context,
                    Styles.bold,
                    Preferences.idTheme,
                  ),
                ),
                leading: const Icon(Icons.date_range),
                onTap: () => vm.mostrarVistaSemana(context),
              ),
              Divider(
                color: AppTheme.color(
                  context,
                  Styles.divider,
                  Preferences.idTheme,
                ),
              ),
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.calendario,
                    'dia',
                  ),
                  style: AppTheme.style(
                    context,
                    Styles.bold,
                    Preferences.idTheme,
                  ),
                ),
                leading: const Icon(Icons.today),
                onTap: () => vm.mostrarVistaDia(context, 0),
              ),
              Divider(
                color: AppTheme.color(
                  context,
                  Styles.divider,
                  Preferences.idTheme,
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
            Preferences.idTheme,
          ),
        ), // Borde arriba
        left: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
            Preferences.idTheme,
          ),
        ), // Borde izquierdo
        right: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
            Preferences.idTheme,
          ),
        ), // Borde derecho
        bottom: BorderSide.none, // Sin borde abajo
        horizontalInside: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
            Preferences.idTheme,
          ),
        ), // Borde horizontal dentro de la tabla
        verticalInside: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
            Preferences.idTheme,
          ),
        ), // Borde vertical dentro de la tabla
      ),
      children: List.generate(
        1,
        (index) => TableRow(
          children: diasSemana.map((dia) {
            return TableCell(
              child: Container(
                height: 25,
                width: 50,
                alignment: Alignment.topCenter,
                child: Text(
                  // Para obtener solo las tres primeras letras del día
                  dia.substring(0, 3),
                  style: AppTheme.style(
                    context,
                    Styles.bold,
                    Preferences.idTheme,
                  ),
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
        top: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
            Preferences.idTheme,
          ),
        ), // Borde arriba
        left: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
            Preferences.idTheme,
          ),
        ), // Borde izquierdo
        right: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
            Preferences.idTheme,
          ),
        ), // Borde derecho
        bottom: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
            Preferences.idTheme,
          ),
        ), // Sin borde abajo
        horizontalInside: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
            Preferences.idTheme,
          ),
        ), // Borde horizontal dentro de la tabla
        verticalInside: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
            Preferences.idTheme,
          ),
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
                        //si el dia no está correcto corregirlo eliminando resolveMonth por monthselectview
                        color: dia.value == vm.today &&
                                vm.resolveMonth(dia.indexWeek) == vm.month &&
                                vm.resolveYear(dia.indexWeek) == vm.year
                            ? AppTheme.color(
                                context,
                                Styles.primary,
                                Preferences.idTheme,
                              )
                            : null,
                        border: Border(
                          bottom: BorderSide(
                            color: AppTheme.color(
                              context,
                              Styles.greyBorder,
                              Preferences.idTheme,
                            ),
                          ),
                        ), // Agregar borde inferior
                      ),
                      child: Center(
                        child: Text(
                          "${dia.value}",
                          style: dia.value == vm.today &&
                                  vm.resolveMonth(dia.indexWeek) == vm.month &&
                                  vm.resolveYear(dia.indexWeek) == vm.year
                              ? AppTheme.style(
                                  context,
                                  Styles.whiteBoldStyle,
                                  Preferences.idTheme,
                                )
                              : AppTheme.style(
                                  context,
                                  Styles.bold,
                                  Preferences.idTheme,
                                ),
                        ),
                      ),
                    ),
                    Container(
                      height: 850,
                      padding: const EdgeInsets.all(5),
                      child: ListView.builder(
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
                          return Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(bottom: 2),
                            child: Column(
                              children: [
                                if (tareasDia.isNotEmpty)
                                  Text(
                                    tareasDia[indexTarea].tarea.toString(),
                                    style: AppTheme.style(
                                      context,
                                      Styles.taskStyle,
                                      Preferences.idTheme,
                                    ),
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

    vm.semanasDelMes = vm.agregarSemanas(vm.monthSelectView, vm.yearSelect);
    List<List<DiaModel>> semanas = vm.semanasDelMes;

    return Table(
      border: TableBorder.all(
        color: AppTheme.color(
          context,
          Styles.greyBorder,
          Preferences.idTheme,
        ),
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
                      Preferences.idTheme,
                    )
                  : null;
              final hoyColor = vm.nuevaIsToday(dia.value, index)
                  ? AppTheme.style(
                      context,
                      Styles.whiteBoldStyle,
                      Preferences.idTheme,
                    )
                  : vm.diasOtroMes(dia, index, diasMesSeleccionado)
                      ? AppTheme.style(
                          context,
                          Styles.diasOtroMes,
                          Preferences.idTheme,
                        )
                      : AppTheme.style(
                          context,
                          Styles.bold,
                          Preferences.idTheme,
                        );
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
                        border: Border(
                          bottom: BorderSide(
                            color: AppTheme.color(
                              context,
                              Styles.greyBorder,
                              Preferences.idTheme,
                            ),
                          ),
                        ), // Agregar borde inferior
                      ),
                      child: Center(
                        child: Text(
                          "${dia.value}",
                          style: hoyColor,
                        ),
                      ),
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
                              Container(
                                height: 135,
                                alignment: Alignment.topCenter,
                                color: AppTheme.color(
                                  context,
                                  Styles.transparent,
                                  Preferences.idTheme,
                                ),
                                child: ListView.builder(
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
                                            style: AppTheme.style(
                                              context,
                                              Styles.taskStyle,
                                              Preferences.idTheme,
                                            ),
                                          ),
                                          Divider(
                                            height: 5,
                                            color: AppTheme.color(
                                              context,
                                              Styles.greyBorder,
                                              Preferences.idTheme,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
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
                                    style: AppTheme.style(
                                      context,
                                      Styles.verMas,
                                      Preferences.idTheme,
                                    ),
                                  ),
                                )
                            ],
                          ),
//Mostrar tareas solo en los dias que pertenecen al mes (1 al 31 dependiendo del mes)
                        if (vm.monthCurrent(dia.value, index))
                          Column(
                            children: [
                              Container(
                                alignment: Alignment.topCenter,
                                height: 135,
                                color: AppTheme.color(
                                  context,
                                  Styles.transparent,
                                  Preferences.idTheme,
                                ),
                                child: ListView.builder(
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
                                            style: AppTheme.style(
                                              context,
                                              Styles.taskStyle,
                                              Preferences.idTheme,
                                            ),
                                          ),
                                          Divider(
                                            height: 5,
                                            color: AppTheme.color(
                                              context,
                                              Styles.greyBorder,
                                              Preferences.idTheme,
                                            ),
                                          ),
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
                                    "(+ ${vm.tareaDia(dia.value, vm.monthSelectView, vm.yearSelect).length - 4})",
                                    textAlign: TextAlign.end,
                                    style: AppTheme.style(
                                      context,
                                      Styles.verMas,
                                      Preferences.idTheme,
                                    ),
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
                              Container(
                                height: 135,
                                alignment: Alignment.topCenter,
                                color: AppTheme.color(
                                  context,
                                  Styles.transparent,
                                  Preferences.idTheme,
                                ),
                                child: ListView.builder(
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
                                            style: AppTheme.style(
                                              context,
                                              Styles.taskStyle,
                                              Preferences.idTheme,
                                            ),
                                          ),
                                          Divider(
                                            height: 5,
                                            color: AppTheme.color(
                                              context,
                                              Styles.greyBorder,
                                              Preferences.idTheme,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
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
                                    style: AppTheme.style(
                                      context,
                                      Styles.verMas,
                                      Preferences.idTheme,
                                    ),
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
              style: AppTheme.style(
                context,
                Styles.bold,
                Preferences.idTheme,
              ),
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
                style: AppTheme.style(
                  context,
                  Styles.bold,
                  Preferences.idTheme,
                ),
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
                style: AppTheme.style(
                  context,
                  Styles.taskStyle,
                  Preferences.idTheme,
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
              child: Center(
                child: Text(
                  horasDia[indexHora].hora12,
                  style: AppTheme.style(
                    context,
                    Styles.hora,
                    Preferences.idTheme,
                  ),
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
                          Preferences.idTheme,
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
                              style: AppTheme.style(
                                context,
                                Styles.bold,
                                Preferences.idTheme,
                              ),
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
            Preferences.idTheme,
          ),
        ), // Borde arriba
        left: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
            Preferences.idTheme,
          ),
        ), // Borde izquierdo
        right: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
            Preferences.idTheme,
          ),
        ), // Borde derecho
        bottom: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
            Preferences.idTheme,
          ),
        ), // Bo, // Sin borde abajo
        horizontalInside: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
            Preferences.idTheme,
          ),
        ), // Borde horizontal dentro de la tabla
        verticalInside: BorderSide(
          color: AppTheme.color(
            context,
            Styles.greyBorder,
            Preferences.idTheme,
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
