import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:provider/provider.dart';

class AmountViewModel extends ChangeNotifier {
  //Contorlador para el input monto
  final TextEditingController montoController = TextEditingController();

  //formulario completo
  final Map<String, String> formValues = {
    'monto': '',
    'autorizacion': '',
    'referencia': '',
  };

  //Key for form
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //True if form is valid
  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  //agregar monto
  void addAmount(
    PaymentModel payment,
    BuildContext context,
  ) {
    //validar formulario
    if (!isValidForm()) return;

    //view model externo
    final vmPayment = Provider.of<PaymentViewModel>(context, listen: false);

    //si la forma de pago requiere banco
    if (payment.banco) {
      //contar cientos bancos hay seleccionados
      int counter = 0;
      for (var bank in vmPayment.banks) {
        if (bank.isSelected) counter++;
      }

      //si no hay bancos seleccionados mostrar mmensaje
      if (counter == 0) {
        NotificationService.showSnackbar(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.notificacion,
            'seleccionarBanco',
          ),
        );
        return;
      }

      //si hay cunetas bancarias requeridas
      if (vmPayment.accounts.isNotEmpty) {
        //contar cuentas bancarias seleccionadas
        counter = 0;
        for (var acc in vmPayment.accounts) {
          if (acc.isSelected) counter++;
        }

        //si no hay cuenta bancaria seleccionada mostrar mensaje
        if (counter == 0) {
          NotificationService.showSnackbar(
            AppLocalizations.of(context)!.translate(
              BlockTranslate.notificacion,
              'seleccionarCuenta',
            ),
          );
          return;
        }
      }
    }

    //convertir monto string a double
    double monto = double.tryParse(formValues["monto"]!) ?? 0;
    double diference = 0;

    //Calcualar si hay diferencia (Cambio)
    if (monto > vmPayment.saldo) {
      diference = monto - vmPayment.saldo;
      monto = vmPayment.saldo;
    }

    //objeto monto que se va a agregar (asignar valores)
    AmountModel amount = AmountModel(
      checked: vmPayment.selectAllAmounts,
      amount: monto,
      //si es requerido
      authorization: payment.autorizacion ? formValues["autorizacion"]! : "",
      //si es requerido
      reference: payment.referencia ? formValues["referencia"]! : "",
      payment: payment,
      //si es requerido
      bank: payment.banco ? getBank(context) : null,
      //si es requerido
      account: vmPayment.accounts.isNotEmpty ? getAccount(context) : null,
      diference: diference,
    );

    //Agregar monto a lista de montos
    vmPayment.addAmount(amount, context);

    //mensaje usuario
    NotificationService.showSnackbar(
      AppLocalizations.of(context)!.translate(
        BlockTranslate.notificacion,
        'pagoAgregado',
      ),
    );

    //regresar pantalla anterior
    Navigator.pop(context);
  }

  //Retorna banco seleccionado
  BankModel getBank(BuildContext context) {
    final vmPayment = Provider.of<PaymentViewModel>(
      context,
      listen: false,
    );

    //filtrar banco seleccionado
    SelectBankModel selectedBank =
        vmPayment.banks.firstWhere((bank) => bank.isSelected);

    return selectedBank.bank;
  }

  //retorna cuenta bancaria seelccionada
  AccountModel getAccount(BuildContext context) {
    final vmPayment = Provider.of<PaymentViewModel>(
      context,
      listen: false,
    );

    //filtrar cuenta bancaria seleccionada
    SelectAccountModel selectedBank =
        vmPayment.accounts.firstWhere((account) => account.isSelected);

    //restornar cuneta seleccionada
    return selectedBank.account;
  }
}
