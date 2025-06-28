import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

// lib/presentation/client_profile/widgets/family_details_widget.dart

class FamilyDetailsWidget extends StatefulWidget {
  final Map<String, dynamic> familyData;
  final bool isEditMode;
  final Function(Map<String, dynamic>) onUpdate;

  const FamilyDetailsWidget({
    super.key,
    required this.familyData,
    required this.isEditMode,
    required this.onUpdate,
  });

  @override
  State<FamilyDetailsWidget> createState() => _FamilyDetailsWidgetState();
}

class _FamilyDetailsWidgetState extends State<FamilyDetailsWidget> {
  bool _isExpanded = false;

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
                    iconName: 'family_restroom',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Family Details',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (_hasFamily())
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.successLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getFamilyCount(),
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.successLight,
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

          // Content
          if (_isExpanded)
            Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Spouse
                  if (widget.familyData['spouse'] != null)
                    _buildFamilyMemberCard(
                      'Spouse',
                      widget.familyData['spouse'] as String,
                      'favorite',
                      AppTheme.lightTheme.colorScheme.error,
                    ),

                  SizedBox(height: 2.h),

                  // Children
                  if (widget.familyData['children'] != null &&
                      (widget.familyData['children'] as List).isNotEmpty)
                    _buildChildrenSection(),

                  SizedBox(height: 2.h),

                  // Pets
                  if (widget.familyData['pets'] != null &&
                      (widget.familyData['pets'] as List).isNotEmpty)
                    _buildPetsSection(),

                  SizedBox(height: 2.h),

                  // Add family member button
                  if (widget.isEditMode) _buildAddFamilyMemberButton(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFamilyMemberCard(
    String role,
    String name,
    String iconName,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  name,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (widget.isEditMode)
            IconButton(
              onPressed: () => _editFamilyMember(role, name),
              icon: CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.textSecondaryLight,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChildrenSection() {
    final children =
        widget.familyData['children'] as List<Map<String, dynamic>>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'child_care',
              color: AppTheme.successLight,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Children',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: children.length,
          separatorBuilder: (context, index) => SizedBox(height: 1.h),
          itemBuilder: (context, index) {
            final child = children[index];
            return Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.successLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.successLight.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: AppTheme.successLight.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'child_friendly',
                      color: AppTheme.successLight,
                      size: 16,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          child['name'] as String,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${child['age']} years old',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.isEditMode)
                    IconButton(
                      onPressed: () => _editChild(child),
                      icon: CustomIconWidget(
                        iconName: 'edit',
                        color: AppTheme.textSecondaryLight,
                        size: 16,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPetsSection() {
    final pets = widget.familyData['pets'] as List<Map<String, dynamic>>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'pets',
              color: AppTheme.warningLight,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Pets',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: pets.length,
          separatorBuilder: (context, index) => SizedBox(height: 1.h),
          itemBuilder: (context, index) {
            final pet = pets[index];
            return Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.warningLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.warningLight.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: AppTheme.warningLight.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: _getPetIcon(pet['type'] as String),
                      color: AppTheme.warningLight,
                      size: 16,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pet['name'] as String,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          pet['type'] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.isEditMode)
                    IconButton(
                      onPressed: () => _editPet(pet),
                      icon: CustomIconWidget(
                        iconName: 'edit',
                        color: AppTheme.textSecondaryLight,
                        size: 16,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAddFamilyMemberButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      child: InkWell(
        onTap: () => _showAddFamilyMemberDialog(),
        borderRadius: BorderRadius.circular(8),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: 'add',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            SizedBox(height: 1.h),
            Text(
              'Add Family Member',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _hasFamily() {
    return widget.familyData['spouse'] != null ||
        (widget.familyData['children'] != null &&
            (widget.familyData['children'] as List).isNotEmpty) ||
        (widget.familyData['pets'] != null &&
            (widget.familyData['pets'] as List).isNotEmpty);
  }

  String _getFamilyCount() {
    int count = 0;
    if (widget.familyData['spouse'] != null) count++;
    if (widget.familyData['children'] != null) {
      count += (widget.familyData['children'] as List).length;
    }
    if (widget.familyData['pets'] != null) {
      count += (widget.familyData['pets'] as List).length;
    }
    return '$count members';
  }

  String _getPetIcon(String petType) {
    switch (petType.toLowerCase()) {
      case 'dog':
        return 'pets';
      case 'cat':
        return 'pets';
      case 'bird':
        return 'pets';
      default:
        return 'pets';
    }
  }

  void _editFamilyMember(String role, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Editing $role: $name')),
    );
  }

  void _editChild(Map<String, dynamic> child) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Editing child: ${child['name']}')),
    );
  }

  void _editPet(Map<String, dynamic> pet) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Editing pet: ${pet['name']}')),
    );
  }

  void _showAddFamilyMemberDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Family Member'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'favorite',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 24,
              ),
              title: Text('Add Spouse'),
              onTap: () {
                Navigator.pop(context);
                _addSpouse();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'child_care',
                color: AppTheme.successLight,
                size: 24,
              ),
              title: Text('Add Child'),
              onTap: () {
                Navigator.pop(context);
                _addChild();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'pets',
                color: AppTheme.warningLight,
                size: 24,
              ),
              title: Text('Add Pet'),
              onTap: () {
                Navigator.pop(context);
                _addPet();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _addSpouse() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Adding spouse...')),
    );
  }

  void _addChild() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Adding child...')),
    );
  }

  void _addPet() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Adding pet...')),
    );
  }
}
