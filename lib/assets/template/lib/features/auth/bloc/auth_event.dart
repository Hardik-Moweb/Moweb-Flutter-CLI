part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

// Login event
class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  
  LoginEvent({required this.email, required this.password});
}

// User detail event
class UserDetailEvent extends AuthEvent {}

// Update profile event
class UpdateProfileEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String phone;
  final String image;
  final bool isRemoveProfile;
  
  UpdateProfileEvent({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.image,
    this.isRemoveProfile = false,
  });
}