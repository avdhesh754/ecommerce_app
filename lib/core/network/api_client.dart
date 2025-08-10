import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' as getx;
import '../constants/api_endpoints.dart';
import '../constants/app_constants.dart';
import '../storage/storage_service.dart';

class ApiClient {
  late Dio _dio;
  late StorageService _storageService;
  final String baseUrl;
  final Duration timeout;
  final bool enableLogging;

  ApiClient({
    required this.baseUrl,
    required this.timeout,
    this.enableLogging = false,
  }) {
    _initializeServices();
  }

  void _initializeServices() {
    try {
      _storageService = getx.Get.find<StorageService>();
    } catch (e) {
      _storageService = StorageService();
    }
    _initializeDio();
  }

  void _initializeDio() {
    if (enableLogging) {
      debugPrint('🔧 Initializing Dio with base URL: $baseUrl');
    }

    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: timeout,
      receiveTimeout: timeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) {
        if (enableLogging) {
          debugPrint('🔍 Response status: $status');
        }
        return status != null && status < 500;
      },
    ));

    // Enhanced Auth Interceptor with token refresh
    _dio.interceptors.add(EnhancedAuthInterceptor(_storageService, enableLogging));

    if (enableLogging) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        error: true,
        logPrint: (object) => debugPrint('🔍 API: $object'),
      ));
    }
  }

  Future<Response<T>> get<T>(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
      }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> post<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> put<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response<T>> delete<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> upload<T>(
      String path,
      FormData formData, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
      }) {
    return _dio.post<T>(
      path,
      data: formData,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );
  }
}

// Enhanced Auth Interceptor with automatic token refresh and request queuing
class EnhancedAuthInterceptor extends Interceptor {
  final StorageService _storageService;
  final bool enableLogging;

  // Token refresh management
  bool _isRefreshing = false;
  final List<_QueuedRequest> _requestQueue = [];
  final Completer<bool>? _refreshCompleter = null;
  Completer<bool>? _currentRefreshCompleter;

  EnhancedAuthInterceptor(this._storageService, this.enableLogging);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add authorization header if token exists and not a refresh token request
    if (!_isRefreshTokenRequest(options.path)) {
      final token = _storageService.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';

        if (enableLogging) {
          debugPrint('🔐 Added Bearer token to ${options.method} ${options.path}');
        }
      }
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (enableLogging) {
      debugPrint('✅ ${response.requestOptions.method} ${response.requestOptions.path} - ${response.statusCode}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (enableLogging) {
      debugPrint('❌ ${err.requestOptions.method} ${err.requestOptions.path} - ${err.response?.statusCode}');
    }

    // Handle 401 Unauthorized - Token might be expired
    if (err.response?.statusCode == 401 &&
        !_isRefreshTokenRequest(err.requestOptions.path) &&
        !_isLoginRequest(err.requestOptions.path)) {

      if (enableLogging) {
        debugPrint('🔄 Token expired, attempting refresh...');
      }

      try {
        final refreshSuccess = await _handleTokenRefresh();

        if (refreshSuccess) {
          // Retry the original request with new token
          final retryResponse = await _retryRequest(err.requestOptions);
          return handler.resolve(retryResponse);
        } else {
          // Refresh failed, handle authentication failure
          await _handleAuthenticationFailure();
        }
      } catch (refreshError) {
        if (enableLogging) {
          debugPrint('🚫 Token refresh error: $refreshError');
        }
        await _handleAuthenticationFailure();
      }
    }

    handler.next(err);
  }

