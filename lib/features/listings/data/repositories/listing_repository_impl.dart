import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:book_bridge/core/error/failures.dart';
import 'package:book_bridge/core/error/exceptions.dart';
import 'package:book_bridge/features/listings/data/datasources/supabase_listings_data_source.dart';
import 'package:book_bridge/features/listings/domain/entities/listing.dart';
import 'package:book_bridge/features/listings/domain/repositories/listing_repository.dart';

/// Implementation of the ListingRepository interface using Supabase.
///
/// This repository acts as the bridge between the domain and data layers,
/// coordinating data sources and mapping data between layers.
class ListingRepositoryImpl implements ListingRepository {
  final SupabaseListingsDataSource dataSource;

  ListingRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<Listing>>> getListings({
    String status = 'available',
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final listingModels = await dataSource.getListings(
        status: status,
        limit: limit,
        offset: offset,
      );
      final listings = listingModels.map((model) => model.toEntity()).toList();
      return Right(listings);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Listing>> getListingDetails(String listingId) async {
    try {
      final listingModel = await dataSource.getListingDetails(listingId);
      return Right(listingModel.toEntity());
    } on NotFoundException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Listing>>> getListingsBySeller(
    String sellerId,
  ) async {
    try {
      final listingModels = await dataSource.getListingsBySeller(sellerId);
      final listings = listingModels.map((model) => model.toEntity()).toList();
      return Right(listings);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Listing>>> searchListings(
    String query, {
    int limit = 50,
  }) async {
    try {
      final listingModels = await dataSource.searchListings(
        query,
        limit: limit,
      );
      final listings = listingModels.map((model) => model.toEntity()).toList();
      return Right(listings);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Listing>> createListing({
    required String title,
    required String author,
    required int priceFcfa,
    required String condition,
    required String imageUrl,
    String? description,
  }) async {
    try {
      final listingModel = await dataSource.createListing(
        title: title,
        author: author,
        priceFcfa: priceFcfa,
        condition: condition,
        imageUrl: imageUrl,
        description: description,
      );
      return Right(listingModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteListing(String listingId) async {
    try {
      await dataSource.deleteListing(listingId);
      return const Right(null);
    } on NotFoundException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadBookImage(File imageFile) async {
    try {
      final imageUrl = await dataSource.uploadBookImage(imageFile);
      return Right(imageUrl);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBookImage(String imagePath) async {
    try {
      await dataSource.deleteBookImage(imagePath);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
