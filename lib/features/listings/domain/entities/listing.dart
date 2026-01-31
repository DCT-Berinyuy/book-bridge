import 'package:equatable/equatable.dart';

/// Represents a book listing in the BookBridge marketplace.
///
/// This is a domain entity that contains the core listing information
/// and is independent of any data source or framework.
class Listing extends Equatable {
  final String id;
  final String title;
  final String author;
  final int priceFcfa;
  final String condition; // 'excellent', 'good', 'fair', 'poor'
  final String imageUrl;
  final String sellerId;
  final String description;
  final String status; // 'available', 'sold'
  final DateTime createdAt;

  // Social Venture Features
  final String sellerType; // 'individual', 'bookshop', 'author'
  final bool isBuyBackEligible;
  final int stockCount; // For bookshops
  final bool isFeatured; // For featured listings

  // Seller info (populated from join)
  final String? sellerName;
  final String? sellerLocality;
  final String? sellerWhatsapp;

  const Listing({
    required this.id,
    required this.title,
    required this.author,
    required this.priceFcfa,
    required this.condition,
    required this.imageUrl,
    required this.description,
    required this.sellerId,
    required this.status,
    required this.createdAt,
    this.sellerType = 'individual',
    this.isBuyBackEligible = false,
    this.stockCount = 1,
    this.isFeatured = false,
    this.sellerName,
    this.sellerLocality,
    this.sellerWhatsapp,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        author,
        priceFcfa,
        condition,
        imageUrl,
        description,
        sellerId,
        status,
        createdAt,
        sellerType,
        isBuyBackEligible,
        stockCount,
        isFeatured,
        sellerName,
        sellerLocality,
        sellerWhatsapp,
      ];
}
