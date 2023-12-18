import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/user_widget.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeViewModel>(context);

    return Stack(
      children: [
        DefaultTabController(
          length: 3, // Número de pestañas
          child: Scaffold(
            appBar: AppBar(
              actions: [
                UserWidget(
                  child: Container(),
                ),
              ],
            ),
            drawer: _MyDrawer(),
            body: Container(),
          ),
        ),
        if (vm.isLoading)
          ModalBarrier(
            dismissible: false,
            // color: Colors.black.withOpacity(0.3),
            color: AppTheme.backroundColor,
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}

class _MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final menuVM = Provider.of<MenuViewModel>(context);
    List<MenuModel> routeMenu = menuVM.routeMenu;
    List<MenuModel> menu = menuVM.menuActive;

    final screenSize = MediaQuery.of(context).size;

    return Drawer(
      width: screenSize.width * 0.8,
      backgroundColor: AppTheme.backroundColor,
      child: Column(
        children: [
          const SizedBox(height: kToolbarHeight),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 0,
            ),
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: routeMenu.length,
              itemBuilder: (BuildContext context, int index) {
                MenuModel route = routeMenu[index];
                return GestureDetector(
                  onTap: () => menuVM.changeRoute(index),
                  child: Row(
                    children: [
                      Text(
                        route.name,
                        style: TextStyle(
                          color: index == routeMenu.length - 1
                              ? AppTheme.primary
                              : null,
                          fontSize: 17,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_right,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => menuVM.refreshData(context),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: menu.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
                itemBuilder: (BuildContext context, int index) {
                  MenuModel itemMenu = menu[index];
                  return ListTile(
                    titleTextStyle: AppTheme.normalStyle,
                    title: Text(
                      itemMenu.name,
                    ),
                    trailing: itemMenu.children.isNotEmpty
                        ? const Icon(Icons.chevron_right)
                        : null,
                    onTap: () => itemMenu.children.isEmpty
                        ? menuVM.navigateDisplay(
                            context,
                            itemMenu.route,
                            itemMenu.display?.tipoDocumento,
                            itemMenu.display!.name,
                            itemMenu.display!.desTipoDocumento,
                          ) //Mostar contenido
                        : menuVM.changeMenuActive(
                            itemMenu.children,
                            itemMenu,
                          ), //Mostar rutas
                  );
                },
              ),
            ),
          ),
          const _FooterDrawer(),
        ],
      ),
    );
  }
}

class _FooterDrawer extends StatelessWidget {
  const _FooterDrawer();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeViewModel>(context);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          height: 56,
          color: AppTheme.backroundColorSecondary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => vm.navigateSettings(context),
                icon: const Icon(
                  Icons.settings,
                ),
              ),
              IconButton(
                onPressed: () => vm.logout(context),
                icon: const Icon(
                  Icons.logout,
                ),
              )
            ],
          )),
    );
  }
}
