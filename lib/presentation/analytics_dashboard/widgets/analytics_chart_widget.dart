import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/app_export.dart';

class AnalyticsChartWidget extends StatefulWidget {
  final String chartType;
  final List<dynamic> data;
  final String title;

  const AnalyticsChartWidget({
    super.key,
    required this.chartType,
    required this.data,
    required this.title,
  });

  @override
  State<AnalyticsChartWidget> createState() => _AnalyticsChartWidgetState();
}

class _AnalyticsChartWidgetState extends State<AnalyticsChartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
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
                    widget.title,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _showChartDetails,
                  icon: CustomIconWidget(
                    iconName: 'info_outline',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return _buildChart();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    switch (widget.chartType) {
      case 'line':
        return _buildLineChart();
      case 'pie':
        return _buildPieChart();
      case 'bar':
        return _buildBarChart();
      default:
        return _buildLineChart();
    }
  }

  Widget _buildLineChart() {
    return SizedBox(
      height: 25.h,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: widget.data.asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value;
                return FlSpot(
                  index.toDouble(),
                  (data["sales"] / 100000).toDouble() * _animation.value,
                );
              }).toList(),
              isCurved: true,
              color: AppTheme.lightTheme.primaryColor,
              barWidth: 3,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 6,
                    color: AppTheme.lightTheme.colorScheme.surface,
                    strokeWidth: 3,
                    strokeColor: AppTheme.lightTheme.primaryColor,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              ),
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < widget.data.length) {
                    return Text(
                      widget.data[value.toInt()]["month"] ?? "",
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    );
                  }
                  return Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '\${value.toInt()}K',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    return SizedBox(
      height: 25.h,
      child: PieChart(
        PieChartData(
          sections: widget.data.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            final colors = [
              AppTheme.primaryLight,
              AppTheme.successLight,
              AppTheme.warningLight,
              AppTheme.accentLight,
            ];

            return PieChartSectionData(
              value: (data["percentage"] as num).toDouble() * _animation.value,
              title: '${data["percentage"]}%',
              color: colors[index % colors.length],
              radius: 60,
              titleStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            );
          }).toList(),
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return SizedBox(
      height: 25.h,
      child: BarChart(
        BarChartData(
          barGroups: widget.data.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY:
                      (data["percentage"] as num).toDouble() * _animation.value,
                  color: AppTheme.lightTheme.primaryColor,
                  width: 20,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < widget.data.length) {
                    return Padding(
                      padding: EdgeInsets.only(top: 1.h),
                      child: Text(
                        widget.data[value.toInt()]["type"] ?? "",
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  }
                  return Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}%',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  void _showChartDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chart Details:',
                style: AppTheme.lightTheme.textTheme.titleSmall),
            SizedBox(height: 1.h),
            ...widget.data.map((item) {
              return Padding(
                padding: EdgeInsets.only(bottom: 0.5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.containsKey("month")
                          ? item["month"]
                          : item.containsKey("source")
                              ? item["source"]
                              : item["type"] ?? "",
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    Text(
                      item.containsKey("sales")
                          ? '\${(item["sales"] / 1000).toInt()}K'
                          : item.containsKey("percentage")
                              ? '${item["percentage"]}%'
                              : item["percentage"]?.toString() ?? "",
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}