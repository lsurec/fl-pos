import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/widgets/card_widget.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class AddPersonView extends StatelessWidget {
  const AddPersonView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TraRestaurantModel transaction =
        ModalRoute.of(context)!.settings.arguments as TraRestaurantModel;

    final TablesViewModel tablesVM = Provider.of<TablesViewModel>(context);

    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Seleccionar cuenta",
                  style: AppTheme.style(context, Styles.title),
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: tablesVM.table!.orders!.length + 1,
                  itemBuilder: (context, index) {
                    if (index < tablesVM.table!.orders!.length) {
                      return _AccountCard(
                        index: tablesVM.table!.orders![index],
                        transaction: transaction,
                      );
                    } else {
                      return _NewAccountCard();
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

class _NewAccountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CardWidget(
      color: AppTheme.color(
        context,
        Styles.secondBackground,
      ),
      elevation: 2,
      raidus: 10,
      child: InkWell(
        onTap: () {},
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                size: 40.0,
                color: AppTheme.primary,
              ),
              SizedBox(height: 16.0),
              Text(
                "Nueva cuenta",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({
    super.key,
    required this.index,
    required this.transaction,
  });

  final int index;
  final TraRestaurantModel transaction;

  @override
  Widget build(BuildContext context) {
    final OrderViewModel orderVM = Provider.of<OrderViewModel>(context);
    final AddPersonViewModel vmAddPerson =
        Provider.of<AddPersonViewModel>(context);

    return CardWidget(
      color: AppTheme.color(
        context,
        Styles.secondBackground,
      ),
      elevation: 2,
      raidus: 10,
      child: InkWell(
        onTap: () => orderVM.addTransactionToOrder(context, transaction, index),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: CircleAvatar(
                      backgroundColor: AppTheme.primary,
                      radius: 30.0,
                      child: Icon(
                        Icons.person,
                        size: 30.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    orderVM.orders[index].nombre,
                    style: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8.0,
              right: 8.0,
              child: IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.grey,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: AppTheme.backroundColor,
                        title: const Text('Renombrar cuenta'), //TODO:Translate
                        content: InputWidget(
                          maxLines: 1,
                          formProperty: "name",
                          formValues: vmAddPerson.formValues,
                          hintText: "Nombre", //TODO:Translate
                          labelText: "Nombre", //TODO:Translate
                          initialValue: orderVM.orders[index].nombre,
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancelar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          ElevatedButton(
                            child: const Text('Renombrar'),
                            onPressed: () {
                              // Aquí puedes manejar el valor ingresado

                              vmAddPerson.renamePerson(context, index);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
