import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/services/services.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/views/views.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
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
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData(context));
  }

  loadData(BuildContext context) {
    //cargar documento guardado en el dispositivo
    DocumentService documentService = DocumentService();
    documentService.loadDocumentSave(context);
    final vmConfirm = Provider.of<ConfirmDocViewModel>(context, listen: false);
    vmConfirm.setIdDocumentoRef();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _goToFirstTab() {
    _tabController.animateTo(0); // Cambiar al primer tab (índice 0)
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DocumentoViewModel>(context);
    final vmMenu = Provider.of<MenuViewModel>(context);
    final vmDoc = Provider.of<DocumentViewModel>(context);

    return Stack(
      children: [
        DefaultTabController(
          length: 2, // Número de pestañas
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                vmMenu.name,
                style: AppTheme.titleStyle,
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
                  onPressed: () => vm.newDocument(context, _goToFirstTab),
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
                            style: AppTheme.normalBoldStyle,
                          ),
                          subtitle: Text(
                            "${vmMenu.documentoName} (${vmMenu.documento})",
                            style: AppTheme.normalStyle,
                          ),
                        ),
                      if (vmDoc.serieSelect != null)
                        ListTile(
                          title: Text(
                            AppLocalizations.of(context)!.translate(
                              BlockTranslate.general,
                              'serie',
                            ),
                            style: AppTheme.normalBoldStyle,
                          ),
                          subtitle: Text(
                            "${vmDoc.serieSelect!.descripcion} (${vmDoc.serieSelect!.serieDocumento})",
                            style: AppTheme.normalStyle,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
              bottom: TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                indicatorColor: AppTheme.primary,
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
              controller: _tabController,
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
            color: AppTheme.backroundColor,
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}
