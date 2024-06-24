import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LocationsView extends StatelessWidget {
  const LocationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LocationsViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              "Ubicaciones", //TODO:Translate
              style: AppTheme.style(
                context,
                Styles.title,
                Preferences.idTheme,
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () => vm.loadData(context),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ListView.builder(
                itemCount: vm.locations.length,
                itemBuilder: (BuildContext context, int index) {
                  LocationsModel ubicacion = vm.locations[index];
                  return GestureDetector(
                    child: _CardLocations(ubicacion: ubicacion),
                    onTap: () => vm.navigateTables(context),
                  );
                },
              ),
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
              Preferences.idTheme,
            ),
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}

class _CardLocations extends StatelessWidget {
  const _CardLocations({
    Key? key,
    required this.ubicacion,
  }) : super(key: key);

  final LocationsModel ubicacion;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      borderColor: const Color(0xffc2cfd9),
      elevation: 0,
      width: double.infinity,
      raidus: 0,
      child: Row(
        children: [
          const SizedBox(
            width: 150,
            child: FadeInImage(
              placeholder: AssetImage('assets/load.gif'),
              image: NetworkImage(
                "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/640px-Image_not_available.png",
              ),
              height: 150,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                ubicacion.descripcion,
                style: AppTheme.style(
                  context,
                  Styles.title,
                  Preferences.idTheme,
                ),
                textAlign: TextAlign.justify,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ),
      color: AppTheme.backroundColor,
      borderWidth: 2,
    );
  }
}
