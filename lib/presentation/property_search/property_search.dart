import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/advanced_filter_sheet.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/property_card_widget.dart';
import './widgets/property_map_widget.dart';
import './widgets/recent_search_widget.dart';
import './widgets/search_bar_widget.dart';

class PropertySearch extends StatefulWidget {
  const PropertySearch({super.key});

  @override
  State<PropertySearch> createState() => _PropertySearchState();
}

class _PropertySearchState extends State<PropertySearch>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  bool _isMapView = false;
  bool _isLoading = false;
  String _selectedSort = 'Price';
  List<String> _appliedFilters = [];
  final List<String> _recentSearches = [
    'Downtown Condos',
    '3BR Houses',
    'Under \$500K',
    'Near Schools'
  ];

  final List<Map<String, dynamic>> _properties = [
    {
      "id": 1,
      "title": "Modern Downtown Condo",
      "price": "\$450,000",
      "address": "123 Main St, Downtown",
      "bedrooms": 2,
      "bathrooms": 2,
      "sqft": 1200,
      "distance": "0.5 miles",
      "imageUrl":
          "https://images.pexels.com/photos/1396122/pexels-photo-1396122.jpeg",
      "isFavorite": false,
      "listingDate": "2024-01-15",
      "propertyType": "Condo",
      "latitude": 40.7128,
      "longitude": -74.0060,
    },
    {
      "id": 2,
      "title": "Spacious Family Home",
      "price": "\$675,000",
      "address": "456 Oak Avenue, Suburbs",
      "bedrooms": 4,
      "bathrooms": 3,
      "sqft": 2400,
      "distance": "2.1 miles",
      "imageUrl":
          "https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg",
      "isFavorite": true,
      "listingDate": "2024-01-12",
      "propertyType": "House",
      "latitude": 40.7589,
      "longitude": -73.9851,
    },
    {
      "id": 3,
      "title": "Luxury Waterfront Villa",
      "price": "\$1,250,000",
      "address": "789 Lake Drive, Waterfront",
      "bedrooms": 5,
      "bathrooms": 4,
      "sqft": 3500,
      "distance": "5.3 miles",
      "imageUrl":
          "https://images.pexels.com/photos/1396132/pexels-photo-1396132.jpeg",
      "isFavorite": false,
      "listingDate": "2024-01-10",
      "propertyType": "Villa",
      "latitude": 40.6892,
      "longitude": -74.0445,
    },
    {
      "id": 4,
      "title": "Cozy Studio Apartment",
      "price": "\$285,000",
      "address": "321 Pine Street, Midtown",
      "bedrooms": 1,
      "bathrooms": 1,
      "sqft": 650,
      "distance": "1.2 miles",
      "imageUrl":
          "https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg",
      "isFavorite": false,
      "listingDate": "2024-01-18",
      "propertyType": "Apartment",
      "latitude": 40.7505,
      "longitude": -73.9934,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleView() {
    setState(() {
      _isMapView = !_isMapView;
    });
  }

  void _onSearch(String query) {
    if (query.isNotEmpty && !_recentSearches.contains(query)) {
      setState(() {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 6) {
          _recentSearches.removeLast();
        }
      });
    }
    _performSearch(query);
  }

  void _performSearch(String query) {
    setState(() {
      _isLoading = true;
    });

    // Simulate search delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _onVoiceSearch() {
    // Voice search implementation would go here
    _searchController.text = "3 bedroom homes under 500k";
    _onSearch(_searchController.text);
  }

  void _onSortChanged(String? value) {
    if (value != null) {
      setState(() {
        _selectedSort = value;
      });
    }
  }

  void _showAdvancedFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AdvancedFilterSheet(
        onFiltersApplied: (filters) {
          setState(() {
            _appliedFilters = filters;
          });
        },
        currentFilters: _appliedFilters,
      ),
    );
  }

  void _removeFilter(String filter) {
    setState(() {
      _appliedFilters.remove(filter);
    });
  }

  void _onPropertyTap(Map<String, dynamic> property) {
    Navigator.pushNamed(context, '/property-detail');
  }

  void _onPropertyLongPress(Map<String, dynamic> property) {
    _showQuickActions(property);
  }

  void _showQuickActions(Map<String, dynamic> property) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
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
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              property["title"] as String,
              style: AppTheme.lightTheme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            _buildQuickActionTile(
              icon: 'favorite_border',
              title: 'Save to Favorites',
              onTap: () => Navigator.pop(context),
            ),
            _buildQuickActionTile(
              icon: 'share',
              title: 'Share with Client',
              onTap: () => Navigator.pop(context),
            ),
            _buildQuickActionTile(
              icon: 'schedule',
              title: 'Schedule Showing',
              onTap: () => Navigator.pop(context),
            ),
            _buildQuickActionTile(
              icon: 'calculate',
              title: 'Calculate Mortgage',
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionTile({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: AppTheme.lightTheme.colorScheme.primary,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with search bar
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Search bar with voice search
                  SearchBarWidget(
                    controller: _searchController,
                    onSearch: _onSearch,
                    onVoiceSearch: _onVoiceSearch,
                  ),

                  SizedBox(height: 2.h),

                  // Controls row
                  Row(
                    children: [
                      // Map/List toggle
                      Container(
                        decoration: BoxDecoration(
                          color:
                              AppTheme.lightTheme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildToggleButton(
                              icon: 'list',
                              isSelected: !_isMapView,
                              onTap: () => setState(() => _isMapView = false),
                            ),
                            _buildToggleButton(
                              icon: 'map',
                              isSelected: _isMapView,
                              onTap: () => setState(() => _isMapView = true),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Sort dropdown
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedSort,
                            items: ['Price', 'Date Listed', 'Distance']
                                .map((sort) => DropdownMenuItem(
                                      value: sort,
                                      child: Text(
                                        sort,
                                        style: AppTheme
                                            .lightTheme.textTheme.bodyMedium,
                                      ),
                                    ))
                                .toList(),
                            onChanged: _onSortChanged,
                            icon: CustomIconWidget(
                              iconName: 'keyboard_arrow_down',
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                              size: 20,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 2.w),

                      // Filter button
                      IconButton(
                        onPressed: _showAdvancedFilters,
                        icon: CustomIconWidget(
                          iconName: 'tune',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 24,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor:
                              AppTheme.lightTheme.colorScheme.primaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Recent searches
            if (_recentSearches.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: RecentSearchWidget(
                  searches: _recentSearches,
                  onSearchTap: (search) {
                    _searchController.text = search;
                    _onSearch(search);
                  },
                ),
              ),
            ],

            // Applied filters
            if (_appliedFilters.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                child: Wrap(
                  spacing: 2.w,
                  runSpacing: 1.h,
                  children: _appliedFilters
                      .map((filter) => FilterChipWidget(
                            label: filter,
                            onRemove: () => _removeFilter(filter),
                          ))
                      .toList(),
                ),
              ),
            ],

            // Content area
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    )
                  : _isMapView
                      ? PropertyMapWidget(
                          properties: _properties,
                          onPropertyTap: _onPropertyTap,
                        )
                      : RefreshIndicator(
                          onRefresh: _onRefresh,
                          color: AppTheme.lightTheme.colorScheme.primary,
                          child: _properties.isEmpty
                              ? _buildEmptyState()
                              : ListView.builder(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 4.w),
                                  itemCount: _properties.length,
                                  itemBuilder: (context, index) {
                                    final property = _properties[index];
                                    return PropertyCardWidget(
                                      property: property,
                                      onTap: () => _onPropertyTap(property),
                                      onLongPress: () =>
                                          _onPropertyLongPress(property),
                                    );
                                  },
                                ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required String icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.onPrimary
              : AppTheme.lightTheme.colorScheme.onSurface,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: AppTheme.lightTheme.colorScheme.outline,
              size: 64,
            ),
            SizedBox(height: 3.h),
            Text(
              'No Properties Found',
              style: AppTheme.lightTheme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Try adjusting your search criteria or explore different areas',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _appliedFilters.clear();
                });
              },
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }
}
