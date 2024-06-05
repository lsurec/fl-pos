// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/dark_theme.dart';
import 'package:flutter_post_printer_example/themes/light_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';

class AppTheme {
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

  static int cambiarTema = 0;
  static bool claro = false;
  static bool oscuro = false;

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.white,
  );

  // static TextStyle style(BuildContext context, String style, String tema) {
  //   //Encontrar el tema del dispositivo
  //   final Brightness brightness = MediaQuery.of(context).platformBrightness;
  //   //si es oscuro
  //   final bool isDarkMode = brightness == Brightness.dark;

  //   // Determinar el tema a utilizar
  //   if (tema.isEmpty || tema == "0") {
  //     tema = isDarkMode ? "2" : "1";
  //   }

  //   if (Preferences.systemTheme == "1") {
  //     tema = "1";
  //   }

  //   if (Preferences.systemTheme == "2") {
  //     tema = "2";
  //   }

  //   // Define los mapas para los estilos de los diferentes temas
  //   final lightThemeStyles = {
  //     Styles.normal: LightTheme.normalStyle,
  //     Styles.bold: LightTheme.normalBoldStyle,
  //     Styles.obligatory: LightTheme.obligatoryBoldStyle,
  //     Styles.hora: LightTheme.horaBoldStyle,
  //     Styles.title: LightTheme.titleStyle,
  //     Styles.subTitle: LightTheme.subTitleStyle,
  //     Styles.disabledStyle: LightTheme.disabledStyle,
  //     Styles.whiteBoldStyle: LightTheme.whiteBoldStyle,
  //     Styles.bold30Style: LightTheme.bold30Style,
  //     Styles.normal20Style: LightTheme.normal20Style,
  //     Styles.versionStyle: LightTheme.versionStyle,
  //     Styles.whiteStyle: LightTheme.whiteStyle,
  //   };

  //   final darkThemeStyles = {
  //     Styles.normal: DarkTheme.normalStyle,
  //     Styles.bold: DarkTheme.normalBoldStyle,
  //     Styles.obligatory: DarkTheme.obligatoryStyle,
  //     Styles.hora: DarkTheme.horaBoldStyle,
  //     Styles.title: DarkTheme.titleStyle,
  //     Styles.subTitle: DarkTheme.subTitleStyle,
  //     Styles.disabledStyle: DarkTheme.disabledStyle,
  //     Styles.whiteBoldStyle: DarkTheme.whiteBoldStyle,
  //     Styles.bold30Style: DarkTheme.bold30Style,
  //     Styles.normal20Style: DarkTheme.normal20Style,
  //     Styles.versionStyle: DarkTheme.versionStyle,
  //     Styles.whiteStyle: DarkTheme.whiteStyle,
  //   };

  //   // Selecciona el mapa correspondiente al tema utilizando un switch-case
  //   Map<String, TextStyle> themeStyles;
  //   switch (tema) {
  //     case "1":
  //       themeStyles = lightThemeStyles;
  //       break;
  //     case "2":
  //       themeStyles = darkThemeStyles;
  //       break;
  //     default:
  //       themeStyles = lightThemeStyles;
  //       break;
  //   }

  //   // Retorna el estilo correspondiente o normalStyle si no se encuentra
  //   return themeStyles[style] ?? LightTheme.normalStyle;
  // }

  // static Color color(BuildContext context, String style, String tema) {
  //   // Encontrar el tema del dispositivo
  //   final Brightness brightness = MediaQuery.of(context).platformBrightness;
  //   final bool isDarkMode = brightness == Brightness.dark;

  //   // Determinar el tema a utilizar
  //   if (tema.isEmpty || tema == "0") {
  //     tema = isDarkMode ? "2" : "1";
  //   }

  //   // Define los mapas para los estilos claros y oscuros
  //   final lightThemeStyles = {
  //     Styles.primary: primary,
  //     Styles.background: LightTheme.backroundColor,
  //     Styles.secondBackground: LightTheme.backroundColorSecondary,
  //   };

  //   final darkThemeStyles = {
  //     Styles.primary: primary,
  //     Styles.background: DarkTheme.backroundColor,
  //     Styles.secondBackground: DarkTheme.backroundSecondary,
  //   };

  //   // Selecciona el mapa correspondiente al tema utilizando un switch-case
  //   Map<String, Color> themeStyles;
  //   switch (tema) {
  //     case "1":
  //       themeStyles = lightThemeStyles;
  //       break;
  //     case "2":
  //       themeStyles = darkThemeStyles;
  //       break;
  //     default:
  //       themeStyles = lightThemeStyles;
  //       break;
  //   }

  //   // Retorna el estilo correspondiente o normalStyle si no se encuentra
  //   return themeStyles[style] ?? black;
  // }

  static TextStyle style(BuildContext context, String style, String tema) {
    // Encontrar el tema del dispositivo
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    // si es oscuro
    final bool isDarkMode = brightness == Brightness.dark;

    if (Preferences.idTheme == "0") {
      // Si no coincide con "1" o "2", usar la lógica original
      tema = isDarkMode ? "2" : "1";
    }
    // Verificar si Preferences.systemTheme tiene longitud mayor que 0
    else if (Preferences.systemTheme.isNotEmpty && Preferences.theme == 0) {
      // Determinar el tema a utilizar basado en Preferences.systemTheme
      switch (Preferences.systemTheme) {
        case "1":
          tema = "1"; // Tema claro
          break;
        case "2":
          tema = "2"; // Tema oscuro
          break;
        default:
          // Si no coincide con "1" o "2", usar la lógica original
          tema = isDarkMode ? "2" : "1";
          break;
      }
    }

    // Define los mapas para los estilos de los diferentes temas
    final lightThemeStyles = {
      Styles.normal: LightTheme.normalStyle,
      Styles.bold: LightTheme.normalBoldStyle,
      Styles.obligatory: LightTheme.obligatoryBoldStyle,
      Styles.hora: LightTheme.horaBoldStyle,
      Styles.title: LightTheme.titleStyle,
      Styles.subTitle: LightTheme.subTitleStyle,
      Styles.disabledStyle: LightTheme.disabledStyle,
      Styles.whiteBoldStyle: LightTheme.whiteBoldStyle,
      Styles.bold30Style: LightTheme.bold30Style,
      Styles.normal20Style: LightTheme.normal20Style,
      Styles.versionStyle: LightTheme.versionStyle,
      Styles.whiteStyle: LightTheme.whiteStyle,
      Styles.menuActive: LightTheme.menuActiveStyle,
      Styles.action: LightTheme.actionStyle,
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
      Styles.bold30Style: DarkTheme.bold30Style,
      Styles.normal20Style: DarkTheme.normal20Style,
      Styles.versionStyle: DarkTheme.versionStyle,
      Styles.whiteStyle: DarkTheme.whiteStyle,
      Styles.menuActive: DarkTheme.menuActiveStyle,
      Styles.action: DarkTheme.actionStyle,
    };

    // Selecciona el mapa correspondiente al tema utilizando un switch-case
    Map<String, TextStyle> themeStyles;
    switch (tema) {
      case "1":
        themeStyles = lightThemeStyles;
        break;
      case "2":
        themeStyles = darkThemeStyles;
        break;
      default:
        themeStyles = lightThemeStyles;
        break;
    }

    // Retorna el estilo correspondiente o normalStyle si no se encuentra
    return themeStyles[style] ?? LightTheme.normalStyle;
  }

  static TextStyle style2(BuildContext context, String style, String tema) {
    // Encontrar el tema del dispositivo
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    // si es oscuro
    final bool isDarkMode = brightness == Brightness.dark;

    // Verificar si Preferences.systemTheme tiene longitud mayor que 0
    if (Preferences.systemTheme.isNotEmpty) {
      // Determinar el tema a utilizar basado en Preferences.systemTheme
      switch (Preferences.systemTheme) {
        case "1":
          tema = "1"; // Tema claro
          break;
        case "2":
          tema = "2"; // Tema oscuro
          break;
        default:
          // Si no coincide con "1" o "2", usar la lógica original
          tema = isDarkMode ? "2" : "1";
          break;
      }
    } else {
      // Determinar el tema a utilizar basado en el modo oscuro del dispositivo
      if (tema.isEmpty || tema == "0") {
        tema = isDarkMode ? "2" : "1";
      }
    }

    // Define los mapas para los estilos de los diferentes temas
    final lightThemeStyles = {
      Styles.normal: LightTheme.normalStyle,
      Styles.bold: LightTheme.normalBoldStyle,
      Styles.obligatory: LightTheme.obligatoryBoldStyle,
      Styles.hora: LightTheme.horaBoldStyle,
      Styles.title: LightTheme.titleStyle,
      Styles.subTitle: LightTheme.subTitleStyle,
      Styles.disabledStyle: LightTheme.disabledStyle,
      Styles.whiteBoldStyle: LightTheme.whiteBoldStyle,
      Styles.bold30Style: LightTheme.bold30Style,
      Styles.normal20Style: LightTheme.normal20Style,
      Styles.versionStyle: LightTheme.versionStyle,
      Styles.whiteStyle: LightTheme.whiteStyle,
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
      Styles.bold30Style: DarkTheme.bold30Style,
      Styles.normal20Style: DarkTheme.normal20Style,
      Styles.versionStyle: DarkTheme.versionStyle,
      Styles.whiteStyle: DarkTheme.whiteStyle,
    };

    // Selecciona el mapa correspondiente al tema utilizando un switch-case
    Map<String, TextStyle> themeStyles;
    switch (tema) {
      case "1":
        themeStyles = lightThemeStyles;
        break;
      case "2":
        themeStyles = darkThemeStyles;
        break;
      default:
        themeStyles = lightThemeStyles;
        break;
    }

    // Retorna el estilo correspondiente o normalStyle si no se encuentra
    return themeStyles[style] ?? LightTheme.normalStyle;
  }

  static Color color(BuildContext context, String style, String tema) {
    // Encontrar el tema del dispositivo
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    final bool isDarkMode = brightness == Brightness.dark;

    if (Preferences.idTheme == "0") {
      // Si no coincide con "1" o "2", usar la lógica original
      tema = isDarkMode ? "2" : "1";
    }
    // Verificar si Preferences.systemTheme tiene longitud mayor que 0
    else if (Preferences.systemTheme.isNotEmpty && Preferences.theme == 0) {
      // Determinar el tema a utilizar basado en Preferences.systemTheme
      switch (Preferences.systemTheme) {
        case "1":
          tema = "1"; // Tema claro
          break;
        case "2":
          tema = "2"; // Tema oscuro
          break;
        default:
          // Si no coincide con "1" o "2", usar la lógica original
          tema = isDarkMode ? "2" : "1";
          break;
      }
    }

    // Define los mapas para los estilos claros y oscuros
    final lightThemeStyles = {
      Styles.primary: primary,
      Styles.background: LightTheme.backroundColor,
      Styles.secondBackground: LightTheme.backroundColorSecondary,
      Styles.grey: LightTheme.grey,
      Styles.iconActive: LightTheme.primary,
      Styles.darkPrimary: LightTheme.primary,
    };

    final darkThemeStyles = {
      Styles.primary: primary,
      Styles.background: DarkTheme.backroundColor,
      Styles.secondBackground: DarkTheme.backroundSecondary,
      Styles.grey: DarkTheme.grey,
      Styles.iconActive: DarkTheme.iconActive,
      Styles.darkPrimary: const Color.fromARGB(255, 82, 150, 252),
    };

    // Selecciona el mapa correspondiente al tema utilizando un switch-case
    Map<String, Color> themeStyles;
    switch (tema) {
      case "1":
        themeStyles = lightThemeStyles;
        break;
      case "2":
        themeStyles = darkThemeStyles;
        break;
      default:
        themeStyles = lightThemeStyles;
        break;
    }

    // Retorna el estilo correspondiente o normalStyle si no se encuentra
    return themeStyles[style] ?? black;
  }

  static ButtonStyle button(BuildContext context, String style, String tema) {
    // Encontrar el tema del dispositivo
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    final bool isDarkMode = brightness == Brightness.dark;

    if (Preferences.idTheme == "0") {
      // Si no coincide con "1" o "2", usar la lógica original
      tema = isDarkMode ? "2" : "1";
    }
    // Verificar si Preferences.systemTheme tiene longitud mayor que 0
    else if (Preferences.systemTheme.isNotEmpty && Preferences.theme == 0) {
      // Determinar el tema a utilizar basado en Preferences.systemTheme
      switch (Preferences.systemTheme) {
        case "1":
          tema = "1"; // Tema claro
          break;
        case "2":
          tema = "2"; // Tema oscuro
          break;
        default:
          // Si no coincide con "1" o "2", usar la lógica original
          tema = isDarkMode ? "2" : "1";
          break;
      }
    }

    // Define los mapas para los estilos de los diferentes temas
    final lightThemeStyles = {
      Styles.buttonStyle: LightTheme.buttonStyle,
    };

    final darkThemeStyles = {
      Styles.buttonStyle: DarkTheme.buttonStyle,
    };

    // Selecciona el mapa correspondiente al tema utilizando un switch-case
    Map<String, ButtonStyle> themeStyles;
    switch (tema) {
      case "1":
        themeStyles = lightThemeStyles;
        break;
      case "2":
        themeStyles = darkThemeStyles;
        break;
      default:
        themeStyles = lightThemeStyles;
        break;
    }

    // Retorna el estilo correspondiente o buttonsStyle si no se encuentra
    return themeStyles[style] ?? buttonsStyle;
  }

  static final ButtonStyle buttonsStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(primary),
  );

  static ButtonStyle button2(BuildContext context, String style, String tema) {
    // Encontrar el tema del dispositivo
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    final bool isDarkMode = brightness == Brightness.dark;

    // Verificar si Preferences.systemTheme tiene longitud mayor que 0
    if (Preferences.systemTheme.isNotEmpty) {
      // Determinar el tema a utilizar basado en Preferences.systemTheme
      switch (Preferences.systemTheme) {
        case "1":
          tema = "1"; // Tema claro
          break;
        case "2":
          tema = "2"; // Tema oscuro
          break;
        default:
          // Si no coincide con "1" o "2", usar la lógica original
          tema = isDarkMode ? "2" : "1";
          break;
      }
    } else {
      // Determinar el tema a utilizar basado en el modo oscuro del dispositivo
      if (tema.isEmpty || tema == "0") {
        tema = isDarkMode ? "2" : "1";
      }
    }

    // Define los mapas para los estilos de los diferentes temas
    final lightThemeStyles = {
      Styles.buttonStyle: LightTheme.buttonStyle,
    };

    final darkThemeStyles = {
      Styles.buttonStyle: DarkTheme.buttonStyle,
    };

    // Selecciona el mapa correspondiente al tema utilizando un switch-case
    Map<String, ButtonStyle> themeStyles;
    switch (tema) {
      case "1":
        themeStyles = lightThemeStyles;
        break;
      case "2":
        themeStyles = darkThemeStyles;
        break;
      default:
        themeStyles = lightThemeStyles;
        break;
    }

    // Retorna el estilo correspondiente o buttonsStyle si no se encuentra
    return themeStyles[style] ?? buttonsStyle;
  }

  // static ButtonStyle button(BuildContext context, String style, String tema) {
  //   // Encontrar el tema del dispositivo
  //   final Brightness brightness = MediaQuery.of(context).platformBrightness;
  //   final bool isDarkMode = brightness == Brightness.dark;

  //   // Determinar el tema a utilizar
  //   if (tema.isEmpty || tema == "0") {
  //     tema = isDarkMode ? "2" : "1";
  //   }
  //   // Define los mapas para los estilos de los diferentes temas
  //   final lightThemeStyles = {
  //     Styles.buttonStyle: LightTheme.buttonStyle,
  //   };

  //   final darkThemeStyles = {
  //     Styles.buttonStyle: DarkTheme.buttonStyle,
  //   };

  //   // Selecciona el mapa correspondiente al tema utilizando un switch-case
  //   Map<String, ButtonStyle> themeStyles;
  //   switch (tema) {
  //     case "1":
  //       themeStyles = darkThemeStyles;
  //       break;
  //     case "2":
  //       themeStyles = darkThemeStyles;
  //       break;
  //     default:
  //       themeStyles = lightThemeStyles;
  //       break;
  //   }

  //   // Retorna el estilo correspondiente o buttonsStyle si no se encuentra
  //   return themeStyles[style] ?? buttonsStyle;
  // }

  static Color colorcito(BuildContext context, String style, String tema) {
    // Encontrar el tema del dispositivo
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    final bool isDarkMode = brightness == Brightness.dark;

    // Determinar el tema a utilizar
    if (tema.isEmpty || tema == "0") {
      tema = isDarkMode ? "2" : "1";
    }

    // Definir los mapas para los estilos claros y oscuros
    final lightThemeStyles = {
      Styles.primary: primary,
      Styles.background: LightTheme.backroundColor,
      Styles.secondBackground: LightTheme.backroundColorSecondary,
    };

    final darkThemeStyles = {
      Styles.primary: primary,
      Styles.background: DarkTheme.backroundColor,
      Styles.secondBackground: DarkTheme.backroundSecondary,
    };

    // Seleccionar el mapa correspondiente al tema
    Map<String, Color> themeStyles;
    switch (tema) {
      case "1":
        themeStyles = lightThemeStyles;
        break;
      case "2":
        themeStyles = darkThemeStyles;
        break;
      default:
        themeStyles = lightThemeStyles;
        break;
    }

    // Retornar el estilo correspondiente o un color por defecto si no se encuentra
    return themeStyles[style] ?? black;
  }
}
