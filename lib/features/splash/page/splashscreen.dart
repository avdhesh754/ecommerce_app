import 'package:cosmetic_ecommerce_app/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../../core/utils/responsive_breakpoints.dart'as rb;
import '../../../core/utils/responsive_breakpoints.dart';
import '../../../core/di/dependency_injection.dart';
import '../../auth/presentation/controllers/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;

  @override
  void initState() {
    super.initState();

    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    // Initialize animations
    _initializeAnimations();

    // Start authentication check
    _checkAuthAndNavigate();
  }

  void _initializeAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.elasticOut,
      ),
    );

    // Logo rotation animation
    _logoRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2.0,
    ).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeInOut,
      ),
    );

    // Text opacity animation
    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeIn,
      ),
    );

    // Text slide animation
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Start animations
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _textController.forward();
      }
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    // Get AuthController (should be initialized in DI)
    if (!Get.isRegistered<AuthController>()) {
      // Initialize dependencies if not done yet
      await DependencyInjection.init();
    }

    final authController = AuthController.to;

    // Wait for animations to complete
    await Future.delayed(const Duration(seconds: 2));

    // Check authentication status
    await authController.checkAuthStatus();

    // Additional delay for smooth transition
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    print('>>>>>>>>>>>>>>>>${authController.isSuperAdmin}');


    // Navigate based on authentication status
    if (authController.isAuthenticated) {
      if (authController.isSuperAdmin) {
        Get.offAllNamed(AppRoutes.superAdminDashboard);
      } else if (authController.isAdmin) {
        Get.offAllNamed(AppRoutes.adminDashboard);
      } else {
        Get.offAllNamed(AppRoutes.home);
      }
    } else {
      Get.offAllNamed('/login');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black.withOpacity(0.6),
        child: rb.ResponsiveBuilder(
          builder: (context, screenType) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with animations
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: Container(
                          width: rb.ResponsiveBreakpoints.getResponsiveSize(context, 120),
                          height: rb.ResponsiveBreakpoints.getResponsiveSize(context, 120),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              size: rb.ResponsiveBreakpoints.getResponsiveSize(context, 60),
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  ResponsiveSizedBox(height: 40),

                  // App name with animations
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _textOpacityAnimation,
                        child: SlideTransition(
                          position: _textSlideAnimation,
                          child: Column(
                            children: [
                              Text(
                                'YourApp',
                                style: TextStyle(
                                  fontSize: ResponsiveBreakpoints.getResponsiveFontSize(context, 32),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Welcome to Excellence',
                                style: TextStyle(
                                  fontSize: rb.ResponsiveBreakpoints.getResponsiveFontSize(context, 16),
                                  color: Colors.white.withOpacity(0.9),
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(
                    height: ResponsiveBreakpoints.getValue(
                      context: context,
                      mobile: 80,
                      tablet: 100,
                      desktop: 120,
                    ),
                  ),

                  // Loading indicator
                  SizedBox(
                    width: ResponsiveBreakpoints.getValue(
                      context: context,
                      mobile: 40,
                      tablet: 50,
                      desktop: 60,
                    ),
                    height: ResponsiveBreakpoints.getValue(
                      context: context,
                      mobile: 40,
                      tablet: 50,
                      desktop: 60,
                    ),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withOpacity(0.8),
                      ),
                      strokeWidth: ResponsiveBreakpoints.getValue(
                        context: context,
                        mobile: 3,
                        tablet: 4,
                        desktop: 5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

}

