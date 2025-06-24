import 'package:equatable/equatable.dart';

abstract class TransportState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TransportInitial extends TransportState {}

class TransportActionInProgress extends TransportState {}

class TransportActionSuccess extends TransportState {
  final int transportId;
  final String action;

  TransportActionSuccess({required this.transportId, required this.action});

  @override
  List<Object?> get props => [transportId, action];
}

class TransportActionFailure extends TransportState {
  final String message;

  TransportActionFailure({required this.message});

  @override
  List<Object?> get props => [message];

}
