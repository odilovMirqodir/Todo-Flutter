import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/todo_filters.dart';

class FiltersBar extends ConsumerWidget {
  const FiltersBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(todoFilterProvider);
    final sort = ref.watch(todoSortProvider);
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Column(
        children: [
          TextField(
            onChanged: (v) => ref.read(todoSearchProvider.notifier).state = v,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: "Search tasks, notes, tags...",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<TodoViewFilter>(
                  value: filter,
                  items: TodoViewFilter.values
                      .map((f) => DropdownMenuItem(
                            value: f,
                            child: Text(
                              f.name.toUpperCase(),
                              style: TextStyle(color: scheme.onSurface),
                            ),
                          ))
                      .toList(),
                  onChanged: (v) => ref.read(todoFilterProvider.notifier).state = v ?? TodoViewFilter.all,
                  decoration: const InputDecoration(
                    labelText: "Filter",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<TodoSort>(
                  value: sort,
                  items: TodoSort.values
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(
                              s.name.toUpperCase(),
                              style: TextStyle(color: scheme.onSurface),
                            ),
                          ))
                      .toList(),
                  onChanged: (v) => ref.read(todoSortProvider.notifier).state = v ?? TodoSort.createdDesc,
                  decoration: const InputDecoration(
                    labelText: "Sort",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
