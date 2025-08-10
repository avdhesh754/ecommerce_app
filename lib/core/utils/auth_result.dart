class AuthResult<T> {
  final bool isSuccess;
  final T? data;
  final String? message;
  final String? error;

  const AuthResult._({
    required this.isSuccess,
    this.data,
    this.message,
    this.error,
  });

  factory AuthResult.success(T? data, [String? message]) {
    return AuthResult._(
      isSuccess: true,
      data: data,
      message: message,
    );
  }

  factory AuthResult.failure(String error) {
    return AuthResult._(
      isSuccess: false,
      error: error,
    );
  }
}