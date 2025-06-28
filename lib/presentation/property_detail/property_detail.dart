import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/property_actions_widget.dart';
import './widgets/property_activity_widget.dart';
import './widgets/property_description_widget.dart';
import './widgets/property_features_widget.dart';
import './widgets/property_image_carousel_widget.dart';
import './widgets/property_info_card_widget.dart';
import './widgets/property_location_widget.dart';
import './widgets/schedule_showing_button_widget.dart';

class PropertyDetail extends StatefulWidget {
  const PropertyDetail({super.key});

  @override
  State<PropertyDetail> createState() => _PropertyDetailState();
}

class _PropertyDetailState extends State<PropertyDetail> {
  final ScrollController _scrollController = ScrollController();
  bool _isEditMode = false;

  // Mock property data
  final Map<String, dynamic> propertyData = {
    "id": 1,
    "title": "Modern Luxury Villa",
    "price": "\$850,000",
    "address": "1234 Sunset Boulevard, Beverly Hills, CA 90210",
    "bedrooms": 4,
    "bathrooms": 3,
    "squareFootage": 2800,
    "lotSize": "0.5 acres",
    "propertyType": "Single Family Home",
    "yearBuilt": 2018,
    "status": "For Sale",
    "description":
        """This stunning modern villa offers the perfect blend of luxury and comfort. 
    Featuring an open-concept design with floor-to-ceiling windows that flood the space with natural light. 
    The gourmet kitchen boasts premium appliances and a large island perfect for entertaining. 
    Master suite includes a walk-in closet and spa-like bathroom with soaking tub.""",
    "features": [
      "Hardwood Floors",
      "Granite Countertops",
      "Stainless Steel Appliances",
      "Walk-in Closets",
      "Central Air Conditioning",
      "Swimming Pool",
      "2-Car Garage",
      "Security System",
      "Garden/Landscaping",
      "Fireplace"
    ],
    "images": [
      "https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800&h=600&fit=crop",
      "https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=800&h=600&fit=crop",
      "https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?w=800&h=600&fit=crop",
      "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800&h=600&fit=crop",
      "https://images.unsplash.com/photo-1600607687644-aac4c3eac7f4?w=800&h=600&fit=crop"
    ],
    "agent": {
      "name": "Sarah Johnson",
      "phone": "+1 (555) 123-4567",
      "email": "sarah.johnson@realestate.com",
      "avatar":
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop"
    },
    "location": {
      "latitude": 34.0736,
      "longitude": -118.4004,
      "neighborhood": "Beverly Hills",
      "walkScore": 85,
      "transitScore": 72
    },
    "recentActivity": [
      {
        "date": "2024-01-15",
        "activity": "Price reduced by \$25,000",
        "type": "price_change"
      },
      {
        "date": "2024-01-10",
        "activity": "New photos added",
        "type": "media_update"
      },
      {
        "date": "2024-01-05",
        "activity": "Property listed",
        "type": "listing_created"
      }
    ],
    "nearbyAmenities": [
      {
        "name": "Whole Foods Market",
        "distance": "0.3 miles",
        "type": "grocery"
      },
      {
        "name": "Beverly Hills High School",
        "distance": "0.8 miles",
        "type": "school"
      },
      {"name": "Rodeo Drive", "distance": "1.2 miles", "type": "shopping"},
      {"name": "Beverly Gardens Park", "distance": "0.5 miles", "type": "park"}
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PropertyImageCarouselWidget(
                      images: (propertyData["images"] as List).cast<String>(),
                      onImageTap: _showFullScreenGallery,
                    ),
                    SizedBox(height: 2.h),
                    PropertyInfoCardWidget(
                      propertyData: propertyData,
                      isEditMode: _isEditMode,
                      onEditToggle: () =>
                          setState(() => _isEditMode = !_isEditMode),
                    ),
                    SizedBox(height: 2.h),
                    PropertyDescriptionWidget(
                      description: propertyData["description"] as String,
                      isEditMode: _isEditMode,
                    ),
                    SizedBox(height: 2.h),
                    PropertyFeaturesWidget(
                      features:
                          (propertyData["features"] as List).cast<String>(),
                      isEditMode: _isEditMode,
                    ),
                    SizedBox(height: 2.h),
                    PropertyLocationWidget(
                      locationData:
                          propertyData["location"] as Map<String, dynamic>,
                      address: propertyData["address"] as String,
                      nearbyAmenities: (propertyData["nearbyAmenities"] as List)
                          .cast<Map<String, dynamic>>(),
                    ),
                    SizedBox(height: 2.h),
                    PropertyActivityWidget(
                      activities: (propertyData["recentActivity"] as List)
                          .cast<Map<String, dynamic>>(),
                    ),
                    SizedBox(height: 2.h),
                    PropertyActionsWidget(
                      agentData: propertyData["agent"] as Map<String, dynamic>,
                      onCallOwner: _callOwner,
                      onSendBrochure: _sendBrochure,
                      onAddToFavorites: _addToFavorites,
                      onCalculateMortgage: _calculateMortgage,
                      onShowQuickActions: _showQuickActions,
                    ),
                    SizedBox(height: 10.h), // Space for sticky button
                  ],
                ),
              ),
            ],
          ),
          _buildStickyScheduleButton(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      backgroundColor:
          AppTheme.lightTheme.scaffoldBackgroundColor.withValues(alpha: 0.95),
      elevation: 0,
      leading: Container(
        margin: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.shadowLight,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: _shareProperty,
            icon: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStickyScheduleButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: ScheduleShowingButtonWidget(
            onScheduleShowing: _scheduleShowing,
          ),
        ),
      ),
    );
  }

  void _showFullScreenGallery(int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _FullScreenGallery(
          images: (propertyData["images"] as List).cast<String>(),
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  void _shareProperty() {
    // Implement property sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Property shared successfully')),
    );
  }

  void _scheduleShowing() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ScheduleShowingBottomSheet(),
    );
  }

  void _callOwner() {
    // Implement call functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Calling owner...')),
    );
  }

  void _sendBrochure() {
    // Implement send brochure functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Brochure sent successfully')),
    );
  }

  void _addToFavorites() {
    // Implement add to favorites functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to favorites')),
    );
  }

  void _calculateMortgage() {
    // Implement mortgage calculator
    showDialog(
      context: context,
      builder: (context) => _MortgageCalculatorDialog(),
    );
  }

  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _QuickActionsBottomSheet(),
    );
  }
}

class _FullScreenGallery extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const _FullScreenGallery({
    required this.images,
    required this.initialIndex,
  });

  @override
  State<_FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<_FullScreenGallery> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'close',
            color: Colors.white,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Implement share image functionality
            },
            icon: CustomIconWidget(
              iconName: 'share',
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return InteractiveViewer(
                child: Center(
                  child: CustomImageWidget(
                    imageUrl: widget.images[index],
                    width: 100.w,
                    height: 100.h,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 4.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_currentIndex + 1} / ${widget.images.length}',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleShowingBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Schedule Showing',
              style: AppTheme.lightTheme.textTheme.headlineSmall,
            ),
            SizedBox(height: 2.h),
            Text(
              'Select your preferred date and time',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 3.h),
            // Date picker would go here
            Container(
              width: double.infinity,
              height: 6.h,
              decoration: BoxDecoration(
                border:
                    Border.all(color: AppTheme.lightTheme.colorScheme.outline),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Select Date',
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            // Time picker would go here
            Container(
              width: double.infinity,
              height: 6.h,
              decoration: BoxDecoration(
                border:
                    Border.all(color: AppTheme.lightTheme.colorScheme.outline),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Select Time',
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Showing scheduled successfully')),
                  );
                },
                child: const Text('Schedule Showing'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MortgageCalculatorDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Mortgage Calculator'),
      content: SizedBox(
        width: 80.w,
        height: 40.h,
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Loan Amount',
                prefixText: '\$ ',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Interest Rate (%)',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Loan Term (years)',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 3.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    'Estimated Monthly Payment',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    '\$3,247',
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Calculation saved')),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _QuickActionsBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Quick Actions',
              style: AppTheme.lightTheme.textTheme.headlineSmall,
            ),
            SizedBox(height: 3.h),
            _buildQuickActionItem(
              context,
              'Duplicate Listing',
              'content_copy',
              () => Navigator.pop(context),
            ),
            _buildQuickActionItem(
              context,
              'Change Status',
              'edit',
              () => Navigator.pop(context),
            ),
            _buildQuickActionItem(
              context,
              'Archive Property',
              'archive',
              () => Navigator.pop(context),
            ),
            _buildQuickActionItem(
              context,
              'Generate Report',
              'description',
              () => Navigator.pop(context),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem(
    BuildContext context,
    String title,
    String iconName,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
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
}
