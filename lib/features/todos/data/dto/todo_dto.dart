import 'dart:convert';
import '../../domain/entities/todo.dart';

class TodoDto {
  static String toJsonString(Todo t) {
    final map = {
      "id": t.id,
      "title": t.title,
      "note": t.note,
      "createdAt": t.createdAt.toIso8601String(),
      "dueDate": t.dueDate?.toIso8601String(),
      "priority": t.priority.index,
      "status": t.status.index,
      "tags": t.tags,
    };
    return jsonEncode(map);
    }

  static Todo fromJsonString(String jsonStr) {
    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    return Todo(
      id: map["id"] as String,
      title: map["title"] as String,
      note: map["note"] as String?,
      createdAt: DateTime.parse(map["createdAt"] as String),
      dueDate: map["dueDate"] == null ? null : DateTime.parse(map["dueDate"] as String),
      priority: TodoPriority.values[(map["priority"] as num).toInt()],
      status: TodoStatus.values[(map["status"] as num).toInt()],
      tags: (map["tags"] as List).map((e) => e.toString()).toList(),
    );
  }
}
