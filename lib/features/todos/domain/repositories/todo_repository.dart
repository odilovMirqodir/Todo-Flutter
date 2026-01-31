import '../entities/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getAll();
  Future<Todo?> getById(String id);
  Future<void> save(Todo todo); // upsert
  Future<void> delete(String id);
}
