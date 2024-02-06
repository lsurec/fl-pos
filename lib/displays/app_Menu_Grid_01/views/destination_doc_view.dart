import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/widgets/card_widget.dart';

class DestinationDocView extends StatelessWidget {
  const DestinationDocView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "convertDocs");
              },
              child: const CardWidget(
                color: AppTheme.grayAppBar,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Documento:",
                        style: AppTheme.normalBoldStyle,
                      ),
                      Text(
                        "Esse laborum excepteur qui et non.",
                        style: AppTheme.normalStyle,
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Serie:",
                        style: AppTheme.normalBoldStyle,
                      ),
                      Text(
                        "dolore amet et qui sunt cillum commodo.",
                        style: AppTheme.normalStyle,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
