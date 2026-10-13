import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/app_colors.dart';
import '../../core/locale_utils.dart';
import '../add_task/add_task_screen.dart';
import 'shared_state.dart';
import 'task_entry.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.userName});

  final String userName;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _addTask() async {
    await Navigator.of(
      context,
    ).push<void>(MaterialPageRoute(builder: (_) => const AddTaskScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final sharedState = SharedStateScope.of(context);
    final tasks = sharedState.tasks;
    final greetingName = widget.userName.trim().isEmpty
        ? 'there'.tr()
        : widget.userName.trim();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 100.h),
                children: [
                  _buildHeader(greetingName),
                  SizedBox(height: 20.h),
                  _buildSummary(sharedState),
                  SizedBox(height: 23.h),
                  Text(
                    'todaysTasks'.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF252631),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ...List.generate(
                    tasks.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: _buildTaskCard(tasks[index], index, sharedState),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 6.h, right: 2.w),
        child: FloatingActionButton.extended(
          onPressed: _addTask,
          backgroundColor: const Color(0xFFDCE0FF),
          foregroundColor: AppColors.primary,
          elevation: 5,
          icon: const Icon(Icons.add),
          label: Text('task'.tr()),
        ),
      ),
    );
  }

  Widget _buildHeader(String greetingName) {
    return Row(
      children: [
        CircleAvatar(
          radius: 23.r,
          backgroundColor: const Color(0xFF4054BD),
          child: Icon(Icons.person, color: Colors.white, size: 25.r),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'goodMorning'.tr(),
                style: TextStyle(
                  color: const Color(0xFF9698A1),
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                greetingName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xFF252631),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          tooltip: 'homeMenu'.tr(),
          icon: Icon(Icons.notifications_none, size: 22.r),
          onSelected: (value) {
            if (value == 'language') {
              toggleLocale(context);
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('noNotifications'.tr())));
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'notifications',
              child: Text('notifications'.tr()),
            ),
            PopupMenuItem(
              value: 'language',
              child: Text('changeLanguage'.tr()),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummary(SharedState sharedState) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFF4054BD),
        borderRadius: BorderRadius.circular(19.r),
      ),
      child: Row(
        children: [
          _SummaryValue(value: sharedState.totalTasks, label: 'tasks'.tr()),
          _SummaryValue(value: sharedState.doneTasks, label: 'done'.tr()),
          _SummaryValue(value: sharedState.pendingTasks, label: 'pending'.tr()),
        ],
      ),
    );
  }

  Widget _buildTaskCard(TaskEntry task, int index, SharedState sharedState) {
    return Dismissible(
      key: ObjectKey(task),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(17.r),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => sharedState.removeTask(task),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17.r),
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        child: InkWell(
          borderRadius: BorderRadius.circular(17.r),
          onTap: () => sharedState.advanceTaskStatus(index),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Row(
              children: [
                Container(
                  width: 12.w,
                  height: 56.h,
                  decoration: BoxDecoration(
                    color: task.color,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                SizedBox(width: 13.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.titleKey?.tr() ?? task.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF292A32),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        task.descriptionKey?.tr() ?? task.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: const Color(0xFF85858B),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      _StatusBadge(status: task.status),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.chevron_right,
                  size: 26.r,
                  color: const Color(0xFF53555F),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryValue extends StatelessWidget {
  const _SummaryValue({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '$value',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: TextStyle(color: const Color(0xFFC5CCF1), fontSize: 11.sp),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, foreground, background) = switch (status) {
      TaskStatus.pending => (
        'pending'.tr(),
        const Color(0xFF168DE0),
        const Color(0xFFDCEFFF),
      ),
      TaskStatus.inProgress => (
        'inProgress'.tr(),
        const Color(0xFFE88800),
        const Color(0xFFFFEED8),
      ),
      TaskStatus.done => (
        'done'.tr(),
        const Color(0xFF319B46),
        const Color(0xFFE0F3E2),
      ),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foreground,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
