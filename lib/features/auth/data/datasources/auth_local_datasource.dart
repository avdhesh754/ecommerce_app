import '../../../../core/storage/storage_service.dart';
import '../models/user_model.dart';
import '../../../../shared/models/user_model.dart' as SharedUserModel;
import '../../../../core/enums/user_role.dart' as SharedUserRole;

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);
  Future<void> saveTokens(String accessToken, String? refreshToken);
  UserModel? getUser();
  String? getToken();
  String? getRefreshToken();
  bool get isLoggedIn;
  Future<void> clearAuthData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final StorageService _storageService;

  AuthLocalDataSourceImpl(this._storageService);

  @override
  Future<void> saveUser(UserModel user) async {
    // Convert to SharedUserModel for storage
    final sharedUser = _convertToSharedUserModel(user);
    await _storageService.saveUser(sharedUser);
  }

  @override
  Future<void> saveTokens(String accessToken, String? refreshToken) async {
    await _storageService.saveToken(accessToken);
    if (refreshToken != null) {
      await _storageService.saveRefreshToken(refreshToken);
    }
  }

  @override
  UserModel? getUser() {
    final sharedUser = _storageService.getUser();
    return sharedUser != null ? _convertFromSharedUserModel(sharedUser) : null;
  }

  @override
  String? getToken() {
    return _storageService.getToken();
  }

  @override
  String? getRefreshToken() {
    return _storageService.getRefreshToken();
  }

  @override
  bool get isLoggedIn => _storageService.isLoggedIn;

  @override
  Future<void> clearAuthData() async {
    await _storageService.clearAuthData();
  }

  // Helper methods to convert between UserModel types
  SharedUserModel.UserModel _convertToSharedUserModel(UserModel authUser) {
    return SharedUserModel.UserModel(
      id: authUser.id,
      email: authUser.email,
      firstName: authUser.firstName,
      lastName: authUser.lastName,
      phone: authUser.phone,
      dateOfBirth: authUser.dateOfBirth,
      gender: authUser.gender,
      isActive: authUser.isActive,
      emailVerified: true, // Default for now
      avatarUrl: null, // Not available in auth UserModel
      lastLogin: null, // Not available in auth UserModel
      roles: authUser.roles.map((role) {
        switch (role) {
          case 'admin':
            return SharedUserRole.UserRole.admin;
          case 'super_admin':
          case 'superadmin':
            return SharedUserRole.UserRole.superAdmin;
          case 'customer':
          default:
            return SharedUserRole.UserRole.customer;
        }
      }).toList(),
      permissions: [], // Empty for now
      createdAt: authUser.createdAt,
      updatedAt: authUser.updatedAt ?? authUser.createdAt,
    );
  }

  UserModel _convertFromSharedUserModel(SharedUserModel.UserModel sharedUser) {
    return UserModel(
      id: sharedUser.id,
      email: sharedUser.email,
      firstName: sharedUser.firstName,
      lastName: sharedUser.lastName,
      phone: sharedUser.phone,
      dateOfBirth: sharedUser.dateOfBirth,
      gender: sharedUser.gender,
      roles: sharedUser.roles.map((role) => role.value).toList(),
      isActive: sharedUser.isActive,
      createdAt: sharedUser.createdAt,
      updatedAt: sharedUser.updatedAt,
    );
  }
}