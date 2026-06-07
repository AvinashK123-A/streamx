import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/storage/hive_storage.dart';
import '../../../../routes/app_routes.dart';
import '../../../home/domain/entities/video.dart';
import '../../../home/domain/repositories/video_repository.dart';

class SearchController extends GetxController {
  final VideoRepository _videoRepository;
  SearchController({required VideoRepository videoRepository}) : _videoRepository = videoRepository;

  final searchController = TextEditingController();
  final RxList<Video> searchResults = <Video>[].obs;
  final RxList<String> recentSearches = <String>[].obs;
  final RxList<String> suggestions = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasSearched = false.obs;
  final RxString currentQuery = ''.obs;

  Timer? _debounce;

  static const List<String> _genres = ['Animation', 'Fantasy', 'Science Fiction', 'Documentary', 'Commercial'];

  @override
  void onInit() {
    super.onInit();
    _loadRecentSearches();
    AnalyticsService.instance.logScreenView('search');
    searchController.addListener(_onSearchChanged);
  }

  @override
  void onClose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    _debounce?.cancel();
    super.onClose();
  }

  void _onSearchChanged() {
    final query = searchController.text;
    currentQuery.value = query;

    if (query.isEmpty) {
      searchResults.clear();
      hasSearched.value = false;
      suggestions.clear();
      return;
    }

    // Show suggestions based on genres
    suggestions.assignAll(
      _genres.where((g) => g.toLowerCase().contains(query.toLowerCase())).toList()
    );

    // Debounce search
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () => _performSearch(query));
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;
    isLoading.value = true;
    hasSearched.value = true;

    final result = await _videoRepository.searchVideos(query: query);
    result.fold(
      (failure) => searchResults.clear(),
      (videos) => searchResults.assignAll(videos),
    );

    isLoading.value = false;
    AnalyticsService.instance.logSearch(searchTerm: query, resultCount: searchResults.length);
  }

  void onSearchSubmit(String query) {
    if (query.isEmpty) return;
    HiveStorage.saveSearchQuery(query);
    _loadRecentSearches();
    _performSearch(query);
    suggestions.clear();
  }

  void onSuggestionTap(String suggestion) {
    searchController.text = suggestion;
    searchController.selection = TextSelection.fromPosition(TextPosition(offset: suggestion.length));
    onSearchSubmit(suggestion);
  }

  void onRecentSearchTap(String query) {
    searchController.text = query;
    searchController.selection = TextSelection.fromPosition(TextPosition(offset: query.length));
    onSearchSubmit(query);
  }

  void onVideoTap(Video video) {
    AnalyticsService.instance.logSearchResultClick(searchTerm: currentQuery.value, videoId: video.id);
    Get.toNamed(AppRoutes.player, arguments: video);
  }

  void clearSearch() {
    searchController.clear();
    searchResults.clear();
    suggestions.clear();
    hasSearched.value = false;
  }

  void removeRecentSearch(String query) {
    HiveStorage.removeSearchQuery(query);
    _loadRecentSearches();
  }

  void clearAllRecentSearches() {
    HiveStorage.clearSearchHistory();
    recentSearches.clear();
  }

  void _loadRecentSearches() {
    recentSearches.assignAll(HiveStorage.getSearchHistory().take(10).toList());
  }

  List<String> get genres => _genres;
}
