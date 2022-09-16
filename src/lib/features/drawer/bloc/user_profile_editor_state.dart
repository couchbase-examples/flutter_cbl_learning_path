import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';

import '../models/models.dart';

class UserProfileEditorState extends Equatable {

  const UserProfileEditorState({
    this.status = FormzStatus.pure,
    this.firstName = const FirstName.pure(),
    this.lastName = const LastName.pure(),
    this.jobTitle = const JobTitle.pure(),
  });

  final FormzStatus status;
  final FirstName firstName;
  final LastName lastName;
  final JobTitle jobTitle;

  UserProfileEditorState copyWith({
    FormzStatus? status,
    FirstName? firstName,
    LastName? lastName,
    JobTitle? jobTitle}){
    return UserProfileEditorState(
        status: status?? this.status,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        jobTitle: jobTitle ?? this.jobTitle);
  }

  @override
  List<Object> get props => [status, firstName, lastName, jobTitle];
}