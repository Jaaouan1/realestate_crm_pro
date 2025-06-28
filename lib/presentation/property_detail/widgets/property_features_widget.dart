import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PropertyFeaturesWidget extends StatefulWidget {
  final List<String> features;
  final bool isEditMode;

  const PropertyFeaturesWidget({
    super.key,
    required this.features,
    required this.isEditMode,
  });

  @override
  State<PropertyFeaturesWidget> createState() => _PropertyFeaturesWidgetState();
}

class _PropertyFeaturesWidgetState extends State<PropertyFeaturesWidget> {
  bool _isExpanded = false;
  late List<String> _editableFeatures;

  @override
  void initState() {
    super.initState();
    _editableFeatures = List.from(widget.features);
  }

  @override
  Widget build(BuildContext context) {
    final displayFeatures = _isExpanded || widget.isEditMode
        ? _editableFeatures
        : _editableFeatures.take(6).toList();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Features & Amenities',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (!widget.isEditMode && _editableFeatures.length > 6)
                GestureDetector(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: CustomIconWidget(
                    iconName: _isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          if (widget.isEditMode) ...[
            _buildEditableFeatures(),
          ] else ...[
            _buildFeatureGrid(displayFeatures),
            if (!_isExpanded && _editableFeatures.length > 6) ...[
              SizedBox(height: 2.h),
              GestureDetector(
                onTap: () => setState(() => _isExpanded = true),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Show ${_editableFeatures.length - 6} more features',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    CustomIconWidget(
                      iconName: 'keyboard_arrow_down',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildFeatureGrid(List<String> features) {
    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: features.map((feature) => _buildFeatureChip(feature)).toList(),
    );
  }

  Widget _buildFeatureChip(String feature) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'check_circle',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 16,
          ),
          SizedBox(width: 1.w),
          Text(
            feature,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableFeatures() {
    return Column(
      children: [
        ..._editableFeatures.asMap().entries.map((entry) {
          final index = entry.key;
          final feature = entry.value;
          return Container(
            margin: EdgeInsets.only(bottom: 1.h),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: feature),
                    decoration: InputDecoration(
                      hintText: 'Enter feature...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _editableFeatures[index] = value;
                      });
                    },
                  ),
                ),
                SizedBox(width: 2.w),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _editableFeatures.removeAt(index);
                    });
                  },
                  icon: CustomIconWidget(
                    iconName: 'remove_circle',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 24,
                  ),
                ),
              ],
            ),
          );
        }),
        SizedBox(height: 1.h),
        OutlinedButton.icon(
          onPressed: () {
            setState(() {
              _editableFeatures.add('');
            });
          },
          icon: CustomIconWidget(
            iconName: 'add',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 20,
          ),
          label: const Text('Add Feature'),
        ),
      ],
    );
  }
}
