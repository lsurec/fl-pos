// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/documento_resumen_model.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/services/services.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/models/models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/services/empresa_service.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/services/estacion_service.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
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
  final List<DocumentoResumenModel> documents = [];

  //Navegar a vista detalles
  Future<void> navigateView(
    BuildContext context,
    DocumentoResumenModel doc,
  ) async {
    //Proveedor de datos externo
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);

    //usuario y token
    String token = vmLogin.token;
    String user = doc.estructura.docUserName;
    int empresaId = doc.estructura.docEmpresa;
    int estacionid = doc.estructura.docEstacionTrabajo;
    int documento = doc.estructura.docTipoDocumento;
    String serieDoc = doc.estructura.docSerieDocumento;
    int cuentaCorrentista = doc.estructura.docCuentaCorrentista;
    int cuentaCorrentistaRef = doc.estructura.docCuentaVendedor ?? 0;

    EmpresaModel? empresa;
    EstacionModel? estacion;
    String documentoDesc = "";
    String serieDesc = "";
    ClientModel? client;
    String seller = "";

    isLoading = true;

    final EmpresaService empresaService = EmpresaService();

    final ApiResModel resEmpresa = await empresaService.getEmpresa(user, token);

    //Si el api para  falló
    if (!resEmpresa.succes) {
      isLoading = false;

      await NotificationService.showErrorView(
        context,
        resEmpresa,
      );
      return;
    }

    final List<EmpresaModel> empresas = resEmpresa.message;

    for (var i = 0; i < empresas.length; i++) {
      final EmpresaModel item = empresas[i];

      if (item.empresa == empresaId) {
        empresa = item;
        break;
      }
    }

    final EstacionService estacionService = EstacionService();

    final ApiResModel resEstacion = await estacionService.getEstacion(
      user,
      token,
    );

    //Si el api para  falló
    if (!resEstacion.succes) {
      isLoading = false;

      await NotificationService.showErrorView(
        context,
        resEstacion,
      );
      return;
    }

    final List<EstacionModel> estaciones = resEstacion.message;

    for (var i = 0; i < estaciones.length; i++) {
      final EstacionModel item = estaciones[i];

      if (item.estacionTrabajo == estacionid) {
        estacion = item;
        break;
      }
    }

    final SerieService serieService = SerieService();

    final ApiResModel resSerie = await serieService.getSerie(
      documento,
      empresaId,
      estacionid,
      user,
      token,
    );

    //Si el api para  falló
    if (!resSerie.succes) {
      isLoading = false;

      await NotificationService.showErrorView(
        context,
        resSerie,
      );
      return;
    }

    final List<SerieModel> series = resSerie.message;

    for (var i = 0; i < series.length; i++) {
      final SerieModel item = series[i];

      if (item.serieDocumento == serieDoc) {
        serieDesc = "${item.descripcion} ($serieDoc)";
        documentoDesc = "${item.desTipoDocumento} ($documento)";
        break;
      }
    }

    final CuentaService cuentaService = CuentaService();

    final ApiResModel resNameClient = await cuentaService.getNombreCuenta(
      token,
      cuentaCorrentista,
    );

    //Si el api para  falló
    if (!resNameClient.succes) {
      isLoading = false;

      await NotificationService.showErrorView(
        context,
        resNameClient,
      );
      return;
    }

    final RespLogin nameClient = resNameClient.message;

    if (nameClient.data != null) {
      final ApiResModel resCuentaClient =
          await cuentaService.getCuentaCorrentista(
        empresaId,
        nameClient.data,
        user,
        token,
      );

      //Si el api para  falló
      if (!resCuentaClient.succes) {
        isLoading = false;

        await NotificationService.showErrorView(
          context,
          resCuentaClient,
        );
        return;
      }

      final List<ClientModel> cuentas = resCuentaClient.message;

      for (var i = 0; i < cuentas.length; i++) {
        final ClientModel item = cuentas[i];

        if (item.cuentaCorrentista == cuentaCorrentista) {
          client = item;
          break;
        }
      }
    }

    final ApiResModel resVendedor = await cuentaService.getCeuntaCorrentistaRef(
      user,
      documento,
      serieDoc,
      empresaId,
      token,
    );

    //Si el api para  falló
    if (!resVendedor.succes) {
      isLoading = false;

      await NotificationService.showErrorView(
        context,
        resVendedor,
      );
      return;
    }

    final List<SellerModel> vendedores = resVendedor.message;

    for (var i = 0; i < vendedores.length; i++) {
      final SellerModel item = vendedores[i];

      if (item.cuentaCorrentista == cuentaCorrentistaRef) {
        seller = item.nomCuentaCorrentista;
        break;
      }
    }

    final List<TransactionDetail> transacciones = [];

    final ProductService productService = ProductService();

    for (var tra in doc.estructura.docTransaccion) {
      final ApiResModel resSku = await productService.getSku(
        token,
        tra.traProducto,
        tra.traUnidadMedida,
      );

      //Si el api para  falló
      if (!resSku.succes) {
        isLoading = false;

        await NotificationService.showErrorView(
          context,
          resSku,
        );
        return;
      }

      final RespLogin sku = resSku.message;

      final ApiResModel resProduct = await productService.getProductId(
        sku.data,
        token,
      );

      //Si el api para  falló
      if (!resProduct.succes) {
        isLoading = false;

        await NotificationService.showErrorView(
          context,
          resProduct,
        );
        return;
      }

      final List<ProductModel> products = resProduct.message;

      for (var i = 0; i < products.length; i++) {
        final ProductModel item = products[i];

        if (item.producto == tra.traProducto) {
          transacciones.add(
            TransactionDetail(
              product: item,
              cantidad: tra.traCantidad,
              total: tra.traMonto,
            ),
          );
          break;
        }
      }
    }

    final PagoService pagoService = PagoService();

    final ApiResModel resPagos = await pagoService.getFormas(
      documento,
      serieDoc,
      empresaId,
      token,
    );

    //Si el api para  falló
    if (!resPagos.succes) {
      isLoading = false;

      showError(context, resPagos);

      return;
    }

    final List<PaymentModel> pagos = resPagos.message;

    final List<AmountModel> montos = [];

    for (var pago in doc.estructura.docCargoAbono) {
      BankModel? banco;
      AccountModel? ceuntaBanco;

      if (pago.banco != null) {
        final ApiResModel resBancos = await pagoService.getBancos(
          user,
          empresaId,
          token,
        );

        //Si el api para  falló
        if (!resBancos.succes) {
          isLoading = false;

          showError(context, resBancos);

          return;
        }

        final List<BankModel> bancos = resBancos.message;

        for (var i = 0; i < bancos.length; i++) {
          final BankModel item = bancos[i];

          if (item.banco == pago.banco) {
            banco = item;
            break;
          }
        }

        if (banco != null && pago.cuentaBancaria != null) {
          final ApiResModel resCuentaBanco = await pagoService.getCuentas(
            user,
            empresaId,
            banco.banco,
            token,
          );

          //Si el api para  falló
          if (!resCuentaBanco.succes) {
            isLoading = false;

            showError(context, resCuentaBanco);

            return;
          }

          List<AccountModel> cuentasBanco = resCuentaBanco.message;

          for (var i = 0; i < cuentasBanco.length; i++) {
            final AccountModel item = cuentasBanco[i];

            if (item.banco == pago.banco) {
              ceuntaBanco = item;
              break;
            }
          }
        }
      }

      for (var i = 0; i < pagos.length; i++) {
        final PaymentModel item = pagos[i];

        if (item.tipoCargoAbono == pago.tipoCargoAbono) {
          montos.add(
            AmountModel(
              checked: false,
              amount: pago.monto,
              diference: pago.cambio,
              authorization: pago.autorizacion,
              reference: pago.referencia,
              payment: item,
              account: ceuntaBanco,
              bank: banco,
            ),
          );

          break;
        }
      }
    }

    final DetailDocModel detallesDoc = DetailDocModel(
      fecha: strDate(doc.item.fechaHora),
      consecutivo: doc.item.consecutivoInterno,
      empresa: empresa!,
      estacion: estacion!,
      client: client,
      seller: seller,
      transactions: transacciones,
      payments: montos,
      cargo: doc.cargo,
      descuento: doc.descuento,
      observacion: doc.estructura.docObservacion1,
      subtotal: doc.subtotal,
      total: doc.total,
      documento: documento,
      serie: serieDoc,
      documentoDesc: documentoDesc,
      serieDesc: serieDesc,
    );

    Navigator.pushNamed(
      context,
      AppRoutes.detailsDoc,
      arguments: detallesDoc,
    );

    //finalizar proceso
    isLoading = false;
  }

  showError(
    BuildContext context,
    ApiResModel res,
  ) async {
    //Si el api para  falló

    await NotificationService.showErrorView(
      context,
      res,
    );
  }

  //fehca str a Date formmat dd/MM/yyyy hh:mm
  String strDate(String dateStr) {
    // Convierte la cadena a un objeto DateTime
    DateTime dateTime = DateTime.parse(dateStr);

    // Formatea la fecha en el formato dd/MM/yyyy
    String formattedDate = DateFormat('dd/MM/yyyy hh:mm').format(dateTime);

    return formattedDate;
  }

  //buscar documentos recientes
  Future<void> loadDocs(BuildContext context) async {
    //Proveedor de datos externos
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);

    //usuario y token
    String user = loginVM.user;
    String token = loginVM.token;

    //servicio documentos
    DocumentService documentService = DocumentService();

    //elinar documentos existentes
    documents.clear();

    //inciar proceso
    isLoading = true;

    //consummo api buscar documentos recienets
    final ApiResModel res = await documentService.getDocument(
      0,
      user,
      token,
    );

    //Si el api falló
    if (!res.succes) {
      //finalizar procesp
      isLoading = false;
      //mostrar dialogo de confirmacion

      await NotificationService.showErrorView(
        context,
        res,
      );
      return;
    }

    final List<GetDocModel> docs = res.message;

    for (var doc in docs) {
      final DocEstructuraModel estructura =
          DocEstructuraModel.fromJson(doc.estructura);

      double subtotal = 0;
      double cargo = 0;
      double descuento = 0;
      double total = 0;

      for (var tra in estructura.docTransaccion) {
        if (tra.traCantidad == 0 && tra.traMonto > 0) {
          cargo += tra.traMonto;
        } else if (tra.traCantidad == 0 && tra.traMonto < 0) {
          descuento += tra.traMonto;
        } else {
          subtotal += tra.traMonto;
        }
      }

      total = (subtotal + cargo) + descuento;

      documents.add(
        DocumentoResumenModel(
          item: doc,
          estructura: estructura,
          subtotal: subtotal,
          cargo: cargo,
          descuento: descuento,
          total: total,
        ),
      );
    }

    //finalizar procesp
    isLoading = false;
  }
}
