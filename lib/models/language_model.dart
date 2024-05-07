class LanguageModel {
  List<Name> names;
  String lang;
  String reg;

  LanguageModel({required this.names, required this.lang, required this.reg});

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      names: (json['names'] as List).map((e) => Name.fromJson(e)).toList(),
      lang: json['lang'],
      reg: json['reg'],
    );
  }
}

class Name {
  String lrCode;
  String name;

  Name({required this.lrCode, required this.name});

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      lrCode: json['lrCode'],
      name: json['name'],
    );
  }
}
