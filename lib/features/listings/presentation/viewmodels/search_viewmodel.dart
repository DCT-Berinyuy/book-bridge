import 'package:flutter/foundation.dart';
import 'package:book_bridge/features/listings/domain/entities/listing.dart';
import 'package:book_bridge/features/listings/domain/usecases/search_listings_usecase.dart';

/// State enum for the Search screen.
enum SearchState { initial, loading, success, error, empty }

/// ViewModel for managing search functionality.
///
/// This ViewModel handles searching listings by query and managing
/// search results with debouncing.
class SearchViewModel extends ChangeNotifier {
  final SearchListingsUseCase searchListingsUseCase;

  SearchState _searchState = SearchState.initial;
  String? _errorMessage;
  List<Listing> _searchResults = [];
  String _currentQuery = '';
  bool _isSearching = false;

  SearchViewModel({required this.searchListingsUseCase});

  // Getters
  SearchState get searchState => _searchState;
  String? get errorMessage => _errorMessage;
  List<Listing> get searchResults => _searchResults;
  String get currentQuery => _currentQuery;
  bool get isSearching => _isSearching;

  /// Performs a search with the given query.
  ///
  /// Returns empty list if query is empty.
  Future<void> search(String query) async {
    _currentQuery = query.trim();

    // Clear results if query is empty
    if (_currentQuery.isEmpty) {
      _searchState = SearchState.initial;
      _searchResults = [];
      _isSearching = false;
      _errorMessage = null;
      notifyListeners();
      return;
    }

    _isSearching = true;
    _searchState = SearchState.loading;
    _errorMessage = null;
    notifyListeners();

    final params = SearchListingsParams(query: _currentQuery);
    final result = await searchListingsUseCase(params);

    result.fold(
      (failure) {
        _searchState = SearchState.error;
        _errorMessage = failure.message;
        _searchResults = [];
        _isSearching = false;
        notifyListeners();
      },
      (listings) {
        if (listings.isEmpty) {
          _searchState = SearchState.empty;
        } else {
          _searchState = SearchState.success;
        }
        _searchResults = listings;
        _isSearching = false;
        _errorMessage = null;
        notifyListeners();
      },
    );
  }

  /// Clears the current search and results.
  void clearSearch() {
    _currentQuery = '';
    _searchResults = [];
    _searchState = SearchState.initial;
    _errorMessage = null;
    _isSearching = false;
    notifyListeners();
  }

  /// Removes a listing by its ID.
  ///
  /// Used to hide broken listings dynamically.
  void removeListingById(String id) {
    _searchResults.removeWhere((l) => l.id == id);
    notifyListeners();
  }
}
