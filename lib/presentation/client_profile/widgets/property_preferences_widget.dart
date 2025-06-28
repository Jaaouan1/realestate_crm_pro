import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

// lib/presentation/client_profile/widgets/property_preferences_widget.dart

class PropertyPreferencesWidget extends StatefulWidget {
  final Map<String, dynamic> preferences;
  final bool isEditMode;
  final Function(Map<String, dynamic>) onUpdate;

  const PropertyPreferencesWidget({
    super.key,
    required this.preferences,
    required this.isEditMode,
    required this.onUpdate,
  });

  @override
  State<PropertyPreferencesWidget> createState() =>
      _PropertyPreferencesWidgetState();
}

class _PropertyPreferencesWidgetState extends State<PropertyPreferencesWidget> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.borderLight,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'home_work',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Property Preferences',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  CustomIconWidget(
                    iconName: _isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.textSecondaryLight,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),

          // Content
          if (_isExpanded)
            Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Budget
                  _buildBudgetCard(),

                  SizedBox(height: 2.h),

                  // Property details
                  Row(
                    children: [
                      Expanded(
                        child: _buildPreferenceCard(
                          'Property Type',
                          widget.preferences['propertyType'] as String,
                          'apartment',
                          AppTheme.lightTheme.primaryColor,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: _buildPreferenceCard(
                          'Location',
                          widget.preferences['location'] as String,
                          'location_on',
                          AppTheme.successLight,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Bedrooms and Bathrooms
                  Row(
                    children: [
                      Expanded(
                        child: _buildPreferenceCard(
                          'Bedrooms',
                          '${widget.preferences['bedrooms']} BR',
                          'bed',
                          AppTheme.warningLight,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: _buildPreferenceCard(
                          'Bathrooms',
                          '${widget.preferences['bathrooms']} BA',
                          'bathroom',
                          AppTheme.lightTheme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Amenities
                  _buildAmenitiesSection(),

                  SizedBox(height: 2.h),

                  // Notes
                  if (widget.preferences['notes'] != null) _buildNotesSection(),

                  SizedBox(height: 2.h),

                  // Saved searches and favorites
                  _buildSavedSearchesSection(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBudgetCard() {
    final budget = widget.preferences['budget'] as Map<String, dynamic>;
    final minBudget = budget['min'] as int;
    final maxBudget = budget['max'] as int;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
            AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'attach_money',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              SizedBox(width: 1.w),
              Text(
                'Budget Range',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            '\$${_formatCurrency(minBudget)} - \$${_formatCurrency(maxBudget)}',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceCard(
    String label,
    String value,
    String iconName,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 18,
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenitiesSection() {
    final amenities = widget.preferences['amenities'] as List<String>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preferred Amenities',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: amenities
              .map((amenity) => Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.successLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.successLight.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: _getAmenityIcon(amenity),
                          color: AppTheme.successLight,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          amenity,
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.successLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.borderLight,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'note',
                color: AppTheme.textSecondaryLight,
                size: 18,
              ),
              SizedBox(width: 2.w),
              Text(
                'Notes',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            widget.preferences['notes'] as String,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedSearchesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Saved Searches & Favorites',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            TextButton(
              onPressed: () => _viewAllSavedSearches(),
              child: Text('View All'),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildSavedSearchCard(
                'Downtown Condos',
                '12 new listings',
                'apartment',
              ),
              SizedBox(width: 3.w),
              _buildSavedSearchCard(
                'Parking Included',
                '5 new listings',
                'local_parking',
              ),
              SizedBox(width: 3.w),
              _buildSavedSearchCard(
                'Under \$500K',
                '8 new listings',
                'attach_money',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSavedSearchCard(
    String title,
    String subtitle,
    String iconName,
  ) {
    return Container(
      width: 40.w,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.borderLight,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              Spacer(),
              Container(
                width: 2.w,
                height: 2.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.error,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            subtitle,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(int amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toString();
  }

  String _getAmenityIcon(String amenity) {
    switch (amenity.toLowerCase()) {
      case 'parking':
        return 'local_parking';
      case 'gym':
        return 'fitness_center';
      case 'pool':
        return 'pool';
      case 'balcony':
        return 'balcony';
      default:
        return 'check_circle';
    }
  }

  void _viewAllSavedSearches() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening saved searches')),
    );
  }
}
