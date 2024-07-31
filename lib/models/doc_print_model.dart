import 'dart:convert';

class DocPrintModel {
  Empresa empresa;
  Documento documento;
  Cliente cliente;
  List<Item> items;
  Montos montos;
  List<Pago> pagos;
  String vendedor;
  Certificador certificador;
  String observacion;
  List<String> mensajes;
  PoweredBy poweredBy;
  String noDoc;
  String? evento;
  String? emailVendedor;
  Fechas? fechas;
  int? cantidadDias;
  ObservacionesRef? refObservaciones;
  String? image64Empresa;

  DocPrintModel({
    required this.empresa,
    required this.documento,
    required this.cliente,
    required this.items,
    required this.montos,
    required this.pagos,
    required this.vendedor,
    required this.certificador,
    required this.observacion,
    required this.mensajes,
    required this.poweredBy,
    required this.noDoc,
    this.evento,
    this.emailVendedor,
    this.fechas,
    this.cantidadDias,
    this.refObservaciones,
    this.image64Empresa,
  });

  factory DocPrintModel.fromJson(String str) =>
      DocPrintModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DocPrintModel.fromMap(Map<String, dynamic> json) => DocPrintModel(
        empresa: Empresa.fromMap(json["empresa"]),
        documento: Documento.fromMap(json["documento"]),
        cliente: Cliente.fromMap(json["cliente"]),
        items: List<Item>.from(json["items"].map((x) => Item.fromMap(x))),
        montos: Montos.fromMap(json["montos"]),
        pagos: List<Pago>.from(json["pagos"].map((x) => Pago.fromMap(x))),
        vendedor: json["vendedor"],
        certificador: Certificador.fromMap(json["certificador"]),
        observacion: json["observacion"],
        mensajes: List<String>.from(json["mensajes"].map((x) => x)),
        poweredBy: PoweredBy.fromMap(json["poweredBy"]),
        noDoc: json["noDoc"],
        evento: json["evento"],
        emailVendedor: json["emailVendedor"],
        fechas: json["fechas"] != null ? Fechas.fromMap(json["fechas"]) : null,
        cantidadDias: json["cantidadDias"],
        refObservaciones: json["refObservaciones"] != null
            ? ObservacionesRef.fromMap(json["refObservaciones"])
            : null,
        image64Empresa: json["image64Empresa"],
      );

  Map<String, dynamic> toMap() => {
        "empresa": empresa.toMap(),
        "documento": documento.toMap(),
        "cliente": cliente.toMap(),
        "items": List<dynamic>.from(items.map((x) => x.toMap())),
        "montos": montos.toMap(),
        "pagos": List<dynamic>.from(pagos.map((x) => x.toMap())),
        "vendedor": vendedor,
        "certificador": certificador.toMap(),
        "observacion": observacion,
        "mensajes": List<dynamic>.from(mensajes.map((x) => x)),
        "poweredBy": poweredBy.toMap(),
        "noDoc": noDoc,
        "evento": evento,
        "emailVendedor": emailVendedor,
        "fechas": fechas?.toMap(),
        "cantidadDias": cantidadDias,
        "refObservaciones": refObservaciones?.toMap(),
        "image64Empresa": image64Empresa,
      };
}

class Certificador {
  String nombre;
  String nit;

  Certificador({
    required this.nombre,
    required this.nit,
  });

  factory Certificador.fromJson(String str) =>
      Certificador.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Certificador.fromMap(Map<String, dynamic> json) => Certificador(
        nombre: json["nombre"],
        nit: json["nit"],
      );

  Map<String, dynamic> toMap() => {
        "nombre": nombre,
        "nit": nit,
      };
}

class Cliente {
  String nombre;
  String direccion;
  String nit;
  String fecha;
  String tel;

  Cliente({
    required this.nombre,
    required this.direccion,
    required this.nit,
    required this.fecha,
    required this.tel,
  });

  factory Cliente.fromJson(String str) => Cliente.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Cliente.fromMap(Map<String, dynamic> json) => Cliente(
        nombre: json["nombre"],
        direccion: json["direccion"],
        nit: json["nit"],
        fecha: json["fecha"],
        tel: json["tel"],
      );

  Map<String, dynamic> toMap() => {
        "nombre": nombre,
        "direccion": direccion,
        "nit": nit,
        "fecha": fecha,
        "tel": tel,
      };
}

class Documento {
  String titulo;
  String descripcion;
  String fechaCert;
  String serie;
  String no;
  String autorizacion;
  String serieInterna;
  String noInterno;
  int consecutivoInterno;

  Documento({
    required this.titulo,
    required this.descripcion,
    required this.fechaCert,
    required this.serie,
    required this.no,
    required this.autorizacion,
    required this.serieInterna,
    required this.noInterno,
    required this.consecutivoInterno,
  });

  factory Documento.fromJson(String str) => Documento.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Documento.fromMap(Map<String, dynamic> json) => Documento(
        titulo: json["titulo"],
        descripcion: json["descripcion"],
        fechaCert: json["fechaCert"],
        serie: json["serie"],
        no: json["no"],
        autorizacion: json["autorizacion"],
        serieInterna: json["serieInterna"],
        noInterno: json["noInterno"],
        consecutivoInterno: json["consecutivoInterno"],
      );

  Map<String, dynamic> toMap() => {
        "titulo": titulo,
        "descripcion": descripcion,
        "fechaCert": fechaCert,
        "serie": serie,
        "no": no,
        "autorizacion": autorizacion,
        "noInterno": noInterno,
        "serieInterna": serieInterna,
        "consecutivoInterno": consecutivoInterno,
      };
}

