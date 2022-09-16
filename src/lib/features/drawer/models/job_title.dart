import 'package:formz/formz.dart';

enum JobTitleValidationError { empty }

class JobTitle extends FormzInput<String, JobTitleValidationError> {
  const JobTitle.pure() : super.pure('');
  const JobTitle.dirty([super.value = ''] ) : super.dirty();

  @override
  JobTitleValidationError? validator(String? value){
    return value?.isNotEmpty == true ? null : JobTitleValidationError.empty;
  }
}