import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tester/features/auth/repositories/auth_repository.dart';
import 'package:tester/features/history/application/cubit/history_state.dart';
import 'package:tester/features/history/models/history.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final AuthRepository _authRepository;

  HistoryCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(HistoryInitial());

 Future<void> fetchHistory(int staffId) async {
  emit(HistoryLoading());
  try {
    final response = await _authRepository.showTransportHistory(staffId);

    print("response: ${response.data}");

    final List<dynamic> data = response.data['data'];
    final List<History> rides = data
        .map((rideJson) => History.fromJson(rideJson))
        .toList();

    emit(HistorySucess(completedRides: rides),);
  } catch (e) {
    emit(HistoryFailure(message: e.toString()));
    print('exception $e');
  }
}

}
