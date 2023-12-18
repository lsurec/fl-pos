part of 'print_bloc.dart';

abstract class PrintState extends Equatable {
  const PrintState();

  @override
  List<Object> get props => [];
}

class SettingsInitialState extends PrintState {}

class SettingsPrinterLoadingState extends PrintState {}

// ignore: must_be_immutable
class SettingsPrinterReceivedState extends PrintState {
  String name;
  String address;
  bool paired;
  int paper;

  SettingsPrinterReceivedState({
    required this.name,
    required this.address,
    required this.paired,
    required this.paper,
  });

  @override
  List<Object> get props => [name, address, paired, paper];

  @override
  String toString() =>
      "SettingsPrinterReceivedState{ name: $name,address:$address,paired:$paired,paper:$paper}";
}

class SettingsPrinterSuccessState extends PrintState {}

// ignore: must_be_immutable
class SettingsTicketReceivedState extends PrintState {
  dynamic ticket;
  SettingsTicketReceivedState({required this.ticket});
  @override
  List<Object> get props => [ticket];
  @override
  String toString() => "SettingsTicketReceivedState{ ticket: $ticket}";
}

class SettingsFailureState extends PrintState {
  final String error;

  const SettingsFailureState({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => "SettingsFailureState{error:$error}";
}
