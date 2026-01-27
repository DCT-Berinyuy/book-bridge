import 'package:equatable/equatable.dart';

/// Base class for all failures in the application.
/// This is used with `Either<Failure, Success>` pattern (from dartz).
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Failure for authentication-related errors.
class AuthFailure extends Failure {
  const AuthFailure({required super.message});
}

/// Failure for server/network-related errors.
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

/// Failure for generic/unexpected errors.
class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}

/// Failure when user is not authenticated.
class NotAuthenticatedFailure extends Failure {
  const NotAuthenticatedFailure({required super.message});
}
