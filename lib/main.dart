// ignore_for_file: avoid_print

import 'package:flutter_post_printer_example/displays/calendario/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
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

    //app_business

    return MaterialApp(
      //snackbar global
      scaffoldMessengerKey: NotificationService.messengerKey,
      title: "Business",
      debugShowCheckedModeBanner: false,
      //Tema de la aplicacion
      theme: themeApp(context),
      //configurar ruta inicial
      home: const SplashView(), // Muestra el SplashScreen durante el inicio
      routes: AppRoutes.routes, //rutas
      onGenerateRoute: AppRoutes.onGenerateRoute, //en caso de ruta incorrecta
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
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

ThemeData themeApp(BuildContext context) {
  //Encontrar el tema del dispositivo
  final Brightness brightness = MediaQuery.of(context).platformBrightness;
  //si es oscuro
  final bool isDarkMode = brightness == Brightness.dark;
  //si es claro
  final bool isLightMode = brightness == Brightness.light;

  //sino hay preferencia, asignar el tema del dispositivo
  if (Preferences.idTheme.isEmpty) {
    //TEMA DEL DISPOSITIVO CLARO
    if (Preferences.theme == 0 && isLightMode) {
      AppTheme.claro = true;
      return AppTheme.lightTheme;
    }

    //TEMA DEL DISPOSITIVO OSCURO
    if (Preferences.theme == 0 && isDarkMode) {
      AppTheme.oscuro = false;
      return AppTheme.darkTheme;
    }
  } else {
    //Si hay preferencia

    //TEMA CLARO
    if (Preferences.idTheme == "1") {
      return AppTheme.lightTheme;
    }

    //TEMA OSCURO
    if (Preferences.idTheme == "2") {
      return AppTheme.darkTheme;
    }
  }

  return AppTheme.lightTheme;
}
