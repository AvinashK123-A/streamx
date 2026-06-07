import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  RemoteConfigService._();
  static final RemoteConfigService _instance = RemoteConfigService._();
  static RemoteConfigService get instance => _instance;
  final FirebaseRemoteConfig _rc = FirebaseRemoteConfig.instance;
  static const Map<String, dynamic> _defaults = {
    'featured_videos_limit': 5, 'enable_pip_mode': true,
    'enable_offline_download': false, 'max_video_quality': '1080p',
    'maintenance_mode': false, 'force_update_version': '0.0.0',
    'show_ads': false, 'buffer_duration_seconds': 30, 'enable_analytics': true,
  };
  Future<void> init() async {
    await _rc.setDefaults(_defaults);
    await _rc.setConfigSettings(RemoteConfigSettings(fetchTimeout: const Duration(minutes: 1), minimumFetchInterval: const Duration(hours: 1)));
    await _rc.fetchAndActivate();
  }
  bool get enablePipMode => _rc.getBool('enable_pip_mode');
  bool get enableOfflineDownload => _rc.getBool('enable_offline_download');
  bool get maintenanceMode => _rc.getBool('maintenance_mode');
  bool get enableAnalytics => _rc.getBool('enable_analytics');
  int get featuredVideosLimit => _rc.getInt('featured_videos_limit');
  int get bufferDurationSeconds => _rc.getInt('buffer_duration_seconds');
  String get maxVideoQuality => _rc.getString('max_video_quality');
  String get forceUpdateVersion => _rc.getString('force_update_version');
}
