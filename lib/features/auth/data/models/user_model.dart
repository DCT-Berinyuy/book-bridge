import 'package:book_bridge/features/auth/domain/entities/user.dart';

/// Data Transfer Object for User.
///
/// This model represents the user data structure received from Supabase.
/// It includes methods for serialization and mapping to domain entities.
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    super.locality,
    super.whatsappNumber,
    required super.createdAt,
  });

  /// Creates a UserModel instance from JSON.
  ///
  /// This factory constructor is typically used when deserializing data
  /// received from Supabase (either Auth or Database).
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String? ?? '',
      locality: json['locality'] as String?,
      whatsappNumber: json['whatsapp_number'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  /// Converts the UserModel to JSON.
  ///
  /// This method is used when sending data to Supabase.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'locality': locality,
      'whatsapp_number': whatsappNumber,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Creates a UserModel from a domain User entity.
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      fullName: user.fullName,
      locality: user.locality,
      whatsappNumber: user.whatsappNumber,
      createdAt: user.createdAt,
    );
  }

  /// Converts this model to a domain User entity.
  User toEntity() {
    return User(
      id: id,
      email: email,
      fullName: fullName,
      locality: locality,
      whatsappNumber: whatsappNumber,
      createdAt: createdAt,
    );
  }
}
