import 'package:get/get.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../controllers/auth_controller.dart';

/// GetX Dependency Injection binding for the Auth feature
/// 
/// Wires up all dependencies following the dependency inversion principle.
/// Dependencies are created lazily and scoped to the auth route lifecycle.
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Data Sources
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(Get.find<DioClient>()),
    );
    Get.lazyPut<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(),
    );

    // Repository
    Get.lazyPut<AuthRepositoryImpl>(
      () => AuthRepositoryImpl(
        remoteDataSource: Get.find<AuthRemoteDataSource>(),
        localDataSource: Get.find<AuthLocalDataSource>(),
      ),
    );

    // Use Cases
    Get.lazyPut(() => LoginUseCase(Get.find<AuthRepositoryImpl>()));
    Get.lazyPut(() => SignupUseCase(Get.find<AuthRepositoryImpl>()));
    Get.lazyPut(() => ForgotPasswordUseCase(Get.find<AuthRepositoryImpl>()));

    // Controller
    Get.lazyPut<AuthController>(
      () => AuthController(
        loginUseCase: Get.find<LoginUseCase>(),
        signupUseCase: Get.find<SignupUseCase>(),
        forgotPasswordUseCase: Get.find<ForgotPasswordUseCase>(),
        authRepository: Get.find<AuthRepositoryImpl>(),
      ),
    );
  }
}
