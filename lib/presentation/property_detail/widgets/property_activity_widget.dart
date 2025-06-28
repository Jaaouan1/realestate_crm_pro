import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PropertyActivityWidget extends StatefulWidget {
  final List<Map<String, dynamic>> activities;

  const PropertyActivityWidget({
    super.key,
    required this.activities,
  });

  @override
  State<PropertyActivityWidget> createState() => _PropertyActivityWidgetState();
}

class _PropertyActivityWidgetState extends State<PropertyActivityWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final displayActivities =
        _isExpanded ? widget.activities : widget.activities.take(3).toList();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (widget.activities.length > 3)
                GestureDetector(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: CustomIconWidget(
                    iconName: _isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          ...displayActivities.asMap().entries.map((entry) {
            final index = entry.key;
            final activity = entry.value;
            final isLast = index == displayActivities.length - 1;
            return _buildActivityItem(activity, isLast);
          }),
          if (!_isExpanded && widget.activities.length > 3) ...[
            SizedBox(height: 1.h),
            GestureDetector(
              onTap: () => setState(() => _isExpanded = true),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Show ${widget.activities.length - 3} more activities',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 1.w),
                  CustomIconWidget(
                    iconName: 'keyboard_arrow_down',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity, bool isLast) {
    final activityType = activity["type"] as String;
    final iconName = _getActivityIcon(activityType);
    final iconColor = _getActivityColor(activityType);
    final date = DateTime.parse(activity["date"] as String);
    final formattedDate = _formatDate(date);

    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: iconName,
                color: iconColor,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity["activity"] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  formattedDate,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getActivityIcon(String type) {
    switch (type) {
      case 'price_change':
        return 'trending_down';
      case 'media_update':
        return 'photo_camera';
      case 'listing_created':
        return 'add_circle';
      case 'showing_scheduled':
        return 'event';
      case 'offer_received':
        return 'local_offer';
      default:
        return 'info';
    }
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'price_change':
        return AppTheme.warningLight;
      case 'media_update':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'listing_created':
        return AppTheme.successLight;
      case 'showing_scheduled':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'offer_received':
        return AppTheme.successLight;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
