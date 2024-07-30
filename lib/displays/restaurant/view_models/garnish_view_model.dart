import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/services/restaurant_service.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class GarnishViewModel extends ChangeNotifier {
  final List<GarnishModel> garnishs = [];

  Future<ApiResModel> loadGarnish(
    BuildContext context,
    int product,
    int um,
  ) async {
    final vmLogin = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    final String user = vmLogin.user;
    final String token = vmLogin.token;

    final RestaurantService restaurantService = RestaurantService();

    final ApiResModel apiResModel = await restaurantService.getGarnish(
      product,
      um,
      user,
      token,
    );

    return apiResModel;
  }
}
