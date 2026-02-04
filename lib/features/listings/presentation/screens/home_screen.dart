import 'package:book_bridge/l10n/app_localizations.dart';
import 'package:book_bridge/features/listings/domain/entities/listing.dart';
import 'package:book_bridge/features/listings/presentation/viewmodels/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Initial load is handled by the ViewModel
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      context.read<HomeViewModel>().loadMoreListings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, _) {
          return RefreshIndicator.adaptive(
            onRefresh: viewModel.refreshListings,
            child: _buildBody(viewModel),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/sell'),
        label: Text(AppLocalizations.of(context)!.sellABook),
        icon: const Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(HomeViewModel viewModel) {
    if (viewModel.homeState == HomeState.loading &&
        viewModel.listings.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.homeState == HomeState.error && viewModel.listings.isEmpty) {
      return _buildErrorState(viewModel);
    }

    if (viewModel.listings.isEmpty) {
      return _buildEmptyState();
    }

    // Combine featured and regular listings
    final featuredListings = viewModel.listings
        .where((l) => l.isFeatured)
        .toList();
    final regularListings = viewModel.listings
        .where((l) => !l.isFeatured)
        .toList();

    return CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        _buildSliverAppBar(context),
        _buildSectionHeader(AppLocalizations.of(context)!.categories),
        _buildCategoryChips(),
        if (featuredListings.isNotEmpty) ...[
          _buildSectionHeader(AppLocalizations.of(context)!.featuredBooks),
          _buildFeaturedListings(featuredListings),
        ],
        _buildSectionHeader(AppLocalizations.of(context)!.recentlyAdded),
        _buildListingsGrid(regularListings, viewModel),
        if (viewModel.hasMoreListings && viewModel.isLoading)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }

  Widget _buildErrorState(HomeViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(
                context,
              )!.oopsExclamation_markSomethingWentWrong,
              style: GoogleFonts.lato(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              viewModel.errorMessage ??
                  AppLocalizations.of(context)!.pleaseCheckYourConnectionPeriod,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: viewModel.refreshListings,
              icon: const Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context)!.tryAgain),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_rounded, size: 80, color: Colors.grey),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.noBooksFound,
              style: GoogleFonts.lato(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(
                context,
              )!.beTheFirstToListABookInYourAreaExclamation_mark,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    final theme = Theme.of(context);
    return SliverAppBar(
      pinned: true,
      floating: true,
      elevation: 2,
      centerTitle: false,
      backgroundColor: theme.appBarTheme.backgroundColor,
      foregroundColor: theme.appBarTheme.foregroundColor,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              'assets/logo.png',
              height: 32,
              width: 32,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Text(AppLocalizations.of(context)!.bookbridge, style: theme.appBarTheme.titleTextStyle),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.notifications_none_rounded,
            color: theme.appBarTheme.foregroundColor,
          ),
          onPressed: () => context.push('/notifications'),
        ),
        IconButton(
          icon: Icon(
            Icons.person_outline_rounded,
            color: theme.appBarTheme.foregroundColor,
          ),
          onPressed: () => context.push('/profile'),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: GestureDetector(
            onTap: () => context.push('/search'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(
                      context,
                    )!.searchByTitleOrAuthorPeriodPeriodPeriod,
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
        child: Text(
          title,
          style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    final categories = [
      AppLocalizations.of(context)!.all,
      AppLocalizations.of(context)!.textbooks,
      AppLocalizations.of(context)!.fiction,
      AppLocalizations.of(context)!.science,
      AppLocalizations.of(context)!.history,
      AppLocalizations.of(context)!.gce,
    ];
    // final categories = [
    //      'All',
    //      'Textbooks',
    //      'Fiction',
    //      'Science',
    //      'History',
    //      'GCE',
    //    ];
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemBuilder: (context, index) {
            final isSelected = index == 0
                ? context.watch<HomeViewModel>().selectedCategory == null
                : context.watch<HomeViewModel>().selectedCategory ==
                      categories[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                label: Text(categories[index]),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    if (index == 0) {
                      // 'All' category - clear filter
                      context.read<HomeViewModel>().clearCategoryFilter();
                    } else {
                      // Specific category
                      context.read<HomeViewModel>().setSelectedCategory(
                        categories[index],
                      );
                    }
                  }
                },
                selectedColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
                labelStyle: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeaturedListings(List<Listing> featuredListings) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 280,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: featuredListings.length,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemBuilder: (context, index) {
            return SizedBox(
              width: 200,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _ListingCard(listing: featuredListings[index]),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListingsGrid(List<Listing> listings, HomeViewModel viewModel) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final listing = listings[index];
          return _ListingCard(listing: listing);
        }, childCount: listings.length),
      ),
    );
  }
}

class _ListingCard extends StatelessWidget {
  final Listing listing;

  const _ListingCard({required this.listing});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/listing/${listing.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildImage(context), _buildContent(context)],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: listing.imageUrl.isNotEmpty
                  ? Image.network(
                      listing.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Notify view model to remove broken listing
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (context.mounted) {
                            context.read<HomeViewModel>().removeListingById(
                              listing.id,
                            );
                          }
                        });
                        return const Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 32,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Icon(
                        Icons.book_rounded,
                        size: 48,
                        color: Colors.grey,
                      ),
                    ),
            ),
            if (listing.sellerType != 'individual')
              _buildVerifiedBadge(context),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifiedBadge(BuildContext context) {
    return Positioned(
      top: 8,
      left: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(153),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.verified, size: 12, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              AppLocalizations.of(context)!.verified,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            listing.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            listing.author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${listing.priceFcfa} FCFA',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              _buildConditionIndicator(context, listing.condition),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConditionIndicator(BuildContext context, String condition) {
    Color color;
    switch (condition) {
      case 'new':
        color = Colors.green;
        break;
      case 'like_new':
        color = Colors.lightGreen;
        break;
      case 'good':
        color = Colors.blue;
        break;
      case 'fair':
        color = Colors.orange;
        break;
      default:
        color = Colors.red;
    }
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
    );
  }
}
