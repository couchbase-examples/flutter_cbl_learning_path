import 'package:equatable/equatable.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent([List props = const []]) : super();
}

class UserProfileGetDataEvent extends UserProfileEvent {
  @override
  String toString() => "UserProfileGetDataEvent";

  @override
  List<Object> get props => [];
}
