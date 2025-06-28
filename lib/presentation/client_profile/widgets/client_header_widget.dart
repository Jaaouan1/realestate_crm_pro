import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

// lib/presentation/client_profile/widgets/client_header_widget.dart

class ClientHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> clientData;
  final bool isEditMode;
  final bool isOfflineMode;
  final VoidCallback onEditToggle;
  final VoidCallback onCall;
  final VoidCallback onText;
  final VoidCallback onEmail;

  const ClientHeaderWidget({
    super.key,
    required this.clientData,
    required this.isEditMode,
    required this.isOfflineMode,
    required this.onEditToggle,
    required this.onCall,
    required this.onText,
    required this.onEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
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
      child: Column(
        children: [
          // Top bar with back button and actions
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.textPrimaryLight,
                  size: 24,
                ),
              ),
              Spacer(),
              if (isOfflineMode)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.warningLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'cloud_off',
                        color: AppTheme.warningLight,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Offline',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.warningLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(width: 2.w),
              IconButton(
                onPressed: onEditToggle,
                icon: CustomIconWidget(
                  iconName: isEditMode ? 'check' : 'edit',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'share':
                      _shareContact(context);
                      break;
                    case 'export':
                      _exportContact(context);
                      break;
                    case 'delete':
                      _deleteContact(context);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'share',
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'share',
                          color: AppTheme.textSecondaryLight,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text('Share Contact'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'export',
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'download',
                          color: AppTheme.textSecondaryLight,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text('Export vCard'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'delete',
                          color: AppTheme.lightTheme.colorScheme.error,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Delete Contact',
                          style: TextStyle(
                            color: AppTheme.lightTheme.colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                child: CustomIconWidget(
                  iconName: 'more_vert',
                  color: AppTheme.textSecondaryLight,
                  size: 24,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Client photo and basic info
          Row(
            children: [
              // Client photo
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.lightTheme.primaryColor,
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl: clientData['avatar'] as String,
                    width: 20.w,
                    height: 20.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(width: 4.w),

              // Client details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clientData['name'] as String,
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      clientData['email'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      clientData['phone'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    // Tags
                    Wrap(
                      spacing: 1.w,
                      runSpacing: 0.5.h,
                      children: (clientData['tags'] as List<String>)
                          .map((tag) => Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                  vertical: 0.5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.primaryColor
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  tag,
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Quick action buttons (thumb-reachable zone)
          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  'Call',
                  'phone',
                  AppTheme.successLight,
                  onCall,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildQuickActionButton(
                  'Text',
                  'message',
                  AppTheme.lightTheme.primaryColor,
                  onText,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildQuickActionButton(
                  'Email',
                  'email',
                  AppTheme.warningLight,
                  onEmail,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    String label,
    String iconName,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 24,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareContact(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing contact...')),
    );
  }

  void _exportContact(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Exporting contact...')),
    );
  }

  void _deleteContact(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Contact'),
        content: Text('Are you sure you want to delete this contact?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
