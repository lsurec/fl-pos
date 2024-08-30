// ignore_for_file: deprecated_member_use

import 'package:flutter_post_printer_example/displays/prc_documento_3/services/services.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/views/views.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Tabs3View extends StatefulWidget {
  const Tabs3View({Key? key}) : super(key: key);

  @override
  State<Tabs3View> createState() => _Tabs3ViewState();
}

class _Tabs3ViewState extends State<Tabs3View>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    final vm = Provider.of<DocumentoViewModel>(context, listen: false);

    vm.tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData(context));
  }

  loadData(BuildContext context) {
    final vmConfirm = Provider.of<ConfirmDocViewModel>(context, listen: false);
    vmConfirm.setIdDocumentoRef();
    //cargar documento guardado en el dispositivo
    DocumentService documentService = DocumentService();
    documentService.loadDocumentSave(context);
  }

  // @override
  // void dispose() {
  //   final vm = Provider.of<DocumentoViewModel>(context, listen: false);

  //   vm.tabController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DocumentoViewModel>(context);
    final vmMenu = Provider.of<MenuViewModel>(context);
    final vmDoc = Provider.of<DocumentViewModel>(context);
    final vmDetalle = Provider.of<DetailsViewModel>(context);

    return WillPopScope(
      onWillPop: () => vm.back(context),
      child: Stack(
        children: [
          DefaultTabController(
            length: 3, // Número de pestañas
            child: Scaffold(
              key: vmDetalle.scaffoldKey,
              appBar: AppBar(
                title: Text(
                  vmMenu.name,
                  style: AppTheme.style(
                    context,
                    Styles.title,
                  ),
                ),
                actions: [
                  IconButton(
                    tooltip: AppLocalizations.of(context)!.translate(
                      BlockTranslate.factura,
                      'docRecientes',
                    ),
                    onPressed: () => Navigator.pushNamed(context, "recent"),
                    icon: const Icon(Icons.schedule),
                  ),
                  IconButton(
                    tooltip: AppLocalizations.of(context)!.translate(
                      BlockTranslate.botones,
                      'nuevoDoc',
                    ),
                    onPressed: () => vm.newDocument(context),
                    icon: const Icon(Icons.note_add_outlined),
                  ),
                  if (vmDoc.monitorPrint())
                    IconButton(
                      onPressed: () => vm.sendDocumnet(
                        context,
                        2,
                      ),
                      icon: const Icon(
                        Icons.desktop_windows_outlined,
                      ),
                    ),
                  IconButton(
                    tooltip: AppLocalizations.of(context)!.translate(
                      BlockTranslate.botones,
                      'imprimir',
                    ),
                    onPressed: () => vm.sendDocumnet(
                      context,
                      1,
                    ),
                    icon: const Icon(Icons.print_outlined),
                  ),
                  UserWidget(
                    child: Column(
                      children: [
                        if (vmMenu.documento != null)
                          ListTile(
                            title: Text(
                              AppLocalizations.of(context)!.translate(
                                BlockTranslate.factura,
                                'tipoDoc',
                              ),
                              style: AppTheme.style(
                                context,
                                Styles.bold,
                              ),
                            ),
                            subtitle: Text(
                              "${vmMenu.documentoName} (${vmMenu.documento})",
                              style: AppTheme.style(
                                context,
                                Styles.normal,
                              ),
                            ),
                          ),
                        if (vmDoc.serieSelect != null)
                          ListTile(
                            title: Text(
                              AppLocalizations.of(context)!.translate(
                                BlockTranslate.general,
                                'serie',
                              ),
                              style: AppTheme.style(
                                context,
                                Styles.bold,
                              ),
                            ),
                            subtitle: Text(
                              "${vmDoc.serieSelect!.descripcion} (${vmDoc.serieSelect!.serieDocumento})",
                              style: AppTheme.style(
                                context,
                                Styles.normal,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
                bottom: TabBar(
                  controller: vm.tabController,
                  labelColor: AppTheme.color(
                    context,
                    Styles.normal,
                  ),
                  indicatorColor: AppTheme.color(
                    context,
                    Styles.darkPrimary,
                  ),
                  tabs: [
                    Tab(
                      text: AppLocalizations.of(context)!.translate(
                        BlockTranslate.general,
                        'documento',
                      ),
                    ),
                    Tab(
                      text: AppLocalizations.of(context)!.translate(
                        BlockTranslate.general,
                        'detalle',
                      ),
                    ),
                    Tab(
                      text: AppLocalizations.of(context)!.translate(
                        BlockTranslate.general,
                        'pago',
                      ),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                controller: vm.tabController,
                children: const [
                  // Contenido de la primera pestaña
                  DocumentView(),
                  // Contenido de la segunda pestaña
                  DetailsView(),
                  // Contenido de la tercera pestaña
                  PaymentView(),
                ],
              ),
            ),
          ),
          if (vm.isLoading)
            ModalBarrier(
              dismissible: false,
              // color: Colors.black.withOpacity(0.3),
              color: AppTheme.color(
                context,
                Styles.loading,
              ),
            ),
          if (vm.isLoading) const LoadWidget(),
        ],
      ),
    );
  }
}
