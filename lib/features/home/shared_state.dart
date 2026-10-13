import 'package:flutter/material.dart';

import 'task_entry.dart';

class SharedState extends ChangeNotifier {
  final List<TaskEntry> _tasks = [
    const TaskEntry(
      title: 'Flutter UI',
      description: 'Build Register Screen',
      titleKey: 'sampleTaskFlutter',
      descriptionKey: 'sampleTaskFlutterDescription',
      color: Color(0xFF2196F3),
      status: TaskStatus.pending,
    ),
    const TaskEntry(
      title: 'Workout',
      description: 'Gym at 6 PM',
      titleKey: 'sampleTaskWorkout',
      descriptionKey: 'sampleTaskWorkoutDescription',
      color: Color(0xFF4CAF50),
      status: TaskStatus.done,
    ),
    const TaskEntry(
      title: 'Meeting',
      description: 'Team Sync',
      titleKey: 'sampleTaskMeeting',
      descriptionKey: 'sampleTaskMeetingDescription',
      color: Color(0xFFFF9800),
      status: TaskStatus.inProgress,
    ),
    const TaskEntry(
      title: 'Read Book',
      description: 'Atomic Habits',
      titleKey: 'sampleTaskReading',
      descriptionKey: 'sampleTaskReadingDescription',
      color: Color(0xFFAB27B7),
      status: TaskStatus.pending,
    ),
  ];

  int _totalTasks = 12;
  int _doneTasks = 5;
  int _pendingTasks = 7;

  List<TaskEntry> get tasks => List.unmodifiable(_tasks);
  int get totalTasks => _totalTasks;
  int get doneTasks => _doneTasks;
  int get pendingTasks => _pendingTasks;

  void addTask(TaskEntry task) {
    _tasks.add(task);
    _totalTasks++;
    if (task.status == TaskStatus.done) {
      _doneTasks++;
    } else {
      _pendingTasks++;
    }
    notifyListeners();
  }

  void advanceTaskStatus(int index) {
    final task = _tasks[index];
    final nextStatus = switch (task.status) {
      TaskStatus.pending => TaskStatus.inProgress,
      TaskStatus.inProgress => TaskStatus.done,
      TaskStatus.done => TaskStatus.pending,
    };

    if (task.status == TaskStatus.done) {
      _doneTasks--;
      _pendingTasks++;
    } else if (nextStatus == TaskStatus.done) {
      _doneTasks++;
      _pendingTasks--;
    }

    _tasks[index] = task.copyWith(status: nextStatus);
    notifyListeners();
  }

  void removeTask(TaskEntry task) {
    final index = _tasks.indexOf(task);
    if (index == -1) return;

    final removedTask = _tasks.removeAt(index);
    _totalTasks--;
    if (removedTask.status == TaskStatus.done) {
      _doneTasks--;
    } else {
      _pendingTasks--;
    }
    notifyListeners();
  }
}

class SharedStateScope extends InheritedNotifier<SharedState> {
  const SharedStateScope({
    required SharedState state,
    required super.child,
    super.key,
  }) : super(notifier: state);

  static SharedState of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<SharedStateScope>();
    assert(scope != null, 'SharedStateScope was not found in the widget tree.');
    return scope!.notifier!;
  }
}