  Future<bool> _handleTokenRefresh() async {
    // If already refreshing, wait for the current refresh to complete
    if (_isRefreshing) {
      if (_currentRefreshCompleter != null) {
        return await _currentRefreshCompleter!.future;
      }
      return false;
    }

    _isRefreshing = true;
    _currentRefreshCompleter = Completer<bool>();

    try {
      final refreshToken = _storageService.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        if (enableLogging) {
          debugPrint('🚫 No refresh token available');
        }
        _currentRefreshCompleter!.complete(false);
        return false;
      }

      if (enableLogging) {
        debugPrint('🔄 Starting token refresh...');
      }

      // Create a separate Dio instance for token refresh to avoid interceptor loops
      final refreshDio = Dio(BaseOptions(
        baseUrl: _storageService.getToken() != null ? '' : AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ));

      final response = await refreshDio.post(
        '${AppConstants.baseUrl}${ApiEndpoints.refreshToken}',
        data: {'refreshToken': refreshToken},
        options: Options(
          headers: {'Authorization': 'Bearer $refreshToken'},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Handle different response structures
        Map<String, dynamic> tokenData;
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          tokenData = data['data'] as Map<String, dynamic>;
        } else if (data is Map<String, dynamic>) {
          tokenData = data;
        } else {
          throw Exception('Invalid token refresh response format');
        }

        // Extract tokens with fallback for different key formats
        final newAccessToken = tokenData['accessToken'] ??
            tokenData['access_token'] ??
            tokenData['token'];

        final newRefreshToken = tokenData['refreshToken'] ??
            tokenData['refresh_token'] ??
            refreshToken; // Use existing if not provided

        if (newAccessToken == null) {
          throw Exception('No access token in refresh response');
        }

        // Save new tokens
        await _storageService.saveToken(newAccessToken);
        if (newRefreshToken != null && newRefreshToken != refreshToken) {
          await _storageService.saveRefreshToken(newRefreshToken);
        }

        if (enableLogging) {
          debugPrint('✅ Token refreshed successfully');
        }

        // Process queued requests with new token
        await _processQueuedRequests(newAccessToken);

        _currentRefreshCompleter!.complete(true);
        return true;
      } else {
        if (enableLogging) {
          debugPrint('🚫 Token refresh failed with status: ${response.statusCode}');
        }
        _currentRefreshCompleter!.complete(false);
        return false;
      }
    } catch (e) {
      if (enableLogging) {
        debugPrint('🚫 Token refresh exception: $e');
      }
      _currentRefreshCompleter!.complete(false);
      return false;
    } finally {
      _isRefreshing = false;
      _currentRefreshCompleter = null;
      _requestQueue.clear();
    }
  }

  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    final token = _storageService.getToken();
    if (token != null) {
      requestOptions.headers['Authorization'] = 'Bearer $token';
    }

    if (enableLogging) {
      debugPrint('🔄 Retrying request: ${requestOptions.method} ${requestOptions.path}');
    }

    final dio = Dio();
    return await dio.fetch(requestOptions);
  }

  Future<void> _processQueuedRequests(String newToken) async {
    if (_requestQueue.isEmpty) return;

    if (enableLogging) {
      debugPrint('🔄 Processing ${_requestQueue.length} queued requests');
    }

    for (final queuedRequest in List.from(_requestQueue)) {
      try {
        queuedRequest.requestOptions.headers['Authorization'] = 'Bearer $newToken';
        final response = await Dio().fetch(queuedRequest.requestOptions);
        queuedRequest.completer.complete(response);
      } catch (e) {
        queuedRequest.completer.completeError(e);
      }
    }

    _requestQueue.clear();
  }

  Future<void> _handleAuthenticationFailure() async {
    if (enableLogging) {
      debugPrint('🚫 Authentication failure - clearing auth data');
    }

    await _storageService.clearAuthData();

    // Navigate to login if AuthController is available
    try {
      if (getx.Get.isRegistered<dynamic>()) {
        // Try to get AuthController and trigger logout
        final authControllerType = getx.Get.find<dynamic>().runtimeType.toString();
        if (authControllerType.contains('AuthController')) {
          final authController = getx.Get.find<dynamic>();
          if (authController != null && authController.hasMethod('logout')) {
            await authController.logout();
            return;
          }
        }
      }
    } catch (e) {
      if (enableLogging) {
        debugPrint('Could not access AuthController: $e');
      }
    }

    // Fallback navigation
    try {
      getx.Get.offAllNamed('/login');
    } catch (e) {
      if (enableLogging) {
        debugPrint('Could not navigate to login: $e');
      }
    }
  }

  bool _isRefreshTokenRequest(String path) {
    return path.contains('refresh-token') || path.contains('refresh_token');
  }

  bool _isLoginRequest(String path) {
    return path.contains('/login') || path.contains('/auth/login');
  }
}

// Helper class for queuing requests during token refresh
class _QueuedRequest {
  final RequestOptions requestOptions;
  final Completer<Response> completer;

  _QueuedRequest(this.requestOptions, this.completer);
}

// Token validation utility
class TokenValidator {
  static bool isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payload = parts[1];
      final normalizedPayload = base64Url.normalize(payload);
      final decodedBytes = base64Url.decode(normalizedPayload);
      final decodedString = utf8.decode(decodedBytes);
      final Map<String, dynamic> tokenData = json.decode(decodedString);

      final exp = tokenData['exp'] as int?;
      if (exp == null) return false;

      final expirationDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final now = DateTime.now();

