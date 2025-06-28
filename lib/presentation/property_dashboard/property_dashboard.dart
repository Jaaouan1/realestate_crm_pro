import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/dashboard_header_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/property_card_widget.dart';

class PropertyDashboard extends StatefulWidget {
  const PropertyDashboard({super.key});

  @override
  State<PropertyDashboard> createState() => _PropertyDashboardState();
}

class _PropertyDashboardState extends State<PropertyDashboard>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isRefreshing = false;
  final ScrollController _scrollController = ScrollController();

  // Mock data for properties
  final List<Map<String, dynamic>> _properties = [
    {
      "id": 1,
      "title": "Modern Downtown Condo",
      "address": "123 Main Street, Downtown",
      "price": "\$450,000",
      "bedrooms": 2,
      "bathrooms": 2,
      "sqft": 1200,
      "status": "Active",
      "imageUrl":
          "https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg",
      "type": "Condo",
      "listingDate": "2024-01-15",
      "agent": "Sarah Johnson"
    },
    {
      "id": 2,
      "title": "Family Home with Garden",
      "address": "456 Oak Avenue, Suburbs",
      "price": "\$675,000",
      "bedrooms": 4,
      "bathrooms": 3,
      "sqft": 2400,
      "status": "Pending",
      "imageUrl":
          "https://images.pexels.com/photos/186077/pexels-photo-186077.jpeg",
      "type": "House",
      "listingDate": "2024-01-10",
      "agent": "Michael Chen"
    },
    {
      "id": 3,
      "title": "Luxury Penthouse Suite",
      "address": "789 High Street, Uptown",
      "price": "\$1,250,000",
      "bedrooms": 3,
      "bathrooms": 3,
      "sqft": 1800,
      "status": "Active",
      "imageUrl":
          "https://images.pexels.com/photos/1396122/pexels-photo-1396122.jpeg",
      "type": "Penthouse",
      "listingDate": "2024-01-20",
      "agent": "Emily Rodriguez"
    },
    {
      "id": 4,
      "title": "Cozy Studio Apartment",
      "address": "321 Pine Street, City Center",
      "price": "\$285,000",
      "bedrooms": 1,
      "bathrooms": 1,
      "sqft": 650,
      "status": "Sold",
      "imageUrl":
          "https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg",
      "type": "Studio",
      "listingDate": "2024-01-05",
      "agent": "David Wilson"
    },
    {
      "id": 5,
      "title": "Waterfront Villa",
      "address": "555 Beach Road, Coastal",
      "price": "\$2,100,000",
      "bedrooms": 5,
      "bathrooms": 4,
      "sqft": 3500,
      "status": "Active",
      "imageUrl":
          "https://images.pexels.com/photos/1396132/pexels-photo-1396132.jpeg",
      "type": "Villa",
      "listingDate": "2024-01-25",
      "agent": "Lisa Thompson"
    }
  ];

  final List<Map<String, dynamic>> _activeFilters = [
    {"label": "Price Range", "count": 2},
    {"label": "Active", "count": 3},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Sticky Header
            DashboardHeaderWidget(
              onSearchTap: () =>
                  Navigator.pushNamed(context, '/property-search'),
              onFilterTap: _showFilterBottomSheet,
            ),

            // Filter Chips
            if (_activeFilters.isNotEmpty)
              Container(
                height: 6.h,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _activeFilters.length,
                  itemBuilder: (context, index) {
                    final filter = _activeFilters[index];
                    return Padding(
                      padding: EdgeInsets.only(right: 2.w),
                      child: FilterChipWidget(
                        label: filter["label"] as String,
                        count: filter["count"] as int,
                        onRemove: () => _removeFilter(index),
                      ),
                    );
                  },
                ),
              ),

            // Properties List
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: AppTheme.lightTheme.primaryColor,
                child: _properties.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 2.h),
                        itemCount: _properties.length,
                        itemBuilder: (context, index) {
                          final property = _properties[index];
                          return Dismissible(
                            key: Key(property["id"].toString()),
                            background: _buildSwipeBackground(isLeft: false),
                            secondaryBackground:
                                _buildSwipeBackground(isLeft: true),
                            onDismissed: (direction) {
                              if (direction == DismissDirection.endToStart) {
                                _deleteProperty(index);
                              } else {
                                _showQuickActions(property);
                              }
                            },
                            child: PropertyCardWidget(
                              property: property,
                              onTap: () => _navigateToPropertyDetail(property),
                              onLongPress: () => _showContextMenu(property),
                            ),
                          );
                        },
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
            iconName: 'home',
            color: _selectedIndex == 0
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Properties',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'people',
            color: _selectedIndex == 1
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Leads',
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
      onPressed: _addNewProperty,
      backgroundColor: AppTheme.lightTheme.primaryColor,
      foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
      icon: CustomIconWidget(
        iconName: 'add',
        color: AppTheme.lightTheme.colorScheme.onPrimary,
        size: 24,
      ),
      label: Text(
        'Add Property',
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _buildSwipeBackground({required bool isLeft}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      decoration: BoxDecoration(
        color: isLeft ? AppTheme.accentLight : AppTheme.successLight,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: isLeft ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: isLeft ? 'delete' : 'edit',
            color: Colors.white,
            size: 28,
          ),
          SizedBox(height: 0.5.h),
          Text(
            isLeft ? 'Delete' : 'Quick Actions',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
              iconName: 'home_work',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 80,
            ),
            SizedBox(height: 3.h),
            Text(
              'No Properties Yet',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Add your first property to get started with managing your real estate portfolio.',
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 4.h),
            ElevatedButton.icon(
              onPressed: _addNewProperty,
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 20,
              ),
              label: Text('Add Your First Property'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Properties updated successfully'),
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
        // Already on Properties tab
        break;
      case 1:
        Navigator.pushNamed(context, '/lead-management');
        break;
      case 2:
        Navigator.pushNamed(context, '/task-management');
        break;
      case 3:
        Navigator.pushNamed(context, '/client-profile');
        break;
    }
  }

  void _navigateToPropertyDetail(Map<String, dynamic> property) {
    Navigator.pushNamed(context, '/property-detail', arguments: property);
  }

  void _addNewProperty() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Add Property feature coming soon'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _showQuickActions(Map<String, dynamic> property) {
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
              'Quick Actions',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            _buildQuickActionTile('Edit Property', 'edit', () {}),
            _buildQuickActionTile('Share Listing', 'share', () {}),
            _buildQuickActionTile('Mark as Sold', 'check_circle', () {}),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionTile(
      String title, String iconName, VoidCallback onTap) {
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

  void _showContextMenu(Map<String, dynamic> property) {
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
              'Property Options',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            _buildContextMenuItem('Duplicate Listing', 'content_copy', () {}),
            _buildContextMenuItem('Schedule Showing', 'event', () {}),
            _buildContextMenuItem('Add Photos', 'photo_camera', () {}),
            _buildContextMenuItem('View Analytics', 'analytics', () {}),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem(
      String title, String iconName, VoidCallback onTap) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
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

  void _deleteProperty(int index) {
    final property = _properties[index];
    setState(() {
      _properties.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Property "${property["title"]}" deleted'),
        backgroundColor: AppTheme.accentLight,
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _properties.insert(index, property);
            });
          },
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
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
                'Filter Properties',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Property Status',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 1.h),
                      Wrap(
                        spacing: 2.w,
                        children: ['All', 'Active', 'Pending', 'Sold']
                            .map((status) => FilterChip(
                                  label: Text(status),
                                  selected: status == 'Active',
                                  onSelected: (selected) {},
                                ))
                            .toList(),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'Property Type',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 1.h),
                      Wrap(
                        spacing: 2.w,
                        children:
                            ['House', 'Condo', 'Studio', 'Villa', 'Penthouse']
                                .map((type) => FilterChip(
                                      label: Text(type),
                                      selected: false,
                                      onSelected: (selected) {},
                                    ))
                                .toList(),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Clear All'),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Apply Filters'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _removeFilter(int index) {
    setState(() {
      _activeFilters.removeAt(index);
    });
  }
}
