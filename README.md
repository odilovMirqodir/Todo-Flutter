A clean-architecture Todo app built with Flutter, designed to look professional and run smoothly on Web and Android.
Includes offline persistence, search, filter, sort, swipe actions, and quick stats.

## Features
- Create, edit, delete tasks
- Mark task as done/undo
- Undo after delete (SnackBar action)
- Priority (low/medium/high)
- Due date
- Tags (comma separated)
- Search by title, note, and tags
- Filter: all / active / done
- Sort: created desc / due date asc / priority desc
- Offline persistence using Hive (works on Web)
- Clean architecture structure (domain/data/presentation)

## Tech Stack
- Flutter (Material 3)
- Riverpod (state management)
- GoRouter (navigation)
- Hive + hive_flutter (local storage, Web supported)
- flutter_slidable (swipe actions)
- intl (date formatting)
- uuid (unique IDs)

## Project Structure
lib/
app.dart
main.dart
core/
routing/
theme/
utils/
widgets/
features/
todos/
domain/
data/
presentation/


## Requirements
- Flutter SDK installed
- Chrome (for Web run)
- Android Studio + Android SDK (optional, for Android run)

## Setup
Install dependencies:
```bash
flutter pub get

Run on Web (Chrome):
flutter run -d chrome


How to Use

Click “New Task” to create a task

Use search to find tasks by text or tags

Use Filter and Sort dropdowns to organize tasks

Swipe a task:

Left side actions: Done/Undo

Right side actions: Edit/Delete

Delete shows Undo option in SnackBar

Data Storage

Tasks are stored locally in Hive:

Box name: todos

Key: task id

Value: JSON string representation of task