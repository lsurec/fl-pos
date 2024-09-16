import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class TemasColoresView extends StatelessWidget {
  const TemasColoresView({super.key});

  @override
  Widget build(BuildContext context) {
    final vmTema = Provider.of<ThemeViewModel>(context);
    final List<ColorModel> colores = vmTema.coloresTemaApp(context);
    // Índice del tema seleccionado
    // ID del color seleccionado
    int selectedColorId = AppNewTheme.idColorTema;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    // style: StyleApp.button,
                    child: SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.botones,
                            "aceptar",
                          ),
                          style: StyleApp.whiteBold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    padding: const EdgeInsets.all(20),
                    color: AppNewTheme.hexToColor(
                      Preferences.valueColor,
                    ),
                    child: const Text(
                      "Cambio de color",
                      style: StyleApp.whiteNormal,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        // 3 elementos por fila
                        crossAxisCount: 4,
                        // Espacio horizontal entre elementos
                        crossAxisSpacing: 45.0,
                        // Espacio vertical entre filas
                        mainAxisSpacing: 25.0,
                        // Relación de aspecto de cada elemento
                        childAspectRatio: 1,
                      ),
                      itemCount: colores.length,
                      itemBuilder: (BuildContext context, int index) {
                        final ColorModel color = colores[index];

                        // Verificar si este es el color seleccionado
                        bool isSelected = color.id == selectedColorId;

                        return GestureDetector(
                          onTap: () {
                            selectedColorId = color.id;
                            vmTema.selectedColor(color.id);

                            vmTema.validarColorTema(
                              context,
                              AppNewTheme.idTema,
                            );
                          },
                          child: Container(
                            padding: isSelected
                                // Borde exterior blanco
                                ? const EdgeInsets.all(4.0)
                                : EdgeInsets.zero,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? (!AppNewTheme.oscuro ||
                                          AppNewTheme.idTema != 2
                                      ? Colors.black
                                      : Colors.white)
                                  // Fondo blanco solo si está seleccionado
                                  : Colors.transparent,
                            ),
                            child: Container(
                              width: 24.0,
                              height: 24.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppNewTheme.hexToColor(
                                  color.valor,
                                ),
                                border: Border.all(
                                  // Borde más grueso o de otro color si está seleccionado
                                  color: isSelected
                                      ? (!AppNewTheme.oscuro ||
                                              AppNewTheme.idTema != 2
                                          ? Colors.white
                                          : Colors.black)
                                      : Colors.grey,
                                  // Ancho del borde diferente si está seleccionado
                                  width: isSelected ? 3.0 : 1.0,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
