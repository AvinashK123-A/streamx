import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/use_case.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Login use case - handles user authentication
class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) {
    return _repository.login(
      email: params.email,
      password: params.password,
      rememberMe: params.rememberMe,
    );
  }
}

class LoginParams {
  final String email;
  final String password;
  final bool rememberMe;
  const LoginParams({required this.email, required this.password, this.rememberMe = false});
}
