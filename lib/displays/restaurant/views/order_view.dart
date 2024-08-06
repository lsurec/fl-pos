import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/order_view_model.dart';
import 'package:provider/provider.dart';

class OrderView extends StatelessWidget {
  const OrderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<OrderViewModel>(context, listen: false);

    return Scaffold(
      body: ListView.separated(
        itemCount: vm.orders[0].transacciones.length,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 10,
                    width: 10,
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
