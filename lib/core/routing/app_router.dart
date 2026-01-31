import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/todos/presentation/screens/edit_todo_screen.dart';
import '../../features/todos/presentation/screens/home_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/edit',
        name: 'create',
        builder: (context, state) => const EditTodoScreen(),
      ),
      GoRoute(
        path: '/edit/:id',
        name: 'edit',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return EditTodoScreen(editId: id);
        },
      ),
    ],
  );
});
