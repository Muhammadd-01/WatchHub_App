import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String title;
  final String brand;
  final String type;
  final double price;
  final String currency;
  final List<String> images;
  final Map<String, String> specs;
  final int stock;
  final double rating;
  final int numRatings;
  final String categoryId;
  final bool isFeatured;
  final DateTime createdAt;
  final String? description;

  ProductModel({
    required this.id,
    required this.title,
    required this.brand,
    required this.type,
    required this.price,
    this.currency = 'USD',
    required this.images,
    required this.specs,
    required this.stock,
    this.rating = 0.0,
    this.numRatings = 0,
    required this.categoryId,
    this.isFeatured = false,
    required this.createdAt,
    this.description,
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      title: data['title'] ?? '',
      brand: data['brand'] ?? '',
      type: data['type'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      currency: data['currency'] ?? 'USD',
      images: List<String>.from(data['images'] ?? []),
      specs: Map<String, String>.from(data['specs'] ?? {}),
      stock: data['stock'] ?? 0,
      rating: (data['rating'] ?? 0).toDouble(),
      numRatings: data['numRatings'] ?? 0,
      categoryId: data['categoryId'] ?? '',
      isFeatured: data['isFeatured'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      description: data['description'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'brand': brand,
      'type': type,
      'price': price,
      'currency': currency,
      'images': images,
      'specs': specs,
      'stock': stock,
      'rating': rating,
      'numRatings': numRatings,
      'categoryId': categoryId,
      'isFeatured': isFeatured,
      'createdAt': Timestamp.fromDate(createdAt),
      'description': description,
    };
  }

  ProductModel copyWith({
    String? title,
    String? brand,
    String? type,
    double? price,
    String? currency,
    List<String>? images,
    Map<String, String>? specs,
    int? stock,
    double? rating,
    int? numRatings,
    String? categoryId,
    bool? isFeatured,
    String? description,
  }) {
    return ProductModel(
      id: id,
      title: title ?? this.title,
      brand: brand ?? this.brand,
      type: type ?? this.type,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      images: images ?? this.images,
      specs: specs ?? this.specs,
      stock: stock ?? this.stock,
      rating: rating ?? this.rating,
      numRatings: numRatings ?? this.numRatings,
      categoryId: categoryId ?? this.categoryId,
      isFeatured: isFeatured ?? this.isFeatured,
      createdAt: createdAt,
      description: description ?? this.description,
    );
  }

  bool get inStock => stock > 0;

  String get formattedPrice => '\$$price';
}
