import 'package:equatable/equatable.dart';

/// Represents a user in the BookBridge application.
///
/// This is a domain entity that contains the core user information
/// and is independent of any data source or framework.
class User extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String? locality;
  final String? whatsappNumber;
  final String? avatarUrl;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    this.locality,
    this.whatsappNumber,
    this.avatarUrl,
    required this.createdAt,
  });

  User copyWith({
    String? id,
    String? email,
    String? fullName,
    String? locality,
    String? whatsappNumber,
    String? avatarUrl,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      locality: locality ?? this.locality,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    fullName,
    locality,
    whatsappNumber,
    avatarUrl,
    createdAt,
  ];
}
