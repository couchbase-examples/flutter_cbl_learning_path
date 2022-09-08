import 'package:equatable/equatable.dart';

abstract class DevDataLoadEvent extends Equatable {
  const DevDataLoadEvent([List props = const []]) : super();
}

class DevDataLoadStartEvent extends DevDataLoadEvent {
  @override
  String toString() => "DevDataLoadStartEvent";

  @override
  List<Object> get props => [];
}
