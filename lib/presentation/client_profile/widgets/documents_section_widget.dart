import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

// lib/presentation/client_profile/widgets/documents_section_widget.dart

class DocumentsSectionWidget extends StatefulWidget {
  final List<Map<String, dynamic>> documents;
  final Function(Map<String, dynamic>) onViewDocument;
  final Function(Map<String, dynamic>) onSignDocument;

  const DocumentsSectionWidget({
    super.key,
    required this.documents,
    required this.onViewDocument,
    required this.onSignDocument,
  });

  @override
  State<DocumentsSectionWidget> createState() => _DocumentsSectionWidgetState();
}

class _DocumentsSectionWidgetState extends State<DocumentsSectionWidget> {
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
                    iconName: 'folder',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Documents',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${widget.documents.length}',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  CustomIconWidget(
                    iconName: _isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.textSecondaryLight,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),

          // Documents list
          if (_isExpanded)
            Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  // Quick actions
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionButton(
                          'Upload Document',
                          'upload_file',
                          AppTheme.lightTheme.primaryColor,
                          () => _uploadDocument(),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: _buildQuickActionButton(
                          'Scan Document',
                          'document_scanner',
                          AppTheme.successLight,
                          () => _scanDocument(),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Documents list
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.documents.length,
                    separatorBuilder: (context, index) => SizedBox(height: 2.h),
                    itemBuilder: (context, index) {
                      final document = widget.documents[index];
                      return _buildDocumentCard(document);
                    },
                  ),
                ],
              ),
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
          borderRadius: BorderRadius.circular(8),
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
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentCard(Map<String, dynamic> document) {
    final status = document['status'] as String;
    final isPendingSignature = status == 'Pending Signature';

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isPendingSignature
              ? AppTheme.warningLight.withValues(alpha: 0.5)
              : AppTheme.borderLight,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Document icon
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: _getDocumentColor(document['type'] as String)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: _getDocumentIcon(document['type'] as String),
              color: _getDocumentColor(document['type'] as String),
              size: 24,
            ),
          ),

          SizedBox(width: 3.w),

          // Document details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document['name'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    Text(
                      document['date'] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: _getStatusColor(status),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Actions
          PopupMenuButton<String>(
            onSelected: (value) => _handleDocumentAction(value, document),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'view',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'visibility',
                      color: AppTheme.textSecondaryLight,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text('View'),
                  ],
                ),
              ),
              if (isPendingSignature)
                PopupMenuItem(
                  value: 'sign',
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'edit',
                        color: AppTheme.warningLight,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text('Sign Document'),
                    ],
                  ),
                ),
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
                    Text('Share'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'download',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'download',
                      color: AppTheme.textSecondaryLight,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text('Download'),
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
                      'Delete',
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
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDocumentColor(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return AppTheme.lightTheme.colorScheme.error;
      case 'doc':
      case 'docx':
        return AppTheme.lightTheme.primaryColor;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return AppTheme.successLight;
      default:
        return AppTheme.textSecondaryLight;
    }
  }

  String _getDocumentIcon(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return 'picture_as_pdf';
      case 'doc':
      case 'docx':
        return 'description';
      case 'jpg':
      case 'jpeg':
      case 'png':
        return 'image';
      default:
        return 'insert_drive_file';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return AppTheme.successLight;
      case 'Pending Signature':
        return AppTheme.warningLight;
      case 'Rejected':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.textSecondaryLight;
    }
  }

  void _handleDocumentAction(String action, Map<String, dynamic> document) {
    switch (action) {
      case 'view':
        widget.onViewDocument(document);
        break;
      case 'sign':
        widget.onSignDocument(document);
        break;
      case 'share':
        _shareDocument(document);
        break;
      case 'download':
        _downloadDocument(document);
        break;
      case 'delete':
        _deleteDocument(document);
        break;
    }
  }

  void _uploadDocument() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening document picker...')),
    );
  }

  void _scanDocument() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening document scanner...')),
    );
  }

  void _shareDocument(Map<String, dynamic> document) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing ${document['name']}')),
    );
  }

  void _downloadDocument(Map<String, dynamic> document) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading ${document['name']}')),
    );
  }

  void _deleteDocument(Map<String, dynamic> document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Document'),
        content: Text('Are you sure you want to delete "${document['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Document deleted')),
              );
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
