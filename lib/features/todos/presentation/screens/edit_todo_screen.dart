import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/todo.dart';
import '../controllers/todo_controller.dart';

class EditTodoScreen extends ConsumerStatefulWidget {
  final String? editId;
  const EditTodoScreen({super.key, this.editId});

  @override
  ConsumerState<EditTodoScreen> createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends ConsumerState<EditTodoScreen> {
  final _title = TextEditingController();
  final _note = TextEditingController();
  final _tags = TextEditingController();

  TodoPriority _priority = TodoPriority.medium;
  DateTime? _due;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadIfEdit();
  }

  Future<void> _loadIfEdit() async {
    if (widget.editId == null) return;
    setState(() => _loading = true);

    final t = await ref.read(todoControllerProvider.notifier).byId(widget.editId!);
    if (t != null) {
      _title.text = t.title;
      _note.text = t.note ?? "";
      _tags.text = t.tags.join(", ");
      _priority = t.priority;
      _due = t.dueDate;
    }

    setState(() => _loading = false);
  }

  List<String> _parseTags(String raw) =>
      raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toSet().toList();

  Future<void> _pickDue() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      initialDate: _due ?? now,
    );
    if (picked != null) setState(() => _due = picked);
  }

  Future<void> _save() async {
    final title = _title.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Title is required")));
      return;
    }

    setState(() => _loading = true);
    final ctrl = ref.read(todoControllerProvider.notifier);

    if (widget.editId == null) {
      await ctrl.addTodo(
        title: title,
        note: _note.text,
        dueDate: _due,
        priority: _priority,
        tags: _parseTags(_tags.text),
      );
    } else {
      final existing = await ctrl.byId(widget.editId!);
      if (existing != null) {
        await ctrl.updateTodo(existing.copyWith(
          title: title,
          note: _note.text.trim().isEmpty ? null : _note.text.trim(),
          dueDate: _due,
          priority: _priority,
          tags: _parseTags(_tags.text),
        ));
      }
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editId != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit task" : "New task")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  controller: _title,
                  decoration: const InputDecoration(labelText: "Title", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _note,
                  minLines: 3,
                  maxLines: 6,
                  decoration: const InputDecoration(labelText: "Note (optional)", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<TodoPriority>(
                  value: _priority,
                  items: TodoPriority.values
                      .map((p) => DropdownMenuItem(value: p, child: Text(p.name.toUpperCase())))
                      .toList(),
                  onChanged: (v) => setState(() => _priority = v ?? TodoPriority.medium),
                  decoration: const InputDecoration(labelText: "Priority", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _pickDue,
                  icon: const Icon(Icons.event),
                  label: Text(_due == null ? "Pick due date" : "Due: ${_due!.toIso8601String().substring(0, 10)}"),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _tags,
                  decoration: const InputDecoration(
                    labelText: "Tags (comma separated)",
                    border: OutlineInputBorder(),
                    hintText: "work, study, health",
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: Text(isEdit ? "Save changes" : "Create task"),
                )
              ],
            ),
    );
  }
}
