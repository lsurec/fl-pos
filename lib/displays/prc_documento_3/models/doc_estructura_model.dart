import 'dart:convert';

class DocEstructuraModel {
  bool docConfirmarOrden;
  int? docMesa;
  int? docUbicacion;
  String? docLatitdud;
  String? docLongitud;
  int consecutivoInterno;
  double docTraMonto;
  double docCaMonto;
  int? docCuentaVendedor;
  int docIdCertificador;
  int docIdDocumentoRef;
  String? docFelNumeroDocumento;
  String? docFelSerie;
  String? docFelUUID;
  String? docFelFechaCertificacion;
  String docFechaDocumento;
  int docCuentaCorrentista;
  String docCuentaCta;
  int docTipoDocumento;
  String docSerieDocumento;
  int docEmpresa;
  int docEstacionTrabajo;
  String docUserName;
  String docObservacion1;
  int docTipoPago;
  int docElementoAsignado;
  List<DocTransaccion> docTransaccion;
  List<DocCargoAbono> docCargoAbono;
  int? docRefTipoReferencia;
  DateTime? docRefFechaIni;
  DateTime? docRefFechaFin;
  DateTime? docFechaIni;
  DateTime? docFechaFin;
  String? docRefObservacion2;
  String? docRefDescripcion;
  String? docRefObservacion3;
  String? docRefObservacion;
  String? docComanda;

  DocEstructuraModel({
    required this.docConfirmarOrden,
    required this.docComanda,
    required this.docMesa,
    required this.docUbicacion,
    required this.docLatitdud,
    required this.docLongitud,
    required this.consecutivoInterno,
    required this.docTraMonto,
    required this.docCaMonto,
    required this.docCuentaVendedor,
    required this.docIdCertificador,
    required this.docIdDocumentoRef,
    required this.docFelNumeroDocumento,
    required this.docFelSerie,
    required this.docFelUUID,
    required this.docFelFechaCertificacion,
    required this.docFechaDocumento,
    required this.docCuentaCorrentista,
    required this.docCuentaCta,
    required this.docTipoDocumento,
    required this.docSerieDocumento,
    required this.docEmpresa,
    required this.docEstacionTrabajo,
    required this.docUserName,
    required this.docObservacion1,
    required this.docTipoPago,
    required this.docElementoAsignado,
    required this.docTransaccion,
    required this.docCargoAbono,
    required this.docRefTipoReferencia,
    required this.docRefFechaIni,
    required this.docRefFechaFin,
    required this.docFechaIni,
    required this.docFechaFin,
    required this.docRefObservacion2,
    required this.docRefDescripcion,
    required this.docRefObservacion3,
    required this.docRefObservacion,
  });

  factory DocEstructuraModel.fromJson(String str) =>
      DocEstructuraModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DocEstructuraModel.fromMap(Map<String, dynamic> json) =>
      DocEstructuraModel(
        docConfirmarOrden: json["Doc_Confirmar_Orden"] ?? false,
        docComanda: json["Doc_Comanda"],
        docMesa: json["Doc_Mesa"],
        docUbicacion: json["Doc_Ubicacion"],
        docLatitdud: json["Doc_Latitdud"] ?? 0,
        docLongitud: json["Doc_Longitud"] ?? 0,
        consecutivoInterno: json["Consecutivo_Interno"] ?? 0,
        docTraMonto: json["Doc_Tra_Monto"].toDouble(),
        docCaMonto: json["Doc_CA_Monto"].toDouble(),
        docCuentaVendedor: json["Doc_Cuenta_Correntista_Ref"],
        docIdCertificador: json["Doc_ID_Certificador"],
        docIdDocumentoRef: json["Doc_ID_Documento_Ref"],
        docFelNumeroDocumento: json["Doc_FEL_numeroDocumento"],
        docFelSerie: json["Doc_FEL_Serie"],
        docFelUUID: json["Doc_FEL_UUID"],
        docFelFechaCertificacion: json["Doc_FEL_fechaCertificacion"],
        docFechaDocumento: json["Doc_Fecha_Documento"],
        docCuentaCorrentista: json["Doc_Cuenta_Correntista"],
        docCuentaCta: json["Doc_Cuenta_Cta"],
        docTipoDocumento: json["Doc_Tipo_Documento"],
        docSerieDocumento: json["Doc_Serie_Documento"],
        docEmpresa: json["Doc_Empresa"],
        docEstacionTrabajo: json["Doc_Estacion_Trabajo"],
        docUserName: json["Doc_UserName"],
        docObservacion1: json["Doc_Observacion_1"],
        docTipoPago: json["Doc_Tipo_Pago"],
        docElementoAsignado: json["Doc_Elemento_Asignado"],
        docTransaccion: List<DocTransaccion>.from(
          json["Doc_Transaccion"].map((x) => DocTransaccion.fromMap(x)),
        ),
        docCargoAbono: List<DocCargoAbono>.from(
            json["Doc_Cargo_Abono"].map((x) => DocCargoAbono.fromMap(x))),
        docRefTipoReferencia: json["Doc_Ref_Tipo_Referencia"],
        docRefFechaIni: json["Doc_Ref_Fecha_Ini"] != null
            ? DateTime.parse(json["Doc_Ref_Fecha_Ini"])
            : null,
        docRefFechaFin: json["Doc_Ref_Fecha_Fin"] != null
            ? DateTime.parse(json["Doc_Ref_Fecha_Fin"])
            : null,
        docFechaIni: json["Doc_Fecha_Ini"] != null
            ? DateTime.parse(json["Doc_Fecha_Ini"])
            : null,
        docFechaFin: json["Doc_Fecha_Fin"] != null
            ? DateTime.parse(json["Doc_Fecha_Fin"])
            : null,
        docRefObservacion2: json["Doc_Ref_Observacion_2"],
        docRefDescripcion: json["Doc_Ref_Descripcion"],
        docRefObservacion3: json["Doc_Ref_Observacion_3"],
        docRefObservacion: json["Doc_Ref_Observacion"],
      );

