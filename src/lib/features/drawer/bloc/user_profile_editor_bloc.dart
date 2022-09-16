import 'package:flutter_cbl_learning_path/features/drawer/bloc/user_profile_editor_event.dart';
import 'package:flutter_cbl_learning_path/features/drawer/bloc/user_profile_editor_state.dart';
import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';

import '../data/user_repository.dart';
import '../models/models.dart';

class UserProfileEditorBloc extends Bloc<UserProfileEditorEvent, UserProfileEditorState> {
  UserProfileEditorBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const UserProfileEditorState()) {
    on<FirstNameChangedEvent>(_onFirstNameChanged);
    on<LastNameChangedEvent>(_onLastNameChanged);
    on<JobTitleChangedEvent>(_onJobTitleChanged);
    on<UserProfileEditorSaveEvent>(_onSaveSubmitted);
  }

  final UserRepository _userRepository;

  void _onFirstNameChanged(FirstNameChangedEvent event,
      Emitter<UserProfileEditorState> emit) {
    final firstName = FirstName.dirty(event.firstName);
    emit(
      state.copyWith(
        firstName: firstName,
        status: Formz.validate([state.firstName, firstName]),
      ),
    );
  }

  void _onLastNameChanged(LastNameChangedEvent event,
      Emitter<UserProfileEditorState> emit) {
    final lastName = LastName.dirty(event.lastName);
    emit(
      state.copyWith(
        lastName: lastName,
        status: Formz.validate([state.lastName, lastName]),
      ),
    );
  }

  void _onJobTitleChanged(JobTitleChangedEvent event,
      Emitter<UserProfileEditorState> emit) {
    final jobTitle = JobTitle.dirty(event.jobTitle);
    emit(
      state.copyWith(
        jobTitle: jobTitle,
        status: Formz.validate([state.jobTitle, jobTitle]),
      ),
    );
  }

  Future<void> _onSaveSubmitted(UserProfileEditorSaveEvent event,
      Emitter<UserProfileEditorState> emit) async {
    if (state.status.isInvalid){
      try {
        Map<String, Object> document = {
          "firstName": state.firstName.value,
          "lastName": state.lastName.value,
          "jobTitle": state.jobTitle.value
        };
        var results = await _userRepository.save(document);
        if (results){
          emit(state.copyWith(status: FormzStatus.submissionSuccess));
        } else {
          emit(state.copyWith(status: FormzStatus.submissionFailure));
        }
      }catch(_){
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }
}