import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String? userPhotoUrl;
  final double rating;
  final String? title;
  final String body;
  final int helpfulCount;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    this.userPhotoUrl,
    required this.rating,
    this.title,
    required this.body,
    this.helpfulCount = 0,
    required this.createdAt,
  });

  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReviewModel(
      id: doc.id,
      productId: data['productId'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userPhotoUrl: data['userPhotoUrl'],
      rating: (data['rating'] ?? 0).toDouble(),
      title: data['title'],
      body: data['body'] ?? '',
      helpfulCount: data['helpfulCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'productId': productId,
      'userId': userId,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'rating': rating,
      'title': title,
      'body': body,
      'helpfulCount': helpfulCount,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
