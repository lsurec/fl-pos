class OriginDetailInterModel {
  int consecutivoInterno;
  double disponible;
  double disponibleMod;
  bool checked;
  String clase;
  dynamic marca;
  String id;
  String producto;
  String bodega;
  double cantidad;

  OriginDetailInterModel({
    required this.consecutivoInterno,
    required this.disponible,
    required this.clase,
    required this.marca,
    required this.id,
    required this.producto,
    required this.bodega,
    required this.cantidad,
    required this.disponibleMod,
    required this.checked,
  });
}
