import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tester/features/auth/repositories/auth_repository.dart';
import 'package:tester/features/home/application/profileCubit/profile_state.dart';
import 'package:tester/features/home/model/profile_model/profile_model.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository _authRepository;

  ProfileCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(ProfileInitial());

  Future<void> getUserDetails() async {
    emit(ProfileLoading());
    try {
      final response = await _authRepository.getMyStats();
      final user = Profile.fromJson(response.data['data']);
      emit(ProfileSuccess(user: user));
    } catch (e) {
      emit(ProfileFailure(message: e.toString()));
      print('Exception in getMyStats: $e');
    }
  }
}
