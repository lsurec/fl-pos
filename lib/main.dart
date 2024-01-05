import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/details_doc_view_model.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/views/views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    // Preferences.clearUrl();
    // Preferences.clearToken();
    // Preferences.clearDocument();

    //TODO id app:
    // final String id_app = "pos_flutter";

    //app_business

    return MaterialApp(
      //snackbar global
      scaffoldMessengerKey: NotificationService.messengerKey,
      title: "POS",
      debugShowCheckedModeBanner: false,
      //Tema de la aplicacion
      theme: AppTheme.lightTheme,
      //configurar ruta inicial
      home: const SplashView(), // Muestra el SplashScreen durante el inicio
      routes: AppRoutes.routes, //rutas
      onGenerateRoute: AppRoutes.onGenerateRoute, //en caso de ruta incorrecta
    );
  }
}
