import 'package:equatable/equatable.dart';

abstract class DevInfoEvent extends Equatable {
  const DevInfoEvent([List props = const []]) : super();
}

class DevInfoGetData extends DevInfoEvent {
  @override
  String toString() => "DevInfoGetData";

  @override
  List<Object> get props => [];
}
