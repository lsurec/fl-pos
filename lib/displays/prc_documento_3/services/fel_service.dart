import 'dart:convert';

import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/fel/models/models.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:http/http.dart' as http;

class FelService {
  final String _baseUrl = Preferences.urlApi;

  //Obtner empresas
  Future<ApiResModel> getReceptor(
    String token,
    String llave,
    String prefijo,
    String receptor,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Fel/consulta/receptor");
    try {
      //url completa

      //configuracion del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "llave": llave,
          "prefijo": prefijo,
          "receptor": receptor,
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

      //Respuesta corerecta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: res.data,
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

  Future<ApiResModel> postXmlUpdate(
    String token,
    PostDocXmlModel doc,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Fel/doc/xml");
    try {
      //url completa

      // Configurar Api y consumirla
      final response = await http.post(
        url,
        body: doc.toJson(),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "bearer $token",
        },
      );

      ResponseModel res = ResponseModel.fromMap(jsonDecode(response.body));

      if (response.statusCode != 200 && response.statusCode != 201) {
        return ApiResModel(
          url: url.toString(),
          succes: false,
          response: res.data,
          storeProcedure: res.storeProcedure,
        );
      }

      //series disponibñes
      List<DataFelModel> documentos = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = DataFelModel.fromMap(item);
        //agregar item a la lista
        documentos.add(responseFinally);
      }

      //respuesta corecta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: documentos,
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

  Future<ApiResModel> postInfile(
    String api,
    DataInfileModel data,
    String token,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Fel/infile/$api");

    try {
      //url completa

      // Configurar Api y consumirla
      final response = await http.post(
        url,
        body: data.toJson(),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "bearer $token",
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

      //Retornar respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: res.data,
        storeProcedure: null,
      );
    } catch (e) {
      //retornar respuesta incorrecta
      return ApiResModel(
        url: url.toString(),
        succes: false,
        response: e.toString(),
        storeProcedure: null,
      );
    }
  }

  //obtner series
  Future<ApiResModel> getCredenciales(
    int certificador,
    int empresa,
    String user,
    String token,
  ) async {
    Uri url =
        Uri.parse("${_baseUrl}Fel/credenciales/$certificador/$empresa/$user");
    try {
      //url completa

      //Configuracion del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
        },
      );

      ResponseModel res = ResponseModel.fromMap(jsonDecode(response.body));

      if (response.statusCode != 200 && response.statusCode != 201) {
        return ApiResModel(
          url: url.toString(),
          succes: false,
          response: res.data,
          storeProcedure: res.storeProcedure,
        );
      }

      //series disponibñes
      List<CredencialModel> documentos = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = CredencialModel.fromMap(item);
        //agregar item a la lista
        documentos.add(responseFinally);
      }

      //respuesta corecta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: documentos,
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

  Future<ApiResModel> getDocXml(
    String user,
    String token,
    int consecutivo,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Fel/xml/cert/$user/$consecutivo");
    try {
      //url completa

      //Configuracion del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
        },
      );

      ResponseModel res = ResponseModel.fromMap(jsonDecode(response.body));

      if (response.statusCode != 200 && response.statusCode != 201) {
        return ApiResModel(
          url: url.toString(),
          succes: false,
          response: res.data,
          storeProcedure: res.storeProcedure,
        );
      }

      //series disponibñes
      List<DocXmlModel> documentos = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = DocXmlModel.fromMap(item);
        //agregar item a la lista
        documentos.add(responseFinally);
      }

      //respuesta corecta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: documentos,
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

  //Obtner empresas
  Future<ApiResModel> getApiCatalogo(
    String user,
    String token,
    String api,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Fel/api/$api/$user");
    try {
      //url completa

      //configuracion del api
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
          response: res.data,
          storeProcedure: res.storeProcedure,
        );
      }

      //Empresas disponuibles
      List<ApiModel> empresas = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = ApiModel.fromMap(item);
        //agregar item a la lista
        empresas.add(responseFinally);
      }

      //Respuesta corerecta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: empresas,
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

//Obtner empresas
  Future<ApiResModel> getApiParametros(
    String user,
    String token,
    int api,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Fel/parametros/$api/$user");
    try {
      //url completa

      //configuracion del api
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
          response: res.data,
          storeProcedure: res.storeProcedure,
        );
      }

      //Empresas disponuibles
      List<ApiParamModel> params = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = ApiParamModel.fromMap(item);
        //agregar item a la lista
        params.add(responseFinally);
      }

      //Respuesta corerecta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: params,
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

  Future<ApiResModel> postDte(
    String urlApi,
    Map<String, String> headers,
    String body,
    String token,
  ) async {
    Uri url = Uri.parse(urlApi);

    try {
      headers["Authorization"] = "bearer $token";

      // Configurar Api y consumirla
      final response = await http.post(
        url,
        body: body,
        headers: headers,
      );

      //si el api no responde
      if (response.statusCode != 200 && response.statusCode != 201) {
        return ApiResModel(
          url: url.toString(),
          succes: false,
          response: response.body,
          storeProcedure: null,
        );
      }

      //Retornar respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: response.body,
        storeProcedure: null,
      );
    } catch (e) {
      //retornar respuesta incorrecta
      return ApiResModel(
        url: url.toString(),
        succes: false,
        response: e.toString(),
        storeProcedure: null,
      );
    }
  }
}
