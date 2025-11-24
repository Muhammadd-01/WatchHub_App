import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../products/domain/models/product_model.dart';

class WishlistProvider with ChangeNotifier {
  final String? userId;
  List<ProductModel> _items = [];
  bool _isLoading = false;
  String? _error;

  WishlistProvider({this.userId}) {
    if (userId != null && userId!.isNotEmpty) {
      loadWishlist();
    }
  }

  List<ProductModel> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get itemCount => _items.length;

  bool isInWishlist(String productId) {
    return _items.any((item) => item.id == productId);
  }

  Future<void> loadWishlist() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final doc = await FirebaseFirestore.instance
          .collection(AppConstants.wishlistsCollection)
          .doc(userId)
          .get();

      if (doc.exists) {
        final data = doc.data();
        final productIds = List<String>.from(data?['productIds'] ?? []);

        // Fetch product details
        if (productIds.isNotEmpty) {
          final productsSnapshot = await FirebaseFirestore.instance
              .collection(AppConstants.productsCollection)
              .where(FieldPath.documentId, whereIn: productIds)
              .get();

          _items = productsSnapshot.docs
              .map((doc) => ProductModel.fromFirestore(doc))
              .toList();
        } else {
          _items = [];
        }
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToWishlist(ProductModel product) async {
    try {
      _items.add(product);
      notifyListeners();

      await _updateFirestore();
    } catch (e) {
      _items.removeWhere((item) => item.id == product.id);
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    final removedProduct = _items.firstWhere((item) => item.id == productId);
    _items.removeWhere((item) => item.id == productId);
    notifyListeners();

    try {
      await _updateFirestore();
    } catch (e) {
      _items.add(removedProduct);
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleWishlist(ProductModel product) async {
    if (isInWishlist(product.id)) {
      await removeFromWishlist(product.id);
    } else {
      await addToWishlist(product);
    }
  }

  Future<void> _updateFirestore() async {
    final productIds = _items.map((item) => item.id).toList();

    await FirebaseFirestore.instance
        .collection(AppConstants.wishlistsCollection)
        .doc(userId)
        .set({
      'productIds': productIds,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> clearWishlist() async {
    _items.clear();
    notifyListeners();

    try {
      await FirebaseFirestore.instance
          .collection(AppConstants.wishlistsCollection)
          .doc(userId)
          .delete();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
