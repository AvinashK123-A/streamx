import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../home/domain/entities/video.dart';
import '../controllers/search_controller.dart' as sc;

class SearchView extends GetView<sc.SearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundColor,
        titleSpacing: 0,
        title: TextField(
          controller: controller.searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Search videos, genres...',
            hintStyle: TextStyle(color: Colors.grey[500]),
            border: InputBorder.none,
            filled: false,
          ),
          onSubmitted: controller.onSearchSubmit,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() => controller.currentQuery.value.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: controller.clearSearch,
              )
            : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Obx(() {
        // Loading
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppConstants.primaryColor));
        }

        // Suggestions dropdown
        if (controller.suggestions.isNotEmpty) {
          return _buildSuggestions();
        }

        // Search results
        if (controller.hasSearched.value) {
          return controller.searchResults.isEmpty
              ? _buildNoResults()
              : _buildResults();
        }

        // Default: show recent searches and genre categories
        return _buildDefault(context);
      }),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      itemCount: controller.suggestions.length,
      itemBuilder: (_, index) {
        final suggestion = controller.suggestions[index];
        return ListTile(
          leading: const Icon(Icons.search, color: Colors.grey, size: 18),
          title: Text(suggestion, style: const TextStyle(color: Colors.white)),
          onTap: () => controller.onSuggestionTap(suggestion),
        );
      },
    );
  }

  Widget _buildDefault(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent searches
          Obx(() => controller.recentSearches.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Recent Searches', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      TextButton(
                        onPressed: controller.clearAllRecentSearches,
                        child: const Text('Clear All', style: TextStyle(color: AppConstants.primaryColor, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: controller.recentSearches.map((q) => GestureDetector(
                      onTap: () => controller.onRecentSearchTap(q),
                      child: Chip(
                        label: Text(q, style: const TextStyle(color: Colors.white, fontSize: 12)),
                        backgroundColor: AppConstants.cardColor,
                        deleteIcon: const Icon(Icons.close, color: Colors.grey, size: 14),
                        onDeleted: () => controller.removeRecentSearch(q),
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 24),
                ],
              )
            : const SizedBox.shrink(),
          ),

          // Browse by genre
          const Text('Browse by Genre', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 2.5,
            ),
            itemCount: controller.genres.length,
            itemBuilder: (_, index) {
              final genre = controller.genres[index];
              final colors = [
                [const Color(0xFF1E3A5F), const Color(0xFF4A90D9)],
                [const Color(0xFF3D1A1A), const Color(0xFFE50914)],
                [const Color(0xFF1A3D1A), const Color(0xFF4CAF50)],
                [const Color(0xFF3D2A1A), const Color(0xFFFF9800)],
                [const Color(0xFF2A1A3D), const Color(0xFF9C27B0)],
              ];
              final colorPair = colors[index % colors.length];
              return GestureDetector(
                onTap: () => controller.onSearchSubmit(genre),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: colorPair, begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  ),
                  child: Center(
                    child: Text(genre, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.7,
      ),
      itemCount: controller.searchResults.length,
      itemBuilder: (_, index) {
        final video = controller.searchResults[index];
        return GestureDetector(
          onTap: () => controller.onVideoTap(video),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  child: CachedNetworkImage(
                    imageUrl: video.thumbnailUrl, fit: BoxFit.cover, width: double.infinity,
                    placeholder: (_, __) => Container(color: AppConstants.cardColor, child: const Icon(Icons.movie, color: Colors.grey)),
                    errorWidget: (_, __, ___) => Container(
                      color: AppConstants.cardColor,
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Icon(Icons.movie, color: Colors.grey),
                        Text(video.title, style: const TextStyle(color: Colors.grey, fontSize: 10), textAlign: TextAlign.center),
                      ]),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(video.title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
              Row(children: [
                const Icon(Icons.star, color: Color(0xFFFFC107), size: 10),
                const SizedBox(width: 2),
                Text(video.formattedRating, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                const SizedBox(width: 6),
                Text(video.genre, style: const TextStyle(color: Colors.grey, fontSize: 10)),
              ]),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, color: Colors.grey, size: 64),
          const SizedBox(height: 16),
          Text('No results for "${controller.currentQuery.value}"',
            style: const TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          const Text('Try different keywords or browse by genre', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
