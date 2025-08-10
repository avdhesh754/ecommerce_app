import 'package:get/get.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/logger.dart';
import '../../../../shared/models/user_model.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../models/dashboard_stats.dart';
import '../models/admin_activity.dart';

class SuperAdminController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final AuthController _authController = Get.find<AuthController>();

  final dashboardStats = const DashboardStats(
    totalUsers: 0,
    totalProducts: 0,
    totalOrders: 0,
    totalRevenue: 0.0,
    newUsersToday: 0,
    ordersToday: 0,
    revenueToday: 0.0,
    growthPercentage: 0.0,
  ).obs;
  final recentActivities = <AdminActivity>[].obs;
  final adminUsers = <UserModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    refreshDashboard();
  }

  Future<void> refreshDashboard() async {
    try {
      isLoading.value = true;
      await Future.wait([
        _loadDashboardStats(),
        _loadRecentActivities(),
        _loadAdminUsers(),
      ]);
    } catch (e) {
      Logger.error('Failed to refresh dashboard', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadDashboardStats() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.dashboardOverview);
      if (response.data != null) {
        dashboardStats.value = DashboardStats.fromJson(response.data['data']);
      }
    } catch (e) {
      Logger.error('Failed to load dashboard stats', e);
    }
  }

  Future<void> _loadRecentActivities() async {
    try {
      final response = await _apiClient.get('/admin/activities?limit=10');
      if (response.data != null) {
        final List<dynamic> activities = response.data['data'] ?? [];
        recentActivities.value = activities
            .map((activity) => AdminActivity.fromJson(activity))
            .toList();
      }
    } catch (e) {
      Logger.error('Failed to load recent activities', e);
    }
  }

  Future<void> _loadAdminUsers() async {
    try {
      final response = await _apiClient.get('${ApiEndpoints.adminUsers}?role=admin');
      if (response.data != null) {
        final List<dynamic> users = response.data['data'] ?? [];
        adminUsers.value = users
            .map((user) => UserModel.fromJson(user))
            .toList();
      }
    } catch (e) {
      Logger.error('Failed to load admin users', e);
    }
  }

  Future<void> createAdmin({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required List<String> permissions,
  }) async {
    try {
      isLoading.value = true;
      
      final response = await _apiClient.post('/admin/create-admin', data: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'permissions': permissions,
      });

      if (response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Admin created successfully',
          snackPosition: SnackPosition.TOP,
        );
        await _loadAdminUsers();
      }
    } catch (e) {
      Logger.error('Failed to create admin', e);
      Get.snackbar(
        'Error',
        'Failed to create admin: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateAdminPermissions(String adminId, List<String> permissions) async {
    try {
      isLoading.value = true;
      
      final response = await _apiClient.put(
        '/admin/users/$adminId/permissions',
        data: {'permissions': permissions},
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Admin permissions updated successfully',
          snackPosition: SnackPosition.TOP,
        );
        await _loadAdminUsers();
      }
    } catch (e) {
      Logger.error('Failed to update admin permissions', e);
      Get.snackbar(
        'Error',
        'Failed to update permissions: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleAdminStatus(String adminId, bool isActive) async {
    try {
      isLoading.value = true;
      
      final response = await _apiClient.put(
        '/admin/users/$adminId/status',
        data: {'isActive': isActive},
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Admin status updated successfully',
          snackPosition: SnackPosition.TOP,
        );
        await _loadAdminUsers();
      }
    } catch (e) {
      Logger.error('Failed to update admin status', e);
      Get.snackbar(
        'Error',
        'Failed to update status: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAdmin(String adminId) async {
    try {
      isLoading.value = true;
      
      final response = await _apiClient.delete('/admin/users/$adminId');

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Admin deleted successfully',
          snackPosition: SnackPosition.TOP,
        );
        await _loadAdminUsers();
      }
    } catch (e) {
      Logger.error('Failed to delete admin', e);
      Get.snackbar(
        'Error',
        'Failed to delete admin: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    _authController.logout();
  }

  // Permission management methods
  Future<List<String>> getAvailablePermissions() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.permissions);
      if (response.data != null) {
        final List<dynamic> permissions = response.data['data'] ?? [];
        return permissions.map((p) => p['name'].toString()).toList();
      }
      return [];
    } catch (e) {
      Logger.error('Failed to load permissions', e);
      return [];
    }
  }

  Future<void> createPermission({
    required String name,
    required String description,
    required String resource,
    required String action,
  }) async {
    try {
      isLoading.value = true;
      
      final response = await _apiClient.post(ApiEndpoints.permissions, data: {
        'name': name,
        'description': description,
        'resource': resource,
        'action': action,
      });

      if (response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Permission created successfully',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Logger.error('Failed to create permission', e);
      Get.snackbar(
        'Error',
        'Failed to create permission: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

}