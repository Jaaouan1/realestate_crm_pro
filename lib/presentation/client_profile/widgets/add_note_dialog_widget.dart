import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

// lib/presentation/client_profile/widgets/add_note_dialog_widget.dart

class AddNoteDialogWidget extends StatefulWidget {
  final Function(String) onSave;

  const AddNoteDialogWidget({
    super.key,
    required this.onSave,
  });

  @override
  State<AddNoteDialogWidget> createState() => _AddNoteDialogWidgetState();
}

class _AddNoteDialogWidgetState extends State<AddNoteDialogWidget> {
  final TextEditingController _noteController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isVoiceRecording = false;
  String _selectedNoteType = 'General';

  final List<String> _noteTypes = [
    'General',
    'Property Interest',
    'Budget Discussion',
    'Showing Feedback',
    'Follow-up Required',
    'Personal Note',
  ];

  @override
  void initState() {
    super.initState();
    // Auto-focus on the text field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 90.w,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'note_add',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Add Note',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.textSecondaryLight,
                    size: 20,
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Note type selector
            Text(
              'Note Type',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.borderLight,
                  width: 1,
                ),
              ),
              child: DropdownButton<String>(
                value: _selectedNoteType,
                isExpanded: true,
                underline: SizedBox(),
                onChanged: (value) {
                  setState(() {
                    _selectedNoteType = value!;
                  });
                },
                items: _noteTypes
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(
                            type,
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                        ))
                    .toList(),
              ),
            ),

            SizedBox(height: 2.h),

            // Note input
            Text(
              'Note',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              constraints: BoxConstraints(
                minHeight: 20.h,
                maxHeight: 30.h,
              ),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.borderLight,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _noteController,
                focusNode: _focusNode,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'Enter your note here...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(3.w),
                ),
              ),
            ),

            SizedBox(height: 1.h),

            // Voice recording button
            Row(
              children: [
                GestureDetector(
                  onTap: _toggleVoiceRecording,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: _isVoiceRecording
                          ? AppTheme.lightTheme.colorScheme.error
                              .withValues(alpha: 0.1)
                          : AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _isVoiceRecording
                            ? AppTheme.lightTheme.colorScheme.error
                            : AppTheme.lightTheme.primaryColor,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: _isVoiceRecording ? 'stop' : 'mic',
                          color: _isVoiceRecording
                              ? AppTheme.lightTheme.colorScheme.error
                              : AppTheme.lightTheme.primaryColor,
                          size: 18,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          _isVoiceRecording
                              ? 'Stop Recording'
                              : 'Voice to Text',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: _isVoiceRecording
                                ? AppTheme.lightTheme.colorScheme.error
                                : AppTheme.lightTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  '${_noteController.text.length}/500',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveNote,
                    child: Text('Save Note'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _toggleVoiceRecording() {
    setState(() {
      _isVoiceRecording = !_isVoiceRecording;
    });

    if (_isVoiceRecording) {
      _startVoiceRecording();
    } else {
      _stopVoiceRecording();
    }
  }

  void _startVoiceRecording() {
    // Implement voice recording functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voice recording started...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
      ),
    );
  }

  void _stopVoiceRecording() {
    // Implement stop recording and convert to text
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voice recording stopped. Converting to text...'),
        backgroundColor: AppTheme.successLight,
      ),
    );

    // Simulate adding voice-to-text content
    if (_noteController.text.isEmpty) {
      _noteController.text = 'Voice note: ';
    } else {
      _noteController.text += ' [Voice input]';
    }
  }

  void _saveNote() {
    if (_noteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a note before saving'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
      return;
    }

    final noteText = '[$_selectedNoteType] ${_noteController.text.trim()}';
    widget.onSave(noteText);
  }
}
