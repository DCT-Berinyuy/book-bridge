import 'package:book_bridge/core/presentation/widgets/notification_icon.dart';
import 'package:book_bridge/features/listings/domain/entities/listing.dart';
import 'package:geolocator/geolocator.dart';
import 'package:book_bridge/features/listings/presentation/viewmodels/home_viewmodel.dart';
import 'package:book_bridge/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:book_bridge/features/favorites/presentation/viewmodels/favorites_viewmodel.dart';
import 'package:book_bridge/core/constants/categories.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final PageController _pageController = PageController();
  int _currentPromoPage = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Initial load is handled by the ViewModel
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _pageController.dispose();
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
          // Handle automatic scroll to results if requested
          if (viewModel.shouldScrollToResults) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  750, // Pointing to the listings section
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                );
                viewModel.consumeScrollRequest();
              }
            });
          }

          return RefreshIndicator.adaptive(
            onRefresh: viewModel.refreshListings,
            child: _buildBody(viewModel),
          );
        },
      ),
    );
  }

  Widget _buildBody(HomeViewModel viewModel) {
    if (viewModel.homeState == HomeState.loading &&
        viewModel.listings.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        _buildSliverAppBar(),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        _buildPromoBanners(),
        _buildNearbyBooksSection(
          viewModel.nearbyListings,
          viewModel.currentPosition,
        ),
        _buildSectionHeader('Categories'),
        _buildCategoriesSection(),
        if (viewModel.homeState == HomeState.error &&
            viewModel.filteredListings.isEmpty)
          SliverFillRemaining(
            hasScrollBody: true,
            child: _buildErrorState(viewModel),
          )
        else if (viewModel.filteredListings.isEmpty)
          SliverFillRemaining(
            hasScrollBody: true,
            child: _buildEmptyState(viewModel),
          )
        else ...[
          // Featured listings logic
          if (viewModel.filteredListings.any((l) => l.isFeatured)) ...[
            _buildSectionHeader('Featured Books'),
            _buildFeaturedListings(
              viewModel.filteredListings.where((l) => l.isFeatured).toList(),
            ),
          ],
          _buildSectionHeader('Recently Added'),
          _buildListingsGrid(
            viewModel.filteredListings.where((l) => !l.isFeatured).toList(),
            viewModel,
          ),
          if (viewModel.hasMoreListings && viewModel.isLoading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildErrorState(HomeViewModel viewModel) {
    return Padding(
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
            'Oops! Something Went Wrong',
            style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            viewModel.errorMessage ?? 'Please check your connection.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: viewModel.refreshListings,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
              if (viewModel.selectedCategory != null) ...[
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: viewModel.clearCategoryFilter,
                  child: const Text('Back to Home'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(HomeViewModel viewModel) {
    final isFiltered = viewModel.selectedCategory != null;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off_rounded, size: 80, color: Colors.grey),
          const SizedBox(height: 24),
          Text(
            isFiltered
                ? 'No Books in ${viewModel.selectedCategory}'
                : 'No Books Found',
            style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            isFiltered
                ? 'Try another category or clear the filter.'
                : 'Be the first to list a book in your area!',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          if (isFiltered) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: viewModel.clearCategoryFilter,
              icon: const Icon(Icons.home_rounded),
              label: const Text('Back to Home'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    final theme = Theme.of(context);
    return SliverAppBar(
      pinned: true,
      floating: true,
      expandedHeight: 130, // branding (70) + search bar (60)
      elevation: 4,
      centerTitle: false,
      backgroundColor: theme.appBarTheme.backgroundColor,
      foregroundColor: theme.appBarTheme.foregroundColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 4,
            bottom: 60, // Same as search bar section
            left: 16,
            right: 8,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              Text(
                'BookBridge',
                style: theme.appBarTheme.titleTextStyle?.copyWith(fontSize: 20),
              ),
              const Spacer(),
              NotificationIcon(color: theme.appBarTheme.foregroundColor),
              IconButton(
                icon: Icon(
                  Icons.person_outline_rounded,
                  color: theme.appBarTheme.foregroundColor,
                ),
                onPressed: () => context.push('/profile'),
              ),
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
          decoration: BoxDecoration(
            color: theme.appBarTheme.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Consumer<HomeViewModel>(
              builder: (context, viewModel, _) {
                return TextField(
                  controller: _searchController,
                  onChanged: (value) => viewModel.setSearchQuery(value),
                  decoration: InputDecoration(
                    hintText: 'Search by title or author...',
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    suffixIcon: viewModel.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              viewModel.clearSearch();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainer,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                );
              },
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

  Widget _buildNearbyBooksSection(
    List<Listing> listings,
    Position? currentPosition,
  ) {
    if (listings.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your nearby books',
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Scroll down to the main grid
                    _scrollController.animateTo(
                      700,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: const Icon(Icons.arrow_forward_rounded, size: 24),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 250, // Reduced height
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              // Show only first 10 for horizontal scroll
              itemCount: listings.length > 10 ? 10 : listings.length,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 160, // Standard display size
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _ListingCard(
                      listing: listings[index],
                      currentPosition: currentPosition,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanners() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          SizedBox(
            height: 165, // Compact height to avoid overflow
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPromoPage = index;
                });
              },
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildNearbyCard(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildDonationCard(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(2, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 6,
                width: _currentPromoPage == index ? 20 : 6,
                decoration: BoxDecoration(
                  color: _currentPromoPage == index
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildNearbyCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E3A8A), // Deep blue
            Color(0xFF7C3AED), // Purple
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned(
            right: -30,
            top: -30,
            child: Icon(
              Icons.explore_rounded,
              size: 160,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          // Decorative circles
          Positioned(
            left: 20,
            bottom: 20,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            'NEARBY',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.location_on,
                            color: Color(0xFF10B981),
                            size: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Discover books in your community',
                        style: GoogleFonts.inter(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 11,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF10B981), Color(0xFF059669)],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF10B981,
                              ).withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            _scrollController.animateTo(
                              320,
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeInOut,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Explore Now',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background glow
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF10B981).withValues(alpha: 0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      // Layered pins
                      const Positioned(
                        top: 8,
                        left: 8,
                        child: Icon(
                          Icons.location_on,
                          color: Color(0xFF34D399),
                          size: 20,
                        ),
                      ),
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFF10B981),
                        size: 40,
                      ),
                      const Positioned(
                        bottom: 8,
                        right: 8,
                        child: Icon(
                          Icons.location_on,
                          color: Color(0xFF059669),
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF97316), // Orange
            Color(0xFFEC4899), // Pink
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEC4899).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.auto_stories_rounded,
              size: 140,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          // Floating hearts
          Positioned(
            right: 30,
            top: 20,
            child: Icon(
              Icons.favorite,
              size: 16,
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
          Positioned(
            right: 50,
            top: 50,
            child: Icon(
              Icons.favorite,
              size: 12,
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            'DONATE',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.favorite,
                            color: Color(0xFFFEF3C7),
                            size: 18,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Give books, create impact',
                        style: GoogleFonts.inter(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 11,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () => context.push('/sell'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFFEC4899),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Give Now',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glow effect
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0.2),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      // Stacked books illustration
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 32,
                            height: 6,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            width: 36,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            width: 30,
                            height: 6,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDE68A),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Icon(
                            Icons.auto_awesome,
                            color: Color(0xFFFEF3C7),
                            size: 16,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    final categories = [
      const Category(
        name: 'All',
        icon: Icons.grid_view_rounded,
        color: Colors.grey,
      ),
      ...appCategories,
    ];

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemBuilder: (context, index) {
            final category = categories[index];
            final name = category.name;
            final icon = category.icon;
            final color = category.color;

            final isSelected = name == 'All'
                ? context.watch<HomeViewModel>().selectedCategory == null
                : context.watch<HomeViewModel>().selectedCategory == name;

            return GestureDetector(
              onTap: () {
                if (name == 'All') {
                  context.read<HomeViewModel>().clearCategoryFilter();
                } else {
                  context.read<HomeViewModel>().setSelectedCategory(name);
                }
              },
              child: Container(
                width: 80,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withValues(alpha: 0.1)
                      : Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(color: color, width: 2)
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: 24),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isSelected
                            ? color
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
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
                child: _ListingCard(
                  listing: featuredListings[index],
                  currentPosition: context
                      .watch<HomeViewModel>()
                      .currentPosition,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListingsGrid(List<Listing> listings, HomeViewModel viewModel) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final listing = listings[index];
          return _ListingCard(
            listing: listing,
            currentPosition: viewModel.currentPosition,
          );
        }, childCount: listings.length),
      ),
    );
  }
}

class _ListingCard extends StatelessWidget {
  final Listing listing;
  final Position? currentPosition;

  const _ListingCard({required this.listing, this.currentPosition});

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
            Positioned(
              top: 8,
              left: 8,
              child: listing.sellerType != 'individual'
                  ? _buildVerifiedBadge()
                  : Container(),
            ),
            if (currentPosition != null &&
                listing.latitude != null &&
                listing.longitude != null)
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 12,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getDistanceString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Positioned(
              top: 8,
              right: 8,
              child: Consumer2<FavoritesViewModel, AuthViewModel>(
                builder: (context, favoritesVM, authVM, _) {
                  final userId = authVM.currentUser?.id;
                  final isFavorite = favoritesVM.isListingFavorite(listing.id);
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      child: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey[700],
                          size: 20,
                        ),
                        onPressed: () {
                          if (userId != null) {
                            favoritesVM.toggleFavorite(userId, listing);
                          } else {
                            context.push('/sign-in');
                          }
                        },
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(6),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifiedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(153),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(Icons.verified, size: 12, color: Colors.white),
          SizedBox(width: 4),
          Text(
            'VERIFIED',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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
          const SizedBox(height: 4),
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

  String _getDistanceString() {
    if (currentPosition == null ||
        listing.latitude == null ||
        listing.longitude == null) {
      return '';
    }
    final distanceInMeters = Geolocator.distanceBetween(
      currentPosition!.latitude,
      currentPosition!.longitude,
      listing.latitude!,
      listing.longitude!,
    );

    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
    }
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
