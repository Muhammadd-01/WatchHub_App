import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_constants.dart';

class CartProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<CartItem> _items = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _userId;

  CartProvider({String? userId}) {
    _userId = userId;
    if (_userId != null && _userId!.isNotEmpty) {
      loadCart();
    }
  }

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(
        0,
        (sum, item) => sum + (item.price * item.quantity),
      );

  double get shipping => subtotal > 0 ? 10.0 : 0.0;
  double get tax => 0.0; // Can be calculated based on location
  double get total => subtotal + shipping + tax;

  void setUserId(String userId) {
    _userId = userId;
    if (_userId != null && _userId!.isNotEmpty) {
      loadCart();
    } else {
      _items = [];
      notifyListeners();
    }
  }

  // Load cart from Firestore
  Future<void> loadCart() async {
    if (_userId == null || _userId!.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final doc = await _firestore
          .collection(AppConstants.cartsCollection)
          .doc(_userId)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('items')) {
          _items = (data['items'] as List<dynamic>)
              .map((item) => CartItem.fromMap(item as Map<String, dynamic>))
              .toList();
        } else {
          _items = [];
        }
      } else {
        _items = [];
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load cart: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save cart to Firestore
  Future<void> _saveCart() async {
    if (_userId == null || _userId!.isEmpty) return;

    try {
      await _firestore
          .collection(AppConstants.cartsCollection)
          .doc(_userId)
          .set({
        'items': _items.map((item) => item.toMap()).toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      _errorMessage = 'Failed to save cart: $e';
      notifyListeners();
    }
  }

  // Add item to cart
  Future<void> addItem({
    required String productId,
    required String title,
    required double price,
    required String image,
    int quantity = 1,
  }) async {
    final existingIndex =
        _items.indexWhere((item) => item.productId == productId);

    if (existingIndex >= 0) {
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + quantity,
      );
    } else {
      _items.add(CartItem(
        productId: productId,
        title: title,
        price: price,
        image: image,
        quantity: quantity,
      ));
    }

    notifyListeners();
    await _saveCart();
  }

  // Remove item from cart
  Future<void> removeItem(String productId) async {
    _items.removeWhere((item) => item.productId == productId);
    notifyListeners();
    await _saveCart();
  }

  // Update item quantity
  Future<void> updateQuantity(String productId, int quantity) async {
    if (quantity <= 0) {
      await removeItem(productId);
      return;
    }

    final index = _items.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: quantity);
      notifyListeners();
      await _saveCart();
    }
  }

  // Clear cart
  Future<void> clearCart() async {
    _items = [];
    notifyListeners();
    await _saveCart();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

class CartItem {
  final String productId;
  final String title;
  final double price;
  final String image;
  final int quantity;

  CartItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
    required this.quantity,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
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

  CartItem copyWith({
    String? productId,
    String? title,
    double? price,
    String? image,
    int? quantity,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      title: title ?? this.title,
      price: price ?? this.price,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
    );
  }

  double get itemTotal => price * quantity;
}
