import 'dart:convert';

class PagoModel {
  int id;
  int tipoCargoAbono;
  double monto;
  double cambio;
  double tipoCambio;
  int moneda;
  double montoMoneda;
  String referencia;
  String autorizacion;
  String fDesTipoCargoAbono;

  PagoModel({
    required this.id,
    required this.tipoCargoAbono,
    required this.monto,
    required this.cambio,
    required this.tipoCambio,
    required this.moneda,
    required this.montoMoneda,
    required this.referencia,
    required this.autorizacion,
    required this.fDesTipoCargoAbono,
  });

  factory PagoModel.fromJson(String str) => PagoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PagoModel.fromMap(Map<String, dynamic> json) => PagoModel(
        id: json["id"],
        tipoCargoAbono: json["tipo_Cargo_Abono"],
        monto: json["monto"]?.toDouble() ?? 0,
        cambio: json["cambio"]?.toDouble() ?? 0,
        tipoCambio: json["tipo_Cambio"],
        moneda: json["moneda"],
        montoMoneda: json["monto_Moneda"]?.toDouble(),
        referencia: json["referencia"],
        autorizacion: json["autorizacion"],
        fDesTipoCargoAbono: json["fDes_Tipo_Cargo_Abono"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "tipo_Cargo_Abono": tipoCargoAbono,
        "monto": monto,
        "cambio": cambio,
        "tipo_Cambio": tipoCambio,
        "moneda": moneda,
        "monto_Moneda": montoMoneda,
        "referencia": referencia,
        "autorizacion": autorizacion,
        "fDes_Tipo_Cargo_Abono": fDesTipoCargoAbono,
      };
}
