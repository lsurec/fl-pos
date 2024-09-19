// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/select_account_view_model.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
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
    final int tipoAccion = data["action"];

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
                    style: StyleApp.normal,
                  )
                : null,
            actions: vm.isSelectedMode
                ? [
                    IconButton(
                      onPressed: () => vm.selectedAll(context),
                      icon: const Icon(Icons.select_all),
                      tooltip: AppLocalizations.of(context)!.translate(
                        BlockTranslate.restaurante,
                        'seleccionarT',
                      ),
                    ),
                    IconButton(
                      onPressed: () => vm.deleteItems(context),
                      icon: const Icon(Icons.delete_outline),
                      tooltip: AppLocalizations.of(context)!.translate(
                        BlockTranslate.botones,
                        'eliminar',
                      ),
                    ),
                    IconButton(
                      onPressed: () => vm.navigatePermisionView(context),
                      icon: const Icon(Icons.drive_file_move_outline),
                      tooltip: AppLocalizations.of(context)!.translate(
                        BlockTranslate.botones,
                        'trasladar',
                      ),
                    ),
                    IconButton(
                      onPressed: () => vm.printStatusAccount(context),
                      icon: const Icon(Icons.print_outlined),
                      tooltip: AppLocalizations.of(context)!.translate(
                        BlockTranslate.restaurante,
                        'estadoCuenta',
                      ),
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
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.restaurante,
                      'seleccionarCuenta',
                    ),
                    style: StyleApp.title,
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
                          tipoAccion: tipoAccion,
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
    required this.tipoAccion,
  });

  //1 agreagr transaccion, 2 detalles, 3 traslados
  final int screen;
  final int tipoAccion;
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
      // Símbolo de la moneda (puedes cambiarlo según tu necesidad)
      symbol: homeVM.moneda,
      // Número de decimales a mostrar
      decimalDigits: 2,
    );

    final SelectAccountViewModel vm =
        Provider.of<SelectAccountViewModel>(context);
    final vmTheme = Provider.of<ThemeViewModel>(context);

    return CardWidget(
      elevation: 2,
      raidus: 10,
      child: InkWell(
        onLongPress: screen == 3
            ? null
            : () => vm.onLongPress(
                  context,
                  index,
                ),
        onTap: vm.isSelectedMode
            ? () => vm.selectedItem(context, index)
            : () => vm.tapCard(
                  context,
                  screen,
                  index,
                  transaction,
                  tipoAccion,
                ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CircleAvatar(
                      backgroundColor: vmTheme.colorPref(
                        AppTheme.idColorTema,
                      ),
                      radius: 30.0,
                      child: const Icon(
                        Icons.person,
                        size: 30.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    orderVM.orders[index].nombre,
                    style: StyleApp.normalBold,
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    "${AppLocalizations.of(context)!.translate(
                      BlockTranslate.calcular,
                      'total',
                    )}: ${currencyFormat.format(orderVM.getTotal(index))}",
                    style: StyleApp.greyText,
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
                        title: Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.restaurante,
                            'renombrarCuenta',
                          ),
                        ),
                        content: InputWidget(
                          maxLines: 1,
                          formProperty: "name",
                          formValues: vmAddPerson.formValues,
                          hintText: AppLocalizations.of(context)!.translate(
                            BlockTranslate.cuenta,
                            'nombre',
                          ),
                          labelText: AppLocalizations.of(context)!.translate(
                            BlockTranslate.cuenta,
                            'nombre',
                          ),
                          initialValue: orderVM.orders[index].nombre,
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text(
                              AppLocalizations.of(context)!.translate(
                                BlockTranslate.botones,
                                'cancelar',
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          ElevatedButton(
                            child: Text(
                              AppLocalizations.of(context)!.translate(
                                BlockTranslate.botones,
                                'renombrar',
                              ),
                              style: StyleApp.whiteBold,
                            ),
                            onPressed: () => vmAddPerson.renamePerson(
                              context,
                              index,
                            ),
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
                  color: AppTheme.verde,
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
    final vmTheme = Provider.of<ThemeViewModel>(context);

    final AddPersonViewModel vmAddPerson = Provider.of<AddPersonViewModel>(
      context,
    );

    return CardWidget(
      elevation: 2,
      raidus: 10,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.cuenta,
                    'nueva',
                  ),
                ),
                content: InputWidget(
                  maxLines: 1,
                  formProperty: "name",
                  formValues: vmAddPerson.formValues,
                  hintText: AppLocalizations.of(context)!.translate(
                    BlockTranslate.cuenta,
                    'nombre',
                  ),
                  labelText: AppLocalizations.of(context)!.translate(
                    BlockTranslate.cuenta,
                    'nombre',
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      AppLocalizations.of(context)!.translate(
                        BlockTranslate.botones,
                        'cancelar',
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    child: Text(
                      AppLocalizations.of(context)!.translate(
                        BlockTranslate.botones,
                        'agregar',
                      ),
                      style: StyleApp.whiteBold,
                    ),
                    onPressed: () => vmAddPerson.addPerson(
                      context,
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                size: 40.0,
                color: vmTheme.colorPref(
                  AppTheme.idColorTema,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.cuenta,
                  'nueva',
                ),
                style: StyleApp.normalBold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
