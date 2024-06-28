import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/classification_model.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/classification_view_model.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/locations_view_model.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/tables_view_model.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ClassificationView extends StatelessWidget {
  const ClassificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vmLoc = Provider.of<LocationsViewModel>(context);
    final vmTables = Provider.of<TablesViewModel>(context);
    final vm = Provider.of<ClassificationViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              vmTables.table!.descripcion,
              style: AppTheme.style(
                context,
                Styles.title,
                Preferences.idTheme,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.description_outlined,
                ),
                padding: const EdgeInsets.only(right: 20),
                onPressed: () {},
              ),
              PopupMenuButton<int>(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 1,
                    child: Text("Trasladar Mesa"),
                  ),
                ],
                // color: AppTheme.backroundColor,
                elevation: 2,
                // on selected we show the dialog box
                onSelected: (value) => {},
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            const Text(
                              "Ubicaciones/", //TODO:Translate
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black38,
                              ),
                            ),
                            Text(
                              "${vmLoc.location!.descripcion}/",
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black38,
                              ),
                            ),
                            Text(
                              vmTables.table!.descripcion,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      RegisterCountWidget(count: vm.totalLength),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => vm.loadData(context),
                    child: ListView.builder(
                      itemCount: vm.menu.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _RowMenu(
                          options: vm.menu[index],
                        );
                      },
                    ),
                  ),
                ),
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
              Preferences.idTheme,
            ),
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}

class _RowMenu extends StatelessWidget {
  const _RowMenu({
    Key? key,
    required this.options,
  }) : super(key: key);

  final List<ClassificationModel> options;

  @override
  Widget build(BuildContext context) {
    final menuVM = Provider.of<ClassificationViewModel>(context, listen: false);

    return Row(
      children: [
        CardImageWidget(
          onTap: () => {},
          description: options[0].desClasificacion,
          // srcImage: options[0].image,
          srcImage:
              "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/640px-Image_not_available.png",
        ),
        if (options.length == 2)
          CardImageWidget(
            onTap: () => {},
            description: options[1].desClasificacion,
            // srcImage: options[1].image,
            srcImage:
                "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/640px-Image_not_available.png",
          ),
        if (options.length == 1) Expanded(child: Container()),
      ],
    );
  }
}

class CardImageWidget extends StatelessWidget {
  const CardImageWidget({
    Key? key,
    required this.description,
    required this.srcImage,
    required this.onTap,
  }) : super(key: key);

  final String description;
  final String srcImage;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          height: 250,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              FadeInImage(
                placeholder: const AssetImage('assets/load.gif'),
                image: NetworkImage(
                  srcImage,
                ),
                height: 150,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 10),
              Text(
                description,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
