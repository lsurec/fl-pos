import 'dart:convert';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:http/http.dart' as http;

class ProductService {
  // Url del servidor
  final String _baseUrl = Preferences.urlApi;

  Future<ApiResModel> getSku(
    String token,
    int product,
    int um,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Producto/sku/$product/$um");
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

  Future<ApiResModel> getDescripcion(
    String token,
    int product,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Producto/descripcion/$product");
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
      final resJson = json.decode(response.body);

      RespLogin respLogin = RespLogin.fromMap(resJson);

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

  //obtener bodegas, existencias de un producto
  Future<ApiResModel> getBodegaProducto(
    String user,
    int empresa,
    int estacion,
    int producto,
    int um,
    String token,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Bodega/producto");
    try {
      //url completa

      //configuracion del api
      final response = await http.get(
        url,
        headers: {
          "user": user,
          "empresa": "$empresa",
          "estacion": "$estacion",
          "producto": "$producto",
          "um": "$um",
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

      //bodegas disponibles
      List<BodegaProductoModel> bodegas = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = BodegaProductoModel.fromMap(item);
        //agregar item a la lista
        bodegas.add(responseFinally);
      }

      //respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: bodegas,
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

  Future<ApiResModel> getProductId(
    String id,
    String token,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Producto/buscar/id/$id");
    try {
      //url completa

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

      List<ProductModel> products = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = ProductModel.fromMap(item);
        //agregar item a la lista
        products.add(responseFinally);
      }

      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: products,
        storeProcedure: null,
      );
    } catch (e) {
      return ApiResModel(
        url: url.toString(),
        succes: false,
        message: e.toString(),
        storeProcedure: null,
      );
    }
  }

  Future<ApiResModel> getProductDesc(
    String desc,
    String token,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Producto/buscar/descripcion/$desc");
    try {
      //url completa

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

      List<ProductModel> products = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = ProductModel.fromMap(item);
        //agregar item a la lista
        products.add(responseFinally);
      }

      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: products,
        storeProcedure: null,
      );
    } catch (e) {
      return ApiResModel(
        url: url.toString(),
        succes: false,
        message: e.toString(),
        storeProcedure: null,
      );
    }
  }

  Future<ApiResModel> getPrecios(
    int bodega,
    int producto,
    int um,
    String user,
    String token,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Producto/precios");
    try {
      //url completa

      final response = await http.get(
        url,
        headers: {
          "bodega": bodega.toString(),
          "producto": producto.toString(),
          'um': um.toString(),
          'user': user,
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

      List<PrecioModel> precios = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = PrecioModel.fromMap(item);
        //agregar item a la lista
        precios.add(responseFinally);
      }

      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: precios,
        storeProcedure: null,
      );
    } catch (e) {
      return ApiResModel(
        url: url.toString(),
        succes: false,
        storeProcedure: null,
        message: e.toString(),
      );
    }
  }

  Future<ApiResModel> getFactorConversion(
    int bodega,
    int producto,
    int um,
    String user,
    String token,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Producto/factor/conversion");
    try {
      //url completa

      final response = await http.get(
        url,
        headers: {
          "bodega": bodega.toString(),
          "producto": producto.toString(),
          'um': um.toString(),
          'user': user,
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

      List<FactorConversionModel> factor = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = FactorConversionModel.fromMap(item);
        //agregar item a la lista
        factor.add(responseFinally);
      }

      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: factor,
        storeProcedure: null,
      );
    } catch (e) {
      return ApiResModel(
        url: url.toString(),
        succes: false,
        message: e.toString(),
        storeProcedure: null,
      );
    }
  }
}
