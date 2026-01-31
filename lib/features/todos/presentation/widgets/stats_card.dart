import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/todo.dart';
import '../controllers/todo_controller.dart';

class StatsCard extends ConsumerWidget {
  const StatsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todoControllerProvider);
    final scheme = Theme.of(context).colorScheme;
    final on = scheme.onSurface;

    return todosAsync.when(
      data: (todos) {
        final total = todos.length;
        final done = todos.where((t) => t.status == TodoStatus.done).length;
        final active = total - done;
        final progress = total == 0 ? 0.0 : done / total;
        final percent = (progress * 100).round();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text("Total: $total", style: TextStyle(color: on))),
                      Expanded(child: Text("Active: $active", style: TextStyle(color: on))),
                      Expanded(child: Text("Done: $done ($percent%)", style: TextStyle(color: on))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: scheme.outlineVariant.withOpacity(0.35),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox(height: 72),
      error: (_, __) => const SizedBox(height: 72),
    );
  }
}
