import 'package:equatable/equatable.dart';

abstract class ProjectListEvent extends Equatable{
  const ProjectListEvent();

  @override
  List<Object> get props => [];
}

class ProjectListInitializeEvent extends ProjectListEvent {
  const ProjectListInitializeEvent();

  @override
  List<Object> get props => [];
}
