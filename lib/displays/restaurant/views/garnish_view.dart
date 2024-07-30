import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:provider/provider.dart';

class GarnishView extends StatelessWidget {
  const GarnishView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GarnishViewModel>(context);

    return Scaffold(
      body: ListView.builder(
        itemCount: vm.treeGarnish.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(
                vm.treeGarnish[index].item?.descripcion ?? "No disponible"),
          );
        },
      ),
    );
  }
}
