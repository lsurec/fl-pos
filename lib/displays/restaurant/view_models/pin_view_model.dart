import 'package:flutter/material.dart';

class PinViewModel extends ChangeNotifier {
  String pinMesero = "";
  //Key for form
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //True if form is valid
  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  validatePin() {}
}
