import 'dart:convert';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:http/http.dart' as http;

class PagoService {
// Url del servidor
  final String _baseUrl = Preferences.urlApi;

  //obtener formas de pago
  Future<ApiResModel> getFormas(
    int doc,
    String serie,
    int empresa,
    String token,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Pago/formas");
    try {
      //url completa

      //configiracion del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "empresa": empresa.toString(),
          "doc": doc.toString(),
          "serie": serie,
        },
      );

      ResponseModel res = ResponseModel.fromMap(jsonDecode(response.body));

      //si el api no responde
      if (response.statusCode != 200 && response.statusCode != 201) {
        return ApiResModel(
          url: url.toString(),
          succes: false,
          message: res.data,
          storeProcedure: res.storeProcedure,
        );
      }

      //formas de pago disponibles
      List<PaymentModel> payments = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = PaymentModel.fromMap(item);
        //agregar item a la lista
        payments.add(responseFinally);
      }

      //respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: payments,
        storeProcedure: null,
      );
    } catch (e) {
      //respuesta incorrecta
      return ApiResModel(
        url: url.toString(),
        succes: false,
        message: e.toString(),
        storeProcedure: null,
      );
    }
  }

  //obtner bancos
  Future<ApiResModel> getBancos(
    String user,
    int empresa,
    String token,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Pago/bancos");
    try {
      //url completa

      //configuracion del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "user": user,
          "empresa": empresa.toString(),
        },
      );

      ResponseModel res = ResponseModel.fromMap(jsonDecode(response.body));

      //si el api no responde
      if (response.statusCode != 200 && response.statusCode != 201) {
        return ApiResModel(
          url: url.toString(),
          succes: false,
          message: res.data,
          storeProcedure: res.storeProcedure,
        );
      }

      //bancos disponibles
      List<BankModel> banks = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = BankModel.fromMap(item);
        //agregar item a la lista
        banks.add(responseFinally);
      }

      //Respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: banks,
        storeProcedure: null,
      );
    } catch (e) {
      //Respuesta incorrecta
      return ApiResModel(
        url: url.toString(),
        succes: false,
        message: e.toString(),
        storeProcedure: null,
      );
    }
  }

  //obtener cuentas bancarias
  Future<ApiResModel> getCuentas(
    String user,
    int empresa,
    int banco,
    String token,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Pago/banco/cuentas");
    try {
      //url completa

      //configuracion del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "user": user,
          "empresa": empresa.toString(),
          "banco": banco.toString(),
        },
      );
      ResponseModel res = ResponseModel.fromMap(jsonDecode(response.body));

      //si el api no responde
      if (response.statusCode != 200 && response.statusCode != 201) {
        return ApiResModel(
          url: url.toString(),
          succes: false,
          message: res.data,
          storeProcedure: res.storeProcedure,
        );
      }

      //Cuentas bancarias disponbles
      List<AccountModel> accounts = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = AccountModel.fromMap(item);
        //agregar item a la lista
        accounts.add(responseFinally);
      }

      //respeusdata correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: accounts,
        storeProcedure: null,
      );
    } catch (e) {
      //respuesta incorrecta
      return ApiResModel(
        url: url.toString(),
        succes: false,
        message: e.toString(),
        storeProcedure: null,
      );
    }
  }
}
