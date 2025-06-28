import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_note_dialog_widget.dart';
import './widgets/client_header_widget.dart';
import './widgets/contact_info_widget.dart';
import './widgets/documents_section_widget.dart';
import './widgets/family_details_widget.dart';
import './widgets/interaction_history_widget.dart';
import './widgets/property_preferences_widget.dart';
import './widgets/quick_actions_sheet_widget.dart';

// lib/presentation/client_profile/client_profile.dart

class ClientProfile extends StatefulWidget {
  const ClientProfile({super.key});

  @override
  State<ClientProfile> createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile> {
  final ScrollController _scrollController = ScrollController();
  bool _isEditMode = false;
  bool _isOfflineMode = false;

  // Mock client data
  final Map<String, dynamic> _clientData = {
    "id": "1",
    "name": "Sarah Johnson",
    "email": "sarah.johnson@email.com",
    "phone": "+1 (555) 123-4567",
    "secondaryPhone": "+1 (555) 987-6543",
    "avatar":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=600",
    "address": {
      "street": "123 Main Street",
      "city": "San Francisco",
      "state": "CA",
      "zipCode": "94102",
      "country": "USA"
    },
    "preferences": {
      "budget": {"min": 450000, "max": 550000},
      "propertyType": "Condo",
      "bedrooms": 3,
      "bathrooms": 2,
      "location": "Downtown",
      "amenities": ["Parking", "Gym", "Pool", "Balcony"],
      "notes": "Looking for move-in ready property with parking"
    },
    "interactions": [
      {
        "id": "1",
        "type": "call",
        "date": "2024-01-15T10:30:00Z",
        "duration": "15 min",
        "outcome": "Discussed budget requirements",
        "notes": "Client confirmed budget range and timeline"
      },
      {
        "id": "2",
        "type": "email",
        "date": "2024-01-14T14:20:00Z",
        "subject": "Property Listings",
        "outcome": "Sent 5 property listings",
        "notes": "Client interested in 2 properties"
      },
      {
        "id": "3",
        "type": "showing",
        "date": "2024-01-12T16:00:00Z",
        "property": "Downtown Condo",
        "outcome": "Positive feedback",
        "notes": "Loved the location but concerned about parking"
      }
    ],
    "documents": [
      {
        "id": "1",
        "name": "Pre-approval Letter",
        "type": "PDF",
        "date": "2024-01-10",
        "status": "Approved",
        "url": "document_url_1"
      },
      {
        "id": "2",
        "name": "Purchase Agreement",
        "type": "PDF",
        "date": "2024-01-13",
        "status": "Pending Signature",
        "url": "document_url_2"
      }
    ],
    "family": {
      "spouse": "Michael Johnson",
      "children": [
        {"name": "Emma", "age": 8},
        {"name": "Jake", "age": 5}
      ],
      "pets": [
        {"name": "Buddy", "type": "Dog"}
      ]
    },
    "tags": ["First-time Buyer", "Pre-approved", "High Priority"],
    "source": "Website",
    "agent": "John Smith",
    "createdDate": "2024-01-01T00:00:00Z",
    "lastContact": "2024-01-15T10:30:00Z"
  };

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _checkConnectivity() async {
    // Check connectivity status
    setState(() {
      _isOfflineMode = false; // Implement actual connectivity check
    });
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  void _showQuickActions() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => QuickActionsSheetWidget(
            clientData: _clientData,
            onAction: (action) {
              Navigator.pop(context);
              _handleQuickAction(action);
            }));
  }

  void _handleQuickAction(String action) {
    switch (action) {
      case 'duplicate':
        _duplicateContact();
        break;
      case 'merge':
        _mergeContacts();
        break;
      case 'export':
        _exportVCard();
        break;
      case 'archive':
        _archiveClient();
        break;
    }
  }

  void _duplicateContact() {
    // Implement duplicate contact functionality
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contact duplicated successfully')));
  }

  void _mergeContacts() {
    // Implement merge contacts functionality
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Contact merge initiated')));
  }

