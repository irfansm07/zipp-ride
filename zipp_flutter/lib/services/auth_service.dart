import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = '';

  // Step 1: Send OTP to Phone Number
  Future<void> sendOTP(String phoneNumber, Function(String) onCodeSent, Function(String) onError) async {
    try {
      debugPrint('Sending OTP to: $phoneNumber');
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-resolution (often works on Android)
          debugPrint('Auto-verification completed');
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint('Verification failed: ${e.code} - ${e.message}');
          String errorMessage = _getErrorMessage(e);
          onError(errorMessage);
        },
        codeSent: (String verificationId, int? resendToken) {
          debugPrint('OTP code sent successfully');
          _verificationId = verificationId;
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          debugPrint('Auto-retrieval timeout');
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      debugPrint('SendOTP error: $e');
      onError(e.toString());
    }
  }

  // Step 2: Verify the OTP entered by use
  Future<User?> verifyOTP(String smsCode) async {
    try {
      debugPrint('Verifying OTP with code: $smsCode');
      debugPrint('Using verificationId: $_verificationId');
      
      if (_verificationId.isEmpty) {
        throw Exception('No verification ID found. Please request OTP again.');
      }
      
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: smsCode,
      );
      UserCredential result = await _auth.signInWithCredential(credential);
      debugPrint('OTP verification successful for user: ${result.user?.uid}');
      return result.user;
    } catch (e) {
      debugPrint('OTP Error: $e');
      rethrow;
    }
  }

  // Helper method to get user-friendly error messages
  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return 'The phone number is not valid. Please check and try again.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'quota-exceeded':
        return 'SMS quota exceeded. Please try again later.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'web-context-cancelled':
        return 'The reCAPTCHA was cancelled. Please try again.';
      case 'app-not-authorized':
        return 'This app is not authorized to use Firebase Authentication.';
      case 'invalid-app-credential':
        return 'The app credential is invalid.';
      case 'session-expired':
        return 'The SMS code has expired. Please request a new one.';
      case 'invalid-verification-code':
        return 'The SMS code is invalid. Please check and try again.';
      case 'missing-verification-code':
        return 'Please enter the SMS code.';
      default:
        return e.message ?? 'An unknown error occurred. Please try again.';
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Stream to listen to auth state changes
  Stream<User?> get user {
    return _auth.authStateChanges();
  }
}
