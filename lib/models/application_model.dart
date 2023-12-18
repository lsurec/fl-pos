import 'dart:convert';

class ApplicationModel {
  int application;
  int applicationFather;
  String description;
  String observacion1;

  ApplicationModel({
    required this.application,
    required this.applicationFather,
    required this.description,
    required this.observacion1,
  });

  factory ApplicationModel.fromJson(String str) =>
      ApplicationModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ApplicationModel.fromMap(Map<String, dynamic> json) =>
      ApplicationModel(
        application: json["application"],
        applicationFather: json["application_Father"],
        description: json["description"],
        observacion1: json["observacion_1"],
      );

  Map<String, dynamic> toMap() => {
        "application": application,
        "application_Father": applicationFather,
        "description": description,
        "observacion_1": observacion1,
      };
}
