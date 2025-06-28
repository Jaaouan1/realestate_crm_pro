import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SharedLeadsListWidget extends StatelessWidget {
  SharedLeadsListWidget({super.key});

  final List<Map<String, dynamic>> _sharedLeads = [
    {
      "id": 1,
      "clientName": "Robert & Jennifer Thompson",
      "budget": "\$800K - \$1.2M",
      "status": "Hot Lead",
      "assignedTo": ["Sarah Johnson", "Michael Chen"],
      "handoffHistory": 2,
      "lastActivity": "2 hours ago",
      "propertyType": "Family Home",
      "location": "Westside",
      "leadSource": "Website Inquiry"
    },
    {
      "id": 2,
      "clientName": "Alexandra Martinez",
      "budget": "\$450K - \$600K",
      "status": "Warm Lead",
      "assignedTo": ["Emily Rodriguez", "Sarah Johnson"],
      "handoffHistory": 1,
      "lastActivity": "1 day ago",
      "propertyType": "Condo",
      "location": "Downtown",
      "leadSource": "Referral"
    },
    {
      "id": 3,
      "clientName": "Tech Solutions Inc.",
      "budget": "\$2M - \$5M",
      "status": "Commercial",
      "assignedTo": ["Michael Chen", "David Wilson"],
      "handoffHistory": 3,
      "lastActivity": "3 hours ago",
      "propertyType": "Office Space",
      "location": "Business District",
      "leadSource": "Cold Call"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      itemCount: _sharedLeads.length,
      itemBuilder: (context, index) {
        final lead = _sharedLeads[index];
        return _buildSharedLeadCard(lead, context);
      },
    );
  }

  Widget _buildSharedLeadCard(Map<String, dynamic> lead, BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
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
                    lead["clientName"],
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _buildStatusChip(lead["status"]),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'attach_money',
                  color: AppTheme.successLight,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  lead["budget"],
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.successLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 4.w),
                CustomIconWidget(
                  iconName: 'location_on',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  lead["location"],
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              '${lead["propertyType"]} • ${lead["leadSource"]}',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assigned Team Members',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Wrap(
                        spacing: 1.w,
                        children:
                            (lead["assignedTo"] as List<String>).map((name) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.primaryColor
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              name,
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'sync',
                          color: AppTheme.warningLight,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '${lead["handoffHistory"]} handoffs',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.warningLight,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      lead["lastActivity"],
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'hot lead':
        color = AppTheme.accentLight;
        break;
      case 'warm lead':
        color = AppTheme.warningLight;
        break;
      case 'commercial':
        color = AppTheme.primaryLight;
        break;
      default:
        color = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
