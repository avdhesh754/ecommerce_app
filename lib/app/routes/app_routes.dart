import 'package:get/get.dart';
import 'middleware/auth_middleware.dart';
import '../../features/admin/dashboard/admin_dashboard_screen.dart';
import '../../features/admin/dashboard/super_admin_dashboard_screen.dart';
import '../../features/admin/dashboard/permission_based_admin_dashboard.dart';
import '../../features/home/unified_home_screen.dart';
import '../../features/admin/orders/presentation/admin_orders_screen.dart';
import '../../features/admin/products/presentation/admin_products_screen.dart';
import '../../features/admin/users/presentation/admin_users_screen.dart';
import '../../features/auth/presentation/pages/forgot_password_screen.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_screen.dart';
import '../../features/customer/home/customer_home_screen.dart';
import '../../features/splash/page/splashscreen.dart';


class AppRoutes {
  // Route names
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Unified routes
  static const String home = '/home';
  
  // Admin routes
  static const String adminDashboard = '/admin/dashboard';
  static const String superAdminDashboard = '/super-admin/dashboard';
  static const String adminProducts = '/admin/products';
  static const String adminOrders = '/admin/orders';
  static const String adminUsers = '/admin/users';
  
  // Customer routes
  static const String products = '/products';
  static const String cart = '/cart';
  static const String orders = '/orders';
  static const String profile = '/profile';

  static List<GetPage> get pages => [

    GetPage(
      name: splash,
      page: () => const SplashScreen(), // or ModernSplashScreen()
      transition: Transition.fadeIn,
    ),
    // Authentication routes
    GetPage(
      name: login,
      page: () => const LoginPage(),
      middlewares: [GuestMiddleware()],
    ),
    GetPage(
      name: register,
      page: () => const RegisterScreen(),
      middlewares: [GuestMiddleware()],
    ),
    GetPage(
      name: forgotPassword,
      page: () => const ForgotPasswordScreen(),
      middlewares: [GuestMiddleware()],
    ),

    // Unified home route
    GetPage(
      name: home,
      page: () => const UnifiedHomeScreen(),
      middlewares: [AuthMiddleware()],
    ),
    
    // Admin routes - protected with admin middleware
    GetPage(
      name: adminDashboard,
      page: () => const PermissionBasedAdminDashboard(),
      middlewares: [AuthMiddleware(), AdminMiddleware()],
    ),
    GetPage(
      name: superAdminDashboard,
      page: () => const SuperAdminDashboardScreen(),
      middlewares: [AuthMiddleware(), SuperAdminMiddleware()],
    ),
    GetPage(
      name: adminProducts,
      page: () => const AdminProductsScreen(),
      middlewares: [AuthMiddleware(), AdminMiddleware()],
    ),
    GetPage(
      name: adminOrders,
      page: () => const AdminOrdersScreen(),
      middlewares: [AuthMiddleware(), AdminMiddleware()],
    ),
    GetPage(
      name: adminUsers,
      page: () => const AdminUsersScreen(),
      middlewares: [AuthMiddleware(), AdminMiddleware()],
    ),

    // Customer routes - protected with auth middleware
    GetPage(
      name: '/customer/home',
      page: () => const CustomerHomeScreen(),
      middlewares: [AuthMiddleware()],
    )];
  //   GetPage(
  //     name: products,
  //     page: () => const CustomerProductsScreen(),
  //     middlewares: [AuthMiddleware()],
  //   ),
  //   GetPage(
  //     name: cart,
  //     page: () => const CartScreen(),
  //     middlewares: [AuthMiddleware()],
  //   ),
  //   GetPage(
  //     name: orders,
  //     page: () => const CustomerOrdersScreen(),
  //     middlewares: [AuthMiddleware()],
  //   ),
  //   GetPage(
  //     name: profile,
  //     page: () => const CustomerProfileScreen(),
  //     middlewares: [AuthMiddleware()],
  //   ),
  // ];
}
