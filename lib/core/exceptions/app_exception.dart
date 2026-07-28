class AppException implements Exception {
  final String code;
  final String message;
  final String? details;

  const AppException({
    required this.code,
    required this.message,
    this.details,
  });

  @override
  String toString() => '[$code] $message${details != null ? ' ($details)' : ''}';
}

class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.details,
  }) : super(code: 'VALIDATION');
}

class NotFoundException extends AppException {
  const NotFoundException({
    required super.message,
    super.details,
  }) : super(code: 'NOT_FOUND');
}

class DuplicateException extends AppException {
  const DuplicateException({
    required super.message,
    super.details,
  }) : super(code: 'DUPLICATE');
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({
    required super.message,
    super.details,
  }) : super(code: 'UNAUTHORIZED');
}

class BusinessException extends AppException {
  const BusinessException({
    required super.message,
    super.details,
  }) : super(code: 'BUSINESS');
}
