import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentSearchWidget extends StatelessWidget {
  final List<String> searches;
  final Function(String) onSearchTap;

  const RecentSearchWidget({
    super.key,
    required this.searches,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Recent Searches',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 5.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: searches.length,
            itemBuilder: (context, index) {
              final search = searches[index];
              return Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: ActionChip(
                  label: Text(
                    search,
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                  onPressed: () => onSearchTap(search),
                  backgroundColor:
                      AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                  side: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    width: 0.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  avatar: CustomIconWidget(
                    iconName: 'history',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
