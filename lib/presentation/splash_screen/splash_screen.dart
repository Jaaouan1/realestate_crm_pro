import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import './widgets/animated_logo_widget.dart';
import './widgets/app_name_widget.dart';
import './widgets/loading_progress_widget.dart';
import 'widgets/animated_logo_widget.dart';
import 'widgets/app_name_widget.dart';
import 'widgets/loading_progress_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _progressController;
  late AnimationController _textController;

  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _textFadeAnimation;

  String _loadingStatus = 'Initializing...';
  int _currentStep = 0;

  final List<String> _loadingSteps = [
    'Initializing...',
    'Syncing Properties...',
    'Loading Contacts...',
    'Checking Updates...',
    'Almost Ready...'
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startLoadingSequence();
  }

  void _initializeAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOut,
    ));

    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));
  }

  void _startLoadingSequence() async {
    // Start logo animation
    await _logoController.forward();

    // Start text animation
    _textController.forward();

    // Start progress animation and loading steps
    _progressController.forward();

    // Simulate loading steps
    for (int i = 0; i < _loadingSteps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) {
        setState(() {
          _currentStep = i;
          _loadingStatus = _loadingSteps[i];
        });
      }
    }

    // Check connectivity and authentication status
    await _checkConnectivityAndAuth();
  }

  Future<void> _checkConnectivityAndAuth() async {
    try {
      // Check network connectivity
      final connectivity = await Connectivity().checkConnectivity();

      if (connectivity == ConnectivityResult.none) {
        _showOfflineMessage();
        return;
      }

      // Check authentication status
      final prefs = await SharedPreferences.getInstance();
      final isAuthenticated = prefs.getBool('is_authenticated') ?? false;

      // Navigate based on authentication status
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        if (isAuthenticated) {
          Navigator.pushReplacementNamed(context, AppRoutes.propertyDashboard);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
        }
      }
    } catch (e) {
      _showErrorAndRetry();
    }
  }

  void _showOfflineMessage() {
    if (mounted) {
      setState(() {
        _loadingStatus = 'No internet connection';
      });
      _showRetryDialog('Please check your internet connection and try again.');
    }
  }

  void _showErrorAndRetry() {
    if (mounted) {
      setState(() {
        _loadingStatus = 'Something went wrong';
      });
      _showRetryDialog('An error occurred during initialization.');
    }
  }

  void _showRetryDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Connection Error',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Text(
          message,
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _retryInitialization();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _retryInitialization() {
    setState(() {
      _currentStep = 0;
      _loadingStatus = _loadingSteps[0];
    });

    _logoController.reset();
    _progressController.reset();
    _textController.reset();

    _startLoadingSequence();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _progressController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // Animated Logo
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) {
                    return AnimatedLogoWidget(
                      fadeAnimation: _logoFadeAnimation,
                      scaleAnimation: _logoScaleAnimation,
                    );
                  },
                ),

                SizedBox(height: 4.h),

                // App Name with Animation
                AnimatedBuilder(
                  animation: _textController,
                  builder: (context, child) {
                    return AppNameWidget(
                      fadeAnimation: _textFadeAnimation,
                    );
                  },
                ),

                const Spacer(),

                // Loading Progress
                AnimatedBuilder(
                  animation: _progressController,
                  builder: (context, child) {
                    return LoadingProgressWidget(
                      progressAnimation: _progressAnimation,
                      loadingStatus: _loadingStatus,
                      currentStep: _currentStep,
                      totalSteps: _loadingSteps.length,
                    );
                  },
                ),

                SizedBox(height: 8.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}