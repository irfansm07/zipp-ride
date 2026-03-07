import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';
import '../models/ride_model.dart';

class PnrBookingScreen extends StatefulWidget {
  const PnrBookingScreen({super.key});

  @override
  State<PnrBookingScreen> createState() => _PnrBookingScreenState();
}

class _PnrBookingScreenState extends State<PnrBookingScreen> {
  final _pnrController = TextEditingController();
  bool _isTracking = false;
  bool _showStatus = false;
  int _selectedCategoryIndex = -1;
  final _categories = getRideCategories();

  @override
  void dispose() {
    _pnrController.dispose();
    super.dispose();
  }

  void _trackPnr() async {
    if (_pnrController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid 10-digit PNR', style: AppTheme.body),
          backgroundColor: AppColors.card,
        ),
      );
      return;
    }

    setState(() {
      _isTracking = true;
      _showStatus = false;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isTracking = false;
      _showStatus = true;
    });
  }

  void _scheduleCab() {
    if (_selectedCategoryIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a ride type first', style: AppTheme.body),
          backgroundColor: AppColors.card,
        ),
      );
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _buildSuccessDialog(ctx),
    );
  }

  Widget _buildSuccessDialog(BuildContext ctx) {
    final rideType = _categories[_selectedCategoryIndex].name;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: GlassCard(
        isGlowing: true,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.success.withValues(alpha: 0.1),
                border: Border.all(
                  color: AppColors.success,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.schedule_rounded,
                color: AppColors.success,
                size: 40,
              ),
            )
                .animate()
                .scale(
                  begin: const Offset(0.3, 0.3),
                  end: const Offset(1, 1),
                  duration: 600.ms,
                  curve: Curves.elasticOut,
                )
                .fadeIn(),
            const SizedBox(height: 20),
            Text(
              'Driver Scheduled!',
              style: AppTheme.heading2,
            ).animate(delay: 200.ms).fadeIn(),
            const SizedBox(height: 12),
            Text(
              'Your $rideType will be waiting at KSR Bengaluru Station exactly when your train arrives. We will adjust the pickup automatically if your train is delayed.',
              style: AppTheme.body.copyWith(color: AppColors.grey),
              textAlign: TextAlign.center,
            ).animate(delay: 300.ms).fadeIn(),
            const SizedBox(height: 24),
            GradientButton(
              text: 'Done',
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
            ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('No Delay Cab', style: AppTheme.heading3),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.teal.withValues(alpha: 0.2),
                      AppColors.blue.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.teal.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.train_rounded,
                      color: AppColors.teal,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Smart Train Sync',
                      style: AppTheme.heading2,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your PNR to auto-sync your cab pickup time with your train arrival. Never wait for a cab at the station again!',
                      style: AppTheme.bodySmall.copyWith(color: AppColors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.05, end: 0),

              const SizedBox(height: 32),

              // PNR Input
              Text('Enter 10-digit PNR Number', style: AppTheme.bodyMedium),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: TextField(
                  controller: _pnrController,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  style: GoogleFonts.dmSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 4,
                    color: AppColors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'XXXXXXXXXX',
                    hintStyle: GoogleFonts.dmSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 4,
                      color: AppColors.grey.withValues(alpha: 0.5),
                    ),
                    counterText: '',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    prefixIcon: const Icon(
                      Icons.confirmation_num_rounded,
                      color: AppColors.teal,
                    ),
                  ),
                ),
              ).animate(delay: 200.ms).fadeIn(),

              const SizedBox(height: 24),

              if (!_showStatus)
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isTracking ? null : _trackPnr,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: AppColors.teal),
                      ),
                    ),
                    child: _isTracking
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: AppColors.teal,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Track Status',
                            style: AppTheme.button.copyWith(color: AppColors.teal),
                          ),
                  ),
                ).animate(delay: 300.ms).fadeIn(),

              if (_showStatus) ...[
                // Train Status Card
                Text('Live Train Status', style: AppTheme.heading3)
                    .animate()
                    .fadeIn(),
                const SizedBox(height: 12),
                GlassCard(
                  isGlowing: true,
                  child: Column(
                    children: [
                      // Train Name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '12628 - Karnataka Express',
                                  style: AppTheme.heading3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Delayed by 45 mins',
                                    style: AppTheme.caption.copyWith(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Route
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('NDLS',
                                    style: AppTheme.heading2
                                        .copyWith(color: AppColors.grey)),
                                Text('New Delhi', style: AppTheme.caption),
                                const SizedBox(height: 4),
                                Text('Mar 5, 20:15', style: AppTheme.bodySmall),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              const Icon(Icons.train_rounded,
                                  color: AppColors.teal),
                              Container(
                                width: 60,
                                height: 2,
                                color: AppColors.cardBorder,
                              ),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('SBC',
                                    style: AppTheme.heading2
                                        .copyWith(color: AppColors.teal)),
                                Text('KSR Bengaluru', style: AppTheme.caption),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('13:40',
                                        style: AppTheme.bodySmall.copyWith(
                                            decoration: TextDecoration
                                                .lineThrough,
                                            color: AppColors.grey)),
                                    const SizedBox(width: 4),
                                    Text('14:25',
                                        style: AppTheme.bodySmall.copyWith(
                                            color: AppColors.teal,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.1, end: 0),

                const SizedBox(height: 24),

                // Destination Input
                Text('Where to?', style: AppTheme.bodyMedium)
                    .animate()
                    .fadeIn(),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: TextField(
                    style: AppTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Enter drop location',
                      hintStyle: AppTheme.bodySmall.copyWith(color: AppColors.grey),
                      border: InputBorder.none,
                      icon: const Icon(Icons.location_on_rounded, color: AppColors.pink),
                    ),
                  ),
                ).animate().fadeIn(),

                const SizedBox(height: 32),

                // Ride Selection
                Text('Choose Your Ride', style: AppTheme.bodyMedium)
                    .animate()
                    .fadeIn(),
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = _selectedCategoryIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedCategoryIndex = index);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 100,
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.teal
                                  : AppColors.cardBorder,
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.teal
                                          .withValues(alpha: 0.2),
                                      blurRadius: 16,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : [],
                          ),
                          child: AnimatedScale(
                            scale: isSelected ? 1.05 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  cat.emoji,
                                  style: const TextStyle(fontSize: 28),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  cat.name,
                                  style: AppTheme.bodySmall.copyWith(
                                    color: isSelected
                                        ? AppColors.teal
                                        : AppColors.white,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  cat.priceRange,
                                  style: AppTheme.caption.copyWith(
                                    color: AppColors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ).animate().fadeIn(),

                const SizedBox(height: 32),

                // Schedule Book Button
                GradientButton(
                  text: 'Schedule No Delay Cab',
                  icon: Icons.flash_on_rounded,
                  onPressed: _scheduleCab,
                ).animate().fadeIn().slideY(begin: 0.1, end: 0),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
