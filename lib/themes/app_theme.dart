import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/themes/dark_theme.dart';
import 'package:flutter_post_printer_example/themes/light_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';

class AppTheme {
  static int idTheme = 1; //Tema claro

  //Color primario de la app
  static const Color primary = Color(0xff134895);
  static const Color grayAppBar = Color(0xfff5f5f5);
  static const Color secondary = Color(0xff1C82AD);
  static const Color activeStep = Color(0xffcccccc);
  static const Color disableStep = primary;
  static const Color disableStepPrimary = Color(0xFF636564);
  static const Color disableStepSecondary = Color(0xFFBABABA);
  static const Color disableStepLine = Color(0xFFDADADA);
  static Color backroundColor = Colors.orange.shade50;
  static const Color backroundColorSecondary = Color(0xffFEF5E7);
  static const Color white = Colors.white;

  static const Color black = Colors.black;
  static const Color darkPrimary = Color.fromARGB(255, 159, 197, 255);
  static const Color darkbackroundColor = Color.fromARGB(255, 48, 45, 45);

  static const normalStyle = TextStyle(
    fontSize: 17,
    color: Colors.black,
  );
  static const normalBoldStyle = TextStyle(
    fontSize: 17,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  static const horaBoldStyle = TextStyle(
    fontSize: 12,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  static const whiteBoldStyle = TextStyle(
    fontSize: 17,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const titleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const obligatoryBoldStyle = TextStyle(
    fontSize: 20,
    color: Colors.red,
    fontWeight: FontWeight.bold,
  );

  static const tareaStyle = TextStyle(
    fontSize: 14,
    color: Color.fromARGB(255, 78, 77, 77),
    fontWeight: FontWeight.w500,
  );

  static const verMas = TextStyle(
    fontSize: 12,
    color: Color.fromARGB(255, 111, 111, 111),
    fontWeight: FontWeight.w500,
  );

  static const inactivoStyle = TextStyle(
    fontSize: 17,
    color: Colors.grey,
  );

  static const diasFueraMes = TextStyle(
    fontSize: 17,
    color: Color.fromARGB(255, 111, 111, 111),
    fontWeight: FontWeight.bold,
  );

  static const taskStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  static final ButtonStyle buttonsStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(primary),
  );

  static final ButtonStyle disabledButtonsStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
  );

  //Tema claro
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: primary,
    appBarTheme: AppBarTheme(
      color: backroundColor,
      iconTheme: const IconThemeData(
        size: 30,
        color: Colors.black,
      ),
      elevation: 0,
    ),
    scaffoldBackgroundColor: backroundColor,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        // ignore: deprecated_member_use
        primary: primary,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        // ignore: deprecated_member_use
        primary: primary,
        elevation: 0,
        shape: const StadiumBorder(),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelStyle: const TextStyle(
        color: primary,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: primary),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: primary),
        borderRadius: BorderRadius.circular(8),
      ),
      border: OutlineInputBorder(
        //borderSide: const BorderSide(color: primary),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: DarkTheme.darkPrimary,
    appBarTheme: const AppBarTheme(
      color: darkbackroundColor,
      iconTheme: IconThemeData(
        size: 30,
        color: Colors.white,
      ),
      elevation: 0,
    ),
    scaffoldBackgroundColor: darkbackroundColor,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        // ignore: deprecated_member_use
        primary: DarkTheme.darkPrimary,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: DarkTheme.darkPrimary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        // ignore: deprecated_member_use
        primary: DarkTheme.darkPrimary,
        elevation: 0,
        shape: const StadiumBorder(),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelStyle: const TextStyle(
        color: DarkTheme.darkPrimary,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: DarkTheme.darkPrimary,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: DarkTheme.darkPrimary,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      border: OutlineInputBorder(
        //borderSide: const BorderSide(color: primary),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  static TextStyle styleTheme(String style, int tema) {
    // Define los mapas para los estilos claros y oscuros
    final lightThemeStyles = {
      Styles.normal: LightTheme.normalStyle,
      Styles.bold: LightTheme.normalBoldStyle,
      Styles.obligatory: LightTheme.obligatoryBoldStyle,
      Styles.hora: LightTheme.horaBoldStyle,
      Styles.title: LightTheme.titleStyle,
      Styles.subTitle: LightTheme.subTitleStyle,
      Styles.disabledStyle: LightTheme.disabledStyle,
      Styles.whiteBoldStyle: LightTheme.whiteBoldStyle,
    };

    final darkThemeStyles = {
      Styles.normal: DarkTheme.normalStyle,
      Styles.bold: DarkTheme.normalBoldStyle,
      Styles.obligatory: DarkTheme.obligatoryStyle,
      Styles.hora: DarkTheme.horaBoldStyle,
      Styles.title: DarkTheme.titleStyle,
      Styles.subTitle: DarkTheme.subTitleStyle,
      Styles.disabledStyle: DarkTheme.disabledStyle,
      Styles.whiteBoldStyle: DarkTheme.whiteBoldStyle,
    };

    // Selecciona el mapa correspondiente al tema
    final themeStyles = tema == 1 ? lightThemeStyles : darkThemeStyles;

    // Retorna el estilo correspondiente o normalStyle si no se encuentra
    return themeStyles[style] ?? normalStyle;
  }

  static Color colorTheme(String style, int tema) {
    // Define los mapas para los estilos claros y oscuros
    final lightThemeStyles = {
      Styles.primary: primary,
      Styles.background: backroundColor,
      Styles.secondBackground: LightTheme.backroundColorSecondary,
      Styles.grey: LightTheme.grey,
      Styles.icons : DarkTheme.grey
    };

    final darkThemeStyles = {
      Styles.primary: darkPrimary,
      Styles.background: darkbackroundColor,
      Styles.secondBackground: DarkTheme.darkBackroundSecondary,
      Styles.grey: DarkTheme.grey,
      Styles.icons : DarkTheme.icons
    };

    // Selecciona el mapa correspondiente al tema
    final themeStyles = tema == 1 ? lightThemeStyles : darkThemeStyles;

    // Retorna el estilo correspondiente o normalStyle si no se encuentra
    return themeStyles[style] ?? black;
  }

  static ButtonStyle buttonStyle(String style, int tema) {
    // Define los mapas para los estilos claros y oscuros
    final lightThemeStyles = {
      Styles.buttonStyle: LightTheme.buttonStyle,
    };

    final darkThemeStyles = {
      Styles.buttonStyle: DarkTheme.buttonStyle,
    };

    // Selecciona el mapa correspondiente al tema
    final themeStyles = tema == 1 ? lightThemeStyles : darkThemeStyles;

    // Retorna el estilo correspondiente o normalStyle si no se encuentra
    return themeStyles[style] ?? buttonsStyle;
  }
}
