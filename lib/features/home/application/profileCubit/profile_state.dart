import 'package:equatable/equatable.dart';
import 'package:tester/features/auth/models/user.dart';
import 'package:tester/features/home/model/profile_model/profile_model.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final Profile user;

  ProfileSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class ProfileFailure extends ProfileState {
  final String message;

  ProfileFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
