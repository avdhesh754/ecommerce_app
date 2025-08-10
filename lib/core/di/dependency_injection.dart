// lib/core/di/dependency_injection.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository_interface.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../network/api_client.dart';
import '../storage/storage_service.dart';
import '../services/websocket_service.dart';
import '../constants/app_constants.dart';

class DependencyInjection {

  static Future<void> init() async {
    // Core services - Initialize storage first
    await _initCoreServices();

    // Network services - ApiClient with enhanced token refresh
    _initNetworkServices();

    // Other services
    _initOtherServices();

    // Auth feature dependencies
    _initAuthDependencies();
  }

  static Future<void> _initCoreServices() async {
    // Storage Service - Initialize first as other services depend on it
    Get.put(StorageService(), permanent: true);
    await Get.find<StorageService>().init();

    debugPrint('✅ Core services initialized');
  }

  static void _initNetworkServices() {
    // Enhanced ApiClient with automatic token refresh
    Get.put(ApiClient(
      baseUrl: AppConstants.baseUrl,
      timeout: AppConstants.requestTimeout,
      enableLogging: AppConstants.isDevelopment,
    ), permanent: true);

    debugPrint('✅ Network services initialized');
  }

  static void _initOtherServices() {
    // WebSocket Service
    Get.put(WebSocketService(), permanent: true);

    debugPrint('✅ Other services initialized');
  }

  static void _initAuthDependencies() {
    // Data sources
    Get.lazyPut<AuthLocalDataSource>(
          () => AuthLocalDataSourceImpl(Get.find<StorageService>()),
    );

    Get.lazyPut<AuthRemoteDataSource>(
          () => AuthRemoteDataSourceImpl(Get.find<ApiClient>()),
    );

    // Repository
    Get.lazyPut<AuthRepositoryInterface>(
          () => AuthRepositoryImpl(
        Get.find<AuthRemoteDataSource>(),
        Get.find<AuthLocalDataSource>(),
      ),
    );

    // Use cases
    Get.lazyPut(() => LoginUseCase(Get.find<AuthRepositoryInterface>()));
    Get.lazyPut(() => RegisterUseCase(Get.find<AuthRepositoryInterface>()));

    // Controller with enhanced token refresh integration
    Get.lazyPut(() => AuthController(
      loginUseCase: Get.find<LoginUseCase>(),
      registerUseCase: Get.find<RegisterUseCase>(),
      authRepository: Get.find<AuthRepositoryInterface>(),
    ));

    debugPrint('✅ Auth dependencies initialized');
  }

  static void resetAuthDependencies() {
    debugPrint('🔄 Resetting auth dependencies...');

    // Stop background token refresh
    BackgroundTokenRefreshManager.stopBackgroundRefresh();

    // Remove auth-related dependencies for clean logout
    if (Get.isRegistered<AuthController>()) {
      Get.delete<AuthController>();
    }

    if (Get.isRegistered<AuthController>()) {
      Get.delete<AuthController>();
    }

    // Remove use cases
    if (Get.isRegistered<LoginUseCase>()) {
      Get.delete<LoginUseCase>();
    }

    if (Get.isRegistered<RegisterUseCase>()) {
      Get.delete<RegisterUseCase>();
    }

    // Remove repository
    if (Get.isRegistered<AuthRepositoryInterface>()) {
      Get.delete<AuthRepositoryInterface>();
    }

    // Remove data sources
    if (Get.isRegistered<AuthRemoteDataSource>()) {
      Get.delete<AuthRemoteDataSource>();
    }

    if (Get.isRegistered<AuthLocalDataSource>()) {
      Get.delete<AuthLocalDataSource>();
    }

    // Reinitialize auth dependencies
    _initAuthDependencies();

    debugPrint('✅ Auth dependencies reset complete');
  }

  // Initialize dependencies for specific features if needed
  static void initProductDependencies() {
    // Add product feature dependencies here when needed
  }

  static void initOrderDependencies() {
    // Add order feature dependencies here when needed
  }

  // Clean up method for app termination
  static void dispose() {
    BackgroundTokenRefreshManager.stopBackgroundRefresh();

    try {
      final webSocketService = Get.find<WebSocketService>();
      webSocketService.disconnect();
    } catch (e) {
      debugPrint('Error disposing WebSocket service: $e');
    }

    debugPrint('✅ Dependencies disposed');
  }
}

