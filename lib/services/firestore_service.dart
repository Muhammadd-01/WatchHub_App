import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Generic get document
  Future<DocumentSnapshot> getDocument(String collection, String docId) async {
    try {
      return await _firestore.collection(collection).doc(docId).get();
    } catch (e) {
      throw Exception('Failed to get document: $e');
    }
  }

  // Generic get collection
  Future<QuerySnapshot> getCollection(String collection) async {
    try {
      return await _firestore.collection(collection).get();
    } catch (e) {
      throw Exception('Failed to get collection: $e');
    }
  }

  // Generic get collection with query
  Future<QuerySnapshot> getCollectionWithQuery(
    String collection,
    List<QueryFilter> filters, {
    int? limit,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      Query query = _firestore.collection(collection);

      // Apply filters
      for (final filter in filters) {
        query = query.where(filter.field, isEqualTo: filter.value);
      }

      // Apply limit
      if (limit != null) {
        query = query.limit(limit);
      }

      // Apply pagination
      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      return await query.get();
    } catch (e) {
      throw Exception('Failed to query collection: $e');
    }
  }

  // Generic add document
  Future<DocumentReference> addDocument(
    String collection,
    Map<String, dynamic> data,
  ) async {
    try {
      return await _firestore.collection(collection).add(data);
    } catch (e) {
      throw Exception('Failed to add document: $e');
    }
  }

  // Generic set document
  Future<void> setDocument(
    String collection,
    String docId,
    Map<String, dynamic> data, {
    bool merge = false,
  }) async {
    try {
      await _firestore
          .collection(collection)
          .doc(docId)
          .set(data, SetOptions(merge: merge));
    } catch (e) {
      throw Exception('Failed to set document: $e');
    }
  }

  // Generic update document
  Future<void> updateDocument(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection(collection).doc(docId).update(data);
    } catch (e) {
      throw Exception('Failed to update document: $e');
    }
  }

  // Generic delete document
  Future<void> deleteDocument(String collection, String docId) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
    } catch (e) {
      throw Exception('Failed to delete document: $e');
    }
  }

  // Stream document
  Stream<DocumentSnapshot> streamDocument(String collection, String docId) {
    return _firestore.collection(collection).doc(docId).snapshots();
  }

  // Stream collection
  Stream<QuerySnapshot> streamCollection(String collection) {
    return _firestore.collection(collection).snapshots();
  }

  // Batch write
  Future<void> batchWrite(List<BatchOperation> operations) async {
    try {
      final batch = _firestore.batch();

      for (final operation in operations) {
        final docRef =
            _firestore.collection(operation.collection).doc(operation.docId);

        switch (operation.type) {
          case BatchOperationType.set:
            batch.set(docRef, operation.data!);
            break;
          case BatchOperationType.update:
            batch.update(docRef, operation.data!);
            break;
          case BatchOperationType.delete:
            batch.delete(docRef);
            break;
        }
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to execute batch write: $e');
    }
  }
}

class QueryFilter {
  final String field;
  final dynamic value;

  QueryFilter(this.field, this.value);
}

enum BatchOperationType { set, update, delete }

class BatchOperation {
  final String collection;
  final String docId;
  final BatchOperationType type;
  final Map<String, dynamic>? data;

  BatchOperation({
    required this.collection,
    required this.docId,
    required this.type,
    this.data,
  });
}
