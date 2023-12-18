import 'dart:convert';

class EncabezadoModel {
  String? idDocumento;
  String? empresaNombre;
  String? razonSocial;
  String? empresaDireccion;
  String? empresaNit;
  String? paginaWeb;
  String? empresaCorreo;
  String? empresaPbx;
  String? empresaDireccionF;
  String? empresaTelefono;
  String? tipoDocumento;
  String? serieDocumento;
  String? serieResolucion;
  String? serieFechaAutorizacion;
  String? serieIni;
  String? serieFin;
  String? serieFormaPago;
  String? serieObervacion;
  String? certificadorDteNombre;
  String? certificadorDteNit;
  String? iDDocumentoRef;
  String? feLNumeroDocumento;
  dynamic feLSerie;
  dynamic feLUuid;
  dynamic feLFechaCertificacion;
  String? montoLetras;

  EncabezadoModel({
    required this.idDocumento,
    required this.empresaNombre,
    required this.razonSocial,
    required this.empresaDireccion,
    required this.empresaNit,
    required this.paginaWeb,
    required this.empresaCorreo,
    required this.empresaPbx,
    required this.empresaDireccionF,
    required this.empresaTelefono,
    required this.tipoDocumento,
    required this.serieDocumento,
    required this.serieResolucion,
    required this.serieFechaAutorizacion,
    required this.serieIni,
    required this.serieFin,
    required this.serieFormaPago,
    required this.serieObervacion,
    required this.certificadorDteNombre,
    required this.certificadorDteNit,
    required this.iDDocumentoRef,
    required this.feLNumeroDocumento,
    required this.feLSerie,
    required this.feLUuid,
    required this.feLFechaCertificacion,
    required this.montoLetras,
  });

  factory EncabezadoModel.fromJson(String str) =>
      EncabezadoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EncabezadoModel.fromMap(Map<String, dynamic> json) => EncabezadoModel(
        idDocumento: json["id_Documento"],
        empresaNombre: json["empresa_Nombre"],
        razonSocial: json["razon_Social"],
        empresaDireccion: json["empresa_Direccion"],
        empresaNit: json["empresa_Nit"],
        paginaWeb: json["pagina_Web"],
        empresaCorreo: json["empresa_Correo"],
        empresaPbx: json["empresa_PBX"],
        empresaDireccionF: json["empresa_Direccion_F"],
        empresaTelefono: json["empresa_Telefono"],
        tipoDocumento: json["tipo_Documento"],
        serieDocumento: json["serie_Documento"],
        serieResolucion: json["serie_Resolucion"],
        serieFechaAutorizacion: json["serie_Fecha_Autorizacion"],
        serieIni: json["serie_Ini"],
        serieFin: json["serie_Fin"],
        serieFormaPago: json["serie_Forma_Pago"],
        serieObervacion: json["serie_Obervacion"],
        certificadorDteNombre: json["certificador_DTE_Nombre"],
        certificadorDteNit: json["certificador_DTE_NIT"],
        iDDocumentoRef: json["iD_Documento_Ref"],
        feLNumeroDocumento: json["feL_numeroDocumento"],
        feLSerie: json["feL_Serie"],
        feLUuid: json["feL_UUID"],
        feLFechaCertificacion: json["feL_fechaCertificacion"],
        montoLetras: json["monto_Letras"],
      );

  Map<String, dynamic> toMap() => {
        "id_Documento": idDocumento,
        "empresa_Nombre": empresaNombre,
        "razon_Social": razonSocial,
        "empresa_Direccion": empresaDireccion,
        "empresa_Nit": empresaNit,
        "pagina_Web": paginaWeb,
        "empresa_Correo": empresaCorreo,
        "empresa_PBX": empresaPbx,
        "empresa_Direccion_F": empresaDireccionF,
        "empresa_Telefono": empresaTelefono,
        "tipo_Documento": tipoDocumento,
        "serie_Documento": serieDocumento,
        "serie_Resolucion": serieResolucion,
        "serie_Fecha_Autorizacion": serieFechaAutorizacion,
        "serie_Ini": serieIni,
        "serie_Fin": serieFin,
        "serie_Forma_Pago": serieFormaPago,
        "serie_Obervacion": serieObervacion,
        "certificador_DTE_Nombre": certificadorDteNombre,
        "certificador_DTE_NIT": certificadorDteNit,
        "iD_Documento_Ref": iDDocumentoRef,
        "feL_numeroDocumento": feLNumeroDocumento,
        "feL_Serie": feLSerie,
        "feL_UUID": feLUuid,
        "feL_fechaCertificacion": feLFechaCertificacion,
        "monto_Letras": montoLetras,
      };
}
