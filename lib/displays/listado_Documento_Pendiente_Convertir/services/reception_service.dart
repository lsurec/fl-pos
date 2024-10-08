import 'dart:convert';

import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:http/http.dart' as http;

class ReceptionService {
  //url del servidor
  final String _baseUrl = Preferences.urlApi;

  //obtener docummentos pendientes de vonvertir
  Future<ApiResModel> getDataPrint(
    String token,
    String user,
    int documento,
    int tipoDocumento,
    String serieDocumento,
    int empresa,
    int localizacion,
    int estacion,
    int fechaReg,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Recepcion/data/print");
    try {
      //url completa

      //configuraci9nes del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "user": user,
          "documento": "$documento",
          "tipoDocumento": "$tipoDocumento",
          "serieDocumento": serieDocumento,
          "empresa": "$empresa",
          "localizacion": "$localizacion",
          "estacion": "$estacion",
          "fechaReg": "$fechaReg",
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

      //documentos disp0onibles
      List<PrintConvertModel> detalles = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = PrintConvertModel.fromMap(item);
        //agregar item a la lista
        detalles.add(responseFinally);
      }

      //respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: detalles,
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

  //obtener docummentos pendientes de vonvertir
  Future<ApiResModel> getDetallesDocDestino(
    String token,
    String user,
    int documento,
    int tipoDocumento,
    String serieDocumento,
    int empresa,
    int localizacion,
    int estacion,
    int fechaReg,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Recepcion/documento/destino/detalles");
    try {
      //url completa

      //configuraci9nes del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "user": user,
          "documento": "$documento",
          "tipoDocumento": "$tipoDocumento",
          "serieDocumento": serieDocumento,
          "empresa": "$empresa",
          "localizacion": "$localizacion",
          "estacion": "$estacion",
          "fechaReg": "$fechaReg",
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

      //documentos disp0onibles
      List<DestinationDetailModel> detalles = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = DestinationDetailModel.fromMap(item);
        //agregar item a la lista
        detalles.add(responseFinally);
      }

      //respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: detalles,
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

  //Crear nueva cuenta correntista
  Future<ApiResModel> postConvertir(
    String token,
    ParamConvertDocModel doc,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Recepcion/documento/convertir");
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

      //si el api no responde
      if (response.statusCode != 200 && response.statusCode != 201) {
        return ApiResModel(
          url: url.toString(),
          succes: false,
          response: res.data,
          storeProcedure: res.storeProcedure,
        );
      }

      DocConvertModel resDoc = DocConvertModel.fromMap(res.data);

      //Retornar respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: resDoc,
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

  //Crear nueva cuenta correntista
  Future<ApiResModel> postActualizar(
    String user,
    String token,
    int consecutivo,
    double cantidad,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Recepcion/documento/actualizar");
    try {
      //url completa

      // Configurar Api y consumirla
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "bearer $token",
          "user": user,
          "consecutivo": "$consecutivo",
          "cantidad": "$cantidad",
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
        response: "ok",
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

  //obtener docummentos pendientes de vonvertir
  Future<ApiResModel> getDetallesDocOrigen(
    String token,
    String user,
    int documento,
    int tipoDocumento,
    String serieDocumento,
    int empresa,
    int localizacion,
    int estacion,
    int fechaReg,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Recepcion/documento/origen/detalles");
    try {
      //url completa

      //configuraci9nes del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "user": user,
          "documento": "$documento",
          "tipoDocumento": "$tipoDocumento",
          "serieDocumento": serieDocumento,
          "empresa": "$empresa",
          "localizacion": "$localizacion",
          "estacion": "$estacion",
          "fechaReg": "$fechaReg",
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

      //documentos disp0onibles
      List<OriginDetailModel> detalles = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = OriginDetailModel.fromMap(item);
        //agregar item a la lista
        detalles.add(responseFinally);
      }

      //respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: detalles,
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

  //obtener docummentos pendientes de vonvertir
  Future<ApiResModel> getTiposDoc(
    String user,
    String token,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Recepcion/tipos/documentos/$user");
    try {
      //url completa

      //configuraci9nes del api
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

      //documentos disp0onibles
      List<TypeDocModel> docs = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = TypeDocModel.fromMap(item);
        //agregar item a la lista
        docs.add(responseFinally);
      }

      //respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: docs,
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
  } //url del servidor

  //obtener docummentos pendientes de vonvertir
  Future<ApiResModel> getPendindgDocs(
    String user,
    String token,
    int doc,
    String fechaIni,
    String fechaFin,
    String criterio,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Recepcion/pending/documents");
    try {
      //url completa

      //configuraci9nes del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "user": user,
          "doc": "$doc",
          "fechaIni": fechaIni,
          "fechaFin": fechaFin,
          "criterio": criterio.isNotEmpty ? criterio : "empty",
          "opcion": criterio.isNotEmpty ? "0" : "1",
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

      //documentos disp0onibles
      List<OriginDocModel> docs = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = OriginDocModel.fromMap(item);
        //agregar item a la lista
        docs.add(responseFinally);
      }

      //respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: docs,
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
  } //url del servidor

  //obtener docunentos destino (para convertir un documento)
  Future<ApiResModel> getDestinationDocs(
    String user,
    String token,
    int doc,
    String serie,
    int empresa,
    int estacion,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Recepcion/destination/docs");
    try {
      //url completa

      //configuraci9nes del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "user": user,
          "doc": "$doc",
          "serie": serie,
          "empresa": "$empresa",
          "estacion": "$estacion",
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

      //documentos disp0onibles
      List<DestinationDocModel> docs = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = DestinationDocModel.fromMap(item);
        //agregar item a la lista
        docs.add(responseFinally);
      }

      //respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: docs,
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

  //Guadar cambios
  Future<ApiResModel> updateDoc(
    String token,
    UpdateDocModel doc,
  ) async {
    //url completa
    Uri url = Uri.parse("${_baseUrl}Recepcion/modify/doc");
    try {
      // Configurar Api y consumirla
      final response = await http.post(
        body: doc.toJson(),
        url,
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
        response: "ok",
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

  Future<ApiResModel> updateDocRef(
    String token,
    UpdateRefModel refModify,
  ) async {
    //url completa
    Uri url = Uri.parse("${_baseUrl}Recepcion/modify/doc/ref");
    try {
      // Configurar Api y consumirla
      final response = await http.post(
        body: refModify.toJson(),
        url,
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
        response: "ok",
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

  //anular transaccion
  Future<ApiResModel> anularTransaccion(
    String token,
    NewTransactionModel transaction,
  ) async {
    //url completa
    Uri url = Uri.parse("${_baseUrl}Recepcion/doc/anular/transaccion");
    try {
      // Configurar Api y consumirla
      final response = await http.post(
        body: transaction.toJson(),
        url,
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
        response: "ok",
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

  //Insertar transaccion

  Future<ApiResModel> insertarTransaccion(
    String token,
    NewTransactionModel transaction,
  ) async {
    //url completa
    Uri url = Uri.parse("${_baseUrl}Recepcion/doc/insertar/transaccion");
    try {
      // Configurar Api y consumirla
      final response = await http.post(
        body: transaction.toJson(),
        url,
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
        response: "ok",
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
