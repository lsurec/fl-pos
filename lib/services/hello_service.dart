import 'package:flutter_post_printer_example/models/models.dart';
import 'package:http/http.dart' as http;

class HelloService {
  //Api de prueba para verificr servicios
  Future<ApiResModel> getHello(
    String baseUrl,
  ) async {
    //Manejo de erroes
    Uri url = Uri.parse("${baseUrl}Hello");
    try {
      //url del servidor

      // Configurar Api y consumirla
      final response = await http.get(url);

      //si el api no responde
      if (response.statusCode != 200 && response.statusCode != 201) {
        return ApiResModel(
          url: url.toString(),
          succes: false,
          response: response.body,
          storeProcedure: null,
        );
      }

      // Asignar respuesta del Api

      //retornar respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: response.body,
        storeProcedure: null,
      );
    } catch (e) {
      //retornar respuesta incorecta
      return ApiResModel(
        url: url.toString(),
        succes: false,
        response: e.toString(),
        storeProcedure: null,
      );
    }
  }
}
