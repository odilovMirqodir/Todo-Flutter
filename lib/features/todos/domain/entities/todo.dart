import 'package:equatable/equatable.dart';

enum TodoPriority { low, medium, high }
enum TodoStatus { active, done }

class Todo extends Equatable {
  final String id;
  final String title;
  final String? note;
  final DateTime createdAt;
  final DateTime? dueDate;
  final TodoPriority priority;
  final TodoStatus status;
  final List<String> tags;

  const Todo({
    required this.id,
    required this.title,
    required this.createdAt,
    this.note,
    this.dueDate,
    this.priority = TodoPriority.medium,
    this.status = TodoStatus.active,
    this.tags = const [],
  });

  Todo copyWith({
    String? title,
    String? note,
    DateTime? dueDate,
    TodoPriority? priority,
    TodoStatus? status,
    List<String>? tags,
  }) {
    return Todo(
      id: id,
      title: title ?? this.title,
      note: note ?? this.note,
      createdAt: createdAt,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props => [id, title, note, createdAt, dueDate, priority, status, tags];
}
