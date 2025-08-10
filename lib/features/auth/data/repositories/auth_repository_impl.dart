import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/utils/auth_result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository_interface.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';
import '../../../../core/network/api_client.dart';

class AuthRepositoryImpl implements AuthRepositoryInterface {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<AuthResult<UserEntity>> login(String email, String password) async {
    try {
      final loginData = await _remoteDataSource.login(email, password);
      
      final user = UserModel.fromJson(loginData['user']);
      final accessToken = loginData['access_token'] as String;
      final refreshToken = loginData['refresh_token'] as String?;

      await Future.wait([
        _localDataSource.saveUser(user),
        _localDataSource.saveTokens(accessToken, refreshToken),
      ]);

      return AuthResult.success(user);
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return AuthResult.failure(apiException.message);
    } catch (e) {
      debugPrint('Login error: $e');
      return AuthResult.failure('Login error: $e');
    }
  }

  @override
  Future<AuthResult<UserEntity>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    try {
      final registerData = await _remoteDataSource.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );

      final user = UserModel.fromJson(registerData['user']);
      final accessToken = registerData['access_token'] as String;
      final refreshToken = registerData['refresh_token'] as String?;

      await Future.wait([
        _localDataSource.saveUser(user),
        _localDataSource.saveTokens(accessToken, refreshToken),
      ]);

      return AuthResult.success(user);
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return AuthResult.failure(apiException.message);
    } catch (e) {
      debugPrint('Registration error: $e');
      return AuthResult.failure('An unexpected error occurred');
    }
  }

  @override
  Future<AuthResult<UserEntity>> getProfile() async {
    try {
      final user = await _remoteDataSource.getProfile();
      await _localDataSource.saveUser(user);
      return AuthResult.success(user);
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return AuthResult.failure(apiException.message);
    } catch (e) {
      debugPrint('Get profile error: $e');
      return AuthResult.failure('An unexpected error occurred');
    }
  }

  @override
  Future<AuthResult<UserEntity>> updateProfile({
    required String firstName,
    required String lastName,
    String? phone,
    DateTime? dateOfBirth,
    String? gender,
  }) async {
    try {
      final user = await _remoteDataSource.updateProfile(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        dateOfBirth: dateOfBirth,
        gender: gender,
      );
      await _localDataSource.saveUser(user);
      return AuthResult.success(user);
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return AuthResult.failure(apiException.message);
    } catch (e) {
      debugPrint('Update profile error: $e');
      return AuthResult.failure('An unexpected error occurred');
    }
  }

  @override
  Future<AuthResult<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return AuthResult.success(null);
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return AuthResult.failure(apiException.message);
    } catch (e) {
      debugPrint('Change password error: $e');
      return AuthResult.failure('An unexpected error occurred');
    }
  }

  @override
  Future<AuthResult<void>> forgotPassword(String email) async {
    try {
      await _remoteDataSource.forgotPassword(email);
      return AuthResult.success(null);
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return AuthResult.failure(apiException.message);
    } catch (e) {
      debugPrint('Forgot password error: $e');
      return AuthResult.failure('An unexpected error occurred');
    }
  }

  @override
  Future<AuthResult<void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.resetPassword(
        token: token,
        newPassword: newPassword,
      );
      return AuthResult.success(null);
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return AuthResult.failure(apiException.message);
    } catch (e) {
      debugPrint('Reset password error: $e');
      return AuthResult.failure('An unexpected error occurred');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _localDataSource.clearAuthData();
    } catch (e) {
      debugPrint('Logout error: $e');
      await _localDataSource.clearAuthData();
    }
  }

  @override
  UserEntity? getCurrentUser() {
    return _localDataSource.getUser();
  }

  @override
  bool get isLoggedIn => _localDataSource.isLoggedIn;
}
