import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/widgets/new_account_card_widget.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AccountsView extends StatelessWidget {
  const AccountsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      );
                    } else {
                      return const NewAccountCardWidget();
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({
    super.key,
    required this.index,
  });

  final int index;

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

    return CardWidget(
      color: AppTheme.color(
        context,
        Styles.secondBackground,
      ),
      elevation: 2,
      raidus: 10,
      child: InkWell(
        onTap: () {
          if (orderVM.orders[index].transacciones.isEmpty) {
            NotificationService.showSnackbar(
                "No hay transacciones para mostrar"); //TODO:Translate
            return;
          }

          Navigator.pushNamed(
            context,
            AppRoutes.order,
            arguments: index,
          );
        },
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
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    "Total: ${currencyFormat.format(orderVM.getTotal(index))}",
                    style: AppTheme.style(
                      context,
                      Styles.versionStyle,
                    ),
                  )
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
