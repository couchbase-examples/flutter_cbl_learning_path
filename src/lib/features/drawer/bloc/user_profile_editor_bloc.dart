import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_cbl_learning_path/features/drawer/bloc/user_profile_editor_event.dart';
import 'package:flutter_cbl_learning_path/features/drawer/bloc/user_profile_editor_state.dart';
import 'package:flutter_cbl_learning_path/models/form_status.dart';
import 'package:flutter_cbl_learning_path/features/drawer/data/user_repository.dart';

class UserProfileEditorBloc extends Bloc<UserProfileEditorEvent, UserProfileEditorState> {
  UserProfileEditorBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const UserProfileEditorState()) {
    on<UserProfileEditorLoadEvent>(_onLoadEvent);
    on<FirstNameChangedEvent>(_onFirstNameChanged);
    on<LastNameChangedEvent>(_onLastNameChanged);
    on<JobTitleChangedEvent>(_onJobTitleChanged);
    on<UserProfileEditorSaveEvent>(_onSaveSubmitted);
  }

  final UserRepository _userRepository;

  Future<void> _onLoadEvent(UserProfileEditorLoadEvent event, Emitter<UserProfileEditorState> emit) async {
    try {
      final user = await _userRepository.get();
      if (user.isNotEmpty && user.keys.length > 1){
        final givenName = user['givenName'] as String;
        final surname = user['surname'] as String;
        final jobTitle = user['jobTitle'] as String;
        emit(state.copyWith(status: FormEditorStatus.dataLoaded,
            firstName: givenName,
            lastName: surname,
            jobTitle: jobTitle));
      }
    }catch(e) {
      debugPrint(e.toString());
    }
  }

  void _onFirstNameChanged(FirstNameChangedEvent event,
      Emitter<UserProfileEditorState> emit) {
    emit(
      state.copyWith(
        firstName: event.firstName,
        status: FormEditorStatus.dataChanged
      ),
    );
  }

  void _onLastNameChanged(LastNameChangedEvent event,
      Emitter<UserProfileEditorState> emit) {
    emit(
      state.copyWith(
        lastName: event.lastName,
        status: FormEditorStatus.dataChanged
      ),
    );
  }

  void _onJobTitleChanged(JobTitleChangedEvent event,
      Emitter<UserProfileEditorState> emit) {
    emit(
      state.copyWith(
        jobTitle: event.jobTitle,
        status: FormEditorStatus.dataChanged
      ),
    );
  }

  Future<void> _onSaveSubmitted(UserProfileEditorSaveEvent event,
      Emitter<UserProfileEditorState> emit) async {
    if (state.status == FormEditorStatus.dataChanged){
      try {
        Map<String, Object> document = {
          "givenName": state.firstName,
          "surname": state.lastName,
          "jobTitle": state.jobTitle
        };
        var results = await _userRepository.save(document);
        if (results){
          emit(state.copyWith(status: FormEditorStatus.dataSaved));
        } else {
          emit(state.copyWith(status: FormEditorStatus.error));
        }
      }catch(e){
        emit(state.copyWith(error: e.toString(), status: FormEditorStatus.error));
      }
    } else {
      emit(state.copyWith(status: FormEditorStatus.cancelled));
    }
  }
}