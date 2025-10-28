class ApiResponse<T> {
  final bool isSuccess;
  final T? data;
  final String? errorMessage;

  ApiResponse._({required this.isSuccess, this.data, this.errorMessage});

  factory ApiResponse.success(T data) {
    return ApiResponse._(isSuccess: true, data: data);
  }

  factory ApiResponse.error(String message) {
    return ApiResponse._(isSuccess: false, errorMessage: message);
  }
}

// Helper responsive methods for different response types
// Return true if screen size is small
