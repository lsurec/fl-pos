import 'dart:convert';

class DisplayModel {
  int userDisplay;
  int? userDisplayFather;
  String userName;
  String name;
  bool active;
  bool visible;
  int rol;
  String? display;
  int application;
  int? param;
  int orden;
  int consecutivoInterno;
  String? displayUrl;
  String? displayMenu;
  String? displayUrlAlter;
  int languageId;
  int? tipoDocumento;
  String? desTipoDocumento;

  DisplayModel({
    required this.userDisplay,
    required this.userDisplayFather,
    required this.userName,
    required this.name,
    required this.active,
    required this.visible,
    required this.rol,
    required this.display,
    required this.application,
    required this.param,
    required this.orden,
    required this.consecutivoInterno,
    required this.displayUrl,
    required this.displayMenu,
    required this.displayUrlAlter,
    required this.languageId,
    required this.tipoDocumento,
    required this.desTipoDocumento,
  });

  factory DisplayModel.fromJson(String str) =>
      DisplayModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DisplayModel.fromMap(Map<String, dynamic> json) => DisplayModel(
        userDisplay: json["user_Display"],
        userDisplayFather: json["user_Display_Father"],
        userName: json["userName"],
        name: json["name"],
        active: json["active"],
        visible: json["visible"],
        rol: json["rol"],
        display: json["display"],
        application: json["application"],
        param: json["param"],
        orden: json["orden"],
        consecutivoInterno: json["consecutivo_Interno"],
        displayUrl: json["display_URL"],
        displayMenu: json["display_Menu"],
        displayUrlAlter: json["display_URL_Alter"],
        languageId: json["language_ID"],
        tipoDocumento: json["tipo_Documento"],
        desTipoDocumento: json["des_Tipo_Documento"],
      );

  Map<String, dynamic> toMap() => {
        "user_Display": userDisplay,
        "user_Display_Father": userDisplayFather,
        "userName": userName,
        "name": name,
        "active": active,
        "visible": visible,
        "rol": rol,
        "display": display,
        "application": application,
        "param": param,
        "orden": orden,
        "consecutivo_Interno": consecutivoInterno,
        "display_URL": displayUrl,
        "display_Menu": displayMenu,
        "display_URL_Alter": displayUrlAlter,
        "language_ID": languageId,
        "tipo_Documento": tipoDocumento,
        "des_Tipo_Documento": desTipoDocumento,
      };
}
