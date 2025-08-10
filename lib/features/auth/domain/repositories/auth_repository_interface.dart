import '../../../../core/utils/auth_result.dart';
import '../entities/user_entity.dart';

abstract class AuthRepositoryInterface {
  Future<AuthResult<UserEntity>> login(String email, String password);
  Future<AuthResult<UserEntity>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  });
  Future<AuthResult<UserEntity>> getProfile();
  Future<AuthResult<UserEntity>> updateProfile({
    required String firstName,
    required String lastName,
    String? phone,
    DateTime? dateOfBirth,
    String? gender,
  });
  Future<AuthResult<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  Future<AuthResult<void>> forgotPassword(String email);
  Future<AuthResult<void>> resetPassword({
    required String token,
    required String newPassword,
  });
  Future<void> logout();
  UserEntity? getCurrentUser();
  bool get isLoggedIn;
}