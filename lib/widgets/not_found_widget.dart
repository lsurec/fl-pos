import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';

class NotFoundWidget extends StatelessWidget {
  const NotFoundWidget({
    Key? key,
    required this.text,
    required this.icon,
  }) : super(key: key);

  final String text;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          Text(
            text,
            style: StyleApp.bold30Style,
          ),
        ],
      ),
    );
  }
}
