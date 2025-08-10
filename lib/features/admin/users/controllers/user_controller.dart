import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../shared/models/permission_model.dart';
import '../../../../shared/models/user_model.dart';
import '../data/user_repository.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();

  final UserRepository _repository = UserRepository();

  // Observable variables
  final RxList<UserModel> _users = <UserModel>[].obs;
  final RxList<RoleModel> _roles = <RoleModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxBool _isLoadingMore = false.obs;
  final RxString _error = ''.obs;
  final RxString _searchQuery = ''.obs;
  final RxString _selectedRole = ''.obs;
  final RxString _sortBy = 'createdAt'.obs;
  final RxString _sortOrder = 'desc'.obs;
  final RxInt _currentPage = 1.obs;
  final RxInt _totalPages = 1.obs;
  final RxBool _hasNextPage = false.obs;

  // Getters
  List<UserModel> get users => _users;
  List<RoleModel> get roles => _roles;
  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  String get error => _error.value;
  String get searchQuery => _searchQuery.value;
  String get selectedRole => _selectedRole.value;
  String get sortBy => _sortBy.value;
  String get sortOrder => _sortOrder.value;
  int get currentPage => _currentPage.value;
  int get totalPages => _totalPages.value;
  bool get hasNextPage => _hasNextPage.value;

  @override
  void onInit() {
    super.onInit();
    loadUsers();
    loadRoles();
  }

  // Load users with current filters
  Future<void> loadUsers({bool refresh = false}) async {
    if (refresh) {
      _currentPage.value = 1;
      _users.clear();
    }

    _setLoading(true);
    _clearError();

    try {
      final result = await _repository.getUsers(
        page: currentPage,
        search: searchQuery.isNotEmpty ? searchQuery : null,
        role: selectedRole.isNotEmpty ? selectedRole : null,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );

      if (result.isSuccess && result.data != null) {
        if (refresh) {
          _users.value = result.data!.users;
        } else {
          _users.addAll(result.data!.users);
        }
        
        _totalPages.value = result.data!.totalPages;
        _hasNextPage.value = result.data!.hasNextPage;
      } else {
        _setError(result.error ?? 'Failed to load users');
      }
    } catch (e) {
      _setError('Error loading users: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load more users for pagination
  Future<void> loadMoreUsers() async {
    if (!hasNextPage || isLoadingMore) return;

    _setLoadingMore(true);
    _currentPage.value++;

    try {
      final result = await _repository.getUsers(
        page: currentPage,
        search: searchQuery.isNotEmpty ? searchQuery : null,
        role: selectedRole.isNotEmpty ? selectedRole : null,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );

      if (result.isSuccess && result.data != null) {
        _users.addAll(result.data!.users);
        _hasNextPage.value = result.data!.hasNextPage;
      } else {
        _currentPage.value--; // Revert page increment on error
        _setError(result.error ?? 'Failed to load more users');
      }
    } catch (e) {
      _currentPage.value--; // Revert page increment on error
      _setError('Error loading more users: $e');
    } finally {
      _setLoadingMore(false);
    }
  }

  // Load roles
  Future<void> loadRoles() async {
    try {
      final result = await _repository.getRoles();
      if (result.isSuccess && result.data != null) {
        _roles.value = result.data!.cast<RoleModel>();
      }
    } catch (e) {
      debugPrint('Error loading roles: $e');
    }
  }

  // Search users
  void searchUsers(String query) {
    _searchQuery.value = query;
    loadUsers(refresh: true);
  }

  // Filter by role
  void filterByRole(String role) {
    _selectedRole.value = role;
    loadUsers(refresh: true);
  }

  // Sort users
  void sortUsers(String sortBy, String sortOrder) {
    _sortBy.value = sortBy;
    _sortOrder.value = sortOrder;
    loadUsers(refresh: true);
  }

  // Clear filters
  void clearFilters() {
    _searchQuery.value = '';
    _selectedRole.value = '';
    _sortBy.value = 'createdAt';
    _sortOrder.value = 'desc';
    loadUsers(refresh: true);
  }

  // Get single user
  Future<UserModel?> getUser(String id) async {
    try {
      final result = await _repository.getUser(id);
      if (result.isSuccess && result.data != null) {
        return result.data;
      } else {
        _setError(result.error ?? 'Failed to load user');
        return null;
      }
    } catch (e) {
      _setError('Error loading user: $e');
      return null;
    }
  }

  // Create user
  Future<bool> createUser(Map<String, dynamic> userData) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _repository.createUser(userData);
      if (result.isSuccess && result.data != null) {
        _users.insert(0, result.data!);
        _setLoading(false);
        
        Get.showSnackbar(const GetSnackBar(
          message: 'User created successfully',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        ));
        
        return true;
      } else {
        _setError(result.error ?? 'Failed to create user');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Error creating user: $e');
      _setLoading(false);
      return false;
    }
  }

  // Update user
  Future<bool> updateUser(String id, Map<String, dynamic> userData) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _repository.updateUser(id, userData);
      if (result.isSuccess && result.data != null) {
        final index = _users.indexWhere((u) => u.id == id);
        if (index != -1) {
          _users[index] = result.data!;
        }
        _setLoading(false);
        
        Get.showSnackbar(const GetSnackBar(
          message: 'User updated successfully',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        ));
        
        return true;
      } else {
        _setError(result.error ?? 'Failed to update user');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Error updating user: $e');
      _setLoading(false);
      return false;
    }
  }

  // Delete user
  Future<bool> deleteUser(String id) async {
    try {
      final result = await _repository.deleteUser(id);
      if (result.isSuccess) {
        _users.removeWhere((u) => u.id == id);
        
        Get.showSnackbar(const GetSnackBar(
          message: 'User deleted successfully',
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        ));
        
        return true;
      } else {
        _setError(result.error ?? 'Failed to delete user');
        return false;
      }
    } catch (e) {
      _setError('Error deleting user: $e');
      return false;
    }
  }

  // Update user status
  Future<bool> updateUserStatus(String id, bool isActive) async {
    try {
      final result = await _repository.updateUserStatus(id, isActive);
      if (result.isSuccess && result.data != null) {
        final index = _users.indexWhere((u) => u.id == id);
        if (index != -1) {
          _users[index] = result.data!;
        }
        
        Get.showSnackbar(GetSnackBar(
          message: 'User ${isActive ? 'activated' : 'deactivated'} successfully',
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        ));
        
        return true;
      } else {
        _setError(result.error ?? 'Failed to update user status');
        return false;
      }
    } catch (e) {
      _setError('Error updating user status: $e');
      return false;
    }
  }

  // Refresh users
  Future<void> refreshUsers() async {
    await loadUsers(refresh: true);
    Get.showSnackbar(const GetSnackBar(
      message: 'Users refreshed',
      backgroundColor: Colors.green,
      duration: Duration(seconds: 1),
      snackPosition: SnackPosition.TOP,
    ));
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading.value = loading;
  }

  void _setLoadingMore(bool loading) {
    _isLoadingMore.value = loading;
  }

  void _setError(String error) {
    _error.value = error;
    if (error.isNotEmpty) {
      Get.showSnackbar(GetSnackBar(
        message: error,
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      ));
    }
  }

  void _clearError() {
    _error.value = '';
  }
}