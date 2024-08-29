// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:http/http.dart' as http;

class ProductService {
  // Url del servidor
  final String _baseUrl = Preferences.urlApi;

  Future<ApiResModel> getValidaProducto(
    String user,
    String serie,
    int tipoDocumento,
    int estacion,
    int empresa,
    int bodega,
    int tipoTransaccion,
    int unidadMedida,
    int producto,
    int cantidad,
    int tipoCambio,
    int moneda,
    int tipoPrecio,
    String token,
  ) async {
    //URL completa
    Uri url = Uri.parse("${_baseUrl}Producto/validate");
    try {
      //Configuraciones del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "user": user,
          "serie": serie,
          "tipoDocumento": "$tipoDocumento",
          "estacion": "$estacion",
          "empresa": "$empresa",
          "bodega": "$bodega",
          "tipoTransaccion": "$tipoTransaccion",
          "unidadMedida": "$unidadMedida",
          "producto": "$producto",
          "cantidad": "$cantidad",
          "tipoCambio": "$tipoCambio",
          "moneda": "$moneda",
          "tipoPrecio": "$tipoPrecio",
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

      //Lista para almacenar la respuesta del api
      List<String> mensajes = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        //agregar item a la lista
        mensajes.add(item);
      }
      //retornar respuesta correcta del api
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: mensajes,
        storeProcedure: null,
      );
    } catch (e) {
      //en caso de error retornar el error
      return ApiResModel(
        url: url.toString(),
        succes: false,
        response: e.toString(),
        storeProcedure: null,
      );
    }
  }

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
          response: res.data,
          storeProcedure: res.storeProcedure,
        );
      }

      RespLogin respLogin = RespLogin.fromMap(res.data);

      //retornar respuesta correcta del api
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: respLogin,
        storeProcedure: null,
      );
    } catch (e) {
      //en caso de error retornar el error
      return ApiResModel(
        url: url.toString(),
        succes: false,
        response: e.toString(),
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
    Uri url = Uri.parse("${_baseUrl}producto/Bodega");
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
          response: res.data,
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
        response: bodegas,
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

  Future<ApiResModel> getProduct(
    String search,
    String token,
    String user,
    int station,
    int start,
    int end,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Producto/buscar");
    try {
      //url completa

      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "user": user,
          "station": "$station",
          "search": search,
          "start": "$start",
          "end": "$end",
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
        response: products,
        storeProcedure: null,
      );
    } catch (e) {
      return ApiResModel(
        url: url.toString(),
        succes: false,
        response: e.toString(),
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
    int correntista,
    String cuentaCta,
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
          "correntista": correntista.toString(),
          "cuentaCta": cuentaCta,
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
        response: precios,
        storeProcedure: null,
      );
    } catch (e) {
      return ApiResModel(
        url: url.toString(),
        succes: false,
        storeProcedure: null,
        response: e.toString(),
      );
    }
  }

  //calcular precio por dias
  Future<ApiResModel> getFormulaPrecioU(
    String token,
    DateTime fechaIni,
    DateTime fechaFin,
    String precioU,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Producto/formula/precio/unitario");
    try {
      //url completa

      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "fechaIni": fechaIni.toIso8601String(),
          "fechaFin": fechaFin.toIso8601String(),
          "precioU": precioU
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

      List<PrecioDiaModel> precios = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = PrecioDiaModel.fromMap(item);
        //agregar item a la lista
        precios.add(responseFinally);
      }

      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: precios,
        storeProcedure: null,
      );
    } catch (e) {
      return ApiResModel(
        url: url.toString(),
        succes: false,
        storeProcedure: null,
        response: e.toString(),
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
          response: res.data,
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
        response: factor,
        storeProcedure: null,
      );
    } catch (e) {
      return ApiResModel(
        url: url.toString(),
        succes: false,
        response: e.toString(),
        storeProcedure: null,
      );
    }
  }

  //obtener las imagenes de cada producto
  Future<ApiResModel> getObjetosProducto(
    String token,
    int product,
    int um,
    int empresa,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Producto/imagenes/$product/$um/$empresa");
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
          response: res.data,
          storeProcedure: res.storeProcedure,
        );
      }

      //img empresa disponibles
      List<ObjetoProductoModel> imgProductos = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = ObjetoProductoModel.fromMap(item);

        //agregar item a la lista
        imgProductos.add(responseFinally);
      }

      //respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: imgProductos,
        storeProcedure: null,
      );
    } catch (e) {
      //en caso de error retornar el error
      return ApiResModel(
        url: url.toString(),
        succes: false,
        response: e.toString(),
        storeProcedure: null,
      );
    }
  }
}
