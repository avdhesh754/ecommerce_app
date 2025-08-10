import '../../../../core/utils/auth_result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository_interface.dart';

class RegisterUseCase {
  final AuthRepositoryInterface _repository;

  RegisterUseCase(this._repository);

  Future<AuthResult<UserEntity>> execute({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    // Business logic validation
    if (email.isEmpty || password.isEmpty || firstName.isEmpty || lastName.isEmpty) {
      return AuthResult.failure('All required fields must be filled');
    }

    if (!_isValidEmail(email)) {
      return AuthResult.failure('Please enter a valid email address');
    }

    if (password.length < 6) {
      return AuthResult.failure('Password must be at least 6 characters');
    }

    if (firstName.trim().length < 2) {
      return AuthResult.failure('First name must be at least 2 characters');
    }

    if (lastName.trim().length < 2) {
      return AuthResult.failure('Last name must be at least 2 characters');
    }

    if (phone != null && phone.isNotEmpty && !_isValidPhone(phone)) {
      return AuthResult.failure('Please enter a valid phone number');
    }

    return await _repository.register(
      email: email.trim().toLowerCase(),
      password: password,
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      phone: phone?.trim(),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    return RegExp(r'^\+?[\d\s\-\(\)]{10,}$').hasMatch(phone);
  }
}