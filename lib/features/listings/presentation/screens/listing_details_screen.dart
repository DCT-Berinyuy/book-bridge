import 'package:flutter/material.dart';
import 'package:book_bridge/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:book_bridge/features/listings/presentation/viewmodels/listing_details_viewmodel.dart';
import 'package:book_bridge/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:book_bridge/features/favorites/presentation/viewmodels/favorites_viewmodel.dart';

/// Listing details screen showing comprehensive information about a book.
///
/// This screen displays book details, images, seller information, and
/// provides functionality to contact the seller via WhatsApp.
class ListingDetailsScreen extends StatefulWidget {
  final String listingId;

  const ListingDetailsScreen({super.key, required this.listingId});

  @override
  State<ListingDetailsScreen> createState() => _ListingDetailsScreenState();
}

class _ListingDetailsScreenState extends State<ListingDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Load listing details when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ListingDetailsViewModel>().loadListingDetails(
          widget.listingId,
        );
      }
    });
  }

  Future<void> _shareListing() async {
    final viewModel = context.read<ListingDetailsViewModel>();
    final listing = viewModel.listing;

    if (listing == null) return;

    final l10n = AppLocalizations.of(context)!;
    final shareText =
        '''
${l10n.shareTextCheckOut}
📚 ${listing.title} by ${listing.author}
💰 ${l10n.priceFormat(listing.priceFcfa)}
🔍 ${l10n.shareTextCondition}: ${_getLocalizedCondition(context, listing.condition)}

${l10n.shareTextDownload}
''';

    await Share.share(shareText);
  }

  Future<void> _contactSeller(String whatsappNumber) async {
    if (whatsappNumber.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.whatsappNotAvailable),
          ),
        );
      }
      return;
    }

    // WhatsApp (wa.me) links require the full international format without the '+' prefix.
    // Most users in Cameroon enter their 9-digit number. We ensure the country code (237) is present.
    String cleanNumber = whatsappNumber.replaceAll(RegExp(r'\D'), '');

    if (cleanNumber.length == 9) {
      cleanNumber = '237$cleanNumber';
    }

    debugPrint('ListingDetailsScreen: Original WhatsApp: $whatsappNumber');
    debugPrint('ListingDetailsScreen: Cleaned WhatsApp: $cleanNumber');

    final message = AppLocalizations.of(context)!.whatsappDefaultMessage;
    final whatsappUrl =
        'https://wa.me/$cleanNumber?text=${Uri.encodeComponent(message)}';

    try {
      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(
          Uri.parse(whatsappUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.whatsappLaunchError),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  Future<void> _callSeller(String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.phoneNotAvailable),
          ),
        );
      }
      return;
    }

    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber.replaceAll(RegExp(r'[^\d+]'), ''),
    );

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.dialerLaunchError),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ListingDetailsViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              color: const Color(0xFF1A4D8C), // Scholar Blue
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 24,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // Check if we can pop before attempting to do so
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          } else {
                            // If we can't pop, navigate to home using go_router
                            context.go('/home');
                          }
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.bookDetailsTitle,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.white),
                        onPressed: () => _shareListing(),
                      ),
                      Consumer2<FavoritesViewModel, AuthViewModel>(
                        builder: (context, favoritesVM, authVM, _) {
                          final viewModel = context
                              .read<ListingDetailsViewModel>();
                          final listing = viewModel.listing;
                          if (listing == null) return const SizedBox.shrink();

                          final userId = authVM.currentUser?.id;
                          final isFavorite = favoritesVM.isListingFavorite(
                            listing.id,
                          );

                          return IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.white,
                            ),
                            onPressed: () {
                              if (userId != null) {
                                favoritesVM.toggleFavorite(userId, listing);
                              } else {
                                context.push('/sign-in');
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: _buildBody(viewModel),
          bottomNavigationBar: _buildBottomBar(viewModel),
        );
      },
    );
  }

  Widget _buildBody(ListingDetailsViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.detailsState == ListingDetailsState.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.failedToLoadListing,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              viewModel.errorMessage ??
                  AppLocalizations.of(context)!.unknownError,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final listing = viewModel.listing;
    if (listing == null) {
      return Center(child: Text(AppLocalizations.of(context)!.noListingFound));
    }

    return Column(
      children: [
        // Book Cover Image
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: listing.imageUrl.isNotEmpty
                    ? Image.network(
                        listing.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // If image fails to load in details screen, it's likely a broken listing
                          // Inform user and go back
                          Future.microtask(() {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.listingNotAvailableSnackBar,
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                              // Check if we can pop before attempting to do so
                              if (Navigator.of(context).canPop()) {
                                Navigator.of(context).pop();
                              } else {
                                // If we can't pop, navigate to home using go_router
                                if (context.mounted) {
                                  context.go('/home');
                                }
                              }
                            }
                          });
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      )
                    : Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: Icon(
                          Icons.image_not_supported,
                          size:
                              MediaQuery.of(context).size.height *
                              0.05, // Responsive size
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
          ),
        ),

        // Main content
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (listing.isBuyBackEligible)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF27AE60).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF27AE60).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.recycling, color: Color(0xFF27AE60)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.buyBackEligible,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF27AE60),
                                  ),
                                ),
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.buyBackDescription,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Title and Author
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              listing.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              listing.author,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Color(0xFF95A5A6),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              listing.sellerType == 'individual'
                                  ? AppLocalizations.of(
                                      context,
                                    )!.sellerTypeIndividualDesc
                                  : listing.sellerType == 'bookshop'
                                  ? AppLocalizations.of(
                                      context,
                                    )!.sellerTypeBookshopDesc
                                  : AppLocalizations.of(
                                      context,
                                    )!.sellerTypeAuthorDesc,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF2D3436), // Ink Black
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (listing.sellerType != 'individual')
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A4D8C),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getLocalizedSellerType(
                              context,
                              listing.sellerType,
                            ).toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Chips / Status
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      // Price chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2994A).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.payments,
                              size: 20,
                              color: Color(0xFFF2994A),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              AppLocalizations.of(
                                context,
                              )!.priceFormat(listing.priceFcfa),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFF2994A),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Condition chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          _getLocalizedCondition(
                            context,
                            listing.condition,
                          ).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      // Category chip
                      if (listing.category != null &&
                          listing.category!.isNotEmpty &&
                          listing.category != 'Uncategorized')
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Text(
                            _getLocalizedCategory(
                              context,
                              listing.category!,
                            ).toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Description / Details
                  Text(
                    AppLocalizations.of(context)!.descriptionLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF9DB9A6), // Light gray
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    listing.description.isNotEmpty
                        ? listing.description
                        : AppLocalizations.of(context)!.noDescriptionProvided,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Seller Section
                  Text(
                    AppLocalizations.of(context)!.sellerInformationLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF9DB9A6), // Light gray
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).dividerColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.2),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child:
                                    listing.sellerAvatarUrl != null &&
                                        listing.sellerAvatarUrl!.isNotEmpty
                                    ? Image.network(
                                        listing.sellerAvatarUrl!,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              );
                                            },
                                        errorBuilder:
                                            (
                                              context,
                                              error,
                                              stackTrace,
                                            ) => Icon(
                                              listing.sellerType == 'bookshop'
                                                  ? Icons.store
                                                  : listing.sellerType ==
                                                        'author'
                                                  ? Icons.history_edu
                                                  : Icons.person,
                                              color: const Color(0xFF1A4D8C),
                                            ),
                                      )
                                    : Icon(
                                        listing.sellerType == 'bookshop'
                                            ? Icons.store
                                            : listing.sellerType == 'author'
                                            ? Icons.history_edu
                                            : Icons.person,
                                        color: const Color(0xFF1A4D8C),
                                      ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    listing.sellerName ??
                                        AppLocalizations.of(
                                          context,
                                        )!.unknownSeller,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
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
                                      Text(
                                        listing.sellerLocality ??
                                            AppLocalizations.of(
                                              context,
                                            )!.unknownLocation,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(
                                            0xFF9DB9A6,
                                          ), // Light gray
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.verified,
                              color: Color(0xFF13EC5B), // Primary green
                            ),
                          ],
                        ),
                        if (listing.sellerType != 'individual') ...[
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 8),
                          Text(
                            listing.sellerType == 'bookshop'
                                ? AppLocalizations.of(
                                    context,
                                  )!.sellerTypeBookshopPromo
                                : AppLocalizations.of(
                                    context,
                                  )!.sellerTypeAuthorPromo,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF13EC5B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildBottomBar(ListingDetailsViewModel viewModel) {
    final listing = viewModel.listing;
    if (listing == null) return null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () => _contactSeller(listing.sellerWhatsapp ?? ''),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366), // WhatsApp Green
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 20),
              label: Text(
                AppLocalizations.of(context)!.contactSellerWhatsApp,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => _callSeller(listing.sellerWhatsapp ?? ''),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.call,
                  size: 16,
                  color: Color(0xFF9DB9A6), // Light gray
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.callSeller,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getLocalizedCondition(BuildContext context, String condition) {
    final l10n = AppLocalizations.of(context)!;
    switch (condition.toLowerCase()) {
      case 'new':
        return l10n.conditionNew;
      case 'like_new':
        return l10n.conditionLikeNew;
      case 'good':
        return l10n.conditionGood;
      case 'fair':
        return l10n.conditionFair;
      case 'poor':
        return l10n.conditionPoor;
      default:
        return condition;
    }
  }

  String _getLocalizedSellerType(BuildContext context, String sellerType) {
    final l10n = AppLocalizations.of(context)!;
    switch (sellerType.toLowerCase()) {
      case 'individual':
        return l10n.sellerTypeIndividual;
      case 'bookshop':
        return l10n.sellerTypeBookshop;
      case 'author':
        return l10n.sellerTypeAuthor;
      default:
        return sellerType;
    }
  }

  String _getLocalizedCategory(BuildContext context, String categoryName) {
    final l10n = AppLocalizations.of(context)!;
    switch (categoryName) {
      case 'Textbooks':
        return l10n.categoryTextbooks;
      case 'Fiction':
        return l10n.categoryFiction;
      case 'Science':
        return l10n.categoryScience;
      case 'History':
        return l10n.categoryHistory;
      case 'GCE':
        return l10n.categoryGCE;
      case 'Business':
        return l10n.categoryBusiness;
      case 'Technology':
        return l10n.categoryTechnology;
      case 'Arts':
        return l10n.categoryArts;
      case 'Language':
        return l10n.categoryLanguage;
      case 'Mathematics':
        return l10n.categoryMathematics;
      case 'Engineering':
        return l10n.categoryEngineering;
      case 'Medicine':
        return l10n.categoryMedicine;
      default:
        return categoryName;
    }
  }
}
