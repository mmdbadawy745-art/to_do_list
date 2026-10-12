import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/app_colors.dart';
import '../home/task_entry.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  TaskStatus _status = TaskStatus.pending;
  Color _color = _taskColors.first;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pop(
      TaskEntry(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        color: _color,
        status: _status,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF9FF),
        foregroundColor: const Color(0xFF252631),
        elevation: 0,
        title: Text(
          'addTask'.tr(),
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.fromLTRB(24.w, 18.h, 24.w, 24.h),
            children: [
              _buildLabel('taskTitle'.tr()),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'taskTitleRequired'.tr()
                    : null,
                decoration: _inputDecoration(hintText: 'taskTitleHint'.tr()),
              ),
              SizedBox(height: 18.h),
              _buildLabel('description'.tr()),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _descriptionController,
                textCapitalization: TextCapitalization.sentences,
                minLines: 5,
                maxLines: 5,
                decoration: _inputDecoration(
                  hintText: 'taskDescriptionHint'.tr(),
                  contentPadding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
                ),
              ),
              SizedBox(height: 18.h),
              _buildLabel('status'.tr()),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsetsDirectional.only(start: 14.w, end: 10.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<TaskStatus>(
                    value: _status,
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(14.r),
                    items: TaskStatus.values
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(
                              _statusLabel(status),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF292A32),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (status) {
                      if (status != null) setState(() => _status = status);
                    },
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              _buildLabel('chooseColor'.tr()),
              SizedBox(height: 12.h),
              Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                children: _taskColors.map(_buildColorOption).toList(),
              ),
              SizedBox(height: 30.h),
              SizedBox(
                height: 48.h,
                child: FilledButton(
                  onPressed: _saveTask,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primarySoft,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                  child: Text(
                    'saveTask'.tr(),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) => Text(
    label,
    style: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF292A32),
    ),
  );

  Widget _buildColorOption(Color color) {
    final isSelected = _color == color;
    return Semantics(
      button: true,
      selected: isSelected,
      label: 'taskColor'.tr(),
      child: GestureDetector(
        onTap: () => setState(() => _color = color),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 36.r,
          height: 36.r,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: isSelected
                ? Border.all(color: Colors.white, width: 3.w)
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 5,
                    ),
                  ]
                : null,
          ),
          child: isSelected
              ? Icon(Icons.check, size: 17.r, color: Colors.white)
              : null,
        ),
      ),
    );
  }

  String _statusLabel(TaskStatus status) => switch (status) {
    TaskStatus.pending => 'pending'.tr(),
    TaskStatus.inProgress => 'inProgress'.tr(),
    TaskStatus.done => 'done'.tr(),
  };

  InputDecoration _inputDecoration({
    required String hintText,
    EdgeInsetsGeometry? contentPadding,
  }) => InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(fontSize: 13.sp, color: const Color(0xFF777982)),
    filled: true,
    fillColor: Colors.white,
    contentPadding:
        contentPadding ??
        EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide(color: AppColors.primarySoft, width: 1.2.w),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide(color: Colors.red.shade300),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide(color: Colors.red.shade500),
    ),
  );
}

const _taskColors = [
  Color(0xFF2196F3),
  Color(0xFF4CAF50),
  Color(0xFFFF9800),
  Color(0xFFAB27B7),
  Color(0xFFF44336),
  Color(0xFF009688),
];
