import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PipelineStageTabsWidget extends StatefulWidget {
  final TabController controller;
  final Function(String) onStageChanged;

  const PipelineStageTabsWidget({
    super.key,
    required this.controller,
    required this.onStageChanged,
  });

  @override
  State<PipelineStageTabsWidget> createState() =>
      _PipelineStageTabsWidgetState();
}

class _PipelineStageTabsWidgetState extends State<PipelineStageTabsWidget> {
  final List<Map<String, dynamic>> _stages = [
    {'name': 'New', 'count': 12},
    {'name': 'Contacted', 'count': 8},
    {'name': 'Qualified', 'count': 15},
    {'name': 'Showing', 'count': 6},
    {'name': 'Negotiating', 'count': 4},
  ];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTabChange);
    super.dispose();
  }

  void _handleTabChange() {
    if (widget.controller.indexIsChanging) {
      final stageName = _stages[widget.controller.index]['name'] as String;
      widget.onStageChanged(stageName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.borderLight,
          width: 1,
        ),
      ),
      child: TabBar(
        controller: widget.controller,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicator: BoxDecoration(
          color: AppTheme.lightTheme.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        labelColor: AppTheme.lightTheme.colorScheme.onPrimary,
        unselectedLabelColor: AppTheme.textSecondaryLight,
        labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle:
            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: _stages.map((stage) => _buildStageTab(stage)).toList(),
      ),
    );
  }

  Widget _buildStageTab(Map<String, dynamic> stage) {
    return Tab(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(stage['name'] as String),
            SizedBox(width: 1.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.3.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${stage['count']}',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
