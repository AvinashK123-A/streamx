import 'package:dartz/dartz.dart';
import '../utils/failure.dart';

/// Base use case interface for clean architecture
/// 
/// All use cases in the domain layer implement this interface.
/// T is the return type, P is the parameters type.
abstract class UseCase<T, P> {
  Future<Either<Failure, T>> call(P params);
}

/// Use case with no parameters
abstract class NoParamsUseCase<T> {
  Future<Either<Failure, T>> call();
}

/// Synchronous use case
abstract class SyncUseCase<T, P> {
  Either<Failure, T> call(P params);
}

/// No operation parameters - used for use cases with no params
class NoParams {
  const NoParams();
}
