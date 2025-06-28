import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GroupTasksListWidget extends StatelessWidget {
  GroupTasksListWidget({super.key});

  final List<Map<String, dynamic>> _groupTasks = [
    {
      "id": 1,
      "title": "Q1 Marketing Campaign Review",
      "description":
          "Review and approve marketing materials for upcoming quarter",
      "assignedTeam": ["Sarah Johnson", "David Wilson", "Michael Chen"],
      "deadline": "2024-02-15",
      "priority": "High",
      "progress": 0.75,
      "completedSubtasks": 3,
      "totalSubtasks": 4,
      "category": "Marketing",
      "status": "In Progress"
    },
    {
      "id": 2,
      "title": "New Agent Onboarding",
      "description": "Complete onboarding process for two new team members",
      "assignedTeam": ["Michael Chen", "Emily Rodriguez"],
      "deadline": "2024-02-20",
      "priority": "Medium",
      "progress": 0.40,
      "completedSubtasks": 2,
      "totalSubtasks": 5,
      "category": "HR",
      "status": "In Progress"
    },
    {
      "id": 3,
      "title": "Client Database Migration",
      "description": "Migrate all client data to new CRM system",
      "assignedTeam": ["David Wilson", "Sarah Johnson"],
      "deadline": "2024-02-10",
      "priority": "Urgent",
      "progress": 0.90,
      "completedSubtasks": 9,
      "totalSubtasks": 10,
      "category": "Technology",
      "status": "Almost Complete"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      itemCount: _groupTasks.length,
      itemBuilder: (context, index) {
        final task = _groupTasks[index];
        return _buildGroupTaskCard(task, context);
      },
    );
  }

  Widget _buildGroupTaskCard(Map<String, dynamic> task, BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task["title"],
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _buildPriorityChip(task["priority"]),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              task["description"],
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 2.h),

            // Progress Section
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            '${(task["progress"] * 100).toInt()}%',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      LinearProgressIndicator(
                        value: task["progress"],
                        backgroundColor:
                            AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getProgressColor(task["progress"]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Subtasks and deadline info
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.successLight,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  '${task["completedSubtasks"]}/${task["totalSubtasks"]} tasks',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.successLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                CustomIconWidget(
                  iconName: 'schedule',
                  color: _getDeadlineColor(task["deadline"]),
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  _formatDeadline(task["deadline"]),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: _getDeadlineColor(task["deadline"]),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Team members
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Team Members',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 1.h),
                Wrap(
                  spacing: 1.w,
                  runSpacing: 0.5.h,
                  children: (task["assignedTeam"] as List<String>).map((name) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        name,
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: CustomIconWidget(
                      iconName: 'visibility',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 16,
                    ),
                    label: Text('View Details'),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: CustomIconWidget(
                      iconName: 'edit',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 16,
                    ),
                    label: Text('Update'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityChip(String priority) {
    Color color;
    switch (priority.toLowerCase()) {
      case 'urgent':
        color = AppTheme.accentLight;
        break;
      case 'high':
        color = AppTheme.warningLight;
        break;
      case 'medium':
        color = AppTheme.primaryLight;
        break;
      default:
        color = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        priority,
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 0.8) return AppTheme.successLight;
    if (progress >= 0.5) return AppTheme.warningLight;
    return AppTheme.primaryLight;
  }

  Color _getDeadlineColor(String deadline) {
    final deadlineDate = DateTime.parse(deadline);
    final now = DateTime.now();
    final daysLeft = deadlineDate.difference(now).inDays;

    if (daysLeft < 0) return AppTheme.accentLight;
    if (daysLeft <= 3) return AppTheme.warningLight;
    return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
  }

  String _formatDeadline(String deadline) {
    final deadlineDate = DateTime.parse(deadline);
    final now = DateTime.now();
    final daysLeft = deadlineDate.difference(now).inDays;

    if (daysLeft < 0) return 'Overdue';
    if (daysLeft == 0) return 'Due Today';
    if (daysLeft == 1) return 'Due Tomorrow';
    return 'Due in $daysLeft days';
  }
}
