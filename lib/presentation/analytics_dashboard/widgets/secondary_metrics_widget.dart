import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SecondaryMetricsWidget extends StatelessWidget {
  final Map<String, dynamic> metrics;

  const SecondaryMetricsWidget({
    super.key,
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Metrics',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 3.w,
          mainAxisSpacing: 2.h,
          childAspectRatio: 2.5,
          children: [
            _buildMetricTile(
              'Avg. Days on Market',
              '${metrics["averageDaysOnMarket"]} days',
              'schedule',
              AppTheme.warningLight,
              'vs 32 last month',
            ),
            _buildMetricTile(
              'Showing-to-Sale Ratio',
              '${(metrics["showingToSaleRatio"] * 100).toStringAsFixed(1)}%',
              'visibility',
              AppTheme.successLight,
              '+2.3% improvement',
            ),
            _buildMetricTile(
              'Client Satisfaction',
              '${metrics["clientSatisfactionScore"]}/5.0',
              'star',
              AppTheme.accentLight,
              '4.5 average industry',
            ),
            _buildMetricTile(
              'Market Share Growth',
              '${(metrics["marketShareGrowth"] * 100).toStringAsFixed(1)}%',
              'trending_up',
              AppTheme.primaryLight,
              'vs 8.7% last quarter',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricTile(
    String title,
    String value,
    String iconName,
    Color accentColor,
    String comparison,
  ) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: iconName,
                  color: accentColor,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              value,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: accentColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              comparison,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
