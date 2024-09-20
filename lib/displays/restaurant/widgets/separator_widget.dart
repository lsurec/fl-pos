import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';

class Separator10Widget extends StatelessWidget {
  const Separator10Widget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.isDark() ? AppTheme.darkSeparador : AppTheme.separador,
      height: 10,
    );
  }
}
