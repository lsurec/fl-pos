import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';

class CardLocationsWidget extends StatelessWidget {
  const CardLocationsWidget({
    Key? key,
    required this.ubicacion,
    required this.onTap,
  }) : super(key: key);

  final LocationModel ubicacion;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      borderColor: AppTheme.cardBorder,
      elevation: 0,
      width: double.infinity,
      raidus: 10,
      // color: AppTheme.backroundColor,
      borderWidth: 2,
      child: InkWell(
        onTap: () => onTap(),
        child: Row(
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: ubicacion.objElementoAsignado!.isEmpty
                  ? Image.asset(
                      "assets/image_not_available.png",
                      fit: BoxFit.cover,
                    )
                  : FadeInImage(
                      placeholder: const AssetImage("assets/load.gif"),
                      image: NetworkImage(ubicacion.objElementoAsignado!),
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) {
                        // Aquí se maneja el error y se muestra una imagen alternativa
                        return Image.asset(
                          'assets/image_not_available.png',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  ubicacion.descripcion,
                  style: StyleApp.title,
                  textAlign: TextAlign.justify,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
