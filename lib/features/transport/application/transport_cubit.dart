import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tester/features/auth/repositories/auth_repository.dart';
import 'package:tester/features/transport/application/transport_state.dart';

class TransportCubit extends Cubit<TransportState> {
  final AuthRepository _authRepository;

  TransportCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(TransportInitial());

  // Future<void> showTransportHistory() async {
  //   try {
  //     await _authRepository.showTransportHistory();
  //   } catch (e) {
  //     print('exception $e');
  //   }
  // }

  Future<void> acceptRequest(int transportId) async {
    emit(TransportActionInProgress());
    try {
      await _authRepository.acceptRequest(transportId);

      await Future.delayed(const Duration(seconds: 1));
      emit(
        TransportActionSuccess(transportId: transportId, action: 'accepted'),
      );
    } catch (e) {
      emit(TransportActionFailure(message: 'Failed to accept request'));
    }
  }

  Future<void> rejectRequest(int transportId) async {
    emit(TransportActionInProgress());
    try {
      await _authRepository.rejectRequest(transportId);

      await Future.delayed(const Duration(seconds: 1));
      emit(
        TransportActionSuccess(transportId: transportId, action: 'rejected'),
      );
    } catch (e) {
      emit(TransportActionFailure(message: 'Failed to reject request'));
    }
  }

  Future<void> completedAdminRequest(int transportId) async {
    emit(TransportActionInProgress());
    try {
      await _authRepository.completedAdminRequest(transportId);

      await Future.delayed(const Duration(seconds: 1));
      emit(
        TransportActionSuccess(transportId: transportId, action: 'rejected'),
      );
    } catch (e) {
      emit(TransportActionFailure(message: 'Failed to reject request'));
    }
  }
}
