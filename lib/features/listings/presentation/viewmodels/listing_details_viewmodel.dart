import 'package:flutter/material.dart';
import 'package:book_bridge/features/listings/domain/entities/listing.dart';
import 'package:book_bridge/features/listings/domain/usecases/get_listing_details_usecase.dart';

/// Represents the different states for listing details.
enum ListingDetailsState { initial, loading, loaded, error }

/// ViewModel for managing listing details state.
///
/// This ChangeNotifier manages fetching and displaying details
/// for a specific listing.
class ListingDetailsViewModel extends ChangeNotifier {
  final GetListingDetailsUseCase getListingDetailsUseCase;

  // State
  ListingDetailsState _detailsState = ListingDetailsState.initial;
  Listing? _listing;
  String? _errorMessage;

  // Getters
  ListingDetailsState get detailsState => _detailsState;
  Listing? get listing => _listing;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _detailsState == ListingDetailsState.loading;

  ListingDetailsViewModel({required this.getListingDetailsUseCase});

  /// Loads the details for a specific listing.
  Future<void> loadListingDetails(String listingId) async {
    _detailsState = ListingDetailsState.loading;
    _listing = null;
    _errorMessage = null;
    notifyListeners();

    final params = GetListingDetailsParams(listingId: listingId);
    final result = await getListingDetailsUseCase(params);

    result.fold(
      (failure) {
        _detailsState = ListingDetailsState.error;
        _errorMessage = failure.message;
      },
      (listing) {
        _detailsState = ListingDetailsState.loaded;
        _listing = listing;
        _errorMessage = null;
      },
    );
    notifyListeners();
  }

  /// Clears the error message.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
