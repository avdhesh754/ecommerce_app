import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/dashboard_stats.dart';

class DashboardRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  // Get dashboard overview statistics
  Future<ApiResult<DashboardStats>> getOverviewStats() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.dashboardOverview);
      
      if (response.statusCode == 200) {
        final data = DashboardStats.fromJson(response.data['data'] ?? response.data);
        return ApiResult.success(data);
      } else {
        return ApiResult.failure('Failed to load dashboard stats');
      }
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return ApiResult.failure(apiException.message);
    } catch (e) {
      return ApiResult.failure('An unexpected error occurred');
    }
  }

  // Get recent orders
  Future<ApiResult<List<RecentOrder>>> getRecentOrders() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.recentOrders);
      
      if (response.statusCode == 200) {
        final List<dynamic> ordersJson = response.data['data'] ?? response.data;
        final orders = ordersJson.map((json) => RecentOrder.fromJson(json)).toList();
        return ApiResult.success(orders);
      } else {
        return ApiResult.failure('Failed to load recent orders');
      }
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return ApiResult.failure(apiException.message);
    } catch (e) {
      return ApiResult.failure('An unexpected error occurred');
    }
  }

  // Get top selling products
  Future<ApiResult<List<TopProduct>>> getTopProducts() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.topProducts);

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = response.data['data'] ?? response.data;
        final products = productsJson.map((json) => TopProduct.fromJson(json)).toList();
        return ApiResult.success(products);
      } else {
        return ApiResult.failure('Failed to load top products');
      }
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return ApiResult.failure(apiException.message);
    } catch (e) {
      return ApiResult.failure('An unexpected error occurred');
    }
  }

  // Get revenue chart data
  Future<ApiResult<List<RevenueData>>> getRevenueChart() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.revenueChart);
      
      if (response.statusCode == 200) {
        final List<dynamic> revenueJson = response.data['data'] ?? response.data;
        final revenue = revenueJson.map((json) => RevenueData.fromJson(json)).toList();
        return ApiResult.success(revenue);
      } else {
        return ApiResult.failure('Failed to load revenue chart');
      }
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return ApiResult.failure(apiException.message);
    } catch (e) {
      return ApiResult.failure('An unexpected error occurred');
    }
  }

  // Get sales statistics
  Future<ApiResult<Map<String, dynamic>>> getSalesStats() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.salesStats);
      
      if (response.statusCode == 200) {
        return ApiResult.success(response.data['data'] ?? response.data);
      } else {
        return ApiResult.failure('Failed to load sales stats');
      }
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return ApiResult.failure(apiException.message);
    } catch (e) {
      return ApiResult.failure('An unexpected error occurred');
    }
  }

  // Get user statistics
  Future<ApiResult<Map<String, dynamic>>> getUserStats() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.userStats);
      
      if (response.statusCode == 200) {
        return ApiResult.success(response.data['data'] ?? response.data);
      } else {
        return ApiResult.failure('Failed to load user stats');
      }
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return ApiResult.failure(apiException.message);
    } catch (e) {
      return ApiResult.failure('An unexpected error occurred');
    }
  }

}