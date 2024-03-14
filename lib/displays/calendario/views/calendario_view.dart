import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/calendario/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/widgets/load_widget.dart';
import 'package:provider/provider.dart';

class CalendarioView extends StatelessWidget {
  const CalendarioView({super.key});

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
                    children: [
                      const SizedBox(height: 10),
                      Center(
                        child: _Dias(),
                      )
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
    final vm = Provider.of<CalendarioViewModel>(context, listen: false);

    final List<int> dias = vm.obtenerDiasDelMes(2024, 3);

    // Dividir los días en sublistas de 7 días cada una
    List<List<int>> diasDivididos = [];
    for (int i = 0; i < dias.length; i += 7) {
      diasDivididos
          .add(dias.sublist(i, i + 7 > dias.length ? dias.length : i + 7));
    }

    return Table(
      border: TableBorder.all(),
      children: List.generate(
        diasDivididos.length,
        (index) => TableRow(
          children: List.generate(
            diasDivididos[index].length,
            (index2) => TableCell(
              child: Container(
                height: 50,
                width: 50,
                alignment: Alignment.center,
                child: Text(
                  '${diasDivididos[index][index2]}',
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


// class _Dias extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final vm = Provider.of<CalendarioViewModel>(context, listen: false);

//     final List<int> dias = vm.obtenerDiasDelMes(2024, 3);

//     return Table(
//       border: TableBorder.all(),
//       children: List.generate(
//         1,
//         (index) => TableRow(
//           children: List.generate(
//             7,
//             (index2) => TableCell(
//               child: ListView.builder(
//                 physics: const NeverScrollableScrollPhysics(),
//                 scrollDirection: Axis.vertical,
//                 shrinkWrap: true,
//                 itemCount: dias.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   final int dia = dias[index];
//                   return Container(
//                     height: 50,
//                     width: 50,
//                     alignment: Alignment.topCenter,
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               // '${index * 7 + index2 + 1}',
//                               '$dia',

//                               style: AppTheme.normalBoldStyle,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