  Map<String, dynamic> toMap() => {
        "Doc_Confirmar_Orden": docConfirmarOrden,
        "Doc_Comanda": docComanda,
        "Doc_Mesa": docMesa,
        "Doc_Ubicacion": docUbicacion,
        "Doc_Latitdud": docLatitdud,
        "Doc_Longitud": docLongitud,
        "Consecutivo_Interno": consecutivoInterno,
        "Doc_Tra_Monto": docTraMonto,
        "Doc_CA_Monto": docCaMonto,
        "Doc_ID_Certificador": docIdCertificador,
        "Doc_Cuenta_Correntista_Ref": docCuentaVendedor,
        "Doc_ID_Documento_Ref": docIdDocumentoRef,
        "Doc_FEL_numeroDocumento": docFelNumeroDocumento,
        "Doc_FEL_Serie": docFelSerie,
        "Doc_FEL_UUID": docFelUUID,
        "Doc_FEL_fechaCertificacion": docFelFechaCertificacion,
        "Doc_Fecha_Documento": docFechaDocumento,
        "Doc_Cuenta_Correntista": docCuentaCorrentista,
        "Doc_Cuenta_Cta": docCuentaCta,
        "Doc_Tipo_Documento": docTipoDocumento,
        "Doc_Serie_Documento": docSerieDocumento,
        "Doc_Empresa": docEmpresa,
        "Doc_Estacion_Trabajo": docEstacionTrabajo,
        "Doc_UserName": docUserName,
        "Doc_Observacion_1": docObservacion1,
        "Doc_Tipo_Pago": docTipoPago,
        "Doc_Elemento_Asignado": docElementoAsignado,
        "Doc_Transaccion":
            List<dynamic>.from(docTransaccion.map((x) => x.toMap())),
        "Doc_Cargo_Abono":
            List<dynamic>.from(docCargoAbono.map((x) => x.toMap())),
        "Doc_Ref_Tipo_Referencia": docRefTipoReferencia,
        "Doc_Ref_Fecha_Ini": docRefFechaIni?.toIso8601String(),
        "Doc_Ref_Fecha_Fin": docRefFechaFin?.toIso8601String(),
        "Doc_Fecha_Ini": docFechaIni?.toIso8601String(),
        "Doc_Fecha_Fin": docFechaFin?.toIso8601String(),
        "Doc_Ref_Observacion_2": docRefObservacion2,
        "Doc_Ref_Descripcion": docRefDescripcion,
        "Doc_Ref_Observacion_3": docRefObservacion3,
        "Doc_Ref_Observacion": docRefObservacion,
      };
}

class DocCargoAbono {
  int dConsecutivoInterno;
  int consecutivoInterno;
  int tipoCargoAbono;
  double monto;
  double cambio;
  double tipoCambio;
  int moneda;
  double montoMoneda;
  dynamic referencia;
  dynamic autorizacion;
  dynamic banco;
  dynamic cuentaBancaria;

  DocCargoAbono({
    required this.dConsecutivoInterno,
    required this.consecutivoInterno,
    required this.tipoCargoAbono,
    required this.monto,
    required this.cambio,
    required this.tipoCambio,
    required this.moneda,
    required this.montoMoneda,
    required this.referencia,
    required this.autorizacion,
    required this.banco,
    required this.cuentaBancaria,
  });

