import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/select_account_view_model.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SelectAccountView extends StatelessWidget {
  const SelectAccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    //1 agreagr transaccion, 2 detalles, 3 traslados
    final int screen = data["screen"];

    TraRestaurantModel? transaction;

    if (screen == 1) {
      transaction = data["transaction"];
    }

    final SelectAccountViewModel vm = Provider.of<SelectAccountViewModel>(
      context,
    );

    final TablesViewModel tablesVM = Provider.of<TablesViewModel>(context);

    return WillPopScope(
      onWillPop: () => vm.backPage(context),
      child: Scaffold(
          appBar: AppBar(
            title: vm.isSelectedMode
                ? Text(
                    vm.getSelectedItems(context).toString(),
                    style: AppTheme.style(context, Styles.normal),
                  )
                : null,
            actions: vm.isSelectedMode
                ? [
                    IconButton(
                      onPressed: () => vm.selectedAll(context),
                      icon: const Icon(Icons.select_all),
                      tooltip: "Seleccionar todo", //TODO:Translate
                    ),
                    IconButton(
                      onPressed: () => vm.deleteItems(context),
                      icon: const Icon(Icons.delete_outline),
                      tooltip: "Eliminar", //TODO:Translate
                    ),
                    IconButton(
                      onPressed: () => vm.navigatePermisionView(context),
                      icon: const Icon(Icons.drive_file_move_outline),
                      tooltip: "Trasladar", //TODO:Translate
                    ),
                  ]
                : null,
          ),
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: tablesVM.table!.orders!.length + 1,
                    itemBuilder: (context, index) {
                      if (index < tablesVM.table!.orders!.length) {
                        return _AccountCard(
                          screen: screen,
                          index: tablesVM.table!.orders![index],
                          transaction: transaction,
                        );
                      } else {
                        return const _NewAccountCard();
                      }
                    },
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({
    required this.index,
    this.transaction,
    required this.screen,
  });

  //1 agreagr transaccion, 2 detalles, 3 traslados
  final int screen;

  final int index;
  final TraRestaurantModel? transaction;

  @override
  Widget build(BuildContext context) {
    final OrderViewModel orderVM = Provider.of<OrderViewModel>(context);
    final AddPersonViewModel vmAddPerson =
        Provider.of<AddPersonViewModel>(context);
    final HomeViewModel homeVM = Provider.of<HomeViewModel>(context);

    // Crear una instancia de NumberFormat para el formato de moneda
    final currencyFormat = NumberFormat.currency(
      symbol: homeVM
          .moneda, // Símbolo de la moneda (puedes cambiarlo según tu necesidad)
      decimalDigits: 2, // Número de decimales a mostrar
    );

    final SelectAccountViewModel vm =
        Provider.of<SelectAccountViewModel>(context);

    return CardWidget(
      color: AppTheme.color(
        context,
        Styles.secondBackground,
      ),
      elevation: 2,
      raidus: 10,
      child: InkWell(
        onLongPress: screen == 3 ? null : () => vm.onLongPress(context, index),
        onTap: vm.isSelectedMode
            ? () => vm.selectedItem(context, index)
            : () => vm.tapCard(context, screen, index, transaction),
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
                  const SizedBox(height: 10.0),
                  Text(
                    "Total: ${currencyFormat.format(orderVM.getTotal(index))}",
                    style: AppTheme.style(
                      context,
                      Styles.versionStyle,
                    ),
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
            if (vm.isSelectedMode && orderVM.orders[index].selected)
              const Positioned(
                left: 10,
                bottom: 10,
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NewAccountCard extends StatelessWidget {
  const _NewAccountCard();

  @override
  Widget build(BuildContext context) {
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
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: AppTheme.backroundColor,
                title: const Text('Nueva cuenta'),
                content: InputWidget(
                  maxLines: 1,
                  formProperty: "name",
                  formValues: vmAddPerson.formValues,
                  hintText: "Nombre",
                  labelText: "Nombre",
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Agregar'),
                    onPressed: () {
                      vmAddPerson.addPerson(context);
                    },
                  ),
                ],
              );
            },
          );
        },
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
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
