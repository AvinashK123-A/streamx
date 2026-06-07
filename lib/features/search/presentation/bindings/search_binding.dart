import 'package:get/get.dart';
import '../../../home/data/datasources/video_datasource.dart';
import '../../../home/data/repositories/video_repository_impl.dart';
import '../controllers/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<VideoDataSource>()) {
      Get.lazyPut<VideoDataSource>(() => VideoDataSourceImpl());
    }
    if (!Get.isRegistered<VideoRepositoryImpl>()) {
      Get.lazyPut<VideoRepositoryImpl>(() => VideoRepositoryImpl(Get.find<VideoDataSource>()));
    }
    Get.lazyPut<SearchController>(() => SearchController(videoRepository: Get.find<VideoRepositoryImpl>()));
  }
}
