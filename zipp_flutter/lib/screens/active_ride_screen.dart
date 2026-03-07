import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class ActiveRideScreen extends StatefulWidget {
  const ActiveRideScreen({super.key});

  @override
  State<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends State<ActiveRideScreen>
    with TickerProviderStateMixin {
  late AnimationController _mapLineController;
  bool _hasActiveRide = false;

  @override
  void initState() {
    super.initState();
    _mapLineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _mapLineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('My Active Ride', style: AppTheme.heading3),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _hasActiveRide ? SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Driver is arriving', style: AppTheme.heading2),
                      const SizedBox(height: 4),
                      Text('Your Sedan will be there in 4 mins',
                          style: AppTheme.bodySmall.copyWith(color: AppColors.grey)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.teal.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.teal.withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      children: [
                        Text('OTP', style: AppTheme.caption.copyWith(color: AppColors.teal)),
                        Text('4821', style: AppTheme.heading3.copyWith(letterSpacing: 2)),
                      ],
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 24),

              // Mock Live Map
              Container(
                height: 220,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  children: [
                    // Grid lines (horizontal)
                    ...List.generate(6, (i) {
                      return Positioned(
                        top: (i + 1) * 36.0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 1,
                          color: AppColors.cardBorder.withValues(alpha: 0.3),
                        ),
                      );
                    }),
                    // Grid lines (vertical)
                    ...List.generate(6, (i) {
                      return Positioned(
                        left: (i + 1) * 60.0,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 1,
                          color: AppColors.cardBorder.withValues(alpha: 0.3),
                        ),
                      );
                    }),
                    
                    // Route line (Animated)
                    AnimatedBuilder(
                      animation: _mapLineController,
                      builder: (context, child) {
                        return Positioned(
                          top: 80,
                          left: 80,
                          child: Container(
                            width: 150,
                            height: 4,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.teal.withValues(alpha: 0.2),
                                  AppColors.teal,
                                  AppColors.teal.withValues(alpha: 0.2),
                                ],
                                stops: [
                                  0.0,
                                  _mapLineController.value,
                                  1.0,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      },
                    ),

                    // Pickup pin (You)
                    Positioned(
                      top: 60,
                      left: 60,
                      child: Column(
                        children: [
                          const Icon(Icons.location_on_rounded, color: AppColors.teal, size: 32),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.background.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text('Pickup', style: AppTheme.caption.copyWith(fontSize: 10)),
                          ),
                        ],
                      ),
                    ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(begin: 0, end: -4, duration: 1000.ms),

                    // Driver pin (Moving vehicle)
                    Positioned(
                      top: 66,
                      left: 140,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.amber,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.amber.withValues(alpha: 0.4),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.directions_car_rounded, color: Colors.white, size: 20),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.background.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text('4 min', style: AppTheme.caption.copyWith(color: AppColors.amber, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ).animate(onPlay: (c) => c.repeat()).moveX(begin: 60, end: -20, duration: 4000.ms),
                    ),
                  ],
                ),
              ).animate(delay: 100.ms).fadeIn().scale(begin: const Offset(0.95, 0.95)),

              const SizedBox(height: 24),

              // Driver Card
              GlassCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.teal.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.teal.withValues(alpha: 0.5), width: 2),
                          ),
                          child: const Center(
                            child: Text('R', style: TextStyle(color: AppColors.teal, fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Rahul Sharma', style: AppTheme.heading3),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Text('Sedan • ', style: AppTheme.caption),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.yellow.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: Colors.yellow.withValues(alpha: 0.5)),
                                    ),
                                    child: Text('KA 01 AB 1234', style: AppTheme.caption.copyWith(color: Colors.yellow, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: AppColors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text('4.8', style: AppTheme.bodySmall.copyWith(color: AppColors.amber, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.phone_rounded, color: AppColors.success, size: 20),
                                SizedBox(width: 8),
                                Text('Call', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.blue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.chat_bubble_rounded, color: AppColors.blue, size: 20),
                                SizedBox(width: 8),
                                Text('Message', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1, end: 0),

              const SizedBox(height: 24),

              // Ride Details Outline
              Text('Trip Details', style: AppTheme.heading3).animate(delay: 300.ms).fadeIn(),
              const SizedBox(height: 12),
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.my_location_rounded, color: AppColors.teal, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Pickup', style: AppTheme.caption),
                              Text('Current Location', style: AppTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 9, top: 4, bottom: 4),
                      child: Container(
                        width: 2,
                        height: 20,
                        color: AppColors.cardBorder,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded, color: AppColors.pink, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Dropoff', style: AppTheme.caption),
                              Text('MG Road, Bangalore', style: AppTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(height: 1, color: AppColors.cardBorder),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Estimated Fare', style: AppTheme.bodyMedium),
                        Text('₹249.00', style: AppTheme.heading3.copyWith(color: AppColors.teal)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Payment Method', style: AppTheme.bodySmall.copyWith(color: AppColors.grey)),
                        Row(
                          children: [
                            const Icon(Icons.account_balance_wallet_rounded, color: AppColors.grey, size: 14),
                            const SizedBox(width: 4),
                            Text('UPI', style: AppTheme.bodySmall.copyWith(color: AppColors.white)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.1, end: 0),

              const SizedBox(height: 32),

              // Cancel Button
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    // Simulating cancellation
                    setState(() => _hasActiveRide = false);
                  },
                  icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                  label: const Text('Cancel Ride', style: TextStyle(color: Colors.red, fontSize: 16)),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: Colors.red.withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ).animate(delay: 500.ms).fadeIn(),
              
              const SizedBox(height: 40),
            ],
          ),
        ) : _buildNoRideView(),
      ),
    );
  }

  Widget _buildNoRideView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.teal.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.directions_car_rounded,
                size: 64,
                color: AppColors.teal,
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                  duration: const Duration(seconds: 2),
                ),
            const SizedBox(height: 24),
            Text('No active rides', style: AppTheme.heading2),
            const SizedBox(height: 8),
            Text(
              'There are 12+ cabs available near you right now. Ready to book?',
              style: AppTheme.body.copyWith(color: AppColors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  setState(() => _hasActiveRide = true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text('Book a Ride',
                    style: AppTheme.button.copyWith(color: AppColors.background)),
              ),
            ).animate().fadeIn(delay: 200.ms),
          ],
        ),
      ),
    );
  }
}
