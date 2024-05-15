import 'package:flutter_post_printer_example/models/language_model.dart';

class LanguagesProvider {
  static List<LanguageModel> languagesProvider = [
    LanguageModel(
      names: [
        Name(
          lrCode: "es-GT",
          name: "Español (Guatemala)",
        ),
        Name(
          lrCode: "en-US",
          name: "Spanish (Guatemala)",
        ),
        Name(
          lrCode: "fr-FR",
          name: "Espagnol (Guatemala)",
        ),
        Name(
          lrCode: "de-DE",
          name: "Spanisch (Guatemala)",
        ),
      ],
      lang: "es",
      reg: "GT",
    ),
    LanguageModel(
      names: [
        Name(
          lrCode: "es-GT",
          name: "Ingles (Estados Unidos)",
        ),
        Name(
          lrCode: "en-US",
          name: "English (United States)",
        ),
        Name(
          lrCode: "fr-FR",
          name: "Anglais (United States)",
        ),
        Name(
          lrCode: "de-DE",
          name: "Englisch (Vereinigte Staaten)",
        ),
      ],
      lang: "en",
      reg: "US",
    ),
    LanguageModel(
      names: [
        Name(
          lrCode: "es-GT",
          name: "Francés (Francia)",
        ),
        Name(
          lrCode: "en-US",
          name: "French (France)",
        ),
        Name(
          lrCode: "fr-FR",
          name: "Français (France)",
        ),
        Name(
          lrCode: "de-DE",
          name: "Französisch (Frankreich)",
        ),
      ],
      lang: "fr",
      reg: "FR",
    ),
    LanguageModel(
      names: [
        Name(
          lrCode: "es-GT",
          name: "Alemán (Alemania)",
        ),
        Name(
          lrCode: "en-US",
          name: "German (Germany)",
        ),
        Name(
          lrCode: "fr-FR",
          name: "Allemand (Allemagne)",
        ),
        Name(
          lrCode: "de-DE",
          name: "Deutsch (Deutschland)",
        ),
      ],
      lang: "de",
      reg: "DE",
    ),
  ];

  static int indexDefaultLang = 0;
}
