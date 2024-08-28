import 'dart:convert';

import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:http/http.dart' as http;

class TareaService {
  final String _baseUrl = Preferences.urlApi;

  //Consumo api para obtener ultimas 10 tareas
  Future<ApiResModel> getTopTareas(
    String user,
    String token,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Tareas/$user/10");
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

      //Ultimas 10 tareas retornadas por el api
      List<TareaModel> tareas = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = TareaModel.fromMap(item);
        //agregar item a la lista
        tareas.add(responseFinally);
      }

      //retornar respuesta correcta del api
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: tareas,
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

  //Consumo api para obtener tareas de la busqueda por descripción.
  Future<ApiResModel> getTareasDescripcion(
    String user,
    String token,
    String filtro,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Tareas/buscar");
    try {
      //url completa

      //Configuraciones del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "filtro": filtro,
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

      //Tareas por busqueda de descripcion retornadas por api
      List<TareaModel> tareas = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = TareaModel.fromMap(item);
        //agregar item a la lista
        tareas.add(responseFinally);
      }

      //retornar respuesta correcta del api
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: tareas,
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

  //Consumo api para obtener tareas de la busqueda por descripción.
  Future<ApiResModel> getTareas(
    String user,
    String token,
    String filtro,
    int opcion,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Tareas/buscar");
    try {
      //url completa

      //Configuraciones del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "filtro": filtro,
          "user": user,
          "opcion": opcion.toString(),
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

      //Tareas por busqueda de descripcion retornadas por api
      List<TareaModel> tareas = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = TareaModel.fromMap(item);
        //agregar item a la lista
        tareas.add(responseFinally);
      }

      //retornar respuesta correcta del api
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: tareas,
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

  //obtener tareas por rango y filtro de busqueda

  //Consumo api para obtener tareas de la busqueda por descripción.
  Future<ApiResModel> getRangoTareas(
    String user,
    String token,
    String filtro,
    int rangoIni,
    int rangoFin,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Tareas/buscar");
    try {
      //url completa

      //Configuraciones del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "filtro": filtro,
          "user": user,
          "rangoIni": rangoIni.toString(),
          "rangoFin": rangoFin.toString(),
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

      //Tareas por busqueda de descripcion retornadas por api
      List<TareaModel> tareas = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = TareaModel.fromMap(item);
        //agregar item a la lista
        tareas.add(responseFinally);
      }

      //retornar respuesta correcta del api
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: tareas,
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

  //Consumo api para obtener tareas de la busqueda por id de referencia.
  Future<ApiResModel> getTareasIdReferencia(
    String user,
    String token,
    String filtro,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Tareas/buscar/Id/Referencia");
    try {
      //url completa

      //Configuraciones del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "filtro": filtro,
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

      //Tareas por busqueda de descripcion retornadas por api
      List<TareaModel> tareas = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = TareaModel.fromMap(item);
        //agregar item a la lista
        tareas.add(responseFinally);
      }

      //retornar respuesta correcta del api
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: tareas,
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

  //Consumo api para obtener tareas de la busqueda por id de referencia.
  Future<ApiResModel> getEstado(
    String token,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Tareas/estados");
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

      //Guardar los estados retornadas por api
      List<EstadoModel> estados = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = EstadoModel.fromMap(item);
        //agregar item a la lista
        estados.add(responseFinally);
      }

      //retornar respuesta correcta del api
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: estados,
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

  //Obtener Tipos de Tarea
  Future<ApiResModel> getTipoTarea(
    String user,
    String token,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Tareas/tipos/$user");
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

      //Tareas por busqueda de descripcion retornadas por api
      List<TipoTareaModel> tipos = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = TipoTareaModel.fromMap(item);
        //agregar item a la lista
        tipos.add(responseFinally);
      }

      //retornar respuesta correcta del api
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: tipos,
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

  //Consumo api para obtener prioridades
  Future<ApiResModel> getPrioridad(
    String user,
    String token,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Tareas/tipo/prioridad/$user");
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

      //Tareas por busqueda de descripcion retornadas por api
      List<PrioridadModel> prioridades = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = PrioridadModel.fromMap(item);
        //agregar item a la lista
        prioridades.add(responseFinally);
      }

      //retornar respuesta correcta del api
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: prioridades,
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

  //Consumo api para obtener periodicidades
  Future<ApiResModel> getPeriodicidad(
    String user,
    String token,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Tareas/tiempo/periodicidad/$user");
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

      //Tareas por busqueda de descripcion retornadas por api
      List<PeriodicidadModel> periodicidades = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = PeriodicidadModel.fromMap(item);
        //agregar item a la lista
        periodicidades.add(responseFinally);
      }

      //retornar respuesta correcta del api
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: periodicidades,
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

  //Consumo api para obtener los comentarios de una tarea
  Future<ApiResModel> getComentario(
    String user,
    String token,
    int tarea,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Tareas/comentarios");
    try {
      //url completa
      //Configuraciones del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "user": user,
          "tarea": tarea.toString(),
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

      //Comentarios retornados por api
      List<ComentarioModel> comentarios = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = ComentarioModel.fromMap(item);
        //agregar item a la lista
        comentarios.add(responseFinally);
      }

      //retornar respuesta correcta del api
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: comentarios,
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

  //Consumo api para obtener los objetos de un comentario de una tarea
  Future<ApiResModel> getObjetoComentario(
    String token,
    int tarea,
    int tareaComentario,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Tareas/comentario/objetos");
    try {
      //url completa
      //Configuraciones del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "tarea": tarea.toString(),
          "tareaComentario": tareaComentario.toString(),
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

      //Objetos del comentario retornados por api
      List<ObjetoComentarioModel> objetos = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = ObjetoComentarioModel.fromMap(item);
        //agregar item a la lista
        objetos.add(responseFinally);
      }

      //retornar respuesta correcta del api
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: objetos,
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

  //Consumo api para obtener al responsable de una tarea y los que han sido responsables de la tarea
  Future<ApiResModel> getResponsable(
    String user,
    String token,
    int tarea,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Tareas/responsables");
    try {
      //url completa
      //Configuraciones del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "user": user,
          "tarea": tarea.toString(),
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

      //Responsables retornados por api
      List<ResponsableModel> responsables = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = ResponsableModel.fromMap(item);
        //agregar item a la lista
        responsables.add(responseFinally);
      }

      //retornar respuesta correcta del api
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: responsables,
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

  //Consumo api para obtener a los invitados de una tarea
  Future<ApiResModel> getInvitado(
    String user,
    String token,
    int tarea,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Tareas/invitados");
    try {
      //url completa
      //Configuraciones del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "user": user,
          "tarea": tarea.toString(),
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

      //Invitados retornados por api
      List<InvitadoModel> invitados = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = InvitadoModel.fromMap(item);
        //agregar item a la lista
        invitados.add(responseFinally);
      }

      //retornar respuesta correcta del api
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: invitados,
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

//Servicio para crear una nueva tarea
  Future<ApiResModel> postTarea(
    String token,
    NuevaTareaModel tarea,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Tareas/tarea");
    try {
      //url completa
      // Configurar Api y consumirla
      final response = await http.post(
        url,
        body: tarea.toJson(),
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

      //Invitado nuevo retornado por api
      List<NuevaTareaModel> resTarea = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = NuevaTareaModel.fromMap(item);
        //agregar item a la lista
        resTarea.add(responseFinally);
      }

      //Retornar respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: resTarea,
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

  //Consumo api para actualizar el estado de la tarea.
  Future<ApiResModel> postEstadoTarea(
    String token,
    ActualizarEstadoModel estado,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Tareas/estado/tarea");
    try {
      //url completa

      // Configurar Api y consumirla
      final response = await http.post(
        url,
        body: estado.toJson(),
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

  //Consumo api para actualizar el nivel de prioridad de la tarea.
  Future<ApiResModel> postPrioridadTarea(
    String token,
    ActualizarPrioridadModel prioridad,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Tareas/prioridad/tarea");
    try {
      //url completa

      // Configurar Api y consumirla
      final response = await http.post(
        url,
        body: prioridad.toJson(),
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

  //Consumo api para eliminar usuarios invitados de la tarea.
  Future<ApiResModel> postEliminarInvitado(
      String token, EliminarUsuarioModel usuario, int tareaUser) async {
    Uri url = Uri.parse("${_baseUrl}Tareas/eliminar/usuario/invitado");
    try {
      //url completa
      // Configurar Api y consumirla
      final response = await http.post(
        url,
        body: usuario.toJson(),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "bearer $token",
          "tareaUser": tareaUser.toString(),
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

  //Consumo api para agregar usuarios invitados a la tarea.
  Future<ApiResModel> postInvitados(
    String token,
    NuevoUsuarioModel usuario,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Tareas/usuario/invitado");
    try {
      //url completa
      // Configurar Api y consumirla
      final response = await http.post(
        url,
        body: usuario.toJson(),
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

      //Invitado nuevo retornado por api
      List<ResNuevoUsuarioModel> invitado = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = ResNuevoUsuarioModel.fromMap(item);
        //agregar item a la lista
        invitado.add(responseFinally);
      }

      //Retornar respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: invitado,
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

  //Consumo api para agregar usuario responsable a la tarea.
  Future<ApiResModel> postResponsable(
    String token,
    NuevoUsuarioModel usuario,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Tareas/usuario/responsable");
    try {
      //url completa
      // Configurar Api y consumirla
      final response = await http.post(
        url,
        body: usuario.toJson(),
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

      //Invitado nuevo retornado por api
      List<ResNuevoUsuarioModel> responsable = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = ResNuevoUsuarioModel.fromMap(item);
        //agregar item a la lista
        responsable.add(responseFinally);
      }

      //Retornar respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: responsable,
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
