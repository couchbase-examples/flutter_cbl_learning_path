import 'package:equatable/equatable.dart';

abstract class UserProfileEditorEvent extends Equatable {
  const UserProfileEditorEvent();

  @override
  List<Object> get props => [];
}

class UserProfileEditorLoadEvent extends UserProfileEditorEvent {
  const UserProfileEditorLoadEvent();

  @override
  List<Object> get props => [];
}

class FirstNameChangedEvent extends UserProfileEditorEvent {
  const FirstNameChangedEvent(this.firstName);

  final String firstName;

  @override
  List<Object> get props => [firstName];
}

class LastNameChangedEvent extends UserProfileEditorEvent {
  const LastNameChangedEvent(this.lastName);

  final String lastName;

  @override
  List<Object> get props => [lastName];
}

class JobTitleChangedEvent extends UserProfileEditorEvent {
  const JobTitleChangedEvent(this.jobTitle);

  final String jobTitle;

  @override
  List<Object> get props => [jobTitle];
}

class UserProfileEditorSaveEvent extends UserProfileEditorEvent {
  const UserProfileEditorSaveEvent();
}