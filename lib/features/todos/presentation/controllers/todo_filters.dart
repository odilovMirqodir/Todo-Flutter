import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/todo.dart';

enum TodoViewFilter { all, active, done }
enum TodoSort { createdDesc, dueAsc, priorityDesc }

final todoSearchProvider = StateProvider<String>((ref) => "");
final todoFilterProvider = StateProvider<TodoViewFilter>((ref) => TodoViewFilter.all);
final todoSortProvider = StateProvider<TodoSort>((ref) => TodoSort.createdDesc);

List<Todo> applyFilters(List<Todo> todos, String search, TodoViewFilter filter, TodoSort sort) {
  var out = todos;

  if (filter == TodoViewFilter.active) out = out.where((t) => t.status == TodoStatus.active).toList();
  if (filter == TodoViewFilter.done) out = out.where((t) => t.status == TodoStatus.done).toList();

  final q = search.trim().toLowerCase();
  if (q.isNotEmpty) {
    out = out.where((t) =>
      t.title.toLowerCase().contains(q) ||
      (t.note ?? "").toLowerCase().contains(q) ||
      t.tags.any((x) => x.toLowerCase().contains(q))
    ).toList();
  }

  out.sort((a, b) {
    switch (sort) {
      case TodoSort.createdDesc:
        return b.createdAt.compareTo(a.createdAt);
      case TodoSort.dueAsc:
        final ad = a.dueDate ?? DateTime(9999);
        final bd = b.dueDate ?? DateTime(9999);
        return ad.compareTo(bd);
      case TodoSort.priorityDesc:
        return b.priority.index.compareTo(a.priority.index);
    }
  });

  return out;
}
