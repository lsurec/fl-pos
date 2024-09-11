// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:flutter_post_printer_example/bloc/print_bloc/print_bloc.dart';
import 'package:flutter_post_printer_example/libraries/app_data.dart'
    // ignore: library_prefixes
    as AppData;
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/print_view_model.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class PrintView extends StatelessWidget {
  const PrintView({super.key});

  @override
  Widget build(BuildContext context) {
    final PrintDocSettingsModel argument =
        ModalRoute.of(context)!.settings.arguments as PrintDocSettingsModel;

    return BlocProvider(
      create: (context) {
        return PrintBloc()..add(GetPrinterEvent());
      },
      child: SettingsFrom(
        settings: argument,
      ),
    );
  }
}

class SettingsFrom extends StatefulWidget {
  final PrintDocSettingsModel settings;

  const SettingsFrom({Key? key, required this.settings}) : super(key: key);

  @override
  State<SettingsFrom> createState() => _SettingsFromState();
}

class _SettingsFromState extends State<SettingsFrom> {
  final PrinterManager instanceManager = PrinterManager.instance;
  List<PrinterDevice> devices = [];
  PrinterDevice printerDefault = PrinterDevice(name: '', address: '');
  int paperDefault = 0;
  bool isPairedDefault = false;
  PrinterDevice printerSelect = PrinterDevice(name: '', address: '');
  StreamSubscription<PrinterDevice>? _subscriptionScan;
  StreamSubscription<BTStatus>? _subscriptionStatus;
  BTStatus _currentStatus = BTStatus.none;
  bool isPairedSelect = false;

  List<int>? pendingTask;

  @override
  void initState() {
    //  implement initState
    scan();
    status();
    super.initState();
  }

  @override
  void dispose() {
    //  implement dispose
    _subscriptionScan!.cancel();
    _subscriptionStatus!.cancel();
    super.dispose();
  }

  scan() {
    devices.clear();
    _subscriptionScan = instanceManager
        .discovery(
      type: PrinterType.bluetooth,
      isBle: isPairedSelect,
    )
        .listen((device) {
      setState(() {
        devices.add(
          PrinterDevice(
            name: device.name,
            address: device.address,
          ),
        );
      });
    });
  }

