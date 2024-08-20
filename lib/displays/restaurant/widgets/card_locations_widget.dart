import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
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
      borderColor: const Color(0xffc2cfd9),
      elevation: 0,
      width: double.infinity,
      raidus: 10,
      color: AppTheme.backroundColor,
      borderWidth: 2,
      child: InkWell(
        onTap: () => onTap(),
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
                  ),
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
