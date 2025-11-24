import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../features/auth/domain/models/user_model.dart';
import '../core/error/error_handler.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ErrorHandler _errorHandler = ErrorHandler.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    return await _errorHandler.runSafely<UserCredential>(
      () => _auth.signInWithEmailAndPassword(email: email, password: password),
      context,
    );
  }

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required BuildContext context,
  }) async {
    return await _errorHandler.runSafely<UserCredential>(
      () async {
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        // Send email verification
        await userCredential.user?.sendEmailVerification();
        // Create user document in Firestore
        await _createUserDocument(
          uid: userCredential.user!.uid,
          email: email,
          name: name,
        );
        return userCredential;
      },
      context,
    );
  }

  // Create user document
  Future<void> _createUserDocument({
    required String uid,
    required String email,
    required String name,
  }) async {
    final userModel = UserModel(
      uid: uid,
      name: name,
      email: email,
      createdAt: DateTime.now(),
      isAdmin: false,
    );
    await _firestore.collection('users').doc(uid).set(userModel.toFirestore());
  }

  // Get user document
  Future<UserModel?> getUserDocument(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Update user document
  Future<void> updateUserDocument(UserModel user) async {
    await _firestore
        .collection('users')
        .doc(user.uid)
        .update(user.toFirestore());
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(
      String email, BuildContext context) async {
    await _errorHandler.runSafely<void>(
      () => _auth.sendPasswordResetEmail(email: email),
      context,
    );
  }

  // Send email verification
  Future<void> sendEmailVerification(BuildContext context) async {
    await _errorHandler.runSafely<void>(
      () async {
        if (_auth.currentUser != null) {
          await _auth.currentUser!.sendEmailVerification();
        }
      },
      context,
    );
  }

  // Reload user
  Future<void> reloadUser() async {
    await _auth.currentUser?.reload();
  }

  // Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required BuildContext context,
  }) async {
    await _errorHandler.runSafely<void>(
      () async {
        final user = _auth.currentUser;
        if (user == null) throw Exception('No user logged in');
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
      },
      context,
    );
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Delete account
  Future<void> deleteAccount(String password, BuildContext context) async {
    await _errorHandler.runSafely<void>(
      () async {
        final user = _auth.currentUser;
        if (user == null) throw Exception('No user logged in');
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
        // Delete user document
        await _firestore.collection('users').doc(user.uid).delete();
        // Delete account
        await user.delete();
      },
      context,
    );
  }
}
