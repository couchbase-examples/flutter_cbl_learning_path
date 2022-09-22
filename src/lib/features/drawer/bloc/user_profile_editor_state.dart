import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cbl_learning_path/models/form_status.dart';
import 'package:formz/formz.dart';

import '../models/models.dart';

class UserProfileEditorState extends Equatable {

  const UserProfileEditorState({
    this.status = FormEditorStatus.dataUninitialized,
    this.firstName = '',
    this.lastName = '',
    this.jobTitle = '',
    this.error = ''
  });

  final FormEditorStatus status;
  final String firstName;
  final String lastName;
  final String jobTitle;
  final String error;

  UserProfileEditorState copyWith({
    FormEditorStatus? status,
    String? firstName,
    String? lastName,
    String? jobTitle,
    String? error}){
    return UserProfileEditorState(
        status: status?? this.status,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        jobTitle: jobTitle ?? this.jobTitle,
        error: error ?? this.error);
  }

  @override
  List<Object> get props => [status, firstName, lastName, jobTitle, error];
}