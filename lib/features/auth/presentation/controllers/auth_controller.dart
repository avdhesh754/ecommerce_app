// Enhanced Auth Controller with integrated token refresh
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/services/websocket_service.dart';
import '../../../../core/storage/storage_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository_interface.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  // Dependencies
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final AuthRepositoryInterface _authRepository;
  late final WebSocketService _webSocketService;

  // Observable state
  final Rx<UserEntity?> currentUser = Rx<UserEntity?>(null);
  final RxBool _isLoading = false.obs;
  final RxBool _isAuthenticated = false.obs;
  final RxString _error = ''.obs;

  // Constructor
 AuthController({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required AuthRepositoryInterface authRepository,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _authRepository = authRepository;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isAuthenticated => _isAuthenticated.value;
  String get error => _error.value;
  bool get isAdmin => currentUser.value?.isAdmin ?? false;
  bool get isCustomer => currentUser.value?.isCustomer ?? true;
  bool get isSuperAdmin => currentUser.value?.isSuperAdmin ?? false;

  @override
  void onInit() {
    super.onInit();
    _webSocketService = Get.find<WebSocketService>();

    // Check auth status on initialization
    checkAuthStatus();

    // Start/stop background token refresh based on authentication status
    ever(_isAuthenticated, (isAuth) {
      if (isAuth) {
        BackgroundTokenRefreshManager.startBackgroundRefresh();
      } else {
        BackgroundTokenRefreshManager.stopBackgroundRefresh();
      }
    });
  }

  @override
  void onClose() {
    BackgroundTokenRefreshManager.stopBackgroundRefresh();
    super.onClose();
  }

  /// Enhanced authentication status check with token validation
  Future<void> checkAuthStatus() async {
    debugPrint('=== Starting enhanced checkAuthStatus ===');
    _setLoading(true);

    try {
      if (_authRepository.isLoggedIn) {
        debugPrint('User appears to be logged in, validating token...');

        // Get current token and validate
        final storageService = Get.find<StorageService>();
        final token = storageService.getToken();

        if (token != null) {
          // Check if token is expired or will expire soon
          if (TokenValidator.isTokenExpired(token)) {
            debugPrint('Token is expired or expiring soon, will refresh on next API call...');
          }

          // Get cached user
          final user = _authRepository.getCurrentUser();
          if (user != null) {
            debugPrint('Got cached user: ${user.email}');
            currentUser.value = user;
            _isAuthenticated.value = true;
            _webSocketService.onAuthStateChanged(true);

            // Try to refresh user profile (this will trigger token refresh if needed)
            _refreshProfileInBackground();
          } else {
            debugPrint('No cached user found');
            _isAuthenticated.value = false;
          }
        } else {
          debugPrint('No token found');
          _isAuthenticated.value = false;
        }
      } else {
        debugPrint('User is not logged in');
        _isAuthenticated.value = false;
      }
    } catch (e) {
      debugPrint('Error checking auth status: $e');
      _isAuthenticated.value = false;
    } finally {
      _setLoading(false);
      debugPrint('=== Enhanced checkAuthStatus completed ===');
    }
  }

  /// Background profile refresh without affecting UI loading state
  Future<void> _refreshProfileInBackground() async {
    try {
      final result = await _authRepository.getProfile();
      if (result.isSuccess && result.data != null) {
        currentUser.value = result.data;
        debugPrint('Background profile refresh successful');
      }
    } catch (e) {
      debugPrint('Background profile refresh failed: $e');
      // Don't show error to user for background operations
    }
  }

  /// Enhanced login with automatic token refresh setup
  Future<bool> login(String email, String password, BuildContext context) async {
    debugPrint('=== Starting enhanced login ===');
    _setLoading(true);
    _clearError();

    try {
      final result = await _loginUseCase.execute(email, password);

      if (result.isSuccess && result.data != null) {
        debugPrint('Login successful for user: ${result.data!.email}');
        currentUser.value = result.data;
        _isAuthenticated.value = true;

        // Connect WebSocket and start background refresh
        _webSocketService.onAuthStateChanged(true);
        BackgroundTokenRefreshManager.startBackgroundRefresh();

        _setLoading(false);
        _navigateAfterLogin();
        _showSuccessNotification(context, 'Welcome back, ${result.data!.firstName}!');

        return true;
      } else {
        _setError(result.error ?? 'Login failed', context);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      debugPrint('Login error: $e');
      _setError('An unexpected error occurred', context);
      _setLoading(false);
      return false;
    }
  }

  /// Navigate based on user role
  void _navigateAfterLogin() {
    if (isSuperAdmin) {
      Get.offAllNamed('/super-admin');
    } else if (isAdmin) {
      Get.offAllNamed('/admin');
    } else {
      Get.offAllNamed('/home');
    }
  }

  /// Enhanced register with token refresh integration
  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
    required BuildContext context,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _registerUseCase.execute(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );

      if (result.isSuccess && result.data != null) {
        currentUser.value = result.data;
        _isAuthenticated.value = true;

        _webSocketService.onAuthStateChanged(true);
        BackgroundTokenRefreshManager.startBackgroundRefresh();

        _setLoading(false);
        _navigateAfterLogin();
        _showSuccessMessage('Account created successfully! Welcome, ${result.data!.firstName}!');

        return true;
      } else {
        _setError(result.error ?? 'Registration failed', context);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('An unexpected error occurred', context);
      _setLoading(false);
      return false;
    }
  }

  /// Update profile with automatic token refresh
  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    String? phone,
    DateTime? dateOfBirth,
    String? gender,
    required BuildContext context,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authRepository.updateProfile(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        dateOfBirth: dateOfBirth,
        gender: gender,
      );

      if (result.isSuccess && result.data != null) {
        currentUser.value = result.data;
        _setLoading(false);
        _showSuccessMessage('Profile updated successfully');
        return true;
      } else {
        _setError(result.error ?? 'Profile update failed', context);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('An unexpected error occurred', context);
      _setLoading(false);
      return false;
    }
  }

  /// Change password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required BuildContext context,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authRepository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      if (result.isSuccess) {
        _setLoading(false);
        _showSuccessMessage('Password changed successfully');
        return true;
      } else {
        _setError(result.error ?? 'Password change failed', context);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('An unexpected error occurred', context);
      _setLoading(false);
      return false;
    }
  }

  /// Enhanced logout with proper cleanup
  Future<void> logout() async {
    debugPrint('=== Starting enhanced logout ===');
    _setLoading(true);

    try {
      // Stop background token refresh immediately
      BackgroundTokenRefreshManager.stopBackgroundRefresh();

      // Disconnect WebSocket
      _webSocketService.onAuthStateChanged(false);

      // Clear authentication data from repository
      await _authRepository.logout();

      // Reset controller state
      currentUser.value = null;
      _isAuthenticated.value = false;
      _clearError();

      _setLoading(false);

      // Navigate to login
      Get.offAllNamed('/login');
      _showInfoMessage('You have been logged out');

      debugPrint('✅ Enhanced logout completed');
    } catch (e) {
      debugPrint('Logout error: $e');
      // Even if there's an error, clear local state
      currentUser.value = null;
      _isAuthenticated.value = false;
      BackgroundTokenRefreshManager.stopBackgroundRefresh();
      _setLoading(false);
      Get.offAllNamed('/login');
    }
  }

  /// Handle token refresh failure from interceptor
  Future<void> handleTokenRefreshFailure() async {
    debugPrint('🚫 Token refresh failed - logging out user');
    await logout();
  }

  /// Public method to refresh user profile
  Future<void> refreshProfile() async {
    if (!_isAuthenticated.value) return;

    try {
      final result = await _authRepository.getProfile();
      if (result.isSuccess && result.data != null) {
        currentUser.value = result.data;
        debugPrint('Manual profile refresh successful');
      }
    } catch (e) {
      debugPrint('Manual profile refresh failed: $e');
    }
  }

  /// Forgot password
  Future<bool> forgotPassword(String email, BuildContext context) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authRepository.forgotPassword(email);
      if (result.isSuccess) {
        _setLoading(false);
        _showInfoMessage('Password reset email sent');
        return true;
      } else {
        _setError(result.error ?? 'Failed to send reset email', context);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('An unexpected error occurred', context);
      _setLoading(false);
      return false;
    }
  }

  /// Reset password
  Future<bool> resetPassword({
    required String token,
    required String newPassword,
    required BuildContext context,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authRepository.resetPassword(
        token: token,
        newPassword: newPassword,
      );
      if (result.isSuccess) {
        _setLoading(false);
        _showSuccessMessage('Password reset successfully');
        Get.offAllNamed('/login');
        return true;
      } else {
        _setError(result.error ?? 'Password reset failed', context);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('An unexpected error occurred', context);
      _setLoading(false);
      return false;
    }
  }

  // Helper methods
  void _setLoading(bool loading) => _isLoading.value = loading;

  void _setError(String error, BuildContext context) {
    _error.value = error;
    if (error.isNotEmpty) {
      _showErrorNotification(context, error);
    }
  }

  void _clearError() => _error.value = '';

  void _showSuccessNotification(BuildContext context, String message) {
    // Use your preferred notification method
    Get.showSnackbar(GetSnackBar(
      message: message,
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    ));
  }

  void _showErrorNotification(BuildContext context, String message) {
    Get.showSnackbar(GetSnackBar(
      message: message,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 4),
      snackPosition: SnackPosition.TOP,
      icon: const Icon(Icons.error, color: Colors.white),
    ));
  }

  void _showSuccessMessage(String message) {
    Get.showSnackbar(GetSnackBar(
      message: message,
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    ));
  }

  void _showInfoMessage(String message) {
    Get.showSnackbar(GetSnackBar(
      message: message,
      backgroundColor: Colors.blue,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
      icon: const Icon(Icons.info, color: Colors.white),
    ));
  }

  // Utility methods
  void clearError() => _clearError();

  bool hasRole(String role) => currentUser.value?.roleNames.contains(role) ?? false;

  bool hasAnyRole(List<String> roles) {
    if (currentUser.value == null) return false;
    return roles.any((role) => currentUser.value!.roleNames.contains(role));
  }

  bool hasPermission(String permission) {
    if (isSuperAdmin) return true;
    // Add more specific permission checking logic here
    return false;
  }

  // Extension method checker for dynamic method calls
  bool hasMethod(String methodName) {
    switch (methodName) {
      case 'logout':
      case 'refreshProfile':
      case 'handleTokenRefreshFailure':
        return true;
      default:
        return false;
    }
  }
}