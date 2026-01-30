import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_bridge/features/listings/presentation/viewmodels/search_viewmodel.dart';

/// Search screen for finding book listings.
///
/// This screen provides a search bar and filters to find books,
/// displaying results in a grid or list format.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(180),
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    // Top bar with logo and notifications
                    Row(
                      children: [
                        const Icon(
                          Icons.menu_book,
                          color: const Color(0xFF1A4D8C), // Primary green
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'BookBridge',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.notifications),
                          onPressed: () {
                            // Notifications functionality
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Search bar
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest
                            .withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).dividerColor.withValues(alpha: 0.1),
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search title, author, or ISBN...',
                          hintStyle: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF9DB9A6), // Light gray
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {});
                          if (value.isNotEmpty) {
                            viewModel.search(value);
                          } else {
                            viewModel.clearSearch();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Academic Categories
                  const Text(
                    'Academic Categories',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio:
                        1.8, // Decreased ratio to provide more height and prevent overflow
                    children: [
                      _buildCategoryItem(
                        'Engineering',
                        Icons.engineering,
                        'Polytechnique',
                      ),
                      _buildCategoryItem('Law', Icons.gavel, 'FSJP'),
                      _buildCategoryItem(
                        'Medicine',
                        Icons.medical_services,
                        'FMSB',
                      ),
                      _buildCategoryItem('Economics', Icons.payments, 'FSEG'),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Recent Searches
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Searches',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Clear all functionality
                        },
                        child: const Text(
                          'Clear All',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF9DB9A6), // Light gray
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Recent search items
                  Column(
                    children: [
                      _buildRecentSearchItem('Organic Chemistry Vol. 2'),
                      _buildRecentSearchItem('Criminal Procedure Code'),
                      _buildRecentSearchItem('Introduction to Macroeconomics'),
                    ],
                  ),

                  // Search results
                  if (viewModel.searchState == SearchState.success &&
                      viewModel.searchResults.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          '${viewModel.searchResults.length} result${viewModel.searchResults.length != 1 ? 's' : ''} found',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio:
                                    0.68, // Increased vertical space for search results
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          itemCount: viewModel.searchResults.length,
                          itemBuilder: (context, index) {
                            final listing = viewModel.searchResults[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image with favorite icon
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(12),
                                            ),
                                        child: Container(
                                          width: double.infinity,
                                          height:
                                              140, // Consistent fixed height
                                          child: listing.imageUrl.isEmpty
                                              ? Center(
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                    size: 48,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface
                                                        .withValues(alpha: 0.3),
                                                  ),
                                                )
                                              : Image.network(
                                                  listing.imageUrl,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        // Completely disappear the listing if image fails to load
                                                        Future.microtask(() {
                                                          if (context.mounted) {
                                                            viewModel
                                                                .removeListingById(
                                                                  listing.id,
                                                                );
                                                          }
                                                        });
                                                        return const SizedBox.shrink();
                                                      },
                                                ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withValues(
                                              alpha: 0.4,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.favorite,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Content
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          listing.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${listing.priceFcfa} FCFA',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on,
                                              size: 14,
                                              color: Color(
                                                0xFF9DB9A6,
                                              ), // Light gray
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Molyko • Used - Good',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onSurfaceVariant,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryItem(String title, IconData icon, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearchItem(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.history,
            size: 18,
            color: Color(0xFF9DB9A6), // Light gray
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF9DB9A6), // Light gray
              ),
            ),
          ),
          const Icon(
            Icons.north_west,
            size: 18,
            color: Color(0xFF9DB9A6), // Light gray
          ),
        ],
      ),
    );
  }
}
