import 'dart:convert';

class PaymentModel {
  int tipoCargoAbono;
  String descripcion;
  bool monto;
  bool referencia;
  bool autorizacion;
  bool calcularMonto;
  bool cuentaCorriente;
  bool reservacion;
  bool facturar;
  bool efectivo;
  bool banco;
  bool fechaVencimiento;
  double comisionPorcentaje;
  double comisionMonto;
  dynamic cuenta;
  bool contabilizar;
  bool valLimiteCredito;
  bool msgLimiteCredito;
  dynamic cuentaCorrentista;
  dynamic cuentaCta;
  bool bloquearDocumento;
  String url;
  dynamic reqCuentaBancaria;

  PaymentModel({
    required this.tipoCargoAbono,
    required this.descripcion,
    required this.monto,
    required this.referencia,
    required this.autorizacion,
    required this.calcularMonto,
    required this.cuentaCorriente,
    required this.reservacion,
    required this.facturar,
    required this.efectivo,
    required this.banco,
    required this.fechaVencimiento,
    required this.comisionPorcentaje,
    required this.comisionMonto,
    required this.cuenta,
    required this.contabilizar,
    required this.valLimiteCredito,
    required this.msgLimiteCredito,
    required this.cuentaCorrentista,
    required this.cuentaCta,
    required this.bloquearDocumento,
    required this.url,
    required this.reqCuentaBancaria,
  });

  factory PaymentModel.fromJson(String str) =>
      PaymentModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PaymentModel.fromMap(Map<String, dynamic> json) => PaymentModel(
        tipoCargoAbono: json["tipo_Cargo_Abono"],
        descripcion: json["descripcion"],
        monto: json["monto"],
        referencia: json["referencia"],
        autorizacion: json["autorizacion"],
        calcularMonto: json["calcular_Monto"],
        cuentaCorriente: json["cuenta_Corriente"],
        reservacion: json["reservacion"],
        facturar: json["facturar"],
        efectivo: json["efectivo"],
        banco: json["banco"],
        fechaVencimiento: json["fecha_Vencimiento"],
        comisionPorcentaje: json["comision_Porcentaje"],
        comisionMonto: json["comision_Monto"],
        cuenta: json["cuenta"],
        contabilizar: json["contabilizar"],
        valLimiteCredito: json["val_Limite_Credito"],
        msgLimiteCredito: json["msg_Limite_Credito"],
        cuentaCorrentista: json["cuenta_Correntista"],
        cuentaCta: json["cuenta_Cta"],
        bloquearDocumento: json["bloquear_Documento"],
        url: json["url"],
        reqCuentaBancaria: json["req_Cuenta_Bancaria"],
      );

  Map<String, dynamic> toMap() => {
        "tipo_Cargo_Abono": tipoCargoAbono,
        "descripcion": descripcion,
        "monto": monto,
        "referencia": referencia,
        "autorizacion": autorizacion,
        "calcular_Monto": calcularMonto,
        "cuenta_Corriente": cuentaCorriente,
        "reservacion": reservacion,
        "facturar": facturar,
        "efectivo": efectivo,
        "banco": banco,
        "fecha_Vencimiento": fechaVencimiento,
        "comision_Porcentaje": comisionPorcentaje,
        "comision_Monto": comisionMonto,
        "cuenta": cuenta,
        "contabilizar": contabilizar,
        "val_Limite_Credito": valLimiteCredito,
        "msg_Limite_Credito": msgLimiteCredito,
        "cuenta_Correntista": cuentaCorrentista,
        "cuenta_Cta": cuentaCta,
        "bloquear_Documento": bloquearDocumento,
        "url": url,
        "req_Cuenta_Bancaria": reqCuentaBancaria,
      };
}
