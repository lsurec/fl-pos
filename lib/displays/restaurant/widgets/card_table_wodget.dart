import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';

class CardTableWidget extends StatelessWidget {
  const CardTableWidget({
    Key? key,
    required this.mesa,
    required this.onTap,
  }) : super(key: key);

  final TableModel mesa;
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mesa.descripcion,
                      style: StyleApp.normalBold,
                      textAlign: TextAlign.justify,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      //TODO:Translate
                      "Cuentas: ${mesa.orders!.length}",
                      style: StyleApp.normalBold,
                      textAlign: TextAlign.justify,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
