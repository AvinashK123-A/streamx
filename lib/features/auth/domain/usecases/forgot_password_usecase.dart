import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/use_case.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase implements UseCase<void, ForgotPasswordParams> {
  final AuthRepository _repository;
  ForgotPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(ForgotPasswordParams params) {
    return _repository.forgotPassword(email: params.email);
  }
}

class ForgotPasswordParams {
  final String email;
  const ForgotPasswordParams({required this.email});
}
