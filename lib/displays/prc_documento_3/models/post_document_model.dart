import 'dart:convert';

class PostDocumentModel {
  String estructura;
  String user;

  PostDocumentModel({
    required this.estructura,
    required this.user,
  });

  factory PostDocumentModel.fromJson(String str) =>
      PostDocumentModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PostDocumentModel.fromMap(Map<String, dynamic> json) =>
      PostDocumentModel(
        estructura: json["estructura"],
        user: json["user"],
      );

  Map<String, dynamic> toMap() => {
        "estructura": estructura,
        "user": user,
      };
}
