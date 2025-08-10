import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'app/app.dart';
import 'core/config/environment.dart';
import 'core/storage/storage_service.dart';
import 'core/services/websocket_service.dart';
import 'core/network/api_client.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/domain/repositories/auth_repository_interface.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'core/utils/logger.dart';

Future<void> runAppWithEnvironment() async {
  // Initialize services
  await _initializeServices();
  
  // Configure logging based on environment  
  if (EnvironmentConfig.enableLogging) {
    Logger.init(
      level: EnvironmentConfig.isDevelopment ? LogLevel.debug : LogLevel.info,
    );
  }
  
  // Configure Flutter framework based on environment
  if (EnvironmentConfig.enableDebugMode && kDebugMode) {
    // Enable additional debugging features
    debugPaintSizeEnabled = false; // Set to true if you want to see widget bounds
  }
  
  // Log environment information
  Logger.info('Starting app in ${EnvironmentConfig.currentEnvironment.name} environment');
  Logger.info('API Base URL: ${EnvironmentConfig.apiBaseUrl}');
  Logger.info('App Name: ${EnvironmentConfig.appName}');
  
  // Run the app
  runApp(const CosmeticEcommerceApp());
}

Future<void> _initializeServices() async {
  try {
    // Initialize storage service first
    final storageService = StorageService();
    await storageService.init();
    Get.put(storageService, permanent: true);
    
    // Wait a bit to ensure storage is ready
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Initialize API client with environment-specific configuration
    final apiClient = ApiClient(
      baseUrl: EnvironmentConfig.apiBaseUrl,
      timeout: EnvironmentConfig.requestTimeout,
      enableLogging: EnvironmentConfig.enableLogging,
    );
    Get.put(apiClient, permanent: true);
    
    // Initialize WebSocket service with environment-specific URL
    final websocketService = WebSocketService();
    Get.put(websocketService, permanent: true);
    
    // Initialize data sources
    final authRemoteDataSource = AuthRemoteDataSourceImpl(apiClient);
    final authLocalDataSource = AuthLocalDataSourceImpl(storageService);
    
    // Initialize auth repository
    final authRepository = AuthRepositoryImpl(authRemoteDataSource, authLocalDataSource);
    Get.put<AuthRepositoryInterface>(authRepository, permanent: true);
    
    // Initialize use cases
    final loginUseCase = LoginUseCase(authRepository);
    final registerUseCase = RegisterUseCase(authRepository);
    
    // Initialize auth controller
    final authController = AuthController(
      loginUseCase: loginUseCase,
      registerUseCase: registerUseCase,
      authRepository: authRepository,
    );
    Get.put(authController, permanent: true);
    
    Logger.info('Services initialized successfully');
    
  } catch (e, stackTrace) {
    Logger.error('Failed to initialize services', e, stackTrace);
    
    // In production, you might want to show a user-friendly error screen
    if (EnvironmentConfig.isProduction) {
      // Handle initialization failure gracefully
      runApp(const _InitializationErrorApp());
      return;
    }
    
    rethrow;
  }
}

// Error app to show when initialization fails in production
class _InitializationErrorApp extends StatelessWidget {
  const _InitializationErrorApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cosmetic Store',
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please try again later',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Restart the app
                  runAppWithEnvironment();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}