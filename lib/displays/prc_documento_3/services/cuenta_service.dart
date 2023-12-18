import 'dart:convert';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:http/http.dart' as http;

class CuentaService {
  // Url del servidor
  final String _baseUrl = Preferences.urlApi;

//Consumo api obtner vendedores
  Future<ApiResModel> postCuenta(
    String user,
    int empresa,
    String token,
    CuentaCorrentistaModel cuenta,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Cuenta");
    try {
      //url completa

      // Configurar Api y consumirla
      final response = await http.post(
        url,
        body: cuenta.toJson(),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "bearer $token",
          "user": user,
          "empresa": "$empresa",
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

      CuentaCorrentistaModel resCuenta =
          CuentaCorrentistaModel.fromMap(res.data);

      //Retornar respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: resCuenta,
        storeProcedure: null,
      );
    } catch (e) {
      //retornar respuesta incorrecta
      return ApiResModel(
        url: url.toString(),
        succes: false,
        message: e.toString(),
        storeProcedure: null,
      );
    }
  }

  //Consumo api buscar clinete
  Future<ApiResModel> getNombreCuenta(
    String token,
    int cuenta,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Cuenta/nombre/$cuenta");
    try {
      //url completa

      //Configuraciones del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
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

      //respuesta del servicio

      RespLogin respLogin = RespLogin.fromMap(res.data);

      //retornar respuesta correcta del api
      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: respLogin,
        storeProcedure: null,
      );
    } catch (e) {
      //en caso de error retornar el error
      return ApiResModel(
        url: url.toString(),
        succes: false,
        message: e.toString(),
        storeProcedure: null,
      );
    }
  }

  //Consu

//Consumo api buscar clinete
  Future<ApiResModel> getIdCuenta(
    String token,
    int cuenta,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Cuenta/id/$cuenta");
    try {
      //url completa

      //Configuraciones del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
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

      RespLogin respLogin = RespLogin.fromMap(res.data);

      //retornar respuesta correcta del api
      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: respLogin,
        storeProcedure: null,
      );
    } catch (e) {
      //en caso de error retornar el error
      return ApiResModel(
        url: url.toString(),
        succes: false,
        message: e.toString(),
        storeProcedure: null,
      );
    }
  }

  //Consumo api buscar clinete
  Future<ApiResModel> getClient(
    int empresa,
    String filter,
    String user,
    String token,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Cuenta/cliente");
    try {
      //url completa

      //Configuraciones del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "user": user,
          "filter": filter,
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

      //clientes retornador por el api
      List<ClientModel> clients = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = ClientModel.fromMap(item);
        //agregar item a la lista
        clients.add(responseFinally);
      }

      //retornar respuesta correcta del api
      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: clients,
        storeProcedure: null,
      );
    } catch (e) {
      //en caso de error retornar el error
      return ApiResModel(
        url: url.toString(),
        succes: false,
        message: e.toString(),
        storeProcedure: null,
      );
    }
  }

  //Consumo api obtner vendedores
  Future<ApiResModel> getSeller(
    String user,
    int doc,
    String serie,
    int empresa,
    String token,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Cuenta/vendedor");
    try {
      //url completa

      //configuraciones del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "user": user,
          "doc": doc.toString(),
          "serie": serie,
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

      //vendedores retornadps por el api
      List<SellerModel> sellers = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = SellerModel.fromMap(item);
        //agregar item a la lista
        sellers.add(responseFinally);
      }

      //Retornar respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: sellers,
        storeProcedure: null,
      );
    } catch (e) {
      //retornar respuesta incorrecta
      return ApiResModel(
        url: url.toString(),
        succes: false,
        message: e.toString(),
        storeProcedure: null,
      );
    }
  }
}
