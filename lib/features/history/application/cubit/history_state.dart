import 'package:equatable/equatable.dart';
import 'package:tester/features/history/models/history.dart';

abstract class HistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistorySucess extends HistoryState {
  final List<History> completedRides;

  HistorySucess({required this.completedRides});

  @override
  List<Object?> get props => [completedRides];
}

class HistoryFailure extends HistoryState {
  final String message;

  HistoryFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
