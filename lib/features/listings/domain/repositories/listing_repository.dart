import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:book_bridge/core/error/failures.dart';
import 'package:book_bridge/features/listings/domain/entities/listing.dart';

/// Abstract repository for listing operations.
///
/// This interface defines the contract for all listing-related
/// data operations. The actual implementation is in the data layer.
abstract class ListingRepository {
  /// Fetches all available listings.
  ///
  /// Optionally filters by [status] (defaults to 'available').
  /// Returns either a [Failure] or a list of [Listing] entities.
  Future<Either<Failure, List<Listing>>> getListings({
    String status = 'available',
    int limit = 50,
    int offset = 0,
  });

  /// Fetches details of a specific listing.
  ///
  /// Returns either a [Failure] or the [Listing] entity.
  /// Returns [NotFoundException] if listing not found.
  Future<Either<Failure, Listing>> getListingDetails(String listingId);

  /// Fetches listings from a specific seller.
  ///
  /// Returns either a [Failure] or a list of [Listing] entities.
  Future<Either<Failure, List<Listing>>> getListingsBySeller(String sellerId);

  /// Searches listings by title or author.
  ///
  /// Returns either a [Failure] or a list of matching [Listing] entities.
  Future<Either<Failure, List<Listing>>> searchListings(
    String query, {
    int limit = 50,
  });

  /// Creates a new listing.
  ///
  /// Returns either a [Failure] or the created [Listing] entity.
  Future<Either<Failure, Listing>> createListing({
    required String title,
    required String author,
    required int priceFcfa,
    required String condition,
    required String imageUrl,
    String? description,
  });

  /// Deletes a listing.
  ///
  /// Returns either a [Failure] or void on success.
  Future<Either<Failure, void>> deleteListing(String listingId);

  /// Uploads a book image to storage.
  ///
  /// Returns either a [Failure] or the public URL of the uploaded image.
  Future<Either<Failure, String>> uploadBookImage(File imageFile);

  /// Deletes a book image from storage.
  ///
  /// Returns either a [Failure] or void on success.
  Future<Either<Failure, void>> deleteBookImage(String imagePath);
}
