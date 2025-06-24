import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tester/features/auth/repositories/auth_repository.dart';
import 'package:tester/features/map/application/map_state.dart';
import 'package:tester/features/map/models/transport.dart';

class MapCubit extends Cubit<MapState> {
  final AuthRepository _authRepository;

  MapCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(MapInitial());

  Future<void> getTransportDetails() async {
    print('Map Cubit taking transports....');
    emit(MapLoading());
    try {
      final response = await _authRepository.getTransportRequest();
      // print('AuthCubit: Login successful, user: $user');
      //emit(AuthAuthenticated(user));

      final dataList = response.data['data']['results'] as List;

      final transports = dataList
          .map((item) => Transport.fromJson(item))
          .toList();

      emit(MapLoaded(transports));
    } catch (e) {
      print('Map Cubit failed: $e');
      emit(MapError(e.toString()));
    }
  }

  Future<void> pushDataToBackEnd(Map<String, num> body) async {
    try {
      await _authRepository.pushLocationToBackend(body);
    } catch (e) {
      print("exception in map_cubit");
    }
  }

  Future<void> completeTransport(int id) async {
    try {
      await _authRepository.completedAdminRequest(id);

      if (state is MapLoaded) {
        final currentList = List<Transport>.from(
          (state as MapLoaded).transportList,
        );
        currentList.removeWhere((t) => t.id == id);

        emit(MapLoaded(currentList));
      }

      emit(MapSuccess("Transport marked as completed"));
    } catch (e) {
      emit(MapError("Failed to complete transport: $e"));
    }
  }
}
