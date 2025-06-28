import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

// lib/presentation/client_profile/widgets/interaction_history_widget.dart

class InteractionHistoryWidget extends StatefulWidget {
  final List<Map<String, dynamic>> interactions;
  final Function(Map<String, dynamic>) onEdit;
  final Function(String) onDelete;

  const InteractionHistoryWidget({
    super.key,
    required this.interactions,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<InteractionHistoryWidget> createState() =>
      _InteractionHistoryWidgetState();
}

class _InteractionHistoryWidgetState extends State<InteractionHistoryWidget> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderLight, width: 1)),
        child: Column(children: [
          // Header
          InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                  padding: EdgeInsets.all(4.w),
                  child: Row(children: [
                    CustomIconWidget(
                        iconName: 'history',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 24),
                    SizedBox(width: 2.w),
                    Expanded(
                        child: Text('Interaction History',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600))),
                    Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                            color: AppTheme.lightTheme.primaryColor
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12)),
                        child: Text('${widget.interactions.length}',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                                    color: AppTheme.lightTheme.primaryColor,
                                    fontWeight: FontWeight.w600))),
                    SizedBox(width: 2.w),
                    CustomIconWidget(
                        iconName: _isExpanded ? 'expand_less' : 'expand_more',
                        color: AppTheme.textSecondaryLight,
                        size: 24),
                  ]))),

          // Timeline content
          if (_isExpanded)
            Container(
                padding: EdgeInsets.all(4.w),
                child: Column(children: [
                  // Filter tabs
                  _buildFilterTabs(),

                  SizedBox(height: 2.h),

                  // Timeline
                  ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.interactions.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 2.h),
                      itemBuilder: (context, index) {
                        final interaction = widget.interactions[index];
                        return _buildTimelineItem(interaction, index == 0);
                      }),
                ])),
        ]));
  }

  Widget _buildFilterTabs() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          _buildFilterChip('All', true),
          SizedBox(width: 2.w),
          _buildFilterChip('Calls', false),
          SizedBox(width: 2.w),
          _buildFilterChip('Emails', false),
          SizedBox(width: 2.w),
          _buildFilterChip('Showings', false),
          SizedBox(width: 2.w),
          _buildFilterChip('Notes', false),
        ]));
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.borderLight,
                width: 1)),
        child: Text(label,
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                    : AppTheme.textSecondaryLight,
                fontWeight: FontWeight.w500)));
  }

  Widget _buildTimelineItem(Map<String, dynamic> interaction, bool isLatest) {
    final interactionType = interaction['type'] as String;
    final date = DateTime.parse(interaction['date'] as String);

    return GestureDetector(
        onLongPress: () => _showInteractionMenu(context, interaction),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Timeline indicator
          Column(children: [
            Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                    color: _getInteractionColor(interactionType)
                        .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: _getInteractionColor(interactionType),
                        width: isLatest ? 3 : 2)),
                child: CustomIconWidget(
                    iconName: _getInteractionIcon(interactionType),
                    color: _getInteractionColor(interactionType),
                    size: 20)),
            if (widget.interactions.indexOf(interaction) <
                widget.interactions.length - 1)
              Container(width: 2, height: 6.h, color: AppTheme.borderLight),
          ]),

          SizedBox(width: 3.w),

          // Content
          Expanded(
              child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                      color: isLatest
                          ? AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.05)
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: isLatest
                              ? AppTheme.lightTheme.primaryColor
                                  .withValues(alpha: 0.3)
                              : AppTheme.borderLight,
                          width: 1)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(children: [
                          Expanded(
                              child: Text(_getInteractionTitle(interaction),
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600))),
                          Text(_formatDate(date),
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                      color: AppTheme.textSecondaryLight)),
                        ]),

                        SizedBox(height: 1.h),

                        // Outcome
                        if (interaction['outcome'] != null)
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                  color: _getInteractionColor(interactionType)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(interaction['outcome'] as String,
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                          color: _getInteractionColor(
                                              interactionType),
                                          fontWeight: FontWeight.w500))),

                        SizedBox(height: 1.h),

                        // Notes
                        if (interaction['notes'] != null)
                          Text(interaction['notes'] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                      color: AppTheme.textSecondaryLight)),

                        // Additional info
                        if (interaction['duration'] != null ||
                            interaction['subject'] != null ||
                            interaction['property'] != null)
                          Padding(
                              padding: EdgeInsets.only(top: 1.h),
                              child: Row(children: [
                                if (interaction['duration'] != null) ...[
                                  CustomIconWidget(
                                      iconName: 'schedule',
                                      color: AppTheme.textSecondaryLight,
                                      size: 14),
                                  SizedBox(width: 1.w),
                                  Text(interaction['duration'] as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                              color:
                                                  AppTheme.textSecondaryLight)),
                                ],
                                if (interaction['subject'] != null) ...[
                                  CustomIconWidget(
                                      iconName: 'subject',
                                      color: AppTheme.textSecondaryLight,
                                      size: 14),
                                  SizedBox(width: 1.w),
                                  Expanded(
                                      child: Text(
                                          interaction['subject'] as String,
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall
                                              ?.copyWith(
                                                  color: AppTheme
                                                      .textSecondaryLight),
                                          overflow: TextOverflow.ellipsis)),
                                ],
                                if (interaction['property'] != null) ...[
                                  CustomIconWidget(
                                      iconName: 'home',
                                      color: AppTheme.textSecondaryLight,
                                      size: 14),
                                  SizedBox(width: 1.w),
                                  Expanded(
                                      child: Text(
                                          interaction['property'] as String,
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall
                                              ?.copyWith(
                                                  color: AppTheme
                                                      .textSecondaryLight),
                                          overflow: TextOverflow.ellipsis)),
                                ],
                              ])),
                      ]))),
        ]));
  }

  void _showInteractionMenu(
      BuildContext context, Map<String, dynamic> interaction) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
            padding: EdgeInsets.all(4.w),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('Interaction Options',
                  style: AppTheme.lightTheme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              SizedBox(height: 2.h),
              ListTile(
                  leading: CustomIconWidget(
                      iconName: 'edit',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 24),
                  title: Text('Edit Interaction'),
                  onTap: () {
                    Navigator.pop(context);
                    widget.onEdit(interaction);
                  }),
              ListTile(
                  leading: CustomIconWidget(
                      iconName: 'delete',
                      color: AppTheme.lightTheme.colorScheme.error,
                      size: 24),
                  title: Text('Delete Interaction',
                      style: TextStyle(
                          color: AppTheme.lightTheme.colorScheme.error)),
                  onTap: () {
                    Navigator.pop(context);
                    _confirmDelete(context, interaction);
                  }),
            ])));
  }

  void _confirmDelete(BuildContext context, Map<String, dynamic> interaction) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Delete Interaction'),
                content:
                    Text('Are you sure you want to delete this interaction?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onDelete(interaction['id'] as String);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppTheme.lightTheme.colorScheme.error),
                      child: Text('Delete')),
                ]));
  }

  Color _getInteractionColor(String type) {
    switch (type) {
      case 'call':
        return AppTheme.successLight;
      case 'email':
        return AppTheme.warningLight;
      case 'showing':
        return AppTheme.lightTheme.primaryColor;
      case 'note':
        return AppTheme.lightTheme.colorScheme.secondary;
      default:
        return AppTheme.textSecondaryLight;
    }
  }

  String _getInteractionIcon(String type) {
    switch (type) {
      case 'call':
        return 'phone';
      case 'email':
        return 'email';
      case 'showing':
        return 'home';
      case 'note':
        return 'note';
      default:
        return 'info';
    }
  }

  String _getInteractionTitle(Map<String, dynamic> interaction) {
    final type = interaction['type'] as String;
    switch (type) {
      case 'call':
        return 'Phone Call';
      case 'email':
        return interaction['subject'] as String? ?? 'Email';
      case 'showing':
        return 'Property Showing';
      case 'note':
        return 'Note Added';
      default:
        return 'Interaction';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
