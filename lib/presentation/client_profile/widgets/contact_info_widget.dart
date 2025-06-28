import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

// lib/presentation/client_profile/widgets/contact_info_widget.dart

class ContactInfoWidget extends StatelessWidget {
  final Map<String, dynamic> clientData;
  final bool isEditMode;
  final Function(Map<String, dynamic>) onUpdate;

  const ContactInfoWidget({
    super.key,
    required this.clientData,
    required this.isEditMode,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
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
                iconName: 'contact_page',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Contact Information',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Phone numbers
          _buildContactItem(
            context,
            'Phone',
            clientData['phone'] as String,
            'phone',
            () => _makeCall(context, clientData['phone'] as String),
          ),

          if (clientData['secondaryPhone'] != null)
            _buildContactItem(
              context,
              'Secondary Phone',
              clientData['secondaryPhone'] as String,
              'phone',
              () => _makeCall(context, clientData['secondaryPhone'] as String),
            ),

          // Email
          _buildContactItem(
            context,
            'Email',
            clientData['email'] as String,
            'email',
            () => _sendEmail(context, clientData['email'] as String),
          ),

          // Address
          if (clientData['address'] != null)
            _buildAddressItem(context, clientData['address']),

          // Additional info
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildInfoChip(
                  'Source',
                  clientData['source'] as String,
                  AppTheme.lightTheme.primaryColor,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildInfoChip(
                  'Agent',
                  clientData['agent'] as String,
                  AppTheme.successLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context,
    String label,
    String value,
    String iconName,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.primaryColor,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  value,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onTap,
            icon: CustomIconWidget(
              iconName: iconName == 'phone' ? 'call' : 'send',
              color: AppTheme.lightTheme.primaryColor,
              size: 20,
            ),
          ),
          IconButton(
            onPressed: () => _copyToClipboard(context, value),
            icon: CustomIconWidget(
              iconName: 'content_copy',
              color: AppTheme.textSecondaryLight,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressItem(BuildContext context, Map<String, dynamic> address) {
    final fullAddress =
        '${address['street']}, ${address['city']}, ${address['state']} ${address['zipCode']}';

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: 'location_on',
              color: AppTheme.lightTheme.primaryColor,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Address',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  fullAddress,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _openMaps(context, fullAddress),
            icon: CustomIconWidget(
              iconName: 'map',
              color: AppTheme.lightTheme.primaryColor,
              size: 20,
            ),
          ),
          IconButton(
            onPressed: () => _copyToClipboard(context, fullAddress),
            icon: CustomIconWidget(
              iconName: 'content_copy',
              color: AppTheme.textSecondaryLight,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
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
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 0.5.h),
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

  void _makeCall(BuildContext context, String phoneNumber) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Calling $phoneNumber')),
    );
  }

  void _sendEmail(BuildContext context, String email) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening email for $email')),
    );
  }

  void _openMaps(BuildContext context, String address) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening maps for $address')),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
