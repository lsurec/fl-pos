import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeRestaurantView extends StatelessWidget {
  const HomeRestaurantView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeRestaurantViewModel>(context);
    final vmMenu = Provider.of<MenuViewModel>(context);

    return Stack(
      children: [
        DefaultTabController(
          length: 2, // Número de pestañas
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                vmMenu.name,
                style: StyleApp.title,
              ),
              bottom: TabBar(
                indicatorColor: AppTheme.hexToColor(
                  Preferences.valueColor,
                ),
                tabs: [
                  Tab(
                    text: AppLocalizations.of(context)!.translate(
                      BlockTranslate.restaurante,
                      'accesos',
                    ),
                  ),
                  Tab(
                    text: AppLocalizations.of(context)!.translate(
                      BlockTranslate.restaurante,
                      'mesasA',
                    ),
                  ),
                ],
              ),
            ),
            body: const TabBarView(
              children: [
                // Contenido de la primera pestaña
                _AccesTab(),
                _TableOpen(),
                // Contenido de la segunda pestaña
              ],
            ),
          ),
        ),
        if (vm.isLoading)
          ModalBarrier(
            dismissible: false,
            // color: Colors.black.withOpacity(0.3),
            color: AppTheme.isDark()
                ? AppTheme.darkBackroundColor
                : AppTheme.backroundColor,
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}

class _TableOpen extends StatelessWidget {
  const _TableOpen();

  @override
  Widget build(BuildContext context) {
    final OrderViewModel orderVM = Provider.of<OrderViewModel>(context);

    final HomeViewModel homeVM = Provider.of<HomeViewModel>(context);

    // Crear una instancia de NumberFormat para el formato de moneda
    final currencyFormat = NumberFormat.currency(
      // Símbolo de la moneda (puedes cambiarlo según tu necesidad)
      symbol: homeVM.moneda,
      // Número de decimales a mostrar
      decimalDigits: 2,
    );

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(20),
          height: 20,
          child: RegisterCountWidget(
            count: orderVM.orders.length,
          ),
        ),
        if (orderVM.orders.isNotEmpty)
          Container(
            color:
                AppTheme.isDark() ? AppTheme.darkSeparador : AppTheme.separador,
            height: 10,
          ),
        Expanded(
          child: ListView.separated(
            itemCount: orderVM.orders.length,
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                color: AppTheme.isDark()
                    ? AppTheme.darkSeparador
                    : AppTheme.separador,
                height: 10,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              OrderModel order = orderVM.orders[index];

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order.nombre,
                              style: StyleApp.normal,
                            ),
                            Text(
                              "${AppLocalizations.of(context)!.translate(
                                BlockTranslate.restaurante,
                                'consecutivo',
                              )} ${order.consecutivo}",
                              style: StyleApp.normal,
                            ),
                          ],
                        ),
                        TextsWidget(
                          title: AppLocalizations.of(context)!.translate(
                            BlockTranslate.restaurante,
                            'mesa',
                          ),
                          text: order.mesa.descripcion,
                        ),
                        const SizedBox(height: 5),
                        TextsWidget(
                          title: AppLocalizations.of(context)!.translate(
                            BlockTranslate.restaurante,
                            'ubicacion',
                          ),
                          text: order.ubicacion.descripcion,
                        ),
                        //  const SizedBox(height: 5),
                        // TextsWidget(
                        //   title: "Serie: ${order.}",
                        //   text: order.ubicacion.descripcion,
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.translate(
                                BlockTranslate.calcular,
                                'total',
                              )}: ${currencyFormat.format(orderVM.getTotal(index))}",
                              style: StyleApp.normalBold,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (orderVM.orders.isNotEmpty &&
                      index == orderVM.orders.length - 1)
                    Container(
                      color: AppTheme.isDark()
                          ? AppTheme.darkSeparador
                          : AppTheme.separador,
                      height: 10,
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AccesTab extends StatelessWidget {
  const _AccesTab();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeRestaurantViewModel>(context);

    return RefreshIndicator(
      onRefresh: () => vm.loadData(context),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.general,
                    'serie',
                  ),
                  style: StyleApp.title,
                ),
                if (vm.series.isEmpty)
                  NotFoundWidget(
                    text: AppLocalizations.of(context)!.translate(
                      BlockTranslate.notificacion,
                      'sinElementos',
                    ),
                    icon: const Icon(
                      Icons.browser_not_supported_outlined,
                      size: 50,
                    ),
                  ),
                if (vm.series.isNotEmpty)
                  DropdownButton<SerieModel>(
                    isExpanded: true,
                    dropdownColor: AppTheme.isDark()
                        ? AppTheme.darkBackroundColor
                        : AppTheme.backroundColor,
                    hint: Text(
                      AppLocalizations.of(context)!.translate(
                        BlockTranslate.factura,
                        'opcion',
                      ),
                    ),
                    value: vm.serieSelect,
                    onChanged: (value) => vm.changeSerie(value, context),
                    items: vm.series.map(
                      (serie) {
                        return DropdownMenuItem<SerieModel>(
                          value: serie,
                          child: Text(serie.descripcion!),
                        );
                      },
                    ).toList(),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => vm.navigateLoc(context),
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.botones,
                          'empezar',
                        ),
                        style: StyleApp.whiteBold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
