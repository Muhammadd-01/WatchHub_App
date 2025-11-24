class CartItemModel {
  final String productId;
  final String title;
  final double price;
  final String image;
  final int quantity;

  CartItemModel({
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
    required this.quantity,
  });

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      productId: map['productId'] ?? '',
      title: map['title'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      image: map['image'] ?? '',
      quantity: map['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'image': image,
      'quantity': quantity,
    };
  }

  CartItemModel copyWith({
    String? productId,
    String? title,
    double? price,
    String? image,
    int? quantity,
  }) {
    return CartItemModel(
      productId: productId ?? this.productId,
      title: title ?? this.title,
      price: price ?? this.price,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
    );
  }

  double get itemTotal => price * quantity;
}
