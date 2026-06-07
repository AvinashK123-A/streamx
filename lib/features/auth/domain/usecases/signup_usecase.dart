import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/use_case.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignupUseCase implements UseCase<User, SignupParams> {
  final AuthRepository _repository;
  SignupUseCase(this._repository);

  @override
  Future<Either<Failure, User>> call(SignupParams params) {
    return _repository.signup(
      name: params.name, email: params.email, password: params.password,
    );
  }
}

class SignupParams {
  final String name, email, password;
  const SignupParams({required this.name, required this.email, required this.password});
}
