import 'dart:convert';

class DocEstructuraModel {
  num docTraMonto;
  num docCaMonto;
  int? docCuentaVendedor;
  int docIdCertificador;
  int docIdDocumentoRef;
  int? docFelNumeroDocumento;
  String? docFelSerie;
  String? docFelUUID;
  DateTime? docFelFechaCertificacion;
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

  DocEstructuraModel({
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
  });

  factory DocEstructuraModel.fromJson(String str) =>
      DocEstructuraModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DocEstructuraModel.fromMap(Map<String, dynamic> json) =>
      DocEstructuraModel(
        docTraMonto: json["Doc_Tra_Monto"],
        docCaMonto: json["Doc_CA_Monto"],
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
      );

  Map<String, dynamic> toMap() => {
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
      };
}

class DocCargoAbono {
  int tipoCargoAbono;
  num monto;
  num cambio;
  num tipoCambio;
  int moneda;
  num montoMoneda;
  dynamic referencia;
  dynamic autorizacion;
  dynamic banco;
  dynamic cuentaBancaria;

  DocCargoAbono({
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
        tipoCargoAbono: json["Tipo_Cargo_Abono"],
        monto: json["Monto"]?.tonum() ?? 0,
        cambio: json["Cambio"]?.tonum() ?? 0,
        tipoCambio: json["Tipo_Cambio"],
        moneda: json["Moneda"],
        montoMoneda: json["Monto_Moneda"]?.tonum(),
        referencia: json["Referencia"],
        autorizacion: json["Autorizacion"],
        banco: json["Banco"],
        cuentaBancaria: json["Cuenta_Bancaria"],
      );

  Map<String, dynamic> toMap() => {
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
  int traConsecutivoInterno;
  int? traConsecutivoInternoPadre;
  int traBodega;
  int traProducto;
  int traUnidadMedida;
  int traCantidad;
  num traTipoCambio;
  int traMoneda;
  int? traTipoPrecio;
  int? traFactorConversion;
  int traTipoTransaccion;
  num traMonto;

  DocTransaccion({
    required this.traConsecutivoInterno,
    required this.traConsecutivoInternoPadre,
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
  });

  factory DocTransaccion.fromJson(String str) =>
      DocTransaccion.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DocTransaccion.fromMap(Map<String, dynamic> json) => DocTransaccion(
        traConsecutivoInterno: json["Tra_Consecutivo_Interno"],
        traConsecutivoInternoPadre: json["Tra_Consecutivo_Interno_Padre"],
        traBodega: json["Tra_Bodega"],
        traProducto: json["Tra_Producto"],
        traUnidadMedida: json["Tra_Unidad_Medida"],
        traCantidad: json["Tra_Cantidad"],
        traTipoCambio: json["Tra_Tipo_Cambio"]?.tonum(),
        traMoneda: json["Tra_Moneda"],
        traTipoPrecio: json["Tra_Tipo_Precio"],
        traFactorConversion: json["Tra_Factor_Conversion"],
        traTipoTransaccion: json["Tra_Tipo_Transaccion"],
        traMonto: json["Tra_Monto"],
      );

  Map<String, dynamic> toMap() => {
        "Tra_Consecutivo_Interno": traConsecutivoInterno,
        "Tra_Consecutivo_Interno_Padre": traConsecutivoInternoPadre,
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
      };
}