  status() {
    _subscriptionStatus = instanceManager.stateBluetooth.listen((status) {
      setState(() {
        _currentStatus = status;
      });
      if (status == BTStatus.connected && pendingTask != null) {
        if (Platform.isAndroid) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            PrinterManager.instance.send(
              type: PrinterType.bluetooth,
              bytes: pendingTask!,
            );
            pendingTask = null;
          });
        }
        if (Platform.isIOS) {
          PrinterManager.instance.send(
            type: PrinterType.bluetooth,
            bytes: pendingTask!,
          );
          pendingTask = null;
        }
      }
    });
  }

  Future connectDevice() async {
    await instanceManager.connect(
      type: PrinterType.bluetooth,
      model: BluetoothPrinterInput(
        name: printerDefault.name,
        address: printerDefault.address!,
        isBle: isPairedDefault,
        autoConnect: true,
      ),
    );
    setState(() {});
  }

  Future disconnectDevice() async {
    await instanceManager.disconnect(type: PrinterType.bluetooth);
    status();
    setState(() {
      _currentStatus = BTStatus.none;
    });
  }

  void _printerEscPos(List<int> bytes, Generator generator) async {
    if (printerDefault.address!.isEmpty) return;
    if (_currentStatus != BTStatus.connected) return;
    bytes += generator.cut();
    pendingTask = null;

    if (Platform.isAndroid) pendingTask = bytes;
    if (Platform.isAndroid) {
      await instanceManager.send(type: PrinterType.bluetooth, bytes: bytes);
      pendingTask = null;
    } else {
      await instanceManager.send(type: PrinterType.bluetooth, bytes: bytes);
    }
  }

  void setPrinter(int paper) {
    BlocProvider.of<PrintBloc>(context).add(
      SetPrinterEvent(
        name: printerSelect.name,
        address: printerSelect.address!,
        paired: isPairedSelect,
        paper: paper,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final printVM = Provider.of<PrintViewModel>(context);

    return BlocListener<PrintBloc, PrintState>(
      listener: (context, state) {
        if (state is SettingsInitialState) {}
        if (state is SettingsPrinterLoadingState) {
          printVM.isLoading = true;
        }
        if (state is SettingsPrinterReceivedState) {
          printerDefault.name = state.name;
          printerDefault.address = state.address;
          paperDefault = state.paper;
          isPairedDefault = state.paired;
          if (_currentStatus == BTStatus.connected) {
            disconnectDevice();
          }
          if (printerDefault.address!.isNotEmpty) {
            connectDevice();
          }
        }
        if (state is SettingsPrinterSuccessState) {
          printVM.isLoading = false;
        }
      },
      child: BlocBuilder<PrintBloc, PrintState>(
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                bottomNavigationBar: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  height: 80,
                  child: GestureDetector(
                    onTap: (_currentStatus == BTStatus.connected)
                        ? () async {
                            final PrintDocSettingsModel settings =
                                widget.settings;

                            switch (settings.opcion) {
                              case 1:
                                //1: prueba
                                PrintModel print =
                                    await printVM.printReceiveTest(
                                  context,
                                  paperDefault,
                                );

                                _printerEscPos(print.bytes, print.generator);
                                break;
                              case 2:
                                //2: docummento factura

                                PrintModel print = await printVM.printDocument(
                                  context, // context,
                                  paperDefault, // paperDefault,
                                  settings
                                      .consecutivoDoc!, // consecutivoDoc, //TODO: verificar eror
                                  settings.cuentaCorrentistaRef ?? "",
                                  settings.client!, // cuentaCorrentistaRef,
                                );

                                _printerEscPos(print.bytes, print.generator);
                                break;
                              case 3:
                                //3: documento conversion
                                PrintModel print =
                                    await printVM.printDocConversion(
                                  context,
                                  paperDefault,
                                  settings.destination!,
                                );

                                _printerEscPos(print.bytes, print.generator);
                                break;
                              case 4:
                                //4: cotizacion
                                PrintModel print =
                                    await printVM.printDocumentAlfayOmega(
                                  context,
                                  paperDefault,
                                  settings.consecutivoDoc!,
                                  settings.cuentaCorrentistaRef ?? "",
                                  settings.client!,
                                );

                                _printerEscPos(print.bytes, print.generator);
                                break;
                              default:
                            }
                          }
                        : null,
                    child: Container(
                      color: (_currentStatus == BTStatus.connected)
                          ? AppTheme.color(
                              context,
                              Styles.primary,
                            )
                          : AppTheme.color(
                              context,
                              Styles.grey,
                            ),
                      child: Center(
                        child: Text(
                          widget.settings.opcion == 1
                              ? AppLocalizations.of(context)!.translate(
                                  BlockTranslate.impresora,
                                  "prueba",
                                )
                              : AppLocalizations.of(context)!.translate(
                                  BlockTranslate.impresora,
                                  "documento",
                                ),
                          style: StyleApp.whiteBold,
                        ),
                      ),
                    ),
                  ),
                ),
                appBar: AppBar(
                  title: Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.impresora,
                      "impresion",
                    ),
                    style: StyleApp.title,
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        NotificationService.showInfoPrint(context);
                      },
                      icon: Icon(
                        Icons.help_outline,
                        color: AppTheme.color(
                          context,
                          Styles.icons,
                        ),
                        size: 20,
                      ),
                      tooltip: "Ayuda",
                    )
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.impresora,
                          "conectado",
                        ),
                        style: StyleApp.title,
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        title: Text(
                          printerDefault.name,
                          style: StyleApp.normal,
                        ),
                        subtitle: Text(
                          "${printerDefault.address!} | ${AppLocalizations.of(context)!.translate(
                            BlockTranslate.impresora,
                            "papelT",
                          )} $paperDefault",
                          style: StyleApp.subTitle,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                printerSelect = printerDefault;
                                isPairedSelect = isPairedDefault;
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) =>
                                      SelectSizePaperFrom(
                                    function: setPrinter,
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.edit,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                BlocProvider.of<PrintBloc>(context).add(
                                  DelPrinterEvent(),
                                );
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                        leading: Icon(
                          Icons.bluetooth,
                          color: AppData.statusColor[_currentStatus],
                        ),
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.impresora,
                          "disponibles",
                        ),
                        style: StyleApp.title,
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: devices.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                devices[index].name,
                                style: StyleApp.normal,
                              ),
                              subtitle: Text(
                                devices[index].address!,
                                style: StyleApp.subTitle,
                              ),
                              onTap: () {
                                setState(() {
                                  printerSelect = devices[index];
                                });
                              },
                              selected: printerSelect == devices[index],
                              trailing: printerSelect == devices[index]
                                  ? ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) =>
                                              SelectSizePaperFrom(
                                            function: setPrinter,
                                          ),
                                        );
                                      },
                                      style: AppTheme.button(
                                        context,
                                        Styles.buttonStyle,
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!.translate(
                                          BlockTranslate.botones,
                                          "agregar",
                                        ),
                                        style: StyleApp.whiteBold,
                                      ),
                                    )
                                  : null,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (printVM.isLoading)
                ModalBarrier(
                  dismissible: false,
                  // color: Colors.black.withOpacity(0.3),
                  color: AppTheme.color(
                    context,
                    Styles.loading,
                  ),
                ),
              if (printVM.isLoading) const LoadWidget(),
            ],
          );
        },
      ),
    );
  }
}

class SelectSizePaperFrom extends StatefulWidget {
  const SelectSizePaperFrom({super.key, required this.function});

  final Function function;

  @override
  State<SelectSizePaperFrom> createState() => _SelectSizePaperFromState();
}

class _SelectSizePaperFromState extends State<SelectSizePaperFrom> {
  int? paper;

  ///*************** initState ***************
  @override
  void initState() {
    super.initState();
  }

  ///*************** dispose ***************
  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.impresora,
          "selecPapel",
        ),
        style: StyleApp.subTitle,
      ),
      content: DropdownButtonFormField<int>(
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context)!.translate(
            BlockTranslate.impresora,
            "papelT",
          ),
        ),
        items: const [
          DropdownMenuItem(value: 58, child: Text("58mm")),
          DropdownMenuItem(value: 72, child: Text("72mm")),
          DropdownMenuItem(value: 80, child: Text("80mm")),
        ],
        onChanged: (value) {
          setState(() {
            paper = value!;
          });
        },
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: AppTheme.button(
            context,
            Styles.buttonStyle,
          ),
          child: Text(
            AppLocalizations.of(context)!.translate(
              BlockTranslate.botones,
              "cancelar",
            ),
            style: StyleApp.whiteNormal,
          ),
        ),
        ElevatedButton(
          onPressed: (paper != null)
              ? () {
                  widget.function(paper);
                  Navigator.pop(context);
                }
              : null,
          style: (paper != null)
              ? AppTheme.button(
                  context,
                  Styles.buttonStyle,
                ) //si esta desactivado
              : AppTheme.disabledButtonsStyle,
          child: Text(
            AppLocalizations.of(context)!.translate(
              BlockTranslate.botones,
              "conectar",
            ),
            style: StyleApp.whiteBold,
          ),
        ),
      ],
    );
  }
}
