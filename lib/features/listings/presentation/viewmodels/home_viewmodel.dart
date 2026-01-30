import 'package:flutter/material.dart';
import 'package:book_bridge/features/listings/domain/entities/listing.dart';
import 'package:book_bridge/features/listings/domain/usecases/get_listings_usecase.dart';

/// Represents the different states for the home feed.
enum HomeState { initial, loading, loaded, error }

/// ViewModel for managing the home feed state and operations.
///
/// This ChangeNotifier manages fetching and displaying listings.
class HomeViewModel extends ChangeNotifier {
  final GetListingsUseCase getListingsUseCase;

  // State
  HomeState _homeState = HomeState.initial;
  List<Listing> _listings = [];
  String? _errorMessage;
  int _currentOffset = 0;
  bool _hasMoreListings = true;
  final int _pageSize = 50;

  // Getters
  HomeState get homeState => _homeState;
  List<Listing> get listings => _listings;
  String? get errorMessage => _errorMessage;
  bool get hasMoreListings => _hasMoreListings;
  bool get isLoading => _homeState == HomeState.loading;

  HomeViewModel({required this.getListingsUseCase}) {
    _loadInitialListings();
  }

  /// Loads the initial set of listings on initialization.
  Future<void> _loadInitialListings() async {
    _homeState = HomeState.loading;
    _currentOffset = 0;
    _listings = [];
    notifyListeners();

    await _fetchListings(offset: 0);
  }

  /// Fetches listings with optional pagination.
  Future<void> _fetchListings({int offset = 0}) async {
    final params = GetListingsParams(
      status: 'available',
      limit: _pageSize,
      offset: offset,
    );

    final result = await getListingsUseCase(params);

    result.fold(
      (failure) {
        _homeState = HomeState.error;
        _errorMessage = failure.message;
        _hasMoreListings = false;
      },
      (newListings) {
        if (offset == 0) {
          // Initial load or refresh
          _listings = newListings;
          _currentOffset = 0;
        } else {
          // Pagination - append to existing
          _listings.addAll(newListings);
          _currentOffset = offset;
        }

        _homeState = HomeState.loaded;
        _errorMessage = null;
        _hasMoreListings = newListings.length == _pageSize;
      },
    );
    notifyListeners();
  }

  /// Refreshes the listings from the beginning.
  Future<void> refreshListings() async {
    await _loadInitialListings();
  }

  /// Loads the next page of listings.
  Future<void> loadMoreListings() async {
    if (!_hasMoreListings || _homeState == HomeState.loading) {
      return;
    }

    _homeState = HomeState.loading;
    notifyListeners();

    await _fetchListings(offset: _currentOffset + _pageSize);
  }

  /// Removes a listing by its ID.
  ///
  /// Used to hide broken listings dynamically.
  void removeListingById(String id) {
    _listings.removeWhere((l) => l.id == id);
    notifyListeners();
  }

  /// Clears the error message.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
