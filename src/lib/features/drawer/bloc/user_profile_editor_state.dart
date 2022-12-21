import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:flutter_cbl_learning_path/models/form_status.dart';

class UserProfileEditorState extends Equatable {

  const UserProfileEditorState({
    this.status = FormEditorStatus.dataUninitialized,
    this.imageRaw,
    this.firstName = '',
    this.lastName = '',
    this.jobTitle = '',
    this.error = ''
  });

  final FormEditorStatus status;
  final Uint8List? imageRaw;
  final String firstName;
  final String lastName;
  final String jobTitle;
  final String error;

  UserProfileEditorState copyWith({
    FormEditorStatus? status,
    Uint8List? imageRaw,
    String? firstName,
    String? lastName,
    String? jobTitle,
    String? error}){
    return UserProfileEditorState(
        status: status?? this.status,
        imageRaw: imageRaw ?? this.imageRaw,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        jobTitle: jobTitle ?? this.jobTitle,
        error: error ?? this.error);
  }

  @override
  List<Object?> get props => [status, imageRaw, firstName, lastName, jobTitle, error];
}