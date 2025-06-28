import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TaskCardWidget extends StatelessWidget {
  final Map<String, dynamic> task;
  final bool isSelected;
  final bool isMultiSelectMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final Function(int) onToggleComplete;

  const TaskCardWidget({
    super.key,
    required this.task,
    required this.isSelected,
    required this.isMultiSelectMode,
    required this.onTap,
    required this.onLongPress,
    required this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = task["isCompleted"] as bool;
    final categoryColor = task["categoryColor"] as Color;

    return Dismissible(
      key: Key(task["id"].toString()),
      background: _buildSwipeBackground(isLeft: true),
      secondaryBackground: _buildSwipeBackground(isLeft: false),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          // Edit action
          _showEditOptions(context);
        } else {
          // Complete/Delete action
          _showCompleteDeleteOptions(context);
        }
      },
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          margin: EdgeInsets.only(bottom: 2.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.borderLight,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.shadowLight,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (isMultiSelectMode)
                    Container(
                      margin: EdgeInsets.only(right: 3.w),
                      child: CustomIconWidget(
                        iconName: isSelected
                            ? 'check_circle'
                            : 'radio_button_unchecked',
                        color: isSelected
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.textSecondaryLight,
                        size: 24,
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: () => onToggleComplete(task["id"]),
                      child: Container(
                        margin: EdgeInsets.only(right: 3.w),
                        child: CustomIconWidget(
                          iconName: isCompleted
                              ? 'check_circle'
                              : 'radio_button_unchecked',
                          color: isCompleted
                              ? AppTheme.successLight
                              : AppTheme.textSecondaryLight,
                          size: 24,
                        ),
                      ),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 3,
                              height: 20,
                              decoration: BoxDecoration(
                                color: categoryColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                task["title"] as String,
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  decoration: isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  color: isCompleted
                                      ? AppTheme.textSecondaryLight
                                      : AppTheme.textPrimaryLight,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'access_time',
                              color: AppTheme.textSecondaryLight,
                              size: 16,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              task["dueTime"] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.textSecondaryLight,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            if (task["priority"] == "High")
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentLight
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'priority_high',
                                      color: AppTheme.accentLight,
                                      size: 12,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      'High',
                                      style: AppTheme
                                          .lightTheme.textTheme.labelSmall
                                          ?.copyWith(
                                        color: AppTheme.accentLight,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      task["category"] as String,
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: categoryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (task["assignedProperty"] != "N/A")
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'home',
                          color: AppTheme.textSecondaryLight,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          task["assignedProperty"] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  if (task["assignedClient"] != "N/A")
                    Row(
                      children: [
                        SizedBox(width: 2.w),
                        CustomIconWidget(
                          iconName: 'person',
                          color: AppTheme.textSecondaryLight,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          task["assignedClient"] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'person_outline',
                    color: AppTheme.textSecondaryLight,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    task["teamMember"] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                  const Spacer(),
                  if (task["attachments"] > 0)
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'attach_file',
                          color: AppTheme.textSecondaryLight,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          task["attachments"].toString(),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  if (task["comments"] > 0)
                    Row(
                      children: [
                        SizedBox(width: 2.w),
                        CustomIconWidget(
                          iconName: 'comment',
                          color: AppTheme.textSecondaryLight,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          task["comments"].toString(),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground({required bool isLeft}) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: isLeft ? AppTheme.lightTheme.primaryColor : AppTheme.accentLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment:
            isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isLeft) ...[
            CustomIconWidget(
              iconName: 'edit',
              color: Colors.white,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text(
              'Edit',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ] else ...[
            Text(
              'Delete',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'delete',
              color: Colors.white,
              size: 24,
            ),
          ],
        ],
      ),
    );
  }

  void _showEditOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text('Edit Task'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'content_copy',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text('Duplicate'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'group',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text('Assign to Team Member'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showCompleteDeleteOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Action'),
        content: Text('What would you like to do with this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onToggleComplete(task["id"]);
              Navigator.pop(context);
            },
            child: Text('Complete'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.accentLight,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
