import 'package:get/get.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';
import '../../../auth/data/datasources/auth_remote_datasource.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../../core/network/dio_client.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<DioClient>()) {
      Get.put(DioClient.instance..init());
    }
    if (!Get.isRegistered<AuthRemoteDataSource>()) {
      Get.lazyPut<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(Get.find<DioClient>()));
    }
    if (!Get.isRegistered<AuthLocalDataSource>()) {
      Get.lazyPut<AuthLocalDataSource>(() => AuthLocalDataSourceImpl());
    }
    if (!Get.isRegistered<AuthRepositoryImpl>()) {
      Get.lazyPut<AuthRepositoryImpl>(() => AuthRepositoryImpl(
        remoteDataSource: Get.find<AuthRemoteDataSource>(),
        localDataSource: Get.find<AuthLocalDataSource>(),
      ));
    }
    Get.lazyPut<ProfileController>(() => ProfileController(authRepository: Get.find<AuthRepositoryImpl>()));
  }
}
