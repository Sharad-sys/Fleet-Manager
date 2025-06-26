import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tester/features/auth/repositories/auth_repository.dart';
import 'package:tester/features/home/application/cubit/stats_state.dart';
import 'package:tester/features/home/model/stats_model/stats_model.dart';

class StatsCubit extends Cubit<StatsState> {
  final AuthRepository _authRepository;

  StatsCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(StatsInitial());

  Future<void> getMyStats() async {
    emit(StatsLoading());
    try {
      final response = await _authRepository.getMyStats();
      final stats = StatsModel.fromJson(response.data);
      emit(StatsSucess(transportStats: stats));
    } catch (e) {
      emit(StatsFailure(message: e.toString()));
      print('Exception in getMyStats: $e');
    }
  }
}
