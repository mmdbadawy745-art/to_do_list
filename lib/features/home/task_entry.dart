import 'package:flutter/material.dart';

enum TaskStatus { pending, inProgress, done }

class TaskEntry {
  const TaskEntry({
    required this.title,
    required this.description,
    required this.color,
    required this.status,
    this.titleKey,
    this.descriptionKey,
  });

  final String title;
  final String description;
  final Color color;
  final TaskStatus status;
  final String? titleKey;
  final String? descriptionKey;

  TaskEntry copyWith({TaskStatus? status}) => TaskEntry(
    title: title,
    description: description,
    color: color,
    status: status ?? this.status,
    titleKey: titleKey,
    descriptionKey: descriptionKey,
  );
}
