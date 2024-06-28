import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/classification_view_model.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/locations_view_model.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/tables_view_model.dart';
import 'package:provider/provider.dart';

class ClassificationView extends StatelessWidget {
  const ClassificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vmLoc = Provider.of<LocationsViewModel>(context);
    final vmTables = Provider.of<TablesViewModel>(context);
    final vm = Provider.of<ClassificationViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.description_outlined,
            ),
            padding: const EdgeInsets.only(right: 20),
            onPressed: () {},
          ),
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 1,
                child: Text("Trasladar Mesa"),
              ),
            ],
            // color: AppTheme.backroundColor,
            elevation: 2,
            // on selected we show the dialog box
            onSelected: (value) => {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const Text(
                          "Ubicaciones/",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black38,
                          ),
                        ),
                        Text(
                          "${vmLoc.location!.descripcion}/",
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black38,
                          ),
                        ),
                        Text(
                          vmTables.table!.descripcion,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    vmTables.table!.descripcion,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: vm.classifications.length,
                itemBuilder: (BuildContext context, int index) {
                  // return _RowMenu(
                  //   mesa: mesa,
                  //   ubicacion: ubicacion,
                  //   options: _menuVM.menu[index],
                  //   mesero: mesero,
                  // );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
