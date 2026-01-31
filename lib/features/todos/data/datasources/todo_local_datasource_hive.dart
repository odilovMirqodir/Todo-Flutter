import 'package:hive/hive.dart';
import '../../domain/entities/todo.dart';
import '../dto/todo_dto.dart';
import 'todo_local_datasource.dart';

class TodoLocalDataSourceHive implements TodoLocalDataSource {
  final Box<String> box;

  TodoLocalDataSourceHive(this.box);

  @override
  Future<List<Todo>> getAll() async {
    final todos = <Todo>[];
    for (final key in box.keys) {
      final json = box.get(key);
      if (json == null) continue;
      todos.add(TodoDto.fromJsonString(json));
    }
    return todos;
  }

  @override
  Future<Todo?> getById(String id) async {
    final json = box.get(id);
    if (json == null) return null;
    return TodoDto.fromJsonString(json);
  }

  @override
  Future<void> save(Todo todo) async {
    await box.put(todo.id, TodoDto.toJsonString(todo));
  }

  @override
  Future<void> delete(String id) async {
    await box.delete(id);
  }
}
