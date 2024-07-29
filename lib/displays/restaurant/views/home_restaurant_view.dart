import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
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
                style: AppTheme.style(
                  context,
                  Styles.title,
                ),
              ),
              bottom: TabBar(
                labelColor: AppTheme.color(
                  context,
                  Styles.normal,
                ),
                indicatorColor: AppTheme.color(
                  context,
                  Styles.darkPrimary,
                ),
                //TODO:Translate
                tabs: const [
                  Tab(text: "Accesos"),
                  Tab(text: "Mesas abiertas"),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                // Contenido de la primera pestaña
                Container(),
                // Contenido de la segunda pestaña
                Container(),
              ],
            ),
          ),
        ),
        if (vm.isLoading)
          ModalBarrier(
            dismissible: false,
            // color: Colors.black.withOpacity(0.3),
            color: AppTheme.color(
              context,
              Styles.loading,
            ),
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}
