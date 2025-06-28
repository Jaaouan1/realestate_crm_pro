import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/lead_card_widget.dart';
import './widgets/lead_filter_chips.dart';
import './widgets/pipeline_stage_tabs.dart';

class LeadManagement extends StatefulWidget {
  const LeadManagement({super.key});

  @override
  State<LeadManagement> createState() => _LeadManagementState();
}

class _LeadManagementState extends State<LeadManagement>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _pipelineController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedSort = 'Recent';
  String _selectedPipelineStage = 'New';
  bool _isMultiSelectMode = false;
  final Set<String> _selectedLeads = <String>{};

  // Mock data for leads
  final List<Map<String, dynamic>> _mockLeads = [
    {
      "id": "1",
      "name": "Sarah Johnson",
      "email": "sarah.johnson@email.com",
      "phone": "+1 (555) 123-4567",
      "avatar":
          "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=400",
      "propertyInterest": "3BR Condo Downtown",
      "lastContact": DateTime.now().subtract(Duration(hours: 2)),
      "priority": "High",
      "stage": "New",
      "source": "Website",
      "budget": "\$450,000 - \$550,000",
      "interactionCount": 5,
      "propertyType": "Condo",
      "notes": "Looking for move-in ready property with parking"
    },
    {
      "id": "2",
      "name": "Michael Chen",
      "email": "m.chen@email.com",
      "phone": "+1 (555) 234-5678",
      "avatar":
          "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400",
      "propertyInterest": "4BR House Suburbs",
      "lastContact": DateTime.now().subtract(Duration(days: 1)),
      "priority": "Medium",
      "stage": "Contacted",
      "source": "Referral",
      "budget": "\$650,000 - \$750,000",
      "interactionCount": 3,
      "propertyType": "House",
      "notes": "Family with two kids, needs good school district"
    },
    {
      "id": "3",
      "name": "Emma Rodriguez",
      "email": "emma.r@email.com",
      "phone": "+1 (555) 345-6789",
      "avatar":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "propertyInterest": "2BR Apartment City",
      "lastContact": DateTime.now().subtract(Duration(days: 3)),
      "priority": "Low",
      "stage": "Qualified",
      "source": "Walk-in",
      "budget": "\$300,000 - \$400,000",
      "interactionCount": 8,
      "propertyType": "Apartment",
      "notes": "First-time buyer, pre-approved for mortgage"
    },
    {
      "id": "4",
      "name": "David Thompson",
      "email": "d.thompson@email.com",
      "phone": "+1 (555) 456-7890",
      "avatar":
          "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=400",
      "propertyInterest": "Luxury Penthouse",
      "lastContact": DateTime.now().subtract(Duration(hours: 6)),
      "priority": "High",
      "stage": "Showing",
      "source": "Website",
      "budget": "\$1,200,000+",
      "interactionCount": 12,
      "propertyType": "Penthouse",
      "notes": "Investment property, cash buyer"
    },
    {
      "id": "5",
      "name": "Lisa Wang",
      "email": "lisa.wang@email.com",
      "phone": "+1 (555) 567-8901",
      "avatar":
          "https://images.pexels.com/photos/1181686/pexels-photo-1181686.jpeg?auto=compress&cs=tinysrgb&w=400",
      "propertyInterest": "Townhouse Waterfront",
      "lastContact": DateTime.now().subtract(Duration(days: 2)),
      "priority": "Medium",
      "stage": "Negotiating",
      "source": "Referral",
      "budget": "\$800,000 - \$950,000",
      "interactionCount": 15,
      "propertyType": "Townhouse",
      "notes": "Relocating for work, needs quick closing"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.index = 2; // Set Leads tab as active
    _pipelineController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pipelineController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredLeads {
    List<Map<String, dynamic>> filtered = List.from(_mockLeads);

    // Filter by pipeline stage
    if (_selectedPipelineStage != 'All') {
      filtered = filtered
          .where((lead) => (lead['stage'] as String) == _selectedPipelineStage)
          .toList();
    }

    // Filter by search query
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered
          .where((lead) =>
              (lead['name'] as String).toLowerCase().contains(query) ||
              (lead['propertyInterest'] as String)
                  .toLowerCase()
                  .contains(query))
          .toList();
    }

    // Sort leads
    switch (_selectedSort) {
      case 'Recent':
        filtered.sort((a, b) => (b['lastContact'] as DateTime)
            .compareTo(a['lastContact'] as DateTime));
        break;
      case 'Priority':
        final priorityOrder = {'High': 3, 'Medium': 2, 'Low': 1};
        filtered.sort((a, b) => (priorityOrder[b['priority']] ?? 0)
            .compareTo(priorityOrder[a['priority']] ?? 0));
        break;
      case 'Value':
        filtered.sort((a, b) => (b['interactionCount'] as int)
            .compareTo(a['interactionCount'] as int));
        break;
    }

    return filtered;
  }

  void _toggleMultiSelect() {
    setState(() {
      _isMultiSelectMode = !_isMultiSelectMode;
      if (!_isMultiSelectMode) {
        _selectedLeads.clear();
      }
    });
  }

  void _toggleLeadSelection(String leadId) {
    setState(() {
      if (_selectedLeads.contains(leadId)) {
        _selectedLeads.remove(leadId);
      } else {
        _selectedLeads.add(leadId);
      }
    });
  }

  void _showBulkActionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Bulk Actions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'person_add',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text('Assign to Team Member'),
              onTap: () {
                Navigator.pop(context);
                // Handle assign action
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'update',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text('Update Stage'),
              onTap: () {
                Navigator.pop(context);
                // Handle update stage action
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'campaign',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text('Send Campaign'),
              onTap: () {
                Navigator.pop(context);
                // Handle send campaign action
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

  Future<void> _refreshLeads() async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      // Refresh data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with search and sort
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
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
                  // Search bar and sort
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 6.h,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.borderLight,
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search leads...',
                              prefixIcon: CustomIconWidget(
                                iconName: 'search',
                                color: AppTheme.textSecondaryLight,
                                size: 20,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 4.w,
                                vertical: 1.5.h,
                              ),
                            ),
                            onChanged: (value) => setState(() {}),
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      PopupMenuButton<String>(
                        initialValue: _selectedSort,
                        onSelected: (value) {
                          setState(() {
                            _selectedSort = value;
                          });
                        },
                        child: Container(
                          height: 6.h,
                          width: 12.w,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.borderLight,
                              width: 1,
                            ),
                          ),
                          child: CustomIconWidget(
                            iconName: 'sort',
                            color: AppTheme.lightTheme.primaryColor,
                            size: 24,
                          ),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(value: 'Recent', child: Text('Recent')),
                          PopupMenuItem(
                              value: 'Priority', child: Text('Priority')),
                          PopupMenuItem(value: 'Value', child: Text('Value')),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  // Pipeline stage tabs
                  PipelineStageTabsWidget(
                    controller: _pipelineController,
                    onStageChanged: (stage) {
                      setState(() {
                        _selectedPipelineStage = stage;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Filter chips
            LeadFilterChipsWidget(
              onFilterChanged: () => setState(() {}),
            ),

            // Multi-select header
            if (_isMultiSelectMode)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                child: Row(
                  children: [
                    Text(
                      '${_selectedLeads.length} selected',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: _showBulkActionsDialog,
                      child: Text('Actions'),
                    ),
                    TextButton(
                      onPressed: _toggleMultiSelect,
                      child: Text('Cancel'),
                    ),
                  ],
                ),
              ),

            // Leads list
            Expanded(
              child: _filteredLeads.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _refreshLeads,
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        itemCount: _filteredLeads.length,
                        itemBuilder: (context, index) {
                          final lead = _filteredLeads[index];
                          return LeadCardWidget(
                            lead: lead,
                            isMultiSelectMode: _isMultiSelectMode,
                            isSelected: _selectedLeads.contains(lead['id']),
                            onTap: () {
                              if (_isMultiSelectMode) {
                                _toggleLeadSelection(lead['id'] as String);
                              } else {
                                Navigator.pushNamed(context, '/client-profile');
                              }
                            },
                            onLongPress: () {
                              if (!_isMultiSelectMode) {
                                _toggleMultiSelect();
                                _toggleLeadSelection(lead['id'] as String);
                              }
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),

      // Bottom navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Leads tab active
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        selectedItemColor: AppTheme.lightTheme.primaryColor,
        unselectedItemColor: AppTheme.textSecondaryLight,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: AppTheme.textSecondaryLight,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'dashboard',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: AppTheme.textSecondaryLight,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'home',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            label: 'Properties',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'people',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            label: 'Leads',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'task',
              color: AppTheme.textSecondaryLight,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'task',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.textSecondaryLight,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.textSecondaryLight,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            label: 'Search',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/property-dashboard');
              break;
            case 1:
              Navigator.pushNamed(context, '/property-detail');
              break;
            case 2:
              // Already on leads screen
              break;
            case 3:
              Navigator.pushNamed(context, '/task-management');
              break;
            case 4:
              Navigator.pushNamed(context, '/client-profile');
              break;
            case 5:
              Navigator.pushNamed(context, '/property-search');
              break;
          }
        },
      ),

      // Floating action button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddLeadDialog();
        },
        icon: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24,
        ),
        label: Text(
          'Add Lead',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'people_outline',
              color: AppTheme.textSecondaryLight,
              size: 80,
            ),
            SizedBox(height: 3.h),
            Text(
              'No Leads Found',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Start building your pipeline by adding new leads or adjusting your filters.',
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
            ),
            SizedBox(height: 4.h),
            ElevatedButton.icon(
              onPressed: () => _showAddLeadDialog(),
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 20,
              ),
              label: Text('Add Your First Lead'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddLeadDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Lead'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'person_add',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text('Manual Entry'),
              subtitle: Text('Enter lead details manually'),
              onTap: () {
                Navigator.pop(context);
                // Handle manual entry
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'contacts',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text('Import from Contacts'),
              subtitle: Text('Select from phone contacts'),
              onTap: () {
                Navigator.pop(context);
                // Handle contact import
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'qr_code_scanner',
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              title: Text('Scan Business Card'),
              subtitle: Text('Capture contact info from card'),
              onTap: () {
                Navigator.pop(context);
                // Handle business card scan
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
}
