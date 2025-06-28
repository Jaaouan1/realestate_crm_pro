import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LeadFilterChipsWidget extends StatefulWidget {
  final VoidCallback onFilterChanged;

  const LeadFilterChipsWidget({
    super.key,
    required this.onFilterChanged,
  });

  @override
  State<LeadFilterChipsWidget> createState() => _LeadFilterChipsWidgetState();
}

class _LeadFilterChipsWidgetState extends State<LeadFilterChipsWidget> {
  String? _selectedSource;
  String? _selectedPropertyType;
  String? _selectedBudgetRange;

  final List<String> _sources = ['All', 'Website', 'Referral', 'Walk-in'];
  final List<String> _propertyTypes = [
    'All',
    'House',
    'Condo',
    'Apartment',
    'Townhouse',
    'Penthouse'
  ];
  final List<String> _budgetRanges = [
    'All',
    'Under \$300K',
    '\$300K - \$500K',
    '\$500K - \$750K',
    '\$750K - \$1M',
    'Over \$1M'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChipGroup(
              'Source',
              _sources,
              _selectedSource,
              (value) {
                setState(() {
                  _selectedSource = value == 'All' ? null : value;
                });
                widget.onFilterChanged();
              },
            ),
            SizedBox(width: 3.w),
            _buildFilterChipGroup(
              'Property Type',
              _propertyTypes,
              _selectedPropertyType,
              (value) {
                setState(() {
                  _selectedPropertyType = value == 'All' ? null : value;
                });
                widget.onFilterChanged();
              },
            ),
            SizedBox(width: 3.w),
            _buildFilterChipGroup(
              'Budget',
              _budgetRanges,
              _selectedBudgetRange,
              (value) {
                setState(() {
                  _selectedBudgetRange = value == 'All' ? null : value;
                });
                widget.onFilterChanged();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChipGroup(
    String label,
    List<String> options,
    String? selectedValue,
    Function(String) onSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            color: AppTheme.textSecondaryLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        PopupMenuButton<String>(
          onSelected: onSelected,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: selectedValue != null
                  ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selectedValue != null
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.borderLight,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedValue ?? 'All',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: selectedValue != null
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 1.w),
                CustomIconWidget(
                  iconName: 'keyboard_arrow_down',
                  color: selectedValue != null
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.textSecondaryLight,
                  size: 16,
                ),
              ],
            ),
          ),
          itemBuilder: (context) => options
              .map((option) => PopupMenuItem<String>(
                    value: option,
                    child: Row(
                      children: [
                        if (option == (selectedValue ?? 'All'))
                          CustomIconWidget(
                            iconName: 'check',
                            color: AppTheme.lightTheme.primaryColor,
                            size: 16,
                          )
                        else
                          SizedBox(width: 16),
                        SizedBox(width: 2.w),
                        Text(option),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
