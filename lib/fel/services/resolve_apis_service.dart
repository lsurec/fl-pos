import 'package:flutter_post_printer_example/models/models.dart';
import 'package:http/http.dart' as http;

class ResolveApisService {
  //Mettodo generico para resolver peticiones GET
  Future<ApiResModel> resolveMethod(
    String url, //url del api que se va a usar
    Map<String, String> headers, //tooken pra las apis si se necesita
    int method, //metodo http que se va a usar
    String content, //contenido body
  ) async {
    final urlApi = Uri.parse(url);
    try {
      //url commmpleta del api

      // ignore: prefer_typing_uninitialized_variables
      var response;

      switch (method) {
        case 1: //POST

          response = await http.post(
            urlApi,
            body: content,
            headers: headers,
          );

          break;
        case 2: //PUT
          response = await http.put(
            urlApi,
            body: content,
            headers: headers,
          );
          break;
        case 3: //GET

          response = await http.get(
            urlApi,
            headers: headers,
          );
          break;
        case 4: //DELETE
          response = await http.delete(
            urlApi,
            body: content,
            headers: headers,
          );
          break;

        default:
          return ApiResModel(
            url: url.toString(),
            succes: false,
            message: "Solo se permiten los metodos POST, PUT, GET y DELETE",
            storeProcedure: null,
          );
      }

      if (response.statusCode != 200) {
        return ApiResModel(
          url: url.toString(),
          succes: false,
          message: response.body,
          storeProcedure: null,
        );
      }

      //configuracion y consumo del api

      //respuesta del api
      final resJson = response.body;

      //aplicaciones disponibles

      //respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: resJson,
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
}
