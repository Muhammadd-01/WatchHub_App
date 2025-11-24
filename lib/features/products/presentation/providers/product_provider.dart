import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/product_model.dart';
import '../../../../core/constants/app_constants.dart';

class ProductProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ProductModel> _products = [];
  List<ProductModel> _featuredProducts = [];
  bool _isLoading = false;
  String? _errorMessage;
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;

  List<ProductModel> get products => _products;
  List<ProductModel> get featuredProducts => _featuredProducts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;

  // Fetch featured products
  Future<void> fetchFeaturedProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.productsCollection)
          .where('isFeatured', isEqualTo: true)
          .limit(10)
          .get();

      _featuredProducts = querySnapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load featured products: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch products with pagination
  Future<void> fetchProducts({bool refresh = false}) async {
    if (_isLoading || (!_hasMore && !refresh)) return;

    if (refresh) {
      _products = [];
      _lastDocument = null;
      _hasMore = true;
    }

    _isLoading = true;
    notifyListeners();

    try {
      Query query = _firestore
          .collection(AppConstants.productsCollection)
          .orderBy('createdAt', descending: true)
          .limit(AppConstants.productsPerPage);

      if (_lastDocument != null && !refresh) {
        query = query.startAfterDocument(_lastDocument!);
      }

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isEmpty) {
        _hasMore = false;
      } else {
        _lastDocument = querySnapshot.docs.last;
        final newProducts = querySnapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc))
            .toList();
        _products.addAll(newProducts);

        if (querySnapshot.docs.length < AppConstants.productsPerPage) {
          _hasMore = false;
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load products: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch products by category
  Future<List<ProductModel>> fetchProductsByCategory(String categoryId) async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.productsCollection)
          .where('categoryId', isEqualTo: categoryId)
          .get();

      return querySnapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to load products by category: $e');
    }
  }

  // Search products
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      // Note: This is a simple search. For production, use Algolia or similar
      final querySnapshot =
          await _firestore.collection(AppConstants.productsCollection).get();

      final allProducts = querySnapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();

      return allProducts.where((product) {
        final searchLower = query.toLowerCase();
        return product.title.toLowerCase().contains(searchLower) ||
            product.brand.toLowerCase().contains(searchLower) ||
            product.type.toLowerCase().contains(searchLower);
      }).toList();
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  // Get product by ID
  Future<ProductModel?> getProductById(String productId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.productsCollection)
          .doc(productId)
          .get();

      if (doc.exists) {
        return ProductModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get product: $e');
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