  void _exportVCard() {
    // Implement vCard export functionality
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('vCard exported successfully')));
  }

  void _archiveClient() {
    // Implement archive client functionality
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Archive Client'),
                content: Text('Are you sure you want to archive this client?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Client archived successfully')));
                      },
                      child: Text('Archive')),
                ]));
  }

  void _showAddNoteDialog() {
    showDialog(
        context: context,
        builder: (context) => AddNoteDialogWidget(onSave: (note) {
              setState(() {
                _clientData['interactions'].insert(0, {
                  "id": DateTime.now().millisecondsSinceEpoch.toString(),
                  "type": "note",
                  "date": DateTime.now().toIso8601String(),
                  "outcome": "Note added",
                  "notes": note
                });
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Note added successfully')));
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: SafeArea(
            child: Column(children: [
          // Header with client photo and quick actions
          ClientHeaderWidget(
              clientData: _clientData,
              isEditMode: _isEditMode,
              isOfflineMode: _isOfflineMode,
              onEditToggle: _toggleEditMode,
              onCall: () => _makeCall(_clientData['phone']),
              onText: () => _sendText(_clientData['phone']),
              onEmail: () => _sendEmail(_clientData['email'])),

          // Scrollable content
          Expanded(
              child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(children: [
                    SizedBox(height: 2.h),

                    // Contact Information
                    ContactInfoWidget(
                        clientData: _clientData,
                        isEditMode: _isEditMode,
                        onUpdate: (updatedData) {
                          setState(() {
                            _clientData.addAll(updatedData);
                          });
                        }),

                    SizedBox(height: 2.h),

                    // Property Preferences
                    PropertyPreferencesWidget(
                        preferences: _clientData['preferences'],
                        isEditMode: _isEditMode,
                        onUpdate: (updatedPreferences) {
                          setState(() {
                            _clientData['preferences'] = updatedPreferences;
                          });
                        }),

                    SizedBox(height: 2.h),

                    // Interaction History
                    InteractionHistoryWidget(
                        interactions: _clientData['interactions'],
                        onEdit: (interaction) {
                          // Handle edit interaction
                        },
                        onDelete: (interactionId) {
                          setState(() {
                            _clientData['interactions'].removeWhere(
                                (interaction) =>
                                    interaction['id'] == interactionId);
                          });
                        }),

                    SizedBox(height: 2.h),

                    // Documents Section
                    DocumentsSectionWidget(
                        documents: _clientData['documents'],
                        onViewDocument: (document) {
                          // Handle document viewing
                        },
                        onSignDocument: (document) {
                          // Handle digital signature
                        }),

                    SizedBox(height: 2.h),

                    // Family Details
                    FamilyDetailsWidget(
                        familyData: _clientData['family'],
                        isEditMode: _isEditMode,
                        onUpdate: (updatedFamily) {
                          setState(() {
                            _clientData['family'] = updatedFamily;
                          });
                        }),

                    SizedBox(height: 2.h),

                    // Secondary Actions
                    _buildSecondaryActions(),

                    SizedBox(height: 10.h), // Space for FAB
                  ]))),
        ])),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: _showAddNoteDialog,
            icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 24),
            label: Text('Add Note',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary)),
            backgroundColor: AppTheme.lightTheme.primaryColor));
  }

  Widget _buildSecondaryActions() {
    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderLight, width: 1)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Quick Actions',
              style: AppTheme.lightTheme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 2.h),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                _buildActionButton('Schedule Showing', 'event',
                    AppTheme.lightTheme.primaryColor, () => _scheduleShowing()),
                SizedBox(width: 3.w),
                _buildActionButton('Send Listings', 'home',
                    AppTheme.successLight, () => _sendListings()),
                SizedBox(width: 3.w),
                _buildActionButton('Add to Campaign', 'campaign',
                    AppTheme.warningLight, () => _addToCampaign()),
                SizedBox(width: 3.w),
                _buildActionButton(
                    'Generate Report',
                    'assessment',
                    AppTheme.lightTheme.colorScheme.secondary,
                    () => _generateReport()),
                SizedBox(width: 3.w),
                _buildActionButton('More Actions', 'more_horiz',
                    AppTheme.textSecondaryLight, _showQuickActions),
              ])),
        ]));
  }

  Widget _buildActionButton(
      String label, String iconName, Color color, VoidCallback onTap) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border:
                    Border.all(color: color.withValues(alpha: 0.3), width: 1)),
            child: Column(children: [
              CustomIconWidget(iconName: iconName, color: color, size: 24),
              SizedBox(height: 1.h),
              Text(label,
                  style: AppTheme.lightTheme.textTheme.labelMedium
                      ?.copyWith(color: color, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center),
            ])));
  }

  void _makeCall(String phoneNumber) {
    // Implement phone call functionality
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Calling $phoneNumber')));
  }

  void _sendText(String phoneNumber) {
    // Implement text message functionality
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Opening messages for $phoneNumber')));
  }

  void _sendEmail(String email) {
    // Implement email functionality
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Opening email for $email')));
  }

  void _scheduleShowing() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Opening schedule showing')));
  }

  void _sendListings() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Opening send listings')));
  }

  void _addToCampaign() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Adding to campaign')));
  }

  void _generateReport() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Generating client report')));
  }
}
