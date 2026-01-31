import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../../data/datasources/todo_local_datasource_hive.dart';
import '../../data/repositories/todo_repository_impl.dart';

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  final box = Hive.box<String>('todos');
  final ds = TodoLocalDataSourceHive(box);
  return TodoRepositoryImpl(ds);
});

final todoControllerProvider = AsyncNotifierProvider<TodoController, List<Todo>>(TodoController.new);

class TodoController extends AsyncNotifier<List<Todo>> {
  TodoRepository get _repo => ref.read(todoRepositoryProvider);
  final _uuid = const Uuid();

  @override
  Future<List<Todo>> build() async {
    return _repo.getAll();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _repo.getAll());
  }

  Future<void> addTodo({
    required String title,
    String? note,
    DateTime? dueDate,
    TodoPriority priority = TodoPriority.medium,
    List<String> tags = const [],
  }) async {
    final t = Todo(
      id: _uuid.v4(),
      title: title.trim(),
      note: note?.trim().isEmpty == true ? null : note?.trim(),
      createdAt: DateTime.now(),
      dueDate: dueDate,
      priority: priority,
      status: TodoStatus.active,
      tags: tags,
    );

    await _repo.save(t);
    await refresh();
  }

  Future<Todo?> byId(String id) => _repo.getById(id);

  Future<void> updateTodo(Todo todo) async {
    await _repo.save(todo);
    await refresh();
  }

  Future<void> toggleDone(Todo todo) async {
    final next = todo.status == TodoStatus.active ? TodoStatus.done : TodoStatus.active;
    await _repo.save(todo.copyWith(status: next));
    await refresh();
  }

  Future<Todo?> deleteTodo(String id) async {
    final existing = await _repo.getById(id);
    await _repo.delete(id);
    await refresh();
    return existing;
  }

  Future<void> restore(Todo todo) async {
    await _repo.save(todo);
    await refresh();
  }
}
