import 'package:equatable/equatable.dart';

abstract class DevInfoEvent extends Equatable {
  const DevInfoEvent([List props = const []]) : super();
}

class DevInfoInitializeEvent extends DevInfoEvent {
  @override
  String toString() => "DevInfoGetDataEvent";

  @override
  List<Object> get props => [];
}
