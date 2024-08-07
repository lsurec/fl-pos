import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class NewAccountCardWidget extends StatelessWidget {
  const NewAccountCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final AddPersonViewModel vmAddPerson =
        Provider.of<AddPersonViewModel>(context);
    return CardWidget(
      color: AppTheme.color(
        context,
        Styles.secondBackground,
      ),
      elevation: 2,
      raidus: 10,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: AppTheme.backroundColor,
                title: const Text('Nueva cuenta'),
                content: InputWidget(
                  maxLines: 1,
                  formProperty: "name",
                  formValues: vmAddPerson.formValues,
                  hintText: "Nombre",
                  labelText: "Nombre",
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Agregar'),
                    onPressed: () {
                      // Aquí puedes manejar el valor ingresado

                      vmAddPerson.addPerson(context);
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                size: 40.0,
                color: AppTheme.primary,
              ),
              SizedBox(height: 16.0),
              Text(
                "Nueva cuenta",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
