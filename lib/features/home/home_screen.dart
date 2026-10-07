import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/app_colors.dart';
import '../../core/locale_utils.dart';
import '../add_task/add_task_dialog.dart';

class _Task {
  _Task(this.title);

  final String title;
  bool done = false;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.userName});

  final String userName;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<_Task> _tasks = [];

  Future<void> _addTask() async {
    final title = await showAddTaskDialog(context);
    if (title == null || !mounted) return;
    setState(() => _tasks.add(_Task(title)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text(
          'hello'.tr(namedArgs: {'name': widget.userName}),
          style: TextStyle(fontSize: 18.sp),
        ),
        actions: [
          IconButton(
            tooltip: 'changeLanguage'.tr(),
            icon: const Icon(Icons.language),
            onPressed: () => toggleLocale(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'addTask'.tr(),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
      body: _tasks.isEmpty
          ? Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Text(
                  'noTasks'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.only(bottom: 88.h),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Dismissible(
                  key: ObjectKey(task),
                  background: Container(
                    color: Colors.red.shade400,
                    alignment: AlignmentDirectional.centerStart,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red.shade400,
                    alignment: AlignmentDirectional.centerEnd,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => setState(() => _tasks.remove(task)),
                  child: CheckboxListTile(
                    value: task.done,
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: AppColors.primary,
                    onChanged: (value) =>
                        setState(() => task.done = value ?? false),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        decoration:
                            task.done ? TextDecoration.lineThrough : null,
                        color: task.done ? Colors.grey : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
