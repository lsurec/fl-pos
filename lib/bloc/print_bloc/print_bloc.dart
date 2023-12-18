import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_post_printer_example/services/storages/storage_printer.dart';

part 'print_event.dart';
part 'print_state.dart';

class PrintBloc extends Bloc<PrintEvent, PrintState> {
  @override
  PrintBloc() : super(SettingsInitialState());

  PrintState get initialState => SettingsInitialState();

  @override
  Stream<PrintState> mapEventToState(PrintEvent event) async* {
    final sp = StoragePrinter();
    try {
      if (event is GetPrinterEvent) {
        yield SettingsPrinterLoadingState();
        yield SettingsPrinterReceivedState(
            name: await sp.getName(),
            address: await sp.getAddress(),
            paired: await sp.getPaired(),
            paper: await sp.getPaper());
        yield SettingsPrinterSuccessState();
      }
      if (event is DelPrinterEvent) {
        yield SettingsPrinterLoadingState();
        sp.delPrinter();
        yield SettingsPrinterReceivedState(
            name: await sp.getName(),
            address: await sp.getAddress(),
            paired: await sp.getPaired(),
            paper: await sp.getPaper());
        yield SettingsPrinterSuccessState();
      }
      if (event is SetPrinterEvent) {
        yield SettingsPrinterLoadingState();
        sp.setPrinter(
            name: event.name,
            address: event.address,
            paired: event.paired,
            paper: event.paper);
        yield SettingsPrinterReceivedState(
            name: await sp.getName(),
            address: await sp.getAddress(),
            paired: await sp.getPaired(),
            paper: await sp.getPaper());
        yield SettingsPrinterSuccessState();
      }

      if (event is PrintTicketEvent) {
        yield SettingsPrinterLoadingState();
        yield SettingsPrinterSuccessState();
      }
    } catch (error) {
      yield SettingsFailureState(error: error.toString());
    }
  }
}
