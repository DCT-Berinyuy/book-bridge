import 'package:book_bridge/features/listings/domain/entities/listing.dart';

/// Data Transfer Object for Listing.
///
/// This model represents the listing data structure received from Supabase.
/// It includes methods for serialization and mapping to domain entities.
class ListingModel extends Listing {
  const ListingModel({
    required super.id,
    required super.title,
    required super.author,
    required super.priceFcfa,
    required super.condition,
    required super.imageUrl,
    required super.description,
    required super.sellerId,
    required super.status,
    required super.createdAt,
    super.sellerName,
    super.sellerLocality,
    super.sellerWhatsapp,
  });

  /// Creates a ListingModel instance from JSON.
  ///
  /// This factory constructor is typically used when deserializing data
  /// received from Supabase.
  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      author: json['author'] as String? ?? '',
      priceFcfa: json['price_fcfa'] as int? ?? 0,
      condition: json['condition'] as String? ?? 'good',
      imageUrl: json['image_url'] as String? ?? '',
      description: json['description'] as String? ?? '',
      sellerId: json['seller_id'] as String? ?? '',
      status: json['status'] as String? ?? 'available',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      sellerName:
          (json['profiles'] as Map<String, dynamic>?)?['full_name'] as String?,
      sellerLocality:
          (json['profiles'] as Map<String, dynamic>?)?['locality'] as String?,
      sellerWhatsapp:
          (json['profiles'] as Map<String, dynamic>?)?['whatsapp_number']
              as String?,
    );
  }

  /// Converts the ListingModel to JSON.
  ///
  /// This method is used when sending data to Supabase.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'price_fcfa': priceFcfa,
      'condition': condition,
      'image_url': imageUrl,
      'description': description,
      'seller_id': sellerId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Creates a ListingModel from a domain Listing entity.
  factory ListingModel.fromEntity(Listing listing) {
    return ListingModel(
      id: listing.id,
      title: listing.title,
      author: listing.author,
      priceFcfa: listing.priceFcfa,
      condition: listing.condition,
      imageUrl: listing.imageUrl,
      description: listing.description,
      sellerId: listing.sellerId,
      status: listing.status,
      createdAt: listing.createdAt,
      sellerName: listing.sellerName,
      sellerLocality: listing.sellerLocality,
      sellerWhatsapp: listing.sellerWhatsapp,
    );
  }

  /// Converts this model to a domain Listing entity.
  Listing toEntity() {
    return Listing(
      id: id,
      title: title,
      author: author,
      priceFcfa: priceFcfa,
      condition: condition,
      imageUrl: imageUrl,
      description: description,
      sellerId: sellerId,
      status: status,
      createdAt: createdAt,
      sellerName: sellerName,
      sellerLocality: sellerLocality,
      sellerWhatsapp: sellerWhatsapp,
    );
  }
}
