// ignore_for_file: deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/services/services.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/views/views.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class Tabs2View extends StatefulWidget {
  const Tabs2View({Key? key}) : super(key: key);

  @override
  State<Tabs2View> createState() => _Tabs2ViewState();
}

class _Tabs2ViewState extends State<Tabs2View>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    final vm = Provider.of<DocumentoViewModel>(context, listen: false);

    vm.tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData(context));
  }

  loadData(BuildContext context) {
    final vmFactura = Provider.of<DocumentoViewModel>(context, listen: false);

    //cargar documento guardado en el dispositivo
    DocumentService documentService = DocumentService();

    if (!vmFactura.editDoc) {
      documentService.loadDocumentSave(context);
    }

    final vmConfirm = Provider.of<ConfirmDocViewModel>(context, listen: false);
    vmConfirm.setIdDocumentoRef();
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
            length: 2, // Número de pestañas
            child: Scaffold(
              key: vmDetalle.scaffoldKey,
              appBar: AppBar(
                title: Text(
                  vmMenu.name,
                  style: StyleApp.title,
                ),
                actions: [
                  if (!vm.editDoc)
                    IconButton(
                      tooltip: AppLocalizations.of(context)!.translate(
                        BlockTranslate.factura,
                        'docRecientes',
                      ),
                      onPressed: () => Navigator.pushNamed(context, "recent"),
                      icon: const Icon(Icons.schedule),
                    ),
                  if (!vm.editDoc)
                    IconButton(
                      tooltip: AppLocalizations.of(context)!.translate(
                        BlockTranslate.botones,
                        'nuevoDoc',
                      ),
                      onPressed: () => vm.newDocument(context),
                      icon: const Icon(Icons.note_add_outlined),
                    ),
                  if (!vm.editDoc)
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
                  if (!vm.editDoc)
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
                  if (vm.editDoc)
                    IconButton(
                      tooltip: AppLocalizations.of(context)!.translate(
                        BlockTranslate.botones,
                        'guardar',
                      ),
                      onPressed: () {
                        vm.modifyDoc(context);
                        //guardar los cambios
                        // print("Aqui para guardar los cambios");
                      },
                      icon: const Icon(Icons.save_outlined),
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
                              style: StyleApp.normalBold,
                            ),
                            subtitle: Text(
                              "${vmMenu.documentoName} (${vmMenu.documento})",
                              style: StyleApp.normal,
                            ),
                          ),
                        if (vmDoc.serieSelect != null)
                          ListTile(
                            title: Text(
                              AppLocalizations.of(context)!.translate(
                                BlockTranslate.general,
                                'serie',
                              ),
                              style: StyleApp.normalBold,
                            ),
                            subtitle: Text(
                              "${vmDoc.serieSelect!.descripcion} (${vmDoc.serieSelect!.serieDocumento})",
                              style: StyleApp.normal,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
                bottom: TabBar(
                  controller: vm.tabController,
                  labelColor: Colors.black,
                  indicatorColor: AppNewTheme.primary,
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
                ],
              ),
            ),
          ),
          if (vm.isLoading)
            ModalBarrier(
              dismissible: false,
              // color: Colors.black.withOpacity(0.3),
              color: AppNewTheme.isDark()
                  ? AppNewTheme.darkBackroundColor
                  : AppNewTheme.backroundColor,
            ),
          if (vm.isLoading) const LoadWidget(),
        ],
      ),
    );
  }
}
