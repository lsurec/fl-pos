import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class TablesView extends StatelessWidget {
  const TablesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TablesViewModel>(context);
    final vmLoc = Provider.of<LocationsViewModel>(context);

    return Padding(
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
                        vmLoc.location!.descripcion,
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
                  vmLoc.location!.descripcion,
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
              itemCount: vm.tables.length,
              itemBuilder: (BuildContext context, int index) {
                TableModel mesa = vm.tables[index];
                return _CardLocations(
                  mesa: mesa,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CardLocations extends StatelessWidget {
  const _CardLocations({
    Key? key,
    required this.mesa,
  }) : super(key: key);

  final TableModel mesa;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TablesViewModel>(context);

    return CardWidget(
      borderColor: const Color(0xffc2cfd9),
      elevation: 0,
      width: double.infinity,
      raidus: 0,
      child: Row(
        children: [
          const SizedBox(
            width: 150,
            child: FadeInImage(
              placeholder: AssetImage('assets/load.gif'),
              image: NetworkImage(
                "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/640px-Image_not_available.png",
              ),
              height: 150,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mesa.descripcion,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.justify,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Cuentas: ${mesa.orders}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.justify,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      color: AppTheme.backroundColor,
      borderWidth: 2,
    );
  }
}
