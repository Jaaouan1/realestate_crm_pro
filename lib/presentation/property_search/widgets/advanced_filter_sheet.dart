import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdvancedFilterSheet extends StatefulWidget {
  final Function(List<String>) onFiltersApplied;
  final List<String> currentFilters;

  const AdvancedFilterSheet({
    super.key,
    required this.onFiltersApplied,
    required this.currentFilters,
  });

  @override
  State<AdvancedFilterSheet> createState() => _AdvancedFilterSheetState();
}

class _AdvancedFilterSheetState extends State<AdvancedFilterSheet> {
  RangeValues _priceRange = const RangeValues(100000, 1000000);
  List<String> _selectedPropertyTypes = [];
  int _bedrooms = 0;
  int _bathrooms = 0;
  RangeValues _sqftRange = const RangeValues(500, 5000);
  List<String> _selectedAmenities = [];

  final List<String> _propertyTypes = [
    'House',
    'Condo',
    'Apartment',
    'Villa',
    'Townhouse',
    'Land',
  ];

  final List<String> _amenities = [
    'Pool',
    'Garage',
    'Garden',
    'Balcony',
    'Gym',
    'Security',
    'Elevator',
    'Parking',
  ];

  @override
  void initState() {
    super.initState();
    _initializeFilters();
  }

  void _initializeFilters() {
    // Initialize filters based on current filters
    // This is a simplified implementation
    _selectedPropertyTypes = List.from(widget.currentFilters
        .where((filter) => _propertyTypes.contains(filter)));
    _selectedAmenities = List.from(
        widget.currentFilters.where((filter) => _amenities.contains(filter)));
  }

  void _applyFilters() {
    List<String> filters = [];

    // Add price range
    if (_priceRange.start > 100000 || _priceRange.end < 1000000) {
      filters.add(
          '\$${(_priceRange.start / 1000).round()}K - \$${(_priceRange.end / 1000).round()}K');
    }

    // Add property types
    filters.addAll(_selectedPropertyTypes);

    // Add bedrooms/bathrooms
    if (_bedrooms > 0) {
      filters.add('$_bedrooms+ Beds');
    }
    if (_bathrooms > 0) {
      filters.add('$_bathrooms+ Baths');
    }

    // Add square footage
    if (_sqftRange.start > 500 || _sqftRange.end < 5000) {
      filters.add('${_sqftRange.start.round()}-${_sqftRange.end.round()} sqft');
    }

    // Add amenities
    filters.addAll(_selectedAmenities);

    widget.onFiltersApplied(filters);
    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      _priceRange = const RangeValues(100000, 1000000);
      _selectedPropertyTypes.clear();
      _bedrooms = 0;
      _bathrooms = 0;
      _sqftRange = const RangeValues(500, 5000);
      _selectedAmenities.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Advanced Filters',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
                const Spacer(),
                TextButton(
                  onPressed: _clearFilters,
                  child: Text(
                    'Clear All',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Filter content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Range
                  _buildFilterSection(
                    title: 'Price Range',
                    child: Column(
                      children: [
                        RangeSlider(
                          values: _priceRange,
                          min: 50000,
                          max: 2000000,
                          divisions: 39,
                          labels: RangeLabels(
                            '\$${(_priceRange.start / 1000).round()}K',
                            '\$${(_priceRange.end / 1000).round()}K',
                          ),
                          onChanged: (values) {
                            setState(() {
                              _priceRange = values;
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${(_priceRange.start / 1000).round()}K',
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                            Text(
                              '\$${(_priceRange.end / 1000).round()}K',
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Property Type
                  _buildFilterSection(
                    title: 'Property Type',
                    child: Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: _propertyTypes.map((type) {
                        final isSelected =
                            _selectedPropertyTypes.contains(type);
                        return FilterChip(
                          label: Text(type),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedPropertyTypes.add(type);
                              } else {
                                _selectedPropertyTypes.remove(type);
                              }
                            });
                          },
                          backgroundColor:
                              AppTheme.lightTheme.colorScheme.surface,
                          selectedColor:
                              AppTheme.lightTheme.colorScheme.primaryContainer,
                          checkmarkColor:
                              AppTheme.lightTheme.colorScheme.primary,
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Bedrooms & Bathrooms
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterSection(
                          title: 'Bedrooms',
                          child: _buildStepperControl(
                            value: _bedrooms,
                            onChanged: (value) {
                              setState(() {
                                _bedrooms = value;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: _buildFilterSection(
                          title: 'Bathrooms',
                          child: _buildStepperControl(
                            value: _bathrooms,
                            onChanged: (value) {
                              setState(() {
                                _bathrooms = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Square Footage
                  _buildFilterSection(
                    title: 'Square Footage',
                    child: Column(
                      children: [
                        RangeSlider(
                          values: _sqftRange,
                          min: 200,
                          max: 8000,
                          divisions: 78,
                          labels: RangeLabels(
                            '${_sqftRange.start.round()}',
                            '${_sqftRange.end.round()}',
                          ),
                          onChanged: (values) {
                            setState(() {
                              _sqftRange = values;
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_sqftRange.start.round()} sqft',
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                            Text(
                              '${_sqftRange.end.round()} sqft',
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Amenities
                  _buildFilterSection(
                    title: 'Amenities',
                    child: Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: _amenities.map((amenity) {
                        final isSelected = _selectedAmenities.contains(amenity);
                        return FilterChip(
                          label: Text(amenity),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedAmenities.add(amenity);
                              } else {
                                _selectedAmenities.remove(amenity);
                              }
                            });
                          },
                          backgroundColor:
                              AppTheme.lightTheme.colorScheme.surface,
                          selectedColor:
                              AppTheme.lightTheme.colorScheme.primaryContainer,
                          checkmarkColor:
                              AppTheme.lightTheme.colorScheme.primary,
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Apply button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  width: 0.5,
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                child: const Text('Apply Filters'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        child,
      ],
    );
  }

  Widget _buildStepperControl({
    required int value,
    required Function(int) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: value > 0 ? () => onChanged(value - 1) : null,
            icon: CustomIconWidget(
              iconName: 'remove',
              color: value > 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.3),
              size: 20,
            ),
          ),
          Text(
            value == 0 ? 'Any' : '$value+',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          IconButton(
            onPressed: value < 10 ? () => onChanged(value + 1) : null,
            icon: CustomIconWidget(
              iconName: 'add',
              color: value < 10
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.3),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
