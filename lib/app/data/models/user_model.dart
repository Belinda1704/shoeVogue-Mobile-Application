import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String email;
  final String displayName;
  final String? phoneNumber;
  final String? photoURL;
  final Map<String, dynamic> address;
  final List<String> favoriteProducts;
  final List<String> recentlyViewed;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLoginAt;

  UserModel({
    this.id,
    required this.email,
    required this.displayName,
    this.phoneNumber,
    this.photoURL,
    required this.address,
    required this.favoriteProducts,
    required this.recentlyViewed,
    required this.createdAt,
    required this.updatedAt,
    this.lastLoginAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'address': address,
      'favoriteProducts': favoriteProducts,
      'recentlyViewed': recentlyViewed,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'lastLoginAt': lastLoginAt != null ? Timestamp.fromDate(lastLoginAt!) : null,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, [String? id]) {
    return UserModel(
      id: id,
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      phoneNumber: map['phoneNumber'],
      photoURL: map['photoURL'],
      address: Map<String, dynamic>.from(map['address'] ?? {}),
      favoriteProducts: List<String>.from(map['favoriteProducts'] ?? []),
      recentlyViewed: List<String>.from(map['recentlyViewed'] ?? []),
      createdAt: map['createdAt'] != null 
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null 
          ? (map['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
      lastLoginAt: map['lastLoginAt'] != null 
          ? (map['lastLoginAt'] as Timestamp).toDate()
          : null,
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? phoneNumber,
    String? photoURL,
    Map<String, dynamic>? address,
    List<String>? favoriteProducts,
    List<String>? recentlyViewed,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoURL: photoURL ?? this.photoURL,
      address: address ?? this.address,
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
      recentlyViewed: recentlyViewed ?? this.recentlyViewed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
} 