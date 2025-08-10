class ApiResult<T> {
  final bool isSuccess;
  final T? data;
  final String? message;
  final String? error;

  const ApiResult._({
    required this.isSuccess,
    this.data,
    this.message,
    this.error,
  });

  factory ApiResult.success(T? data, [String? message]) {
    return ApiResult._(
      isSuccess: true,
      data: data,
      message: message,
    );
  }

  factory ApiResult.failure(String error) {
    return ApiResult._(
      isSuccess: false,
      error: error,
    );
  }

  bool get isFailure => !isSuccess;
}