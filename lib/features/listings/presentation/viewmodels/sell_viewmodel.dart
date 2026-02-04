import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:book_bridge/features/listings/domain/entities/listing.dart';
import 'package:book_bridge/features/listings/domain/repositories/listing_repository.dart';
import 'package:book_bridge/features/listings/domain/usecases/create_listing_usecase.dart';
import 'package:book_bridge/features/listings/domain/usecases/update_listing_usecase.dart';
import 'package:book_bridge/core/error/exceptions.dart';

/// State enum for the Sell screen.
enum SellState { initial, loading, success, error }

/// ViewModel for managing the sell/create listing functionality.
///
/// This ViewModel handles the creation of new listings including
/// form state management and API interactions.
class SellViewModel extends ChangeNotifier {
  final CreateListingUseCase createListingUseCase;
  final UpdateListingUseCase updateListingUseCase;
  final ListingRepository repository;

  SellState _sellState = SellState.initial;
  String? _errorMessage;
  Listing? _createdListing;
  Listing? _editingListing;

  // Form fields
  String? _title;
  String? _author;
  int? _priceFcfa;
  String _condition = 'good';
  String? _imageUrl;
  String? _description;
  String? _category;
  String _sellerType = 'individual';
  bool _isBuyBackEligible = false;
  int _stockCount = 1;

  SellViewModel({
    required this.createListingUseCase,
    required this.updateListingUseCase,
    required this.repository,
  });

  // Getters
  SellState get sellState => _sellState;
  String? get errorMessage => _errorMessage;
  Listing? get createdListing => _createdListing;
  Listing? get editingListing => _editingListing;
  bool get isLoading => _sellState == SellState.loading;
  bool get isEditing => _editingListing != null;

  String? get title => _title;
  String? get author => _author;
  int? get priceFcfa => _priceFcfa;
  String get condition => _condition;
  String? get imageUrl => _imageUrl;
  String? get description => _description;
  String? get category => _category;
  String get sellerType => _sellerType;
  bool get isBuyBackEligible => _isBuyBackEligible;
  int get stockCount => _stockCount;

  /// Updates the title field.
  void setTitle(String title) {
    _title = title;
    notifyListeners();
  }

  /// Updates the author field.
  void setAuthor(String author) {
    _author = author;
    notifyListeners();
  }

  /// Updates the price field.
  void setPrice(int price) {
    _priceFcfa = price;
    notifyListeners();
  }

  /// Updates the condition field.
  void setCondition(String condition) {
    _condition = condition;
    notifyListeners();
  }

  /// Updates the image URL field.
  void setImageUrl(String imageUrl) {
    _imageUrl = imageUrl;
    notifyListeners();
  }

  /// Updates the description field.
  void setDescription(String description) {
    _description = description;
    notifyListeners();
  }

  /// Updates the category field.
  void setCategory(String? category) {
    _category = category;
    notifyListeners();
  }

  /// Updates the seller type field.
  void setSellerType(String sellerType) {
    _sellerType = sellerType;
    notifyListeners();
  }

  /// Updates the buy-back eligibility field.
  void setIsBuyBackEligible(bool isBuyBackEligible) {
    _isBuyBackEligible = isBuyBackEligible;
    notifyListeners();
  }

  /// Updates the stock count field.
  void setStockCount(int stockCount) {
    _stockCount = stockCount;
    notifyListeners();
  }

  /// Sets the listing to be edited and populates form fields.
  void setEditingListing(Listing listing) {
    _editingListing = listing;
    _title = listing.title;
    _author = listing.author;
    _priceFcfa = listing.priceFcfa;
    _condition = listing.condition;
    _imageUrl = listing.imageUrl;
    _description = listing.description;
    _category = listing.category;
    _sellerType = listing.sellerType;
    _isBuyBackEligible = listing.isBuyBackEligible;
    _stockCount = listing.stockCount;
    notifyListeners();
  }