class Empresa {
  String razonSocial;
  String nombre;
  String direccion;
  String nit;
  String tel;

  Empresa({
    required this.razonSocial,
    required this.nombre,
    required this.direccion,
    required this.nit,
    required this.tel,
  });

  factory Empresa.fromJson(String str) => Empresa.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Empresa.fromMap(Map<String, dynamic> json) => Empresa(
        razonSocial: json["razonSocial"],
        nombre: json["nombre"],
        direccion: json["direccion"],
        nit: json["nit"],
        tel: json["tel"],
      );

  Map<String, dynamic> toMap() => {
        "razonSocial": razonSocial,
        "nombre": nombre,
        "direccion": direccion,
        "nit": nit,
        "tel": tel,
      };
}

class Item {
  String descripcion;
  double cantidad;
  String unitario;
  String total;
  String sku;
  String precioDia;
  String? precioReposicion;
  String? imagen64;

  Item({
    required this.descripcion,
    required this.cantidad,
    required this.unitario,
    required this.total,
    required this.sku,
    required this.precioDia,
    this.precioReposicion,
    this.imagen64,
  });

  factory Item.fromJson(String str) => Item.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        descripcion: json["descripcion"],
        cantidad: json["cantidad"],
        unitario: json["precioUnitario"]?.toDouble(),
        total: json["precioUnitario"]?.toDouble(),
        sku: json["sku"],
        precioDia: json["precioDia"],
        precioReposicion: json["precioReposicion"],
        imagen64: json["imagen64"],
      );

  Map<String, dynamic> toMap() => {
        "descripcion": descripcion,
        "cantidad": cantidad,
        "unitario": unitario,
        "total": total,
        "sku": sku,
        "precioDia": precioDia,
        "precioReposicion": precioReposicion,
        "imagen64": imagen64,
      };
}

class Montos {
  double subtotal;
  double cargos;
  double descuentos;
  double total;
  String totalLetras;

  Montos({
    required this.subtotal,
    required this.cargos,
    required this.descuentos,
    required this.total,
    required this.totalLetras,
  });

  factory Montos.fromJson(String str) => Montos.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Montos.fromMap(Map<String, dynamic> json) => Montos(
        subtotal: json["subtotal"],
        cargos: json["cargos"],
        descuentos: json["descuentos"],
        total: json["total"],
        totalLetras: json["totalLetras"],
      );

  Map<String, dynamic> toMap() => {
        "subtotal": subtotal,
        "cargos": cargos,
        "descuentos": descuentos,
        "total": total,
        "totalLetras": totalLetras,
      };
}

class Pago {
  String tipoPago;
  double pago;
  double monto;
  double cambio;

  Pago({
    required this.tipoPago,
    required this.pago,
    required this.monto,
    required this.cambio,
  });

  factory Pago.fromJson(String str) => Pago.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Pago.fromMap(Map<String, dynamic> json) => Pago(
        tipoPago: json["tipoPago"],
        monto: json["monto"],
        cambio: json["cambio"],
        pago: json["pago"],
      );

  Map<String, dynamic> toMap() => {
        "tipoPago": tipoPago,
        "monto": monto,
        "pago": pago,
        "cambio": cambio,
      };
}

class PoweredBy {
  String nombre;
  String website;

  PoweredBy({
    required this.nombre,
    required this.website,
  });

  factory PoweredBy.fromJson(String str) => PoweredBy.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PoweredBy.fromMap(Map<String, dynamic> json) => PoweredBy(
        nombre: json["nombre"],
        website: json["website"],
      );

  Map<String, dynamic> toMap() => {
        "nombre": nombre,
        "website": website,
      };
}

//Fechas
class Fechas {
  String? fechaInicio;
  String? fechaFin;
  String? fechaInicioRef;
  String? fechaFinRef;

  Fechas({
    this.fechaInicio,
    this.fechaFin,
    this.fechaInicioRef,
    this.fechaFinRef,
  });

  factory Fechas.fromJson(String str) => Fechas.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Fechas.fromMap(Map<String, dynamic> json) => Fechas(
        fechaInicio: json["fechaInicio"] as String?,
        fechaFin: json["fechaFin"] as String?,
        fechaInicioRef: json["fechaInicioRef"] as String?,
        fechaFinRef: json["fechaFinRef"] as String?,
      );

  Map<String, dynamic> toMap() => {
        "fechaInicio": fechaInicio,
        "fechaFin": fechaFin,
        "fechaInicioRef": fechaInicioRef,
        "fechaFinRef": fechaFinRef,
      };
}

//Observaciones
class ObservacionesRef {
  String observacion2; // contacto
  String descripcion; // Descripcion
  String observacion3; // direccion entrega
  String observacion; // observacion

  ObservacionesRef({
    required this.observacion2,
    required this.descripcion,
    required this.observacion3,
    required this.observacion,
  });

  factory ObservacionesRef.fromJson(String str) =>
      ObservacionesRef.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ObservacionesRef.fromMap(Map<String, dynamic> json) =>
      ObservacionesRef(
        observacion2: json["observacion2"],
        descripcion: json["descripcion"],
        observacion3: json["observacion3"],
        observacion: json["observacion"],
      );

  Map<String, dynamic> toMap() => {
        "observacion2": observacion2,
        "descripcion": descripcion,
        "observacion3": observacion3,
        "observacion": observacion,
      };
}
