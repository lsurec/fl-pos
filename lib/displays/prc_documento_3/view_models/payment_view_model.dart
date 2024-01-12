// ignore_for_file: use_build_context_synchronously

import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/services/services.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentViewModel extends ChangeNotifier {
  //controlar el proceso
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //Totales globales
  double saldo = 0;
  double cambio = 0;
  double pagado = 0;

  //Seleccionar todas las formas de pago
  bool selectAllAmounts = false;

  //Formas de pago agregadas
  final List<AmountModel> amounts = [];

  //Formas de pago disponibles
  final List<PaymentModel> paymentList = [];

  //Bancos disponibles
  final List<SelectBankModel> banks = [];

  //Cuentas bancarias disponibles
  final List<SelectAccountModel> accounts = [];

  //cargar formas de pago
  Future<void> loadPayments(BuildContext context) async {
    //limpiar lista
    paymentList.clear();

    //view models exxternos
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final vmFactura = Provider.of<DocumentoViewModel>(context, listen: false);
    final vmMenu = Provider.of<MenuViewModel>(context, listen: false);
    final vmDoc = Provider.of<DocumentViewModel>(context, listen: false);
    final vmLocal = Provider.of<LocalSettingsViewModel>(context, listen: false);

    //Si no hay tipo docummento cancelar
    if (vmMenu.documento == null) return;

    //si no hay serie seleccionada mostrar error
    if (vmDoc.serieSelect == null) {
      NotificationService.showSnackbar("Selecciona una serie");
      return;
    }

    //instancia del servicio
    PagoService pagoService = PagoService();

    //load prosses
    vmFactura.isLoading = true;

    //Consumo del servicio
    ApiResModel res = await pagoService.getFormas(
      vmMenu.documento!, // doc,
      vmDoc.serieSelect!.serieDocumento!, // serie,
      vmLocal.selectedEmpresa!.empresa, // empresa,
      loginVM.token, // token,
    );

    //stop process
    vmFactura.isLoading = false;

    //valid succes response
    if (!res.succes) {
      //si algo salio mal mostrar alerta
      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: res.message,
        url: res.url,
        storeProcedure: res.storeProcedure,
      );

      await NotificationService.showErrorView(
        context,
        error,
      );
      return;
    }

    //agregar formas de pago encontradas
    paymentList.addAll(res.message);

    notifyListeners();
  }

  //cargar cuentas bancarias
  Future<void> loadCuentasBanco(BuildContext context, int banco) async {
    //limipiar lista
    accounts.clear();

    //view model externo
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final localVM = Provider.of<LocalSettingsViewModel>(context, listen: false);

    //instancia del servico
    PagoService pagoService = PagoService();

    //load prosses
    isLoading = true;

    ApiResModel res = await pagoService.getCuentas(
      loginVM.nameUser, // user,
      localVM.selectedEmpresa!.empresa, // empresa,
      banco, // banco,
      loginVM.token, // token,
    );

    //stop process
    isLoading = false;

    //valid succes response
    if (!res.succes) {
      //si algo salio mal mostrar alerta
      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: res.message,
        url: res.url,
        storeProcedure: res.storeProcedure,
      );

      await NotificationService.showErrorView(
        context,
        error,
      );
      return;
    }

    //agreagar cuenta banccaria a un modelo nuevo
    for (var account in res.message as List<AccountModel>) {
      accounts.add(SelectAccountModel(account: account, isSelected: false));
    }

    //Si solo hay una cuenta bancaria seleccioanrlo por defecto
    if (accounts.length == 1) {
      accounts.first.isSelected = true;
    }
    notifyListeners();
  }

  //cargar bancos disponibñes
  Future<void> loadBancos(BuildContext context) async {
    //limpiar lista
    banks.clear();

    //View models externos
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final vmFactura = Provider.of<DocumentoViewModel>(context, listen: false);
    final localVM = Provider.of<LocalSettingsViewModel>(context, listen: false);

    //instancia del servicio
    PagoService pagoService = PagoService();

    //load prosses
    vmFactura.isLoading = true;
    //call service obtener Informacion de usuario

    ApiResModel res = await pagoService.getBancos(
      loginVM.nameUser, //usuario
      localVM.selectedEmpresa!.empresa, //empresa
      loginVM.token, //token
    );

    //stop process
    vmFactura.isLoading = false;

    //valid succes response
    if (!res.succes) {
      //si algo salio mal mostrar alerta
      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: res.message,
        url: res.url,
        storeProcedure: res.storeProcedure,
      );

      await NotificationService.showErrorView(
        context,
        error,
      );
      return;
    }

    //Agregar bancos a un modelo nuevo
    for (var bank in res.message as List<BankModel>) {
      banks.add(SelectBankModel(bank: bank, isSelected: false));
    }

    //si solo hay un banco seleccionarlo por defecto
    if (banks.length == 1) {
      banks.first.isSelected = true;
    }

    notifyListeners();
  }

  //cambiar cuenta bancaria seleccionada
  void changeAccountSelect(int? value, BuildContext context) {
    //Maracr todos en falso
    for (var account in accounts) {
      account.isSelected = false;
    }
    //marcar el seleccionado en verdadero
    accounts[value!].isSelected = true;

    notifyListeners();
  }

  //cambiar banco seleccionado
  void changeBankSelect(
    int? value,
    BuildContext context,
    PaymentModel payment,
  ) {
    //TODO:Revisar cambio de banco no obtiene cuentas bancaria
    //Maracr todos en falso
    for (var bank in banks) {
      bank.isSelected = false;
    }

    //marcar el selecccionado en verdadero
    banks[value!].isSelected = true;

    //Buscar el seleccionado
    SelectBankModel selectedBank = banks.firstWhere((bank) => bank.isSelected);

    //verificar si cuenta bancario es null conevrtirlo en false
    payment.reqCuentaBancaria ??= false;

    //si la cuenta bancaria es requerida buscar cuenta bancaria
    if (payment.reqCuentaBancaria) {
      loadCuentasBanco(context, selectedBank.bank.banco);
    }

    notifyListeners();
  }

  //limpiar campos de la vista del usuario
  void clearView(BuildContext context) {
    amounts.clear(); //limpiar formas de o¿pago agrefadas
    calculateTotales(context); //calcular totales
  }

  //eliminar formas de pago seleccioandas
  void deleteAmounts(BuildContext context) async {
    int numSelected = 0;

    //contar formas de pago seleccionadas
    for (var element in amounts) {
      if (element.checked) {
        numSelected += 1;
      }
    }

    //si no hay formas de pago seleccionadas mmostrar mensaje
    if (numSelected == 0) {
      NotificationService.showSnackbar(
          "Seleccione por lo menos una transacción.");
      return;
    }

    //si no estan seleccioandos todos
    if (numSelected < amounts.length) {
      //montos seleccionados
      List<AmountModel> checkedAmounts =
          amounts.where((amount) => amount.checked).toList();

      //montos con diferencias
      List<AmountModel> diferencesAmounts =
          amounts.where((amount) => amount.diference > 0).toList();

      //montos con diferencias selecccionados
      List<AmountModel> diferencesChecked =
          checkedAmounts.where((amount) => amount.diference > 0).toList();

      //si el total de montos con diferencias y el total seekccionado con diferencias es distitnto
      if (diferencesAmounts.length != diferencesChecked.length) {
        //mostar mensaje
        NotificationService.showSnackbar(
            "Elimina las transacciones con diferencia.");
        return;
      }
    }

    //mostrar dialogo de confirmacion
    bool result = await showDialog(
          context: context,
          builder: (context) => AlertWidget(
            title: "¿Estás seguro?",
            description:
                "Si no se han guardado los cambios, los perderás para siempre.",
            onOk: () => Navigator.of(context).pop(true),
            onCancel: () => Navigator.of(context).pop(false),
          ),
        ) ??
        false;

    //cancelar
    if (!result) return;

    //eliminar los seleccionados
    amounts.removeWhere((document) => document.checked == true);
    //calcular totales
    calculateTotales(context);
  }

  //Seleccionar una forma de pago agregada
  void changeCheckedamount(
    bool? value,
    int index,
  ) {
    //cambiar valor segun checkbox
    amounts[index].checked = value!;
    notifyListeners();
  }

  //seleccionar toas las formas de pago agregadas
  void selectAllMounts(bool? value) {
    selectAllAmounts = value!;

    //Cambiar todos los valores
    for (var element in amounts) {
      element.checked = selectAllAmounts;
    }
    notifyListeners();
  }

  //Navegar a pantalla para agregar datos de la forma de pago
  //monto, autorizacion y referencia
  Future<void> navigateAmount(
    BuildContext context,
    PaymentModel payment,
  ) async {
    //limpiar cuentas
    accounts.clear();

    notifyListeners();

    //View model externo
    final vmDetails = Provider.of<DetailsViewModel>(context, listen: false);
    final vmDoc = Provider.of<DocumentViewModel>(context, listen: false);

    if (vmDoc.clienteSelect == null) {
      NotificationService.showSnackbar(
          "Sleccione una cuenta antes de agregar pagos.");
      return;
    }

    if (payment.cuentaCorriente && !vmDoc.clienteSelect!.permitirCxC) {
      NotificationService.showSnackbar(
          "La cuenta asignada al documento no tiene permitido cuentas por cobrar.");
      return;
    }

    //si el cliente tiene permmitido CxC y la forma de pago
    if (vmDoc.clienteSelect!.permitirCxC && payment.cuentaCorriente) {
      //validar limite de credito
      if (vmDetails.total > (vmDoc.clienteSelect?.limiteCredito ?? 0)) {
        //Mostrar alerta
        NotificationService.showSnackbar(
            "El total del documento supera el limmite de credito de la cuenta asignada al documento.");
        return;
      }
    }

    //validaciones para poder navegar a la pantalla
    if (vmDetails.total == 0) {
      NotificationService.showSnackbar("El total a pagar es 0");
    } else if (saldo == 0) {
      NotificationService.showSnackbar("El saldo a pagar es 0");
    } else {
      if (payment.banco) await loadBancos(context);

      //Navegar a la pantalla siguiente
      Navigator.pushNamed(
        context,
        "amount",
        arguments: payment,
      );
    }
  }

  //agregar forma de pago
  void addAmount(AmountModel amount, BuildContext context) {
    amounts.add(amount); //agregar a lista
    calculateTotales(context); //calcular totales
  }

  //Calcular totales
  void calculateTotales(BuildContext context) {
    DocumentService.saveDocumentLocal(context);

    //View models externos
    final vmDetails = Provider.of<DetailsViewModel>(context, listen: false);
    final vmAmount = Provider.of<AmountViewModel>(context, listen: false);

    //Reicniciar valores
    saldo = 0;
    cambio = 0;
    pagado = 0;

    //Recorrer formas de pago agregadas
    for (var element in amounts) {
      double monto = element.amount;
      pagado += monto; //sumar totales
    }

    //Recorrer formas de pago agregadas
    for (var element in amounts) {
      double diference = element.diference;
      pagado += diference; //sumar totales
    }

    //Calcular cambio y saldo pendiente de pagar
    if (pagado > vmDetails.total) {
      cambio = pagado - vmDetails.total;
    } else {
      saldo = vmDetails.total - pagado;
    }

    //Agregar valores a los inputs
    vmAmount.montoController.text = saldo.toStringAsFixed(2);
    vmAmount.formValues["monto"] = saldo.toStringAsFixed(2);

    notifyListeners();
  }
}
