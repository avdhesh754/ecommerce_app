import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/enums/user_role.dart';
import '../../../features/auth/presentation/controllers/auth_controller.dart';
import '../app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    
    // If user is not authenticated, redirect to login
    if (!authController.isAuthenticated) {
      return const RouteSettings(name: AppRoutes.login);
    }
    
    return null;
  }
}

class AdminMiddleware extends GetMiddleware {
  @override
  int? get priority => 2;

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    final user = authController.currentUser.value;
    
    // If user is not admin or super admin, redirect to home
    if (user == null || (!user.isAdmin && !user.isSuperAdmin)) {
      return const RouteSettings(name: AppRoutes.home);
    }
    
    return null;
  }
}

class SuperAdminMiddleware extends GetMiddleware {
  @override
  int? get priority => 2;

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    final user = authController.currentUser.value;
    
    // If user is not super admin, redirect to home
    if (user == null || !user.isSuperAdmin) {
      return const RouteSettings(name: AppRoutes.home);
    }
    
    return null;
  }
}

class GuestMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    
    // If user is authenticated, redirect to unified home
    if (authController.isAuthenticated) {
      return const RouteSettings(name: AppRoutes.home);
    }
    
    return null;
  }
}