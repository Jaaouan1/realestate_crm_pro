import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
        ),
      ),
      backgroundColor: AppTheme.lightTheme.colorScheme.primaryContainer,
      deleteIcon: CustomIconWidget(
        iconName: 'close',
        color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
        size: 16,
      ),
      onDeleted: onRemove,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
