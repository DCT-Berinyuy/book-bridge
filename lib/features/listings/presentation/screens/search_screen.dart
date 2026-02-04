import 'package:book_bridge/l10n/app_localizations.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:book_bridge/features/listings/presentation/viewmodels/search_viewmodel.dart';
import 'package:book_bridge/features/listings/domain/entities/listing.dart';

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
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query, SearchViewModel viewModel) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        viewModel.search(query);
      } else {
        viewModel.clearSearch();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(180),
            child: Container(
              color: const Color(0xFF1A4D8C), // Scholar Blue
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
                          const Icon(Icons.menu_book, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)!.bookbridge,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(
                              Icons.notifications,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              context.push('/notifications');
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Search bar
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          // No border needed for white on blue
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(color: Colors.black),
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(
                              context,
                            )!
                                .searchTitleCommaAuthorCommaOrIsbnPeriodPeriodPeriod,
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      viewModel.clearSearch();
                                      setState(() {});
                                    },
                                  )
                                : null,
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
                            _onSearchChanged(value, viewModel);
                          },
                        ),
                      ),
                    ],
                  ),
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
                  // Show Categories and Recent Searches only when NOT searching
                  if (viewModel.searchState == SearchState.initial ||
                      (viewModel.searchState == SearchState.success &&
                          _searchController.text.isEmpty)) ...[
                    // Academic Categories
                    Text(
                      AppLocalizations.of(context)!.academicCategories,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.8,
                      children: [
                        _buildCategoryItem(
                          AppLocalizations.of(context)!.engineering,
                          Icons.engineering,
                          AppLocalizations.of(context)!.polytechnique,
                        ),
                        _buildCategoryItem(
                          AppLocalizations.of(context)!.law,
                          Icons.gavel,
                          'FSJP',
                        ),
                        _buildCategoryItem(
                          AppLocalizations.of(context)!.medicine,
                          Icons.medical_services,
                          'FMSB',
                        ),
                        _buildCategoryItem(
                          AppLocalizations.of(context)!.economics,
                          Icons.payments,
                          'FSEG',
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Recent Searches Section
                    if (viewModel.recentSearches.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.recentSearches,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              viewModel.clearRecentSearches();
                            },
                            child: Text(
                              AppLocalizations.of(context)!.clearAll,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF9DB9A6), // Light gray
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Recent search items
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: viewModel.recentSearches.length,
                        itemBuilder: (context, index) {
                          final query = viewModel.recentSearches[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Theme.of(
                                    context,
                                  ).dividerColor.withOpacity(0.1),
                                ),
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                _searchController.text = query;
                                viewModel.search(query);
                                FocusScope.of(context).unfocus();
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.history,
                                    size: 18,
                                    color: Color(0xFF9DB9A6),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      query,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF9DB9A6),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Color(0xFF9DB9A6),
                                    ),
                                    onPressed: () {
                                      viewModel.removeRecentSearch(query);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],

                  // Loading State
                  if (viewModel.searchState == SearchState.loading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),

                  // Error State
                  if (viewModel.searchState == SearchState.error)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          viewModel.errorMessage ??
                              AppLocalizations.of(context)!.anErrorOccurred,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ),

                  // Empty State
                  if (viewModel.searchState == SearchState.empty ||
                      (viewModel.searchState == SearchState.success &&
                          viewModel.searchResults.isEmpty &&
                          _searchController.text.isNotEmpty))
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No results found for "${_searchController.text}"',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Search results
                  if (viewModel.searchState == SearchState.success &&
                      viewModel.searchResults.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          '${viewModel.searchResults.length} ${AppLocalizations.of(context)!.resultOpen_parenthesisSClose_parenthesisFound}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.68,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: viewModel.searchResults.length,
                          itemBuilder: (context, index) {
                            final listing = viewModel.searchResults[index];
                            return _buildListingCard(
                              context,
                              listing,
                              viewModel,
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

  Widget _buildListingCard(
    BuildContext context,
    Listing listing,
    SearchViewModel viewModel,
  ) {
    return GestureDetector(
      onTap: () {
        context.push('/listing/${listing.id}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with favorite icon
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 140,
                    child: listing.imageUrl.isEmpty
                        ? Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 48,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.3),
                            ),
                          )
                        : Image.network(
                            listing.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                              );
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
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.favorite_border,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${listing.priceFcfa} FCFA',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: Color(0xFF9DB9A6), // Light gray
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          listing.sellerLocality ?? 'Cameroon',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String title, IconData icon, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
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
                ).colorScheme.primary.withOpacity(0.2),
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
}
