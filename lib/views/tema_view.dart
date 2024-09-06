import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class TemasColoresView extends StatelessWidget {
  const TemasColoresView({super.key});

  @override
  Widget build(BuildContext context) {
    final vmTema = Provider.of<ThemeViewModel>(context);
    final List<TemaModel> temas = vmTema.temasAppM(context);
    final List<ColorModel> colores = vmTema.coloresApp(context);
    // Índice del tema seleccionado
    int selectedIndex = AppNewTheme.idTema;
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
                  SizedBox(
                    width: 350,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        children: [
                          const Text(
                            "Elegir tema de preferencia.",
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "ID DEL TEMA: ${AppNewTheme.idTema}.",
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "NOMBRE TEMA: ${vmTema.temasApp(context)[AppNewTheme.idTema].descripcion}.",
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "ID DEL COLOR: ${AppNewTheme.idColorTema}.",
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "NOMBRE TEMA: ${vmTema.obtenerColorModel(
                                  context,
                                  AppNewTheme.idColorTema,
                                ).nombre}.",
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "VALOR COLOR: ${Preferences.valueColor}.",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: temas.length,
                    itemBuilder: (BuildContext context, int index) {
                      final TemaModel tema = temas[index];
                      // Cada item de la lista
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 15,
                        ),
                        title: Text(
                          tema.descripcion,
                          style: StyleApp.normal,
                        ),
                        leading: Radio<int>(
                          value: index,
                          groupValue: selectedIndex,
                          onChanged: (int? value) {
                            selectedIndex = value!;
                            // Tu función personalizada
                            vmTema.validarColorTema(
                              context,
                              tema.id,
                            );
                          },
                        ),
                        onTap: () {
                          vmTema.validarColorTema(context, tema.id);
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
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
                        crossAxisSpacing: 25.0,
                        // Espacio vertical entre filas
                        mainAxisSpacing: 15.0,
                        // Relación de aspecto de cada elemento
                        childAspectRatio: 1,
                      ),
                      itemCount: colores.length,
                      itemBuilder: (BuildContext context, int index) {
                        final ColorModel color = colores[index];
                        // Cada item de la lista
                        final List<int> colorValor = AppNewTheme.hexToRgb(
                          color.valor,
                        );

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
                                color: Color.fromRGBO(
                                  colorValor[0],
                                  colorValor[1],
                                  colorValor[2],
                                  1,
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
                  IconButton(
                    onPressed: () {
                      // Navigator.pushNamed(
                      //   context,
                      //   AppRoutes.tema,
                      // );
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios,
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