  factory DocCargoAbono.fromJson(String str) =>
      DocCargoAbono.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DocCargoAbono.fromMap(Map<String, dynamic> json) => DocCargoAbono(
        consecutivoInterno: json["Consecutivo_Interno"] ?? 0,
        dConsecutivoInterno: json["D_Consecutivo_Interno"] ?? 0,
        tipoCargoAbono: json["Tipo_Cargo_Abono"],
        monto: json["Monto"]?.toDouble() ?? 0,
        cambio: json["Cambio"]?.toDouble() ?? 0,
        tipoCambio: json["Tipo_Cambio"]?.toDouble(),
        moneda: json["Moneda"],
        montoMoneda: json["Monto_Moneda"]?.toDouble(),
        referencia: json["Referencia"],
        autorizacion: json["Autorizacion"],
        banco: json["Banco"],
        cuentaBancaria: json["Cuenta_Bancaria"],
      );

  Map<String, dynamic> toMap() => {
        "Consecutivo_Interno": consecutivoInterno,
        "D_Consecutivo_Interno": dConsecutivoInterno,
        "Tipo_Cargo_Abono": tipoCargoAbono,
        "Monto": monto,
        "Cambio": cambio,
        "Tipo_Cambio": tipoCambio,
        "Moneda": moneda,
        "Monto_Moneda": montoMoneda,
        "Referencia": referencia,
        "Autorizacion": autorizacion,
        "Banco": banco,
        "Cuenta_Bancaria": cuentaBancaria,
      };
}

class DocTransaccion {
  String? traObservacion;
  int traConsecutivoInterno;
  int? traConsecutivoInternoPadre;
  int dConsecutivoInterno;
  int traBodega;
  int traProducto;
  int traUnidadMedida;
  int traCantidad;
  double traTipoCambio;
  int traMoneda;
  int? traTipoPrecio;
  int? traFactorConversion;
  int traTipoTransaccion;
  double traMonto;
  double? traMontoDias;

  DocTransaccion({
    required this.traObservacion,
    required this.traConsecutivoInterno,
    required this.traConsecutivoInternoPadre,
    required this.dConsecutivoInterno,
    required this.traBodega,
    required this.traProducto,
    required this.traUnidadMedida,
    required this.traCantidad,
    required this.traTipoCambio,
    required this.traMoneda,
    required this.traTipoPrecio,
    required this.traFactorConversion,
    required this.traTipoTransaccion,
    required this.traMonto,
    required this.traMontoDias,
  });

  factory DocTransaccion.fromJson(String str) =>
      DocTransaccion.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DocTransaccion.fromMap(Map<String, dynamic> json) => DocTransaccion(
        traObservacion: json["Tra_Observacion"],
        traConsecutivoInterno: json["Tra_Consecutivo_Interno"],
        traConsecutivoInternoPadre: json["Tra_Consecutivo_Interno_Padre"],
        dConsecutivoInterno: json["D_Consecutivo_Interno"] ?? 0,
        traBodega: json["Tra_Bodega"],
        traProducto: json["Tra_Producto"],
        traUnidadMedida: json["Tra_Unidad_Medida"],
        traCantidad: json["Tra_Cantidad"],
        traTipoCambio: json["Tra_Tipo_Cambio"]?.toDouble(),
        traMoneda: json["Tra_Moneda"],
        traTipoPrecio: json["Tra_Tipo_Precio"],
        traFactorConversion: json["Tra_Factor_Conversion"],
        traTipoTransaccion: json["Tra_Tipo_Transaccion"],
        traMonto: json["Tra_Monto"].toDouble(),
        traMontoDias: json["Tra_Monto_Dias"]?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "Tra_Observacion": traObservacion,
        "Tra_Consecutivo_Interno": traConsecutivoInterno,
        "Tra_Consecutivo_Interno_Padre": traConsecutivoInternoPadre,
        "D_Consecutivo_Interno": dConsecutivoInterno,
        "Tra_Bodega": traBodega,
        "Tra_Producto": traProducto,
        "Tra_Unidad_Medida": traUnidadMedida,
        "Tra_Cantidad": traCantidad,
        "Tra_Tipo_Cambio": traTipoCambio,
        "Tra_Moneda": traMoneda,
        "Tra_Tipo_Precio": traTipoPrecio,
        "Tra_Factor_Conversion": traFactorConversion,
        "Tra_Tipo_Transaccion": traTipoTransaccion,
        "Tra_Monto": traMonto,
        "Tra_Monto_Dias": traMontoDias,
      };
}

class GuarnicionModel {
  int productoCaracteristica;
  int? productoCaracteristicaPadre;

  GuarnicionModel({
    required this.productoCaracteristica,
    required this.productoCaracteristicaPadre,
  });

  factory GuarnicionModel.fromJson(String str) =>
      GuarnicionModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GuarnicionModel.fromMap(Map<String, dynamic> json) => GuarnicionModel(
        productoCaracteristica: json["productoCaracteristica"],
        productoCaracteristicaPadre: json["productoCaracteristicaPadre"],
      );

  Map<String, dynamic> toMap() => {
        "productoCaracteristica": productoCaracteristica,
        "productoCaracteristicaPadre": productoCaracteristicaPadre,
      };
}
