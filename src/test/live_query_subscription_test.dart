import 'dart:async';

import 'package:cbl/cbl.dart';
import 'package:flutter_cbl_learning_path/features/audit/bloc/audit_list.dart';
import 'package:flutter_cbl_learning_path/features/audit/data/audit_repository.dart';
import 'package:flutter_cbl_learning_path/features/project/bloc/project_list.dart';
import 'package:flutter_cbl_learning_path/features/project/data/project_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// Stand-in for a Couchbase Lite live query stream that records whether a
/// listener is attached, the way the real stream adds/removes a change
/// listener on the database when it is listened to/cancelled.
class FakeLiveQueryStream extends AsyncListenStream<QueryChange<ResultSet>> {
  final _controller = StreamController<QueryChange<ResultSet>>();
  var listenCount = 0;
  var cancelCount = 0;

  bool get isListening => listenCount > cancelCount;

  FakeLiveQueryStream() {
    _controller
      ..onListen = (() => listenCount++)
      ..onCancel = (() => cancelCount++);
  }

  @override
  Future<void> get listening => Future.value();

  @override
  StreamSubscription<QueryChange<ResultSet>> listen(
          void Function(QueryChange<ResultSet> event)? onData,
          {Function? onError,
          void Function()? onDone,
          bool? cancelOnError}) =>
      _controller.stream.listen(onData,
          onError: onError, onDone: onDone, cancelOnError: cancelOnError);
}

class FakeAuditRepository implements AuditRepository {
  // like the real repository, every call builds a new live query stream
  final requested = <MapEntry<String, FakeLiveQueryStream>>[];

  Iterable<FakeLiveQueryStream> streamsFor(String projectId) => requested
      .where((entry) => entry.key == projectId)
      .map((entry) => entry.value);

  int get activeListeners =>
      requested.where((entry) => entry.value.isListening).length;

  @override
  Future<AsyncListenStream<QueryChange<ResultSet>>?>? getDocuments(
      String projectId) async {
    final stream = FakeLiveQueryStream();
    requested.add(MapEntry(projectId, stream));
    return stream;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeProjectRepository implements ProjectRepository {
  final stream = FakeLiveQueryStream();

  @override
  Future<AsyncListenStream<QueryChange<ResultSet>>?>? getDocuments() async =>
      stream;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> settle() => Future<void>.delayed(Duration.zero);

void main() {
  group('AuditListBloc live query', () {
    test('switching projects cancels the previous project live query',
        () async {
      final repository = FakeAuditRepository();
      final bloc = AuditListBloc(repository: repository);

      bloc.add(const AuditListInitializeEvent(projectId: 'project-a'));
      await settle();
      expect(repository.streamsFor('project-a').single.isListening, isTrue);

      bloc.add(const AuditListInitializeEvent(projectId: 'project-b'));
      await settle();
      expect(repository.streamsFor('project-a').single.isListening, isFalse);
      expect(repository.streamsFor('project-b').single.isListening, isTrue);
      expect(repository.activeListeners, 1);

      await bloc.close();
    });

    test('re-initializing the same project keeps a single listener', () async {
      final repository = FakeAuditRepository();
      final bloc = AuditListBloc(repository: repository);

      for (var i = 0; i < 3; i++) {
        bloc.add(const AuditListInitializeEvent(projectId: 'project-a'));
        await settle();
      }
      expect(repository.requested, hasLength(3));
      expect(repository.activeListeners, 1);

      await bloc.close();
    });

    test('closing the bloc cancels the live query', () async {
      final repository = FakeAuditRepository();
      final bloc = AuditListBloc(repository: repository);

      bloc.add(const AuditListInitializeEvent(projectId: 'project-a'));
      await settle();
      await bloc.close();

      expect(repository.activeListeners, 0);
    });
  });

  group('ProjectListBloc live query', () {
    test('closing the bloc cancels the live query', () async {
      final repository = FakeProjectRepository();
      final bloc = ProjectListBloc(repository: repository);

      bloc.add(const ProjectListInitializeEvent());
      await settle();
      expect(repository.stream.isListening, isTrue);

      await bloc.close();
      expect(repository.stream.isListening, isFalse);
      expect(bloc.isClosed, isTrue);
    });
  });
}
