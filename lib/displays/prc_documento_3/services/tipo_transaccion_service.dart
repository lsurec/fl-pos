import 'dart:convert';

import 'package:flutter_post_printer_example/displays/prc_documento_3/models/tipo_transaccion_model.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:http/http.dart' as http;

class TipoTransaccionService {
  // Url del servidor
  final String _baseUrl = Preferences.urlApi;

  //obtener formas de pago
  Future<ApiResModel> getTipoTransaccion(
    int documento,
    String serie,
    int empresa,
    String token,
    String user,
  ) async {
    Uri url = Uri.parse("${_baseUrl}transaccion/tipo");
    try {
      //url completa

      //configiracion del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "empresa": empresa.toString(),
          "documento": documento.toString(),
          "serie": serie,
          "user": user,
        },
      );

      ResponseModel res = ResponseModel.fromMap(jsonDecode(response.body));

      //si el api no responde
      if (response.statusCode != 200 && response.statusCode != 201) {
        return ApiResModel(
          url: url.toString(),
          succes: false,
          response: res.data,
          storeProcedure: res.storeProcedure,
        );
      }

      //formas de pago disponibles
      List<TipoTransaccionModel> transacciones = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = TipoTransaccionModel.fromMap(item);
        //agregar item a la lista
        transacciones.add(responseFinally);
      }

      //respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: transacciones,
        storeProcedure: null,
      );
    } catch (e) {
      //respuesta incorrecta
      return ApiResModel(
        url: url.toString(),
        succes: false,
        response: e.toString(),
        storeProcedure: null,
      );
    }
  }
}
