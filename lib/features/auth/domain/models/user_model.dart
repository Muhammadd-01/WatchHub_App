import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? phone;
  final String? photoUrl;
  final List<Address> addresses;
  final DateTime createdAt;
  final bool isAdmin;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.phone,
    this.photoUrl,
    this.addresses = const [],
    required this.createdAt,
    this.isAdmin = false,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'],
      photoUrl: data['photoUrl'],
      addresses: (data['addresses'] as List<dynamic>?)
              ?.map((addr) => Address.fromMap(addr as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isAdmin: data['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'addresses': addresses.map((addr) => addr.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'isAdmin': isAdmin,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    List<Address>? addresses,
    bool? isAdmin,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      addresses: addresses ?? this.addresses,
      createdAt: createdAt,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}

class Address {
  final String id;
  final String label;
  final String line1;
  final String? line2;
  final String city;
  final String postalCode;
  final String country;

  Address({
    required this.id,
    required this.label,
    required this.line1,
    this.line2,
    required this.city,
    required this.postalCode,
    required this.country,
  });

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'] ?? '',
      label: map['label'] ?? '',
      line1: map['line1'] ?? '',
      line2: map['line2'],
      city: map['city'] ?? '',
      postalCode: map['postalCode'] ?? '',
      country: map['country'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'line1': line1,
      'line2': line2,
      'city': city,
      'postalCode': postalCode,
      'country': country,
    };
  }

  String get fullAddress {
    final parts = [
      line1,
      if (line2 != null && line2!.isNotEmpty) line2,
      city,
      postalCode,
      country,
    ];
    return parts.join(', ');
  }
}
