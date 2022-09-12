import 'package:equatable/equatable.dart';

enum UserProfileStatus { uninitialized, success, fail }

class UserProfileState extends Equatable {
  const UserProfileState(
      {this.status = UserProfileStatus.uninitialized,
      this.userProfile = const <String, Object?>{},
      this.error = ''});

  final UserProfileStatus status;
  final Map<String, Object?> userProfile;
  final String error;

  @override
  List<Object> get props => [userProfile, status, error];

  @override
  String toString() =>
      'Status:  $status, error: $error, user: ${userProfile.length}';
}