  /// Resets the form to initial state.
  void resetForm() {
    _title = null;
    _author = null;
    _priceFcfa = null;
    _condition = 'good';
    _imageUrl = null;
    _description = null;
    _category = null;
    _sellerType = 'individual';
    _isBuyBackEligible = false;
    _stockCount = 1;
    _sellState = SellState.initial;
    _errorMessage = null;
    _createdListing = null;
    _editingListing = null;
    notifyListeners();
  }

  /// Validates the form fields.
  bool validateForm() {
    if (_title == null || _title!.isEmpty) {
      _errorMessage = 'Title is required';
      _sellState = SellState.error;
      notifyListeners();
      return false;
    }

    if (_author == null || _author!.isEmpty) {
      _errorMessage = 'Author is required';
      _sellState = SellState.error;
      notifyListeners();
      return false;
    }

    if (_priceFcfa == null || _priceFcfa! <= 0) {
      _errorMessage = 'Valid price is required';
      _sellState = SellState.error;
      notifyListeners();
      return false;
    }

    if (_imageUrl == null || _imageUrl!.isEmpty) {
      _errorMessage = 'Book image is required';
      _sellState = SellState.error;
      notifyListeners();
      return false;
    }

    // Check if the image URL is a local file path (not yet uploaded)
    if (_imageUrl!.startsWith('/')) {
      _errorMessage = 'Please wait for image to upload';
      _sellState = SellState.error;
      notifyListeners();
      return false;
    }

    return true;
  }

  /// Creates a new listing.
  Future<void> createListing() async {
    if (!validateForm()) return;

    _sellState = SellState.loading;
    _errorMessage = null;
    notifyListeners();

    final params = CreateListingParams(
      title: _title!,
      author: _author!,
      priceFcfa: _priceFcfa!,
      condition: _condition,
      imageUrl: _imageUrl!,
      description: _description,
      category: _category,
      sellerType: _sellerType,
      isBuyBackEligible: _isBuyBackEligible,
      stockCount: _stockCount,
    );

    final result = await createListingUseCase(params);

    result.fold(
      (failure) {
        _sellState = SellState.error;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (listing) {
        _createdListing = listing;
        _sellState = SellState.success;
        _errorMessage = null;
        notifyListeners();
      },
    );
  }

  /// Updates an existing listing.
  Future<void> updateListing() async {
    if (_editingListing == null || !validateForm()) return;

    _sellState = SellState.loading;
    _errorMessage = null;
    notifyListeners();

    final params = UpdateListingParams(
      id: _editingListing!.id,
      title: _title,
      author: _author,
      priceFcfa: _priceFcfa,
      condition: _condition,
      imageUrl: _imageUrl,
      description: _description,
      category: _category,
      sellerType: _sellerType,
      isBuyBackEligible: _isBuyBackEligible,
      stockCount: _stockCount,
    );

    final result = await updateListingUseCase(params);

    result.fold(
      (failure) {
        _sellState = SellState.error;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (listing) {
        _editingListing = null; // Clear editing state after success
        _sellState = SellState.success;
        _errorMessage = null;
        notifyListeners();
      },
    );
  }

  /// Picks an image from the gallery.
  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      await _processAndUploadImage(File(pickedFile.path));
    }
  }

  /// Takes a photo using the camera.
  Future<void> pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      await _processAndUploadImage(File(pickedFile.path));
    }
  }

  /// Processes and uploads the selected image to Supabase Storage.
  Future<void> _processAndUploadImage(File imageFile) async {
    _sellState = SellState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await repository.uploadBookImage(imageFile);
      result.fold(
        (failure) {
          _sellState = SellState.error;
          _errorMessage = 'Failed to upload image: ${failure.message}';
          notifyListeners();
        },
        (imageUrl) {
          _imageUrl = imageUrl;
          _sellState = SellState
              .initial; // Reset to initial since we're just setting the image
          notifyListeners();
        },
      );
    } on ServerException catch (e) {
      _sellState = SellState.error;
      _errorMessage = 'Failed to upload image: ${e.message}';
      notifyListeners();
    } catch (e) {
      _sellState = SellState.error;
      _errorMessage = 'Failed to process image: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Clears the error message and resets the sell state to initial.
  void clearState() {
    _errorMessage = null;
    _sellState = SellState.initial;
    notifyListeners();
  }
}
