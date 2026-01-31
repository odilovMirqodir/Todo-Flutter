import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/empty_state.dart';
import '../controllers/todo_controller.dart';
import '../controllers/todo_filters.dart';
import '../widgets/filters_bar.dart';
import '../widgets/stats_card.dart';
import '../widgets/todo_tile.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todoControllerProvider);
    final search = ref.watch(todoSearchProvider);
    final filter = ref.watch(todoFilterProvider);
    final sort = ref.watch(todoSortProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo WOW"),
        actions: [
          IconButton(
            tooltip: "Refresh",
            onPressed: () => ref.read(todoControllerProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
floatingActionButton: FloatingActionButton.extended(
  onPressed: () => context.pushNamed('create'),
  icon: const Icon(Icons.add_rounded),
  label: const Text("New Task"),
),

      body: todosAsync.when(
        data: (todos) {
          final visible = applyFilters(todos, search, filter, sort);

          return Column(
            children: [
              const SizedBox(height: 8),
              const StatsCard(),
              const SizedBox(height: 6),
              const FiltersBar(),
              Expanded(
                child: visible.isEmpty
                    ? const EmptyState(
                        title: "No tasks yet",
                        subtitle: "Create your first task and organize your day like a pro.",
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 88),
                        itemCount: visible.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, i) => TodoTile(todo: visible[i]),
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}
