import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/quick_task_creation_dialog.dart';
import './widgets/task_card_widget.dart';
import './widgets/task_detail_bottom_sheet.dart';

class TaskManagement extends StatefulWidget {
  const TaskManagement({super.key});

  @override
  State<TaskManagement> createState() => _TaskManagementState();
}

class _TaskManagementState extends State<TaskManagement>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedFilterIndex = 0;
  final List<String> _filterOptions = [
    'Today',
    'This Week',
    'Overdue',
    'Completed'
  ];
  final List<String> _categoryFilters = [
    'All',
    'Priority',
    'Category',
    'Team Member',
    'Property'
  ];
  int _selectedCategoryIndex = 0;
  final List<int> _selectedTasks = [];
  bool _isMultiSelectMode = false;

  // Mock data for tasks
  final List<Map<String, dynamic>> _tasks = [
    {
      "id": 1,
      "title": "Property showing at Sunset Villa",
      "description": "Show the 3-bedroom villa to the Johnson family",
      "dueTime": "10:30 AM",
      "priority": "High",
      "category": "Property Showing",
      "categoryColor": Color(0xFF2C5282),
      "assignedProperty": "Sunset Villa",
      "assignedClient": "Johnson Family",
      "isCompleted": false,
      "teamMember": "Sarah Wilson",
      "attachments": 2,
      "comments": 3,
    },
    {
      "id": 2,
      "title": "Follow up with Martinez family",
      "description": "Check interest level for downtown apartment",
      "dueTime": "2:00 PM",
      "priority": "Medium",
      "category": "Client Follow-up",
      "categoryColor": Color(0xFF38A169),
      "assignedProperty": "Downtown Apartment",
      "assignedClient": "Martinez Family",
      "isCompleted": false,
      "teamMember": "Mike Rodriguez",
      "attachments": 1,
      "comments": 1,
    },
    {
      "id": 3,
      "title": "Launch social media campaign",
      "description": "Post new luxury condo listings on social platforms",
      "dueTime": "4:30 PM",
      "priority": "High",
      "category": "Marketing Campaign",
      "categoryColor": Color(0xFFD69E2E),
      "assignedProperty": "Luxury Condos",
      "assignedClient": "N/A",
      "isCompleted": false,
      "teamMember": "Emma Thompson",
      "attachments": 5,
      "comments": 7,
    },
    {
      "id": 4,
      "title": "Prepare listing documentation",
      "description": "Complete paperwork for Ocean View property",
      "dueTime": "Tomorrow 9:00 AM",
      "priority": "Medium",
      "category": "Documentation",
      "categoryColor": Color(0xFF805AD5),
      "assignedProperty": "Ocean View House",
      "assignedClient": "N/A",
      "isCompleted": false,
      "teamMember": "David Chen",
      "attachments": 3,
      "comments": 2,
    },
    {
      "id": 5,
      "title": "Client onboarding meeting",
      "description": "Welcome new client and discuss requirements",
      "dueTime": "Yesterday 3:00 PM",
      "priority": "High",
      "category": "Client Follow-up",
      "categoryColor": Color(0xFF38A169),
      "assignedProperty": "N/A",
      "assignedClient": "Anderson Family",
      "isCompleted": true,
      "teamMember": "Sarah Wilson",
      "attachments": 0,
      "comments": 4,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this, initialIndex: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredTasks {
    List<Map<String, dynamic>> filtered = List.from(_tasks);

    // Filter by time period
    switch (_selectedFilterIndex) {
      case 0: // Today
        filtered = filtered
            .where((task) =>
                (task["dueTime"] as String).contains("AM") ||
                (task["dueTime"] as String).contains("PM"))
            .toList();
        break;
      case 1: // This Week
        // Keep all tasks for demo
        break;
      case 2: // Overdue
        filtered = filtered
            .where((task) => (task["dueTime"] as String).contains("Yesterday"))
            .toList();
        break;
      case 3: // Completed
        filtered =
            filtered.where((task) => task["isCompleted"] == true).toList();
        break;
    }

    return filtered;
  }

  void _toggleTaskSelection(int taskId) {
    setState(() {
      if (_selectedTasks.contains(taskId)) {
        _selectedTasks.remove(taskId);
      } else {
        _selectedTasks.add(taskId);
      }

      if (_selectedTasks.isEmpty) {
        _isMultiSelectMode = false;
      }
    });
  }

  void _startMultiSelect(int taskId) {
    setState(() {
      _isMultiSelectMode = true;
      _selectedTasks.add(taskId);
    });
  }

  void _exitMultiSelect() {
    setState(() {
      _isMultiSelectMode = false;
      _selectedTasks.clear();
    });
  }

  void _showTaskDetail(Map<String, dynamic> task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TaskDetailBottomSheet(task: task),
    );
  }

  void _showQuickTaskCreation() {
    showDialog(
      context: context,
      builder: (context) => const QuickTaskCreationDialog(),
    );
  }

  Future<void> _refreshTasks() async {
    // Simulate network call
    await Future.delayed(const Duration(seconds: 1));
    // In real app, this would sync with server
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFilterTabs(),
            _buildCategoryFilters(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshTasks,
                color: AppTheme.lightTheme.primaryColor,
                child: _filteredTasks.isEmpty
                    ? _buildEmptyState()
                    : _buildTaskList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
      floatingActionButton:
          _isMultiSelectMode ? null : _buildFloatingActionButton(),
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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Task Management',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Today, ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryLight,
                ),
              ),
            ],
          ),
          if (_isMultiSelectMode)
            Row(
              children: [
                Text(
                  '${_selectedTasks.length} selected',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 2.w),
                GestureDetector(
                  onTap: _exitMultiSelect,
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 24,
                  ),
                ),
              ],
            )
          else
            GestureDetector(
              onTap: _showQuickTaskCreation,
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'add',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 24,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      height: 6.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filterOptions.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedFilterIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilterIndex = index;
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 2.w),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.borderLight,
                ),
              ),
              child: Text(
                _filterOptions[index],
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.onPrimary
                      : AppTheme.textPrimaryLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return Container(
      height: 5.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categoryFilters.length,
        itemBuilder: (context, index) {
          return FilterChipWidget(
            label: _categoryFilters[index],
            isSelected: _selectedCategoryIndex == index,
            onTap: () {
              setState(() {
                _selectedCategoryIndex = index;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildTaskList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      itemCount: _filteredTasks.length,
      itemBuilder: (context, index) {
        final task = _filteredTasks[index];
        final isSelected = _selectedTasks.contains(task["id"]);

        return TaskCardWidget(
          task: task,
          isSelected: isSelected,
          isMultiSelectMode: _isMultiSelectMode,
          onTap: () {
            if (_isMultiSelectMode) {
              _toggleTaskSelection(task["id"]);
            } else {
              _showTaskDetail(task);
            }
          },
          onLongPress: () {
            if (!_isMultiSelectMode) {
              _startMultiSelect(task["id"]);
            }
          },
          onToggleComplete: (taskId) {
            setState(() {
              final taskIndex = _tasks.indexWhere((t) => t["id"] == taskId);
              if (taskIndex != -1) {
                _tasks[taskIndex]["isCompleted"] =
                    !_tasks[taskIndex]["isCompleted"];
              }
            });
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'task_alt',
            color: AppTheme.textSecondaryLight,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'No tasks found',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.textSecondaryLight,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Start organizing your real estate activities\nwith task templates',
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryLight,
            ),
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: _showQuickTaskCreation,
            child: Text('Create Your First Task'),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _showQuickTaskCreation,
      backgroundColor: AppTheme.lightTheme.primaryColor,
      child: CustomIconWidget(
        iconName: 'add',
        color: AppTheme.lightTheme.colorScheme.onPrimary,
        size: 24,
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: 3, // Task Management tab
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
            color: AppTheme.textSecondaryLight,
            size: 24,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'people',
            color: AppTheme.lightTheme.primaryColor,
            size: 24,
          ),
          label: 'Leads',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'task',
            color: AppTheme.lightTheme.primaryColor,
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
            Navigator.pushNamed(context, '/lead-management');
            break;
          case 3:
            // Current screen
            break;
          case 4:
            Navigator.pushNamed(context, '/client-profile');
            break;
          case 5:
            Navigator.pushNamed(context, '/property-search');
            break;
        }
      },
    );
  }
}
