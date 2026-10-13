import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/app_colors.dart';
import '../home/shared_state.dart';
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
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;

    SharedStateScope.of(context).addTask(
      TaskEntry(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        color: _color,
        status: _status,
        scheduledDate: _selectedDate,
        scheduledTime: _selectedTime,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
            children: [
              TextFormField(
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'taskTitleRequired'.tr()
                    : null,
                decoration: _inputDecoration(hintText: 'taskTitleHint'.tr()),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _descriptionController,
                textCapitalization: TextCapitalization.sentences,
                minLines: 4,
                maxLines: 4,
                decoration: _inputDecoration(
                  hintText: 'taskDescriptionHint'.tr(),
                  contentPadding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(
                    child: _buildDateTimeBox(
                      label: 'taskDate'.tr(),
                      value: _selectedDate == null
                          ? null
                          : MaterialLocalizations.of(
                              context,
                            ).formatMediumDate(_selectedDate!),
                      onTap: _selectDate,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _buildDateTimeBox(
                      label: 'taskTime'.tr(),
                      value: _selectedTime == null
                          ? null
                          : MaterialLocalizations.of(
                              context,
                            ).formatTimeOfDay(_selectedTime!),
                      onTap: _selectTime,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsetsDirectional.only(start: 14.w, end: 10.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3E3E3),
                  borderRadius: BorderRadius.circular(12.r),
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
              SizedBox(height: 12.h),
              _buildLabel('chooseColor'.tr()),
              SizedBox(height: 6.h),
              Wrap(
                spacing: 7.w,
                runSpacing: 7.h,
                children: _taskColors.map(_buildColorOption).toList(),
              ),
              SizedBox(height: 14.h),
              SizedBox(
                height: 44.h,
                child: FilledButton(
                  onPressed: _saveTask,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFA916A8),
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

  Widget _buildDateTimeBox({
    required String label,
    required String? value,
    required VoidCallback onTap,
  }) => Material(
    color: const Color(0xFFE3E3E3),
    borderRadius: BorderRadius.circular(12.r),
    child: InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Text(
          value ?? label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13.sp,
            color: value == null
                ? const Color(0xFF777982)
                : const Color(0xFF292A32),
          ),
        ),
      ),
    ),
  );

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null && mounted) setState(() => _selectedDate = date);
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (time != null && mounted) setState(() => _selectedTime = time);
  }

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
          width: 28.r,
          height: 28.r,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: isSelected
                ? Border.all(color: Colors.white, width: 2.w)
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
              ? Icon(Icons.check, size: 14.r, color: Colors.white)
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
    fillColor: const Color(0xFFE3E3E3),
    contentPadding:
        contentPadding ??
        EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: AppColors.primarySoft, width: 1.2.w),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: Colors.red.shade300),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
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
