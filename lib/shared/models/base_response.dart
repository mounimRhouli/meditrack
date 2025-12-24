// lib/shared/models/base_response.dart

/// A generic wrapper for API or service responses.
/// [T] is the type of the data payload on success.
class BaseResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final String? error;

  BaseResponse.success({this.message, this.data})
      : success = true,
        error = null;

  BaseResponse.failure({this.message, required this.error})
      : success = false,
        data = null;

  @override
  String toString() {
    return 'BaseResponse(success: $success, message: $message, data: $data, error: $error)';
  }
}