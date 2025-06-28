import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/analytics_chart_widget.dart';
import './widgets/date_range_selector_widget.dart';
import './widgets/hero_metrics_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/secondary_metrics_widget.dart';

class AnalyticsDashboard extends StatefulWidget {
  const AnalyticsDashboard({super.key});

  @override
  State<AnalyticsDashboard> createState() => _AnalyticsDashboardState();
}

class _AnalyticsDashboardState extends State<AnalyticsDashboard>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  String _selectedDateRange = 'This Month';
  String _selectedFilter = 'All Properties';
  bool _isRefreshing = false;
  late TabController _chartTabController;

  // Mock analytics data
  final Map<String, dynamic> _analyticsData = {
    "heroMetrics": {
      "totalSalesVolume": 4250000,
      "activeListings": 23,
      "conversionRate": 0.18,
      "commissionEarned": 127500
    },
    "monthlyTrends": [
      {"month": "Jan", "sales": 850000, "listings": 15},
      {"month": "Feb", "sales": 920000, "listings": 18},
      {"month": "Mar", "sales": 1100000, "listings": 22},
      {"month": "Apr", "sales": 980000, "listings": 19},
      {"month": "May", "sales": 1200000, "listings": 25},
      {"month": "Jun", "sales": 1400000, "listings": 28}
    ],
    "leadSources": [
      {"source": "Website", "percentage": 35, "count": 142},
      {"source": "Referrals", "percentage": 28, "count": 113},
      {"source": "Social Media", "percentage": 20, "count": 81},
      {"source": "Cold Calls", "percentage": 17, "count": 69}
    ],
    "propertyTypes": [
      {"type": "House", "percentage": 45, "volume": 1912500},
      {"type": "Condo", "percentage": 30, "volume": 1275000},
      {"type": "Villa", "percentage": 15, "volume": 637500},
      {"type": "Studio", "percentage": 10, "volume": 425000}
    ],
    "secondaryMetrics": {
      "averageDaysOnMarket": 28,
      "showingToSaleRatio": 0.15,
      "clientSatisfactionScore": 4.7,
      "marketShareGrowth": 0.12
    }
  };

  @override
  void initState() {
    super.initState();
    _chartTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _chartTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with date range and export
            _buildHeader(),

            // Main content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: AppTheme.lightTheme.primaryColor,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2.h),

                      // Hero Metrics
                      HeroMetricsWidget(
                        metrics: _analyticsData["heroMetrics"],
                      ),

                      SizedBox(height: 3.h),

                      // Filter Options
                      _buildFilterSection(),

                      SizedBox(height: 3.h),

                      // Interactive Charts
                      _buildChartsSection(),

                      SizedBox(height: 3.h),

                      // Secondary Metrics
                      SecondaryMetricsWidget(
                        metrics: _analyticsData["secondaryMetrics"],
                      ),

                      SizedBox(height: 3.h),

                      // Quick Actions
                      QuickActionsWidget(
                        onGenerateReport: _generateReport,
                        onScheduleReview: _scheduleReview,
                        onSetGoals: _setGoals,
                        onCompareToMarket: _compareToMarket,
                      ),

                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Analytics Dashboard',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Performance insights & metrics',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          DateRangeSelectorWidget(
            selectedRange: _selectedDateRange,
            onRangeChanged: (range) {
              setState(() {
                _selectedDateRange = range;
              });
            },
          ),
          SizedBox(width: 2.w),
          IconButton(
            onPressed: _showExportOptions,
            icon: CustomIconWidget(
              iconName: 'download',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filter Analysis',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              'All Properties',
              'House',
              'Condo',
              'Villa',
              'Studio',
              'Price Range',
              'Team Member'
            ].map((filter) {
              final isSelected = _selectedFilter == filter;
              return Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: FilterChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = filter;
                    });
                  },
                  backgroundColor:
                      AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                  selectedColor:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  labelStyle:
                      AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildChartsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Performance Charts',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),

        // Chart tabs
        Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TabBar(
            controller: _chartTabController,
            indicator: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            indicatorPadding: EdgeInsets.all(1.w),
            dividerColor: Colors.transparent,
            labelColor: AppTheme.lightTheme.primaryColor,
            unselectedLabelColor:
                AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle:
                AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            tabs: [
              Tab(text: 'Sales Trends'),
              Tab(text: 'Lead Sources'),
              Tab(text: 'Property Types'),
            ],
          ),
        ),

        SizedBox(height: 2.h),

        // Chart content
        SizedBox(
          height: 35.h,
          child: TabBarView(
            controller: _chartTabController,
            children: [
              AnalyticsChartWidget(
                chartType: 'line',
                data: _analyticsData["monthlyTrends"],
                title: 'Monthly Sales Volume',
              ),
              AnalyticsChartWidget(
                chartType: 'pie',
                data: _analyticsData["leadSources"],
                title: 'Lead Source Distribution',
              ),
              AnalyticsChartWidget(
                chartType: 'bar',
                data: _analyticsData["propertyTypes"],
                title: 'Property Type Performance',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onBottomNavTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      selectedItemColor: AppTheme.lightTheme.primaryColor,
      unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      elevation: 8.0,
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'analytics',
            color: _selectedIndex == 0
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Analytics',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'group',
            color: _selectedIndex == 1
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Team',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'task',
            color: _selectedIndex == 2
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Tasks',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'person',
            color: _selectedIndex == 3
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Profile',
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _exportData,
      backgroundColor: AppTheme.lightTheme.primaryColor,
      foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
      icon: CustomIconWidget(
        iconName: 'file_download',
        color: AppTheme.lightTheme.colorScheme.onPrimary,
        size: 24,
      ),
      label: Text(
        'Export',
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onPrimary,
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Analytics data updated successfully'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Already on Analytics tab
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/team-collaboration');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/task-management');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/client-profile');
        break;
    }
  }

  void _showExportOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Export Options',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            _buildExportOption('PDF Report', 'picture_as_pdf', () {}),
            _buildExportOption('Excel Spreadsheet', 'table_chart', () {}),
            _buildExportOption('CSV Data', 'description', () {}),
            _buildExportOption('Email Report', 'email', () {}),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildExportOption(String title, String iconName, VoidCallback onTap) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: AppTheme.lightTheme.primaryColor,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge,
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting analytics data...'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _generateReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Generating detailed report...'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _scheduleReview() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Scheduling performance review...'),
        backgroundColor: AppTheme.warningLight,
      ),
    );
  }

  void _setGoals() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening goal setting interface...'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  void _compareToMarket() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Loading market comparison data...'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }
}
