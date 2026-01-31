import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_datasource.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource local;
  TodoRepositoryImpl(this.local);

  @override
  Future<void> delete(String id) => local.delete(id);

  @override
  Future<List<Todo>> getAll() => local.getAll();

  @override
  Future<Todo?> getById(String id) => local.getById(id);

  @override
  Future<void> save(Todo todo) => local.save(todo);
}
