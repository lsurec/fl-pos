import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthDays extends StatelessWidget {
  final int year;
  final int month;

  const MonthDays({
    super.key,
    required this.year,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Días del Mes'),
      ),
      body: _buildMonthDays(),
    );
  }

  Widget _buildMonthDays() {
    List<Widget> dayWidgets = [];

    // Obtener el primer día del mes
    DateTime firstDayOfMonth = DateTime(year, month, 1);

    // Obtener el número de días en el mes
    int numberOfDaysInMonth = DateTime(year, month + 1, 0).day;

    // Obtener el nombre del día de la semana del primer día del mes
    int firstDayOfWeekIndex = firstDayOfMonth.weekday;

    // Construir widgets para cada día del mes
    for (int i = 0; i < numberOfDaysInMonth; i++) {
      DateTime currentDate = DateTime(year, month, i + 1);
      String dayOfWeek = DateFormat('EEEE').format(currentDate);
      int dayOfWeekIndex = (currentDate.weekday - 1 + 7) %
          7; // Ajuste del índice para que lunes sea 0

      dayWidgets.add(
        ListTile(
          title: Text('Día: ${i + 1}'),
          subtitle: Text('Nombre del día: $dayOfWeek'),
          trailing: Text('Índice en la semana: $dayOfWeekIndex'),
        ),
      );
    }

    return ListView(
      children: dayWidgets,
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: MonthDays(
        year: 2024, month: 4), // Cambia el año y el mes según lo necesites
  ));
}
