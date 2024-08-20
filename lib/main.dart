// ignore_for_file: avoid_print

import 'package:flutter_post_printer_example/displays/calendario/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/views/views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  //inicializar shared preferences (preferencias de usuario)
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  //inicializar aplicacion
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => ApiViewModel()),
        ChangeNotifierProvider(create: (_) => DocumentViewModel()),
        ChangeNotifierProvider(create: (_) => DetailsViewModel()),
        ChangeNotifierProvider(create: (_) => ProductViewModel()),
        ChangeNotifierProvider(create: (_) => PaymentViewModel()),
        ChangeNotifierProvider(create: (_) => AmountViewModel()),
        ChangeNotifierProvider(create: (_) => ConfirmDocViewModel()),
        ChangeNotifierProvider(create: (_) => MenuViewModel()),
        ChangeNotifierProvider(create: (_) => LocalSettingsViewModel()),
        ChangeNotifierProvider(create: (_) => DocumentoViewModel()),
        ChangeNotifierProvider(create: (_) => SplashViewModel()),
        ChangeNotifierProvider(create: (_) => PrintViewModel()),
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
        ChangeNotifierProvider(create: (_) => ErrorViewModel()),
        // ChangeNotifierProvider(create: (_) => UpdateViewModel()),
        ChangeNotifierProvider(create: (_) => RecentViewModel()),
        ChangeNotifierProvider(create: (_) => DetailsViewModel()),
        ChangeNotifierProvider(create: (_) => DetailsDocViewModel()),
        ChangeNotifierProvider(create: (_) => AddClientViewModel()),
        ChangeNotifierProvider(create: (_) => PendingDocsViewModel()),
        ChangeNotifierProvider(create: (_) => DestinationDocViewModel()),
        ChangeNotifierProvider(create: (_) => TypesDocViewModel()),
        ChangeNotifierProvider(create: (_) => ConvertDocViewModel()),
        ChangeNotifierProvider(create: (_) => DetailsDestinationDocViewModel()),
        ChangeNotifierProvider(create: (_) => TareasViewModel()),
        ChangeNotifierProvider(create: (_) => DetalleTareaViewModel()),
        ChangeNotifierProvider(create: (_) => ComentariosViewModel()),
        ChangeNotifierProvider(create: (_) => CrearTareaViewModel()),
        ChangeNotifierProvider(create: (_) => IdReferenciaViewModel()),
        ChangeNotifierProvider(create: (_) => UsuariosViewModel()),
        ChangeNotifierProvider(create: (_) => CalendarioViewModel()),
        ChangeNotifierProvider(create: (_) => Calendario2ViewModel()),
        ChangeNotifierProvider(
            create: (_) => DetalleTareaCalendarioViewModel()),
        ChangeNotifierProvider(create: (_) => ShareDocViewModel()),
        ChangeNotifierProvider(create: (_) => LangViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
        ChangeNotifierProvider(create: (_) => ClassificationViewModel()),
        ChangeNotifierProvider(create: (_) => LocationsViewModel()),
        ChangeNotifierProvider(create: (_) => TablesViewModel()),
        ChangeNotifierProvider(create: (_) => OrderViewModel()),
        ChangeNotifierProvider(create: (_) => PinViewModel()),
        ChangeNotifierProvider(create: (_) => ProductsClassViewModel()),
        ChangeNotifierProvider(create: (_) => DetailsRestaurantViewModel()),
        ChangeNotifierProvider(create: (_) => HomeRestaurantViewModel()),
        ChangeNotifierProvider(create: (_) => AddPersonViewModel()),
        ChangeNotifierProvider(create: (_) => AccountsViewModel()),
        ChangeNotifierProvider(create: (_) => FechasViewModel()),
        ChangeNotifierProvider(create: (_) => PermisionsViewModel()),
        ChangeNotifierProvider(create: (_) => SelectTableViewModel()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // limpiar preferencias
    // Preferences.clearLang();
    // Preferences.clearTheme();
    // Preferences.clearUrl();
    // Preferences.clearToken();
    // Preferences.clearDocument();
    // Preferences.clearTheme();

    //app_business

    return MaterialApp(
      //snackbar global
      scaffoldMessengerKey: NotificationService.messengerKey,
      title: "Business",
      debugShowCheckedModeBanner: false,
      //Tema de la aplicacion
      theme: aplicarTemaApp(context),
      //configurar ruta inicial
      home: const SplashView(), // Muestra el SplashScreen durante el inicio
      // home: const Tabs4View(), // Muestra el SplashScreen durante el inicio
      routes: AppRoutes.routes, //rutas
      onGenerateRoute: AppRoutes.onGenerateRoute, //en caso de ruta incorrecta
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'), // Español
        Locale('en'), // Ingles
        Locale('fr'), // Frances
        Locale('de'), // Aleman
      ],
      //inicializar la aplicacion con el ultimo idioma guardado
      //sino se ha seleccionado inicializa con el idioma Español
      locale: Preferences.language.isEmpty
          ? AppLocalizations.idioma
          : Locale(Preferences.language),
    );
  }
}

//Tema de la aplicación
ThemeData aplicarTemaApp(BuildContext context) {
  // Encontrar el tema del dispositivo
  final Brightness brightness = MediaQuery.of(context).platformBrightness;
  final bool isDarkMode = brightness == Brightness.dark;
  final bool isLightMode = brightness == Brightness.light;

  //1- Evaluar que la preferencia idTheme no esté vacía.
  if (Preferences.idTheme.isNotEmpty) {
    //2- Verificar si la preferencia es 1: Tema Claro
    if (Preferences.idTheme == "1") {
      return AppTheme.lightTheme;
      //3- Verificar si la preferencia es 2: Tema Oscuro
    } else if (Preferences.idTheme == "2") {
      return AppTheme.darkTheme;
    }

    //4- Verificar si la preferencia es 0:Determinado por el sistema
    if (Preferences.idTheme == "0") {
      //5- Verifiar el tema del dispositivo es: Oscuro
      if (isDarkMode) {
        Preferences.systemTheme = "2";
        return AppTheme.darkTheme;
        //6- Verificar el tema del dispositivo es: Claro
      } else if (isLightMode) {
        Preferences.systemTheme = "1";
        return AppTheme.lightTheme;
      }
    }
    //7- Si la preferencia está vacía. Verificar el tema del dispositivo
  } else {
    //8- Si es tema Claro
    if (isDarkMode) {
      Preferences.systemTheme = "2";
      return AppTheme.darkTheme;
    }

    //9- Si es tema Oscuro
    if (isLightMode) {
      Preferences.systemTheme = "1";
      return AppTheme.lightTheme;
    }
  }

  //10- Sino encuentra nada
  // Retornar un tema por defecto en caso de que no se cumplan las condiciones
  return AppTheme.lightTheme;
}
