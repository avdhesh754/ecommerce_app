

import '../../../../core/utils/auth_result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository_interface.dart';

class LoginUseCase {
  final AuthRepositoryInterface _repository;

  LoginUseCase(this._repository);

  Future<AuthResult<UserEntity>> execute(String email, String password) async {
    // Add business logic validation here if needed
    if (email.isEmpty || password.isEmpty) {
      return AuthResult.failure('Email and password are required');
    }

    if (!_isValidEmail(email)) {
      return AuthResult.failure('Please enter a valid email address');
    }

    if (password.length < 6) {
      return AuthResult.failure('Password must be at least 6 characters');
    }

    return await _repository.login(email, password);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
