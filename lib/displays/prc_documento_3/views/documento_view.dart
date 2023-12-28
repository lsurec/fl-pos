import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/views/views.dart';
import 'package:flutter_post_printer_example/widgets/user_widget.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DocumentoView extends StatefulWidget {
  const DocumentoView({Key? key}) : super(key: key);

  @override
  State<DocumentoView> createState() => _DocumentoViewState();
}

class _DocumentoViewState extends State<DocumentoView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) => loadData(context));
  }

  loadData(BuildContext context) {
    final vmFactura = Provider.of<DocumentoViewModel>(context, listen: false);
    vmFactura.loadData(context);
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
          length: 3, // Número de pestañas
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                vmMenu.name,
                style: AppTheme.titleStyle,
              ),
              actions: [
                IconButton(
                  tooltip: "Documentos recientes",
                  onPressed: () => Navigator.pushNamed(context, "recent"),
                  icon: const Icon(Icons.schedule),
                ),
                IconButton(
                  tooltip: "Nuevo documento",
                  onPressed: () => vm.newDocument(context, _goToFirstTab),
                  icon: const Icon(Icons.note_add_outlined),
                ),
                IconButton(
                  tooltip: "Imprimir",
                  onPressed: () => vm.sendDocumnet(context),
                  icon: const Icon(Icons.print_outlined),
                ),
                UserWidget(
                  child: Column(
                    children: [
                      if (vmMenu.documento != null)
                        ListTile(
                          title: const Text(
                            "Tipo documento",
                            style: AppTheme.normalBoldStyle,
                          ),
                          subtitle: Text(
                            "${vmMenu.docuentoName} (${vmMenu.documento})",
                            style: AppTheme.normalStyle,
                          ),
                        ),
                      if (vmDoc.serieSelect != null)
                        ListTile(
                          title: const Text(
                            "Serie",
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
                tabs: const [
                  Tab(text: 'Documento'),
                  Tab(text: 'Detalle'),
                  Tab(text: 'Pago'),
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
            color: AppTheme.backroundColor,
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}
