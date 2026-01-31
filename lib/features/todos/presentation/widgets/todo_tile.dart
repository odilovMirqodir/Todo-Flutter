import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/date_fmt.dart';
import '../../domain/entities/todo.dart';
import '../controllers/todo_controller.dart';

class TodoTile extends ConsumerWidget {
  final Todo todo;
  const TodoTile({super.key, required this.todo});

  Color _priorityColor() {
    switch (todo.priority) {
      case TodoPriority.low:
        return Colors.green;
      case TodoPriority.medium:
        return Colors.orange;
      case TodoPriority.high:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(todoControllerProvider.notifier);

    return Slidable(
      key: ValueKey(todo.id),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => ctrl.toggleDone(todo),
            icon: todo.status == TodoStatus.done ? Icons.undo : Icons.check,
            label: todo.status == TodoStatus.done ? "Undo" : "Done",
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => context.pushNamed('edit', pathParameters: {'id': todo.id}),
            icon: Icons.edit,
            label: "Edit",
          ),
          SlidableAction(
            onPressed: (_) async {
              final deleted = await ctrl.deleteTodo(todo.id);
              if (!context.mounted) return;

              final snack = SnackBar(
                content: Text('Deleted: ${todo.title}'),
                action: deleted == null
                    ? null
                    : SnackBarAction(
                        label: 'UNDO',
                        onPressed: () => ctrl.restore(deleted),
                      ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snack);
            },
            icon: Icons.delete,
            label: "Delete",
            backgroundColor: Colors.red,
          ),
        ],
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _priorityColor().withOpacity(0.35)),
        ),
        child: Row(
          children: [
            Checkbox(
              value: todo.status == TodoStatus.done,
              onChanged: (_) => ctrl.toggleDone(todo),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          decoration: todo.status == TodoStatus.done ? TextDecoration.lineThrough : null,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(DateFmt.short(todo.dueDate), style: Theme.of(context).textTheme.bodySmall),
                  if (todo.tags.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: -6,
                      children: todo.tags.take(4).map((t) => Chip(label: Text(t))).toList(),
                    )
                  ]
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 10,
              height: 40,
              decoration: BoxDecoration(
                color: _priorityColor(),
                borderRadius: BorderRadius.circular(10),
              ),
            )
          ],
        ),
      ),
    );
  }
}
