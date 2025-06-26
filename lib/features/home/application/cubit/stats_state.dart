import 'package:equatable/equatable.dart';
import 'package:tester/features/home/model/stats_model/stats_model.dart';

abstract class StatsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StatsInitial extends StatsState {}

class StatsLoading extends StatsState {}

class StatsSucess extends StatsState {

  final StatsModel transportStats;

  StatsSucess({required this.transportStats});

  @override
  List<Object?> get props => [transportStats];
}

class StatsFailure extends StatsState {
  final String message;

  StatsFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
