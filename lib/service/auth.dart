import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:planner/service/database.dart';

class AuthMethod {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  Future<User?> getCurrentUser() async => _auth.currentUser;

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      // ให้ timeout กันแอปค้างนานเกิน
      final googleUser = await _googleSignIn
          .signIn()
          .timeout(const Duration(seconds: 15), onTimeout: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google Login ใช้เวลานานเกินไป')),
        );
        return null;
      });

      if (googleUser == null) {
        // ผู้ใช้กด cancel หรือ timeout
        return null;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final result = await _auth.signInWithCredential(credential);
      final user = result.user;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ไม่สามารถเข้าสู่ระบบด้วย Google ได้')),
        );
        return null;
      }

      // บันทึก user ลง Firestore
      final userInfoMap = {
        "email": user.email,
        "name": user.displayName,
        "imgUrl": user.photoURL,
        "id": user.uid,
      };
      await DatabaseMethod().addUser(user.uid, userInfoMap);

      return result;
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException (Google): ${e.code}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Login error: ${e.code}')),
      );
      return null;
    } catch (e) {
      debugPrint('Google sign-in error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Login failed: $e')),
      );
      return null;
    }
  }

  //Apple
  Future<void> signInWithApple(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login with Apple ยังไม่พร้อมใช้งาน')),
    );
  }
}
