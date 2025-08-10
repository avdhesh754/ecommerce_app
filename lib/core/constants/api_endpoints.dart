import 'package:cosmetic_ecommerce_app/core/constants/app_constants.dart';

class ApiEndpoints {
  static final String apiGateway = AppConstants.baseUrl;  // Main gateway
  static const String userService = '/user';
  static const String productService = '/product';
  static const String orderService = '/order';
  static const String adminService = '/admin';
  static const String notificationService = '/notification';

  // Authentication (User Service)
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String profile = '/auth/me';
  static const String refreshToken = '/auth/refresh-token';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String changePassword = '/auth/change-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';

  // Users Management
  static const String users = '/users';
  static const String userById = '/users/{id}';
  static const String userRoles = '/users/{id}/roles';

  // Admin Dashboard (Admin Service)
  static const String adminDashboard = '/admin/dashboard';
  static const String dashboardStats = '/admin/dashboard/stats';
  static const String dashboardOverview = '/admin/dashboard/overview';
  static const String salesStats = '/admin/dashboard/sales-stats';
  static const String userStats = '/admin/dashboard/user-stats';
  static const String recentOrders = '/admin/dashboard/recent-orders';
  static const String topProducts = '/admin/dashboard/top-products';
  static const String revenueChart = '/admin/dashboard/revenue-chart';
  static const String systemHealth = '/admin/system/health';

  // Products (Product Service)
  static const String products = '/products';
  static const String productById = '/products/{id}';
  static const String categories = '/categories';
  static const String categoryById = '/categories/{id}';
  static const String reviews = '/reviews';
  static const String productReviews = '/products/{id}/reviews';
  static const String uploadImage = '/upload/image';
  static const String productImages = '/products/{id}/images';
  static const String inventory = '/inventory';
  static const String inventoryById = '/inventory/{id}';

  // Orders (Order Service)
  static const String orders = '/orders';
  static const String orderById = '/orders/{id}';
  static const String orderStatus = '/orders/{id}/status';
  static const String orderTracking = '/orders/{id}/tracking';
  static const String userOrders = '/users/{userId}/orders';

  // Cart & Wishlist (User Service)
  static const String cart = '/cart';
  static const String cartItems = '/cart/items';
  static const String cartItem = '/cart/items/{id}';
  static const String wishlist = '/wishlist';
  static const String wishlistItems = '/wishlist/items';
  static const String wishlistItem = '/wishlist/items/{id}';

  // Admin Management (Admin Service)
  static const String adminUsers = '/admin/users';
  static const String adminUserById = '/admin/users/{id}';
  static const String adminProducts = '/admin/products';
  static const String adminOrders = '/admin/orders';
  static const String roles = '/roles';
  static const String roleById = '/roles/{id}';
  static const String permissions = '/permissions';
  static const String permissionById = '/permissions/{id}';

  // Notifications (Notification Service)
  static const String notifications = '/notifications';
  static const String notificationById = '/notifications/{id}';
  static const String markNotificationRead = '/notifications/{id}/read';
  static const String userNotifications = '/users/{userId}/notifications';

  // Additional features from backend
  static const String coupons = '/coupons';
  static const String couponById = '/coupons/{id}';
  static const String applyCoupon = '/cart/apply-coupon';
  static const String removeCoupon = '/cart/remove-coupon';
  
  static const String banners = '/banners';
  static const String activeBanners = '/banners/active';
  
  static const String promos = '/promos';
  static const String activePromos = '/promos/active';
  
  static const String ads = '/ads';
  static const String activeAds = '/ads/active';
  
  static const String taxation = '/taxation';
  static const String calculateTax = '/taxation/calculate';
  
  static const String abandonedCarts = '/abandoned-cart';
  static const String abandonedCartNotify = '/abandoned-cart/notify';
  
  static const String smsTemplates = '/sms-templates';
  static const String sendSms = '/sms/send';
  
  static const String otpGenerate = '/otp/generate';
  static const String otpVerify = '/otp/verify';

  // Helper method to replace path parameters
  static String replacePathParams(String endpoint, Map<String, String> params) {
    String result = endpoint;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }

}