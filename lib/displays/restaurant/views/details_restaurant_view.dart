import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class DetailsRestaurantView extends StatelessWidget {
  const DetailsRestaurantView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vmProduct = Provider.of<ProductsClassViewModel>(
      context,
      listen: false,
    );
    final vm = Provider.of<DetailsRestaurantViewModel>(context, listen: false);
    final ProductRestaurantModel product = vmProduct.product!;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.description_outlined,
            ),
            padding: const EdgeInsets.only(right: 20),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.desProducto,
              style: AppTheme.style(
                context,
                Styles.title,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product.productoId,
              style: AppTheme.style(
                context,
                Styles.normal,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(30),
              height: 300,
              width: double.infinity,
              child: const FadeInImage(
                placeholder: AssetImage('assets/load.gif'),
                image: NetworkImage(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/640px-Image_not_available.png',
                ),
                height: 150,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: vm.types.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vm.types[index].precio.desTipoPrecio,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Q.${vm.types[index].precio.precioUnidad}",
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      _ButtonIncrement(indice: index),
                    ],
                  ),
                );
              },
            ),
            // _ListPrecios(),
            // _ButtonIncrement(),
            const SizedBox(height: 20),
            InputWidget(
              labelText: "Observacion",
              hintText: "Observacion",
              maxLines: 3,
              formProperty: "observacion",
              formValues: vm.formValues,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Cuentas",
                  style: AppTheme.style(context, Styles.normal),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const _Accounts(),
            _NewAccount(),
          ],
        ),
      ),
    );
  }
}

class _NewAccount extends StatelessWidget {
  const _NewAccount({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AccountsViewModel>(context);

    return Row(
      children: [
        Expanded(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: vm.formKey,
            child: InputWidget(
              hintText: "Nombre Cuenta",
              labelText: "Nueva Cuenta",
              maxLines: 1,
              formProperty: "cuenta",
              formValues: vm.formValueAccount,
            ),
          ),
        ),
        IconButton(
          onPressed: () => vm.addNewAccount(context),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}

class _Accounts extends StatefulWidget {
  const _Accounts({
    Key? key,
  }) : super(key: key);

  @override
  State<_Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<_Accounts> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AccountsViewModel>(context);

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: vm.orders.length,
      itemBuilder: (BuildContext context, int index) {
        OrderModel cuenta = vm.orders[index];

        return RadioListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          controlAffinity: ListTileControlAffinity.trailing,
          activeColor: AppTheme.primary,
          title: Text(cuenta.nombre),
          value: index,
          groupValue: vm.formValueAccount['option'],
          onChanged: (value) {
            setState(() {
              vm.formValueAccount['option'] = value as int?;
            });
          },
        );
      },
    );
  }
}

class _ButtonIncrement extends StatelessWidget {
  const _ButtonIncrement({
    Key? key,
    required this.indice,
  }) : super(key: key);

  final int indice;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DetailsRestaurantViewModel>(context);

    final _size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.grey),
        borderRadius: BorderRadius.circular(30),
      ),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: _size.width * 0.25,
            child: IconButton(
              icon: const Icon(
                Icons.remove,
                color: AppTheme.primary,
                size: 20,
              ),
              onPressed: () => vm.decrement(indice),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(
                    width: 2,
                    color: Colors.grey,
                  ),
                  left: BorderSide(
                    width: 2,
                    color: Colors.grey,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  vm.types[indice].cantidad.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: _size.width * 0.25,
            child: IconButton(
              icon: const Icon(
                Icons.add,
                color: AppTheme.primary,
                size: 20,
              ),
              onPressed: () => vm.increment(indice),
            ),
          )
        ],
      ),
    );
  }
}
