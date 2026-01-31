import '../../domain/entities/todo.dart';

abstract class TodoLocalDataSource {
  Future<List<Todo>> getAll();
  Future<Todo?> getById(String id);
  Future<void> save(Todo todo);
  Future<void> delete(String id);
}
