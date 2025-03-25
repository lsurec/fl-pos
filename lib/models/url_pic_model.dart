import 'dart:convert';

class UrlPicModel {
  String url;

  UrlPicModel({
    required this.url,
  });

  factory UrlPicModel.fromJson(String str) =>
      UrlPicModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UrlPicModel.fromMap(Map<String, dynamic> json) => UrlPicModel(
        url: json["url"],
      );

  Map<String, dynamic> toMap() => {
        "url": url,
      };
}
