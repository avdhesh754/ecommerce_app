import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/api_result.dart';
import '../../../../shared/models/user_model.dart';
import '../models/user_list_response.dart';
import '../models/role_model.dart';

class UserRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  // Get all users with pagination
  Future<ApiResult<UserListResponse>> getUsers({
    int page = 1,
    int limit = 20,
    String? search,
    String? role,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
        if (role != null && role.isNotEmpty) 'role': role,
        if (sortBy != null && sortBy.isNotEmpty) 'sortBy': sortBy,
        if (sortOrder != null && sortOrder.isNotEmpty) 'sortOrder': sortOrder,
      };

      final response = await _apiClient.get(
        ApiEndpoints.adminUsers,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = UserListResponse.fromJson(response.data);
        return ApiResult.success(data);
      } else {
        return ApiResult.failure('Failed to load users');
      }
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return ApiResult.failure(apiException.message);
    } catch (e) {
      return ApiResult.failure('An unexpected error occurred');
    }
  }

  // Get single user by ID
  Future<ApiResult<UserModel>> getUser(String id) async {
    try {
      final response = await _apiClient.get('${ApiEndpoints.adminUsers}/$id');

      if (response.statusCode == 200) {
        final user = UserModel.fromJson(response.data['data'] ?? response.data);
        return ApiResult.success(user);
      } else {
        return ApiResult.failure('Failed to load user');
      }
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return ApiResult.failure(apiException.message);
    } catch (e) {
      return ApiResult.failure('An unexpected error occurred');
    }
  }

  // Create new user
  Future<ApiResult<UserModel>> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.adminUsers,
        data: userData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final user = UserModel.fromJson(response.data['data'] ?? response.data);
        return ApiResult.success(user);
      } else {
        return ApiResult.failure('Failed to create user');
      }
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return ApiResult.failure(apiException.message);
    } catch (e) {
      return ApiResult.failure('An unexpected error occurred');
    }
  }

  // Update user
  Future<ApiResult<UserModel>> updateUser(String id, Map<String, dynamic> userData) async {
    try {
      final response = await _apiClient.put(
        '${ApiEndpoints.adminUsers}/$id',
        data: userData,
      );

      if (response.statusCode == 200) {
        final user = UserModel.fromJson(response.data['data'] ?? response.data);
        return ApiResult.success(user);
      } else {
        return ApiResult.failure('Failed to update user');
      }
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return ApiResult.failure(apiException.message);
    } catch (e) {
      return ApiResult.failure('An unexpected error occurred');
    }
  }

  // Delete user
  Future<ApiResult<bool>> deleteUser(String id) async {
    try {
      final response = await _apiClient.delete('${ApiEndpoints.adminUsers}/$id');

      if (response.statusCode == 200) {
        return ApiResult.success(true);
      } else {
        return ApiResult.failure('Failed to delete user');
      }
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return ApiResult.failure(apiException.message);
    } catch (e) {
      return ApiResult.failure('An unexpected error occurred');
    }
  }

  // Update user status
  Future<ApiResult<UserModel>> updateUserStatus(String id, bool isActive) async {
    try {
      final response = await _apiClient.put(
        '${ApiEndpoints.adminUsers}/$id/status',
        data: {'isActive': isActive},
      );

      if (response.statusCode == 200) {
        final user = UserModel.fromJson(response.data['data'] ?? response.data);
        return ApiResult.success(user);
      } else {
        return ApiResult.failure('Failed to update user status');
      }
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return ApiResult.failure(apiException.message);
    } catch (e) {
      return ApiResult.failure('An unexpected error occurred');
    }
  }

  // Get roles
  Future<ApiResult<List<RoleModel>>> getRoles() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.roles);

      if (response.statusCode == 200) {
        final List<dynamic> rolesJson = response.data['data'] ?? response.data;
        final roles = rolesJson.map((json) => RoleModel.fromJson(json)).toList();
        return ApiResult.success(roles);
      } else {
        return ApiResult.failure('Failed to load roles');
      }
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return ApiResult.failure(apiException.message);
    } catch (e) {
      return ApiResult.failure('An unexpected error occurred');
    }
  }
}

class UserListResponse {
  final List<UserModel> users;
  final int totalCount;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const UserListResponse({
    required this.users,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory UserListResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> usersJson = json['data'] ?? json['users'] ?? [];
    final users = usersJson.map((json) => UserModel.fromJson(json)).toList();

    return UserListResponse(
      users: users,
      totalCount: json['totalCount'] ?? json['total'] ?? 0,
      currentPage: json['currentPage'] ?? json['page'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
    );
  }
}

class ApiResult<T> {
  final bool isSuccess;
  final T? data;
  final String? error;

  const ApiResult({
    required this.isSuccess,
    this.data,
    this.error,
  });

  factory ApiResult.success(T data) {
    return ApiResult(isSuccess: true, data: data);
  }

  factory ApiResult.failure(String error) {
    return ApiResult(isSuccess: false, error: error);
  }
}