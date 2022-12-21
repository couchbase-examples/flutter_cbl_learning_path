import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:cbl/cbl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cbl_learning_path/features/drawer/bloc/user_profile_editor_event.dart';
import 'package:flutter_cbl_learning_path/features/drawer/bloc/user_profile_event.dart';
import 'package:flutter_cbl_learning_path/features/drawer/bloc/user_profile_state.dart';
import 'package:flutter_cbl_learning_path/features/drawer/data/user_repository.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc({required UserRepository userRepository})
      : _repository = userRepository,
        super(const UserProfileState(status: UserProfileStatus.uninitialized)) {
    on<UserProfileGetDataEvent>(_initialize);
  }

  final UserRepository _repository;

  Future<void> _initialize(
      UserProfileGetDataEvent event, Emitter<UserProfileState> emit) async {
    try {
      var user = await _repository.get();
      /* validate we get an email address back, if not fail */
      if (user.containsKey('email')) {
        //make email address readable
        user['emailDisplay'] = user['email'] as String;

        /* process profile picture if one isn't returned
        return default image */
        if (user.containsKey('imageData')) {
          var blob = user['imageData'] as Blob;
          user['imgRaw'] = await blob.content();
        } else {
          user['imgRaw'] = _getDefaultImageBase64();
        }
        var successState = UserProfileState(
            error: '', status: UserProfileStatus.success, userProfile: user);
        emit(successState);
      } else {
        var failedState = const UserProfileState(
            error: 'Results missing email', status: UserProfileStatus.fail);
        emit(failedState);
      }
    } catch (e) {
      var error =
          UserProfileState(error: e.toString(), status: UserProfileStatus.fail);
      emit(error);
      debugPrint(e.toString());
    }
  }

  static Uint8List _getDefaultImageBase64() {
    return const Base64Decoder().convert(
        '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');
  }
}
