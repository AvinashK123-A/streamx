import 'package:equatable/equatable.dart';

/// Base failure class for error handling throughout the app
/// 
/// Follows clean architecture's failure handling pattern.
/// All failures extend this base class.
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Network connectivity failures
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Server-side failures (5xx errors)
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Authentication failures (401, 403)
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Input validation failures (400, 422)
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Cache/Local storage failures
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Not found failures (404)
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}
