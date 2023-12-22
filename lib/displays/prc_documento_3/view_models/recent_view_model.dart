// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/services/services.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RecentViewModel extends ChangeNotifier {
  //control del proceso
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //Lista de documentos recentes
  final List<GetDocModel> documents = [];

  //Navegar a vista detalles
  Future<void> navigateView(
    BuildContext context,
    GetDocModel doc,
  ) async {
    //Documento estructura json
    DocEstructuraModel document = DocEstructuraModel.fromJson(
      doc.estructura,
    );

    //Proveedor de datos externo
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);

    //usuario y token
    String token = vmLogin.token;
    String user = vmLogin.nameUser;

    //empresa del documento
    int empresa = document.docEmpresa;

    //servicio para cuentas
    CuentaService cuentaService = CuentaService();

    //iniciar proceso
    isLoading = true;

    //buscar nombre del cliente
    ApiResModel resNameClient = await cuentaService.getNombreCuenta(
      token, //token
      document.docCuentaCorrentista, //nombre del cliente (documento)
    );

    //Si el api para  falló
    if (!resNameClient.succes) {
      isLoading = false;

      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: resNameClient.message,
        url: resNameClient.url,
        storeProcedure: resNameClient.storeProcedure,
      );

      await NotificationService.showErrorView(
        context,
        error,
      );
      return;
    }

    //si la respuesta es correcta pero no se encontró ningun nombre
    if (!resNameClient.succes) {
      isLoading = false;
      //mostrar alerta
      showDialog(
        context: context,
        builder: (context) => AlertInfoWidget(
          title: "Algo salió mal",
          description:
              "No fue posible obtener el cliente asignado al documento.",
          onOk: () => Navigator.pop(context),
        ),
      );
      return;
    }

    //Nommbre del cliente del documemnto
    RespLogin nameClient = resNameClient.message;

    //Buscar cuenta del cliente
    ApiResModel resClient = await cuentaService.getClient(
      empresa,
      nameClient.data,
      user,
      token,
    );

    //Si el api  falló
    if (!resClient.succes) {
      isLoading = false;
      //mostrar dialogo de confirmacion
      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: resClient.message,
        url: resClient.url,
        storeProcedure: resClient.storeProcedure,
      );

      await NotificationService.showErrorView(
        context,
        error,
      );

      return;
    }

    //clientes encontrados
    List<ClientModel> clients = resClient.message;

    //si no se encontraron clientes
    if (clients.isEmpty) {
      isLoading = false;
      //Mostrar alerta
      showDialog(
        context: context,
        builder: (context) => AlertInfoWidget(
          title: "Algo salió mal",
          description:
              "No fue posible obtener el cliente asignado al documento.",
          onOk: () => Navigator.pop(context),
        ),
      );
      return;
    }

    //cuenta cliente del docuemento
    ClientModel? client;

    //buscar el cliente nen los clientes encontrados
    for (var element in clients) {
      //si es el mismo mcliente
      if (element.cuentaCorrentista == document.docCuentaCorrentista) {
        client = element; //asignar cliente
        break;
      }
    }

    //buscar nombre del vendedor del documento
    ApiResModel resVendedor = await cuentaService.getNombreCuenta(
      token,
      document.docCuentaVendedor,
    );

    //Si el api  falló
    if (!resVendedor.succes) {
      isLoading = false;

      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: resVendedor.message,
        url: resVendedor.url,
        storeProcedure: resVendedor.storeProcedure,
      );

      await NotificationService.showErrorView(
        context,
        error,
      );

      return;
    }

    //vendedor
    RespLogin vendedor = resVendedor.message;

    //si el api estuvo bien pero no se encontró el vendedor
    if (!vendedor.success) {
      isLoading = false;
      //mmostrar alerta
      showDialog(
        context: context,
        builder: (context) => AlertInfoWidget(
          title: "Algo salió mal",
          description:
              "No fue posible obtener el vendedor asignado al documento.",
          onOk: () => Navigator.pop(context),
        ),
      );
      return;
    }

    //vendedor del docuemmtnp
    String seller = vendedor.data;

    //servicio para los productos
    ProductService productService = ProductService();

    //Proveedor de datos externo
    final confirmVm = Provider.of<ConfirmDocViewModel>(
      context,
      listen: false,
    );

    //id tipo transaccon cargo
    int tipoCargo = confirmVm.resolveTipoTransaccion(3, context);
    //id tipo transaccon descuento
    int tipoDescuento = confirmVm.resolveTipoTransaccion(4, context);

    //totales
    double cargo = 0;
    double descuento = 0;
    double subtotal = 0;
    double total = 0;

    //transacciones del docummento
    final List<TransactionDetail> transactions = [];

    //buscar productos
    for (var item in document.docTransaccion) {
      //si la transaccion es cargo sumar cargos
      if (item.traTipoTransaccion == tipoCargo) {
        cargo += item.traMonto;
      }

      //si la transaccion es desceunto sumar descuentos
      if (item.traTipoTransaccion == tipoDescuento) {
        descuento += item.traMonto;
      }

      //si la transaccion no es cargo ni descuento
      if (item.traTipoTransaccion != tipoCargo &&
          item.traTipoTransaccion != tipoDescuento) {
        //sumar total transacciones
        subtotal += item.traMonto;

        //api buscar suku del producto
        ApiResModel resSku = await productService.getSku(
          token,
          item.traProducto,
        );

        //Si el api  falló
        if (!resSku.succes) {
          isLoading = false;

          ErrorModel error = ErrorModel(
            date: DateTime.now(),
            description: resSku.message,
            url: resSku.url,
            storeProcedure: resSku.storeProcedure,
          );

          await NotificationService.showErrorView(
            context,
            error,
          );

          return;
        }

        //sku del producto
        RespLogin sku = resSku.message;

        //si el api fue correcto pero no encontró el sku
        if (!sku.success) {
          isLoading = false;
          showDialog(
            context: context,
            builder: (context) => AlertInfoWidget(
              title: "Algo salió mal",
              description:
                  "No fue posible obtener las transacciones del documento.",
              onOk: () => Navigator.pop(context),
            ),
          );
          return;
        }

        //Buscar producto por sku
        ApiResModel resProduct = await productService.getProductId(
          sku.data,
          token,
        );

        //I el api falló
        if (!resProduct.succes) {
          isLoading = false;

          ErrorModel error = ErrorModel(
            date: DateTime.now(),
            description: resProduct.message,
            url: resProduct.url,
            storeProcedure: resProduct.storeProcedure,
          );

          await NotificationService.showErrorView(
            context,
            error,
          );

          return;
        }

        //productos encontrados
        List<ProductModel> products = resProduct.message;

        //si no se encontró el producto
        if (products.isEmpty) {
          isLoading = false;

          //mmostrar alerrta
          showDialog(
            context: context,
            builder: (context) => AlertInfoWidget(
              title: "Algo salió mal",
              description:
                  "No fue posible obtener las transacciones del documento.",
              onOk: () => Navigator.pop(context),
            ),
          );
          return;
        }

        //si solo hay un producto
        if (products.length == 1) {
          //objeto transaccion
          TransactionDetail transactionDetail = TransactionDetail(
            product: products.first,
            cantidad: item.traCantidad,
            total: item.traMonto,
          );

          //agregar transaccion
          transactions.add(transactionDetail);
        } else {
          //si hay mas productos
          for (var product in products) {
            //buscar producto de la transaccion
            if (product.producto == item.traProducto) {
              //Objeti transaccion
              TransactionDetail transactionDetail = TransactionDetail(
                product: products.first,
                cantidad: item.traCantidad,
                total: item.traMonto,
              );

              //transaccion
              transactions.add(transactionDetail);
            }

            break;
          }
        }
      }
    }

    //calcular total
    total += (subtotal + cargo) + descuento;

    //search pagos
    final List<AmountModel> payments = [];

    //proveedor de datos externo
    PagoService pagoService = PagoService();

    ApiResModel resFormas = await pagoService.getFormas(
      document.docTipoDocumento,
      document.docSerieDocumento,
      empresa,
      token,
    );

    if (!resFormas.succes) {
      isLoading = false;

      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: resFormas.message,
        url: resFormas.url,
        storeProcedure: resFormas.storeProcedure,
      );

      await NotificationService.showErrorView(
        context,
        error,
      );

      return;
    }

    final List<PaymentModel> formas = resFormas.message;

    if (formas.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertInfoWidget(
          title: "Algo salió mal",
          description:
              "No fue posible obtener la forma de pago asignada al documento.",
          onOk: () => Navigator.pop(context),
        ),
      );
      return;
    }

    for (var formaDoc in document.docCargoAbono) {
      for (var i = 0; i < formas.length; i++) {
        final PaymentModel forma = formas[i];
        if (formaDoc.tipoCargoAbono == forma.tipoCargoAbono) {
          AmountModel amount = AmountModel(
            checked: false,
            amount: formaDoc.monto,
            diference: 0,
            authorization: formaDoc.autorizacion,
            reference: formaDoc.referencia,
            payment: forma,
          );

          //agregar forma de pago
          payments.add(amount);
          break;
        }
      }
    }

    //Objeto detalles del documento
    final DetailDocModel details = DetailDocModel(
      doc: document.docTipoDocumento,
      serie: document.docSerieDocumento,
      client: client!,
      seller: seller,
      transactions: transactions,
      payments: payments,
      subtotal: subtotal,
      total: total,
      cargo: cargo,
      descuento: descuento,
      observacion: document.docObservacion1,
    );

    //navegar a pantalla detalles
    Navigator.pushNamed(
      context,
      "detailsDoc",
      arguments: details,
    );

    //finalizar proceso
    isLoading = false;
  }

  //fehca str a Date formmat dd/MM/yyyy hh:mm
  String strDate(String dateStr) {
    // Convierte la cadena a un objeto DateTime
    DateTime dateTime = DateTime.parse(dateStr);

    // Formatea la fecha en el formato dd/MM/yyyy
    String formattedDate = DateFormat('dd/MM/yyyy hh:mm').format(dateTime);

    return formattedDate;
  }

  //ibtener total del documento
  Map<String, double> getTotalDoc(BuildContext context, String document) {
    //porveedor de dtaos externos
    final confirmVm = Provider.of<ConfirmDocViewModel>(
      context,
      listen: false,
    );

    //id tipo transaccion cargo
    int tipoCargo = confirmVm.resolveTipoTransaccion(3, context);
    //id tipo transaccion descuento
    int tipoDescuento = confirmVm.resolveTipoTransaccion(4, context);

    //Totales
    double cargo = 0;
    double descuento = 0;
    double subtotal = 0;
    double total = 0;

    //Docummento estructura
    DocEstructuraModel doc = DocEstructuraModel.fromJson(document);

    //recorrer la transacciones
    for (var tra in doc.docTransaccion) {
      //Si no es ni cargo ni desceuntosumar total transaccones
      if (tra.traTipoTransaccion != tipoCargo &&
          tra.traTipoTransaccion != tipoDescuento) {
        subtotal += tra.traMonto;
      }

      //sii es cargo sumar cargo
      if (tra.traTipoTransaccion == tipoCargo) {
        cargo += tra.traMonto;
      }

      //si es descuento sumar descuento
      if (tra.traTipoTransaccion == tipoDescuento) {
        descuento += tra.traMonto;
      }
    }

    //calcular total
    total = (subtotal + cargo) + descuento;

    //retornar totales
    return <String, double>{
      'cargo': cargo,
      'descuento': descuento,
      'subtotal': subtotal,
      'total': total,
    };
  }

  //buscar documentos recientes
  Future<void> loadDocs(BuildContext context) async {
    //Proveedor de datos externos
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);

    //usuario y token
    String user = loginVM.nameUser;
    String token = loginVM.token;

    //servicio documentos
    DocumentService documentService = DocumentService();

    //elinar documentos existentes
    documents.clear();

    //inciar proceso
    isLoading = true;

    //consummo api buscar documentos recienets
    final ApiResModel res = await documentService.getDocument(0, user, token);

    //finalizar procesp
    isLoading = false;

    //Si el api falló
    if (!res.succes) {
      //mostrar dialogo de confirmacion
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

    //agregar documentos encontrados
    documents.addAll(res.message);
  }
}
