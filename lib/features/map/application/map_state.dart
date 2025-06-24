import 'package:equatable/equatable.dart';
import 'package:tester/features/map/models/transport.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapSuccess extends MapState {
  final String message;

  const MapSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class MapLoaded extends MapState {
  final List<Transport> transportList;

  const MapLoaded(this.transportList);

  @override
  List<Object?> get props => [transportList];
}

class MapError extends MapState {
  final String errorMessage;

  const MapError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
