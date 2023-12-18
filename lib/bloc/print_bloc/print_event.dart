part of 'print_bloc.dart';

abstract class PrintEvent extends Equatable {
  const PrintEvent();

  @override
  List<Object> get props => [];
}

class GetPrinterEvent extends PrintEvent {}

// ignore: must_be_immutable
class SetPrinterEvent extends PrintEvent {
  String name;
  String address;
  bool paired;
  int paper;

  SetPrinterEvent({
    required this.name,
    required this.address,
    required this.paired,
    required this.paper,
  });
}

class DelPrinterEvent extends PrintEvent {}

class PrintTicketEvent extends PrintEvent {}
