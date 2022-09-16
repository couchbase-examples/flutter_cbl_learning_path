import 'package:formz/formz.dart';

enum FirstNameValidationError { empty }

class FirstName extends FormzInput<String, FirstNameValidationError> {
  const FirstName.pure() : super.pure('');
  const FirstName.dirty([super.value = ''] ) : super.dirty();

  @override
  FirstNameValidationError? validator(String? value){
    return value?.isNotEmpty == true ? null : FirstNameValidationError.empty;
  }
}