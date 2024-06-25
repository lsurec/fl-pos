import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeViewModel>(context);
    final menuVM = Provider.of<MenuViewModel>(context);

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
            body: RefreshIndicator(
              onRefresh: () => menuVM.refreshData(context),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ListView(
                  children: const [],
                ),
              ),
            ),
          ),
        ),
        if (vm.isLoading)
          ModalBarrier(
            dismissible: false,
            // color: Colors.black.withOpacity(0.3),
            color: AppTheme.color(
              Styles.loading,
            ),
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
    final List<MenuModel> routeMenu = menuVM.routeMenu;
    final List<MenuModel> menu = menuVM.menuActive;

    final screenSize = MediaQuery.of(context).size;

    return Drawer(
      width: screenSize.width * 0.8,
      backgroundColor: AppTheme.color(
        Styles.black,
      ),
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
                        style: index == routeMenu.length - 1
                            ? AppTheme.style(
                                Styles.menuActive,
                              )
                            : AppTheme.style(
                                Styles.normal,
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
          Divider(
            color: AppTheme.color(
              Styles.divider,
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: menu.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  color: AppTheme.color(
                    Styles.divider,
                  ),
                );
              },
              itemBuilder: (BuildContext context, int index) {
                MenuModel itemMenu = menu[index];
                return ListTile(
                  titleTextStyle: AppTheme.style(
                    Styles.normal,
                  ),
                  title: Text(
                    itemMenu.name,
                    style: AppTheme.style(
                      Styles.normal,
                    ),
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
        color: AppTheme.color(
          Styles.secondBackground,
        ),
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
        ),
      ),
    );
  }
}
