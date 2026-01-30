import 'package:dartz/dartz.dart';
import 'package:book_bridge/core/error/failures.dart';
import 'package:book_bridge/core/usecases/usecase.dart';
import 'package:book_bridge/features/listings/domain/entities/listing.dart';
import 'package:book_bridge/features/listings/domain/repositories/listing_repository.dart';

/// Use case for creating a new book listing.
class CreateListingUseCase implements UseCase<Listing, CreateListingParams> {
  final ListingRepository repository;

  CreateListingUseCase({required this.repository});

  @override
  Future<Either<Failure, Listing>> call(CreateListingParams params) async {
    return await repository.createListing(
      title: params.title,
      author: params.author,
      priceFcfa: params.priceFcfa,
      condition: params.condition,
      imageUrl: params.imageUrl,
      description: params.description,
      sellerType: params.sellerType,
      isBuyBackEligible: params.isBuyBackEligible,
      stockCount: params.stockCount,
    );
  }
}

/// Parameters for creating a listing.
class CreateListingParams {
  final String title;
  final String author;
  final int priceFcfa;
  final String condition;
  final String imageUrl;
  final String? description;
  final String sellerType;
  final bool isBuyBackEligible;
  final int stockCount;

  CreateListingParams({
    required this.title,
    required this.author,
    required this.priceFcfa,
    required this.condition,
    required this.imageUrl,
    this.description,
    this.sellerType = 'individual',
    this.isBuyBackEligible = false,
    this.stockCount = 1,
  });
}
