import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';

class InputWidget extends StatelessWidget {
  const InputWidget({
    Key? key,
    this.suffixIcon,
    this.labelText,
    this.hintText,
    required this.maxLines,
    this.initialValue,
    this.validator = true,
    required this.formProperty,
    required this.formValues,
  }) : super(key: key);

  final IconData? suffixIcon;
  final String? labelText;
  final String? hintText;
  final String? initialValue;
  final int maxLines;

  final bool? validator;
  final String formProperty;
  final Map<String, dynamic> formValues;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: TextFormField(
        maxLines: maxLines,
        initialValue: initialValue,
        onChanged: (value) {
          formValues[formProperty] = value;
        },
        decoration: InputDecoration(
          //counter: const Text('Caracteres'),
          labelText: labelText,
          hintText: hintText,
          suffixIcon: suffixIcon == null
              ? null
              : Icon(
                  suffixIcon,
                  color: AppTheme.grey,
                ),
        ),
        validator: (value) {
          if (validator == true) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.translate(
                BlockTranslate.notificacion,
                'requerido',
              );
            }
          }
          return null;
        },
      ),
    );
  }
}
