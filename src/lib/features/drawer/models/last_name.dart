import 'package:formz/formz.dart';

enum LastNameValidationError { empty }

class LastName extends FormzInput<String, LastNameValidationError> {
  const LastName.pure() : super.pure('');
  const LastName.dirty([super.value = ''] ) : super.dirty();

  @override
  LastNameValidationError? validator(String? value){
    return value?.isNotEmpty == true ? null : LastNameValidationError.empty;
  }
}