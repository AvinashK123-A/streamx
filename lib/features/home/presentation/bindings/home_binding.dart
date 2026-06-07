import 'package:get/get.dart';
import '../../data/datasources/video_datasource.dart';
import '../../data/repositories/video_repository_impl.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideoDataSource>(() => VideoDataSourceImpl());
    Get.lazyPut<VideoRepositoryImpl>(() => VideoRepositoryImpl(Get.find<VideoDataSource>()));
    Get.lazyPut<HomeController>(() => HomeController(videoRepository: Get.find<VideoRepositoryImpl>()));
  }
}
