import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_button.dart';
import '../services/auth_service.dart';
import 'main_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool _isOtpSent = false;
  bool _isLoading = false;
  final _nameController = TextEditingController(text: 'Irfan');
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _sendOtp() async {
    String phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a phone number'), backgroundColor: AppColors.pink),
      );
      return;
    }

    // Validate phone number format
    if (!phone.startsWith('+')) {
      phone = '+91$phone';
    }
    
    // Basic phone number validation
    if (phone.length < 10 || phone.length > 15) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid phone number'), backgroundColor: AppColors.pink),
      );
      return;
    }

    setState(() => _isLoading = true);

    await _authService.sendOTP(
      phone,
      (String verificationId) {
        setState(() {
          _isLoading = false;
          _isOtpSent = true;
        });
      },
      (String error) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(error), backgroundColor: AppColors.pink),
          );
        }
      },
    );
  }

  void _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the OTP code'), backgroundColor: AppColors.pink),
      );
      return;
    }

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a 6-digit OTP code'), backgroundColor: AppColors.pink),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      User? user = await _authService.verifyOTP(otp);
      if (mounted && user != null) {
        setState(() => _isLoading = false);
        final name = _nameController.text.isEmpty ? 'Rider' : _nameController.text;
        _showLoginSuccess(name);
      } else {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed. Please try again.'), backgroundColor: AppColors.pink),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.pink),
        );
      }
    }
  }

  void _showLoginSuccess(String name) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (ctx) {
        Future.delayed(const Duration(seconds: 2), () {
          if (ctx.mounted) Navigator.pop(ctx);
          if (mounted) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => MainNavigation(userName: name),
                transitionsBuilder: (_, animation, __, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOutCubic,
                    )),
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 500),
              ),
            );
          }
        });

        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.teal.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.teal.withValues(alpha: 0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.teal.withValues(alpha: 0.15),
                  ),
                  child: const Icon(
                    Icons.waving_hand_rounded,
                    color: AppColors.amber,
                    size: 32,
                  ),
                )
                    .animate()
                    .scale(
                      begin: const Offset(0, 0),
                      end: const Offset(1, 1),
                      duration: 500.ms,
                      curve: Curves.elasticOut,
                    ),
                const SizedBox(height: 20),
                Text(
                  '🎉 Welcome!',
                  style: AppTheme.heading2,
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 8),
                Text(
                  'Hey $name! 👋',
                  style: AppTheme.bodyMedium.copyWith(color: AppColors.teal),
                ).animate().fadeIn(delay: 400.ms),
                const SizedBox(height: 4),
                Text(
                  'Ready to ride?',
                  style: AppTheme.bodySmall,
                ).animate().fadeIn(delay: 500.ms),
              ],
            ),
          ).animate().scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                duration: 400.ms,
                curve: Curves.easeOutBack,
              ),
        );
      },
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: AppTheme.body,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTheme.body.copyWith(color: AppColors.grey),
          prefixIcon: Icon(icon, color: AppColors.teal, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Logo
              Row(
                 children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.teal.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.flash_on_rounded,
                        color: AppColors.teal,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('ZipRide', style: AppTheme.heading1),
                 ]
              ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.2, end: 0),
              const SizedBox(height: 40),
              
              // Title
              Text(
                _isOtpSent ? 'Verify\nCode 📩' : 'Let\'s Get\nStarted ✨',
                style: AppTheme.heading1.copyWith(
                  fontSize: 36,
                  height: 1.2,
                ),
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 8),
              Text(
                _isOtpSent
                    ? 'Enter the 6-digit code sent to your phone'
                    : 'Enter your phone number to sign up or login',
                style: AppTheme.body.copyWith(color: AppColors.grey),
              ),
              const SizedBox(height: 32),

              // Form fields
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Column(
                  key: ValueKey(_isOtpSent),
                  children: [
                    if (!_isOtpSent) ...[
                      _buildInputField(
                        controller: _nameController,
                        hint: 'Full Name',
                        icon: Icons.person_outline_rounded,
                      ),
                      _buildInputField(
                        controller: _phoneController,
                        hint: 'Phone Number (e.g. +91...)',
                        icon: Icons.phone_rounded,
                        keyboardType: TextInputType.phone,
                      ),
                    ] else ...[
                      _buildInputField(
                        controller: _otpController,
                        hint: '6-Digit OTP Code',
                        icon: Icons.message_rounded,
                        keyboardType: TextInputType.number,
                      ),
                    ]
                  ],
                ),
              ),

              const SizedBox(height: 24),
              if (_isLoading)
                 const Center(child: CircularProgressIndicator(color: AppColors.teal))
              else
                 GradientButton(
                   text: _isOtpSent ? 'Verify & Login' : 'Send SMS Code',
                   icon: _isOtpSent ? Icons.check_circle_rounded : Icons.send_rounded,
                   onPressed: _isOtpSent ? _verifyOtp : _sendOtp,
                 ),
              
              if (_isOtpSent)
                 Padding(
                   padding: const EdgeInsets.only(top: 16),
                   child: Align(
                     alignment: Alignment.center,
                     child: TextButton(
                       onPressed: () => setState(() => _isOtpSent = false),
                       child: Text('Change Phone Number', style: AppTheme.bodySmall.copyWith(color: AppColors.grey)),
                     ),
                   ),
                 ),

              const SizedBox(height: 24),
              // Divider
              Row(
                children: [
                  Expanded(child: Container(height: 1, color: AppColors.cardBorder)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('or continue with', style: AppTheme.bodySmall),
                  ),
                  Expanded(child: Container(height: 1, color: AppColors.cardBorder)),
                ],
              ),
              const SizedBox(height: 24),
              // Social buttons
              Row(
                children: [
                  _buildSocialButton(Icons.mail_rounded, 'Google'),
                  const SizedBox(width: 12),
                  _buildSocialButton(Icons.apple_rounded, 'Apple'),
                ],
              ),
              const SizedBox(height: 32),
            ]
          )
        )
      )
    );
  }

  Widget _buildSocialButton(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.white, size: 20),
            const SizedBox(width: 8),
            Text(label, style: AppTheme.body),
          ],
        ),
      ),
    );
  }
}

