import 'package:book_bridge/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:book_bridge/features/listings/presentation/viewmodels/listing_details_viewmodel.dart';

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

    final shareText =
        '''
Check out this book on BookBridge:
📚 ${listing.title} by ${listing.author}
💰 ${listing.priceFcfa} FCFA
🔍 Condition: ${listing.condition}

Download BookBridge to view more details!
''';

    await Share.share(shareText);
  }

  Future<void> _contactSeller(String whatsappNumber) async {
    if (whatsappNumber.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No WhatsApp number available')),
        );
      }
      return;
    }

    final cleanNumber = whatsappNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final message = 'Hi, I saw your book on BookBridge and I am interested!';
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
              content: Text(
                AppLocalizations.of(context)!.couldNotLaunchWhatsapp,
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> _callSeller(String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No phone number available')),
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
            const SnackBar(content: Text('Could not launch dialer')),
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            'assets/logo.png',
                            height: 36, // Adjust height as needed
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.white),
                        onPressed: () => _shareListing(),
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
                                    )!.thisListingIsNoLongerAvailablePeriod,
                                  ),
                                  duration: Duration(seconds: 2),
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
                          Icon(Icons.recycling, color: Color(0xFF27AE60)),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.buyHyphenBackEligible,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF27AE60),
                                  ),
                                ),
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.sellThisBookBackToThePlatformWhenYouBackslashApostropheReDonePeriod,
                                  style: TextStyle(
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
                                    )!.thisStudentIsSellingToFundTheirNextSemesterPeriod
                                  : listing.sellerType == 'bookshop'
                                  ? AppLocalizations.of(
                                      context,
                                    )!.aVerifiedLocalBookshopSupportingTheCommunityPeriod
                                  : AppLocalizations.of(
                                      context,
                                    )!.directFromTheAuthorPeriodSupportingLocalCreativityPeriod,
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
                            listing.sellerType.toUpperCase(),
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
                              '${listing.priceFcfa} FCFA',
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
                          listing.condition.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Description / Details
                  Text(
                    AppLocalizations.of(context)!.description,
                    style: TextStyle(
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
                        : AppLocalizations.of(
                            context,
                          )!.noDescriptionProvidedPeriod,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Seller Section
                  Text(
                    AppLocalizations.of(context)!.sellerInformation,
                    style: TextStyle(
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
                              child: Icon(
                                listing.sellerType == 'bookshop'
                                    ? Icons.store
                                    : listing.sellerType == 'author'
                                    ? Icons.history_edu
                                    : Icons.person,
                                color: const Color(0xFF1A4D8C), // Primary green
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
                                  )!.supportingLocalBusinessesDemocratizesAccessToKnowledgePeriod
                                : AppLocalizations.of(
                                    context,
                                  )!.supportingLocalAuthorsFostersAVibrantCultureOfLearningPeriod,
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
              onPressed: () =>
                  _contactSeller(context, listing.sellerWhatsapp ?? ''),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF2994A), // Bridge Orange
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.chat_bubble),
              label: Text(
                AppLocalizations.of(context)!.contactSellerViaWhatsapp,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
}