      // Consider token expired if it expires within the next 5 minutes
      return expirationDate.isBefore(now.add(const Duration(minutes: 5)));
    } catch (e) {
      return true; // Consider expired if we can't decode
    }
  }

  static Duration? getTokenTimeToExpiry(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final normalizedPayload = base64Url.normalize(payload);
      final decodedBytes = base64Url.decode(normalizedPayload);
      final decodedString = utf8.decode(decodedBytes);
      final Map<String, dynamic> tokenData = json.decode(decodedString);

      final exp = tokenData['exp'] as int?;
      if (exp == null) return null;

      final expirationDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final now = DateTime.now();

      return expirationDate.difference(now);
    } catch (e) {
      return null;
    }
  }
}

// Background Token Refresh Manager
class BackgroundTokenRefreshManager {
  static Timer? _refreshTimer;
  static const Duration _refreshInterval = Duration(minutes: 10); // Check every 10 minutes

  static void startBackgroundRefresh() {
    stopBackgroundRefresh(); // Stop any existing timer

    _refreshTimer = Timer.periodic(_refreshInterval, (timer) async {
      await _checkAndRefreshToken();
    });

    debugPrint('🔄 Background token refresh started');
  }

  static void stopBackgroundRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
    debugPrint('🛑 Background token refresh stopped');
  }

  static Future<void> _checkAndRefreshToken() async {
    try {
      if (!getx.Get.isRegistered<StorageService>()) return;

      final storageService = getx.Get.find<StorageService>();
      final token = storageService.getToken();

      if (token == null) {
        stopBackgroundRefresh();
        return;
      }

      // Check if token will expire soon (within 15 minutes)
      final timeToExpiry = TokenValidator.getTokenTimeToExpiry(token);
      if (timeToExpiry != null && timeToExpiry.inMinutes <= 15 && timeToExpiry.inMinutes > 0) {
        debugPrint('🔄 Token expiring soon (${timeToExpiry.inMinutes} minutes), triggering refresh check...');

        // The token refresh will happen automatically on the next API request
        // We could also trigger a manual profile refresh here
        try {
          if (getx.Get.isRegistered<dynamic>()) {
            // Try to trigger a profile refresh which will handle token refresh if needed
            final authController = getx.Get.find<dynamic>();
            if (authController != null && authController.hasMethod('refreshProfile')) {
              await authController.refreshProfile();
            }
          }
        } catch (e) {
          debugPrint('Background refresh trigger failed: $e');
        }
      }
    } catch (e) {
      debugPrint('Background token refresh check failed: $e');
    }
  }
}

// Enhanced ApiException with better error handling
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;
  final dynamic data;
  final Map<String, dynamic>? details;

  const ApiException({
    required this.message,
    this.statusCode,
    this.errorCode,
    this.data,
    this.details,
  });

  factory ApiException.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(
          message: 'Connection timeout. Please check your internet connection.',
        );

      case DioExceptionType.badResponse:
        final response = dioError.response;
        String message = 'Something went wrong';
        String? errorCode;
        Map<String, dynamic>? details;

        if (response?.data != null) {
          final data = response!.data;

          // Handle different API error response structures
          if (data is Map<String, dynamic>) {
            // Check for nested error structure: { "error": { "message": ["Invalid credentials"] } }
            if (data.containsKey('error') && data['error'] is Map<String, dynamic>) {
              final error = data['error'] as Map<String, dynamic>;
              if (error.containsKey('message')) {
                final errorMessage = error['message'];
                if (errorMessage is List && errorMessage.isNotEmpty) {
                  message = errorMessage.first.toString();
                } else if (errorMessage is String) {
                  message = errorMessage;
                }
              }
              errorCode = error['code']?.toString();
              details = error['details'];
            }
            // Check for direct message field: { "message": "Error message" }
            else if (data.containsKey('message') && data['message'] is String) {
              message = data['message'];
            }
            // Check for message array: { "message": ["Error message"] }
            else if (data.containsKey('message') && data['message'] is List) {
              final messageList = data['message'] as List;
              if (messageList.isNotEmpty) {
                message = messageList.first.toString();
              }
            }

            // Extract error code and details from main data
            errorCode ??= data['error_code']?.toString() ?? data['code']?.toString();
            details ??= data['details'];
          }
        }

        return ApiException(
          message: message,
          statusCode: response?.statusCode,
          errorCode: errorCode,
          data: response?.data,
          details: details,
        );

      case DioExceptionType.cancel:
        return const ApiException(message: 'Request was cancelled');

      case DioExceptionType.connectionError:
        return const ApiException(
          message: 'No internet connection. Please check your network settings.',
        );

      case DioExceptionType.badCertificate:
        return const ApiException(message: 'Certificate error');

      case DioExceptionType.unknown:
        if (dioError.error is SocketException) {
          return const ApiException(
            message: 'No internet connection. Please check your network settings.',
          );
        }
        return ApiException(
          message: dioError.message ?? 'Unexpected error occurred',
        );
    }
  }

  @override
  String toString() => 'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}