import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PropertyMapWidget extends StatelessWidget {
  final List<Map<String, dynamic>> properties;
  final Function(Map<String, dynamic>) onPropertyTap;

  const PropertyMapWidget({
    super.key,
    required this.properties,
    required this.onPropertyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surfaceContainerLow,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Stack(
        children: [
          // Map placeholder (would integrate with actual map service)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.lightTheme.colorScheme.primaryContainer,
                  AppTheme.lightTheme.colorScheme.secondaryContainer,
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'map',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 64,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Map View',
                    style: AppTheme.lightTheme.textTheme.headlineSmall,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Interactive map with property pins would appear here',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Property pins simulation
          ...properties.asMap().entries.map((entry) {
            final index = entry.key;
            final property = entry.value;

            // Simulate pin positions
            final left = (20 + (index * 15) % 60).toDouble();
            final top = (30 + (index * 20) % 40).toDouble();

            return Positioned(
              left: left.w,
              top: top.h,
              child: GestureDetector(
                onTap: () => onPropertyTap(property),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: 1.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightTheme.colorScheme.shadow,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    property["price"] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }),

          // Map controls
          Positioned(
            top: 2.h,
            right: 4.w,
            child: Column(
              children: [
                _buildMapControl(
                  icon: 'add',
                  onTap: () {},
                ),
                SizedBox(height: 1.h),
                _buildMapControl(
                  icon: 'remove',
                  onTap: () {},
                ),
                SizedBox(height: 2.h),
                _buildMapControl(
                  icon: 'my_location',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapControl({
    required String icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 12.w,
        height: 6.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: icon,
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ),
    );
  }
}
