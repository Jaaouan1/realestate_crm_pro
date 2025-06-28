import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/group_tasks_list_widget.dart';
import './widgets/shared_leads_list_widget.dart';
import './widgets/team_member_card_widget.dart';
import './widgets/team_messages_widget.dart';
import './widgets/team_segmented_control_widget.dart';

class TeamCollaboration extends StatefulWidget {
  const TeamCollaboration({super.key});

  @override
  State<TeamCollaboration> createState() => _TeamCollaborationState();
}

class _TeamCollaborationState extends State<TeamCollaboration>
    with TickerProviderStateMixin {
  int _selectedIndex = 1; // Team tab active
  int _segmentedIndex = 0;
  bool _isRefreshing = false;
  late TabController _tabController;

  // Mock data for team members
  final List<Map<String, dynamic>> _teamMembers = [
    {
      "id": 1,
      "name": "Sarah Johnson",
      "role": "Senior Agent",
      "email": "sarah.johnson@realty.com",
      "phone": "+1 234 567 8901",
      "isOnline": true,
      "profileImage":
          "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg",
      "currentAssignments": 8,
      "completedDeals": 24,
      "averageRating": 4.8,
      "specialization": "Luxury Properties"
    },
    {
      "id": 2,
      "name": "Michael Chen",
      "role": "Team Lead",
      "email": "michael.chen@realty.com",
      "phone": "+1 234 567 8902",
      "isOnline": true,
      "profileImage":
          "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg",
      "currentAssignments": 12,
      "completedDeals": 45,
      "averageRating": 4.9,
      "specialization": "Commercial Real Estate"
    },
    {
      "id": 3,
      "name": "Emily Rodriguez",
      "role": "Junior Agent",
      "email": "emily.rodriguez@realty.com",
      "phone": "+1 234 567 8903",
      "isOnline": false,
      "profileImage":
          "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg",
      "currentAssignments": 5,
      "completedDeals": 12,
      "averageRating": 4.6,
      "specialization": "First-time Buyers"
    },
    {
      "id": 4,
      "name": "David Wilson",
      "role": "Marketing Specialist",
      "email": "david.wilson@realty.com",
      "phone": "+1 234 567 8904",
      "isOnline": true,
      "profileImage":
          "https://images.pexels.com/photos/1040880/pexels-photo-1040880.jpeg",
      "currentAssignments": 3,
      "completedDeals": 8,
      "averageRating": 4.5,
      "specialization": "Digital Marketing"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with team name and notifications
            _buildHeader(),

            // Segmented Control
            TeamSegmentedControlWidget(
              selectedIndex: _segmentedIndex,
              onSelectionChanged: (index) {
                setState(() {
                  _segmentedIndex = index;
                });
              },
            ),

            // Main Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: AppTheme.lightTheme.primaryColor,
                child: _buildSegmentedContent(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildHeader() {
    return Container(
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sunset Realty Team',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${_teamMembers.where((m) => m["isOnline"]).length} online • ${_teamMembers.length} members',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: _showNotifications,
                icon: CustomIconWidget(
                  iconName: 'notifications',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.accentLight,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedContent() {
    switch (_segmentedIndex) {
      case 0:
        return _buildTeamMembersView();
      case 1:
        return SharedLeadsListWidget();
      case 2:
        return GroupTasksListWidget();
      case 3:
        return TeamMessagesWidget();
      default:
        return _buildTeamMembersView();
    }
  }

  Widget _buildTeamMembersView() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      itemCount: _teamMembers.length,
      itemBuilder: (context, index) {
        final member = _teamMembers[index];
        return Dismissible(
          key: Key(member["id"].toString()),
          background: _buildSwipeBackground(false),
          secondaryBackground: _buildSwipeBackground(true),
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              _showMemberCalendar(member);
            } else {
              _sendDirectMessage(member);
            }
          },
          child: GestureDetector(
            onLongPress: () => _showMemberQuickActions(member),
            child: TeamMemberCardWidget(
              member: member,
              onTap: () => _openMemberProfile(member),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSwipeBackground(bool isRight) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      decoration: BoxDecoration(
        color: isRight ? AppTheme.warningLight : AppTheme.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: isRight ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: isRight ? 'calendar_today' : 'message',
            color: Colors.white,
            size: 28,
          ),
          SizedBox(height: 0.5.h),
          Text(
            isRight ? 'Calendar' : 'Message',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onBottomNavTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      selectedItemColor: AppTheme.lightTheme.primaryColor,
      unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      elevation: 8.0,
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'home',
            color: _selectedIndex == 0
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Properties',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'group',
            color: _selectedIndex == 1
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Team',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'task',
            color: _selectedIndex == 2
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Tasks',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'person',
            color: _selectedIndex == 3
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Profile',
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _createTeamAnnouncement,
      backgroundColor: AppTheme.lightTheme.primaryColor,
      foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
      icon: CustomIconWidget(
        iconName: 'campaign',
        color: AppTheme.lightTheme.colorScheme.onPrimary,
        size: 24,
      ),
      label: Text(
        'Announce',
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onPrimary,
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Team data updated successfully'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/property-dashboard');
        break;
      case 1:
        // Already on Team tab
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/task-management');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/client-profile');
        break;
    }
  }

  void _openMemberProfile(Map<String, dynamic> member) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.9,
        minChildSize: 0.6,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              CircleAvatar(
                radius: 40,
                backgroundImage:
                    NetworkImage(member["profileImage"]),
              ),
              SizedBox(height: 2.h),
              Text(
                member["name"],
                style: AppTheme.lightTheme.textTheme.headlineSmall,
              ),
              Text(
                member["role"],
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildProfileStat(
                      "Assignments", member["currentAssignments"].toString()),
                  _buildProfileStat(
                      "Deals", member["completedDeals"].toString()),
                  _buildProfileStat(
                      "Rating", member["averageRating"].toString()),
                ],
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _sendDirectMessage(member),
                      icon: CustomIconWidget(
                        iconName: 'message',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 20,
                      ),
                      label: Text('Message'),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _assignLead(member),
                      icon: CustomIconWidget(
                        iconName: 'person_add',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 20,
                      ),
                      label: Text('Assign Lead'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            color: AppTheme.lightTheme.primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  void _showMemberQuickActions(Map<String, dynamic> member) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Quick Actions',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            _buildQuickActionTile(
                'Direct Message', 'message', () => _sendDirectMessage(member)),
            _buildQuickActionTile(
                'Assign Lead', 'person_add', () => _assignLead(member)),
            _buildQuickActionTile(
                'Schedule Meeting', 'event', () => _scheduleMeeting(member)),
            _buildQuickActionTile('View Calendar', 'calendar_today',
                () => _showMemberCalendar(member)),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionTile(
      String title, String iconName, VoidCallback onTap) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: AppTheme.lightTheme.primaryColor,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge,
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void _showNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('3 new team notifications'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _createTeamAnnouncement() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Team announcement feature coming soon'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _sendDirectMessage(Map<String, dynamic> member) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening chat with ${member["name"]}'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  void _assignLead(Map<String, dynamic> member) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Assigning lead to ${member["name"]}'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _scheduleMeeting(Map<String, dynamic> member) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Scheduling meeting with ${member["name"]}'),
        backgroundColor: AppTheme.warningLight,
      ),
    );
  }

  void _showMemberCalendar(Map<String, dynamic> member) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${member["name"]}\'s calendar'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }
}