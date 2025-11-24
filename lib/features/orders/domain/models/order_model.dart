import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../auth/domain/models/user_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double subtotal;
  final double shipping;
  final double tax;
  final double total;
  final Address shippingAddress;
  final String paymentMethod;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? trackingNumber;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.total,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.trackingNumber,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      items: (data['items'] as List<dynamic>)
          .map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      subtotal: (data['subtotal'] ?? 0).toDouble(),
      shipping: (data['shipping'] ?? 0).toDouble(),
      tax: (data['tax'] ?? 0).toDouble(),
      total: (data['total'] ?? 0).toDouble(),
      shippingAddress:
          Address.fromMap(data['shippingAddress'] as Map<String, dynamic>),
      paymentMethod: data['paymentMethod'] ?? '',
      status: data['status'] ?? 'processing',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      trackingNumber: data['trackingNumber'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'shipping': shipping,
      'tax': tax,
      'total': total,
      'shippingAddress': shippingAddress.toMap(),
      'paymentMethod': paymentMethod,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'trackingNumber': trackingNumber,
    };
  }

  String get statusDisplay {
    switch (status) {
      case 'processing':
        return 'Processing';
      case 'shipped':
        return 'Shipped';
      case 'out_for_delivery':
        return 'Out for Delivery';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }
}

class OrderItem {
  final String productId;
  final String title;
  final double price;
  final int quantity;
  final String image;

  OrderItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity,
    required this.image,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      title: map['title'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 1,
      image: map['image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'quantity': quantity,
      'image': image,
    };
  }

  double get itemTotal => price * quantity;
}
