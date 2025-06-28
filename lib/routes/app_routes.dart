// lib/routes/app_routes.dart
import 'package:flutter/material.dart';
import '../presentation/property_dashboard/property_dashboard.dart';
import '../presentation/task_management/task_management.dart';
import '../presentation/lead_management/lead_management.dart';
import '../presentation/property_search/property_search.dart';
import '../presentation/property_detail/property_detail.dart';
import '../presentation/client_profile/client_profile.dart';
import '../presentation/team_collaboration/team_collaboration.dart';
import '../presentation/analytics_dashboard/analytics_dashboard.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/login_screen/login_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String loginScreen = '/login-screen';
  static const String propertyDashboard = '/property-dashboard';
  static const String propertyDetail = '/property-detail';
  static const String leadManagement = '/lead-management';
  static const String taskManagement = '/task-management';
  static const String clientProfile = '/client-profile';
  static const String propertySearch = '/property-search';
  static const String teamCollaboration = '/team-collaboration';
  static const String analyticsDashboard = '/analytics-dashboard';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    loginScreen: (context) => const LoginScreen(),
    propertyDashboard: (context) => const PropertyDashboard(),
    propertyDetail: (context) => const PropertyDetail(),
    leadManagement: (context) => const LeadManagement(),
    taskManagement: (context) => const TaskManagement(),
    clientProfile: (context) => const ClientProfile(),
    propertySearch: (context) => const PropertySearch(),
    teamCollaboration: (context) => const TeamCollaboration(),
    analyticsDashboard: (context) => const AnalyticsDashboard(),
  };
}
