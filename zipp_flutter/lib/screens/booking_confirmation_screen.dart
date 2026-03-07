import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../models/driver_model.dart';
import '../widgets/glass_card.dart';
import 'main_navigation.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final DriverModel driver;
  final String rideType;
  final String destination;
  final int passengerCount;
  final bool isShareCab;
  final bool isLadyDriver;
  final String userName;

  const BookingConfirmationScreen({
    super.key,
    required this.driver,
    required this.rideType,
    required this.destination,
    required this.passengerCount,
    required this.isShareCab,
    required this.isLadyDriver,
    required this.userName,
  });

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen>
    with TickerProviderStateMixin {
  int _selectedPayment = 0;
  bool _isBooked = false;
  int _countdownSeconds = 240; // 4 minutes
  Timer? _timer;
  late AnimationController _checkController;
  late Animation<double> _checkAnimation;

  final _paymentMethods = [
    {'icon': Icons.money_rounded, 'label': 'Cash', 'emoji': '💵'},
    {'icon': Icons.phone_android_rounded, 'label': 'UPI', 'emoji': '📱'},
    {'icon': Icons.account_balance_wallet_rounded, 'label': 'Wallet', 'emoji': '👛'},
  ];

  @override
  void initState() {
    super.initState();
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _checkAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _checkController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _checkController.dispose();
    super.dispose();
  }

  void _confirmBooking() {
    setState(() => _isBooked = true);
    _checkController.forward();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 0) {
        setState(() => _countdownSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  String get _formattedTime {
    final min = _countdownSeconds ~/ 60;
    final sec = _countdownSeconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  double get _splitFare {
    return widget.driver.price * 0.6;
  }

  @override
  Widget build(BuildContext context) {
    if (_isBooked) {
      return _buildSuccessScreen();
    }
    return _buildConfirmationScreen();
  }

  Widget _buildConfirmationScreen() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back_rounded,
                          color: AppColors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('Confirm Booking', style: AppTheme.heading3),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Animated receipt icon
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.teal.withValues(alpha: 0.1),
                          border: Border.all(
                            color: AppColors.teal.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.receipt_long_rounded,
                          color: AppColors.teal,
                          size: 36,
                        ),
                      )
                          .animate()
                          .scale(
                            begin: const Offset(0.5, 0.5),
                            end: const Offset(1, 1),
                            duration: 500.ms,
                            curve: Curves.elasticOut,
                          )
                          .fadeIn(),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text('Booking Summary',
                          style: AppTheme.heading2),
                    ).animate(delay: 200.ms).fadeIn(),

                    const SizedBox(height: 24),

                    // Summary card
                    GlassCard(
                      child: Column(
                        children: [
                          _buildSummaryRow(
                            Icons.trip_origin_rounded,
                            'Pickup',
                            'Current Location',
                            AppColors.teal,
                          ),
                          _buildDivider(),
                          _buildSummaryRow(
                            Icons.location_on_rounded,
                            'Drop',
                            widget.destination,
                            AppColors.pink,
                          ),
                          _buildDivider(),
                          _buildSummaryRow(
                            Icons.directions_car_rounded,
                            'Ride Type',
                            '${_getRideEmoji()} ${widget.rideType}',
                            AppColors.amber,
                          ),
                          _buildDivider(),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.blue.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.person_rounded,
                                    color: AppColors.blue, size: 18),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Driver', style: AppTheme.bodySmall),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            widget.driver.name,
                                            style: AppTheme.bodyMedium,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Icon(Icons.star_rounded,
                                            color: AppColors.amber, size: 14),
                                        Text(' ${widget.driver.rating}',
                                            style: AppTheme.caption
                                                .copyWith(color: AppColors.amber)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (widget.isLadyDriver)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.pink.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text('♀️ Lady',
                                      style: AppTheme.caption
                                          .copyWith(color: AppColors.pink)),
                                ),
                            ],
                          ),
                          _buildDivider(),
                          _buildSummaryRow(
                            Icons.people_rounded,
                            'Passengers',
                            '${widget.passengerCount}',
                            AppColors.teal,
                          ),
                          _buildDivider(),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.currency_rupee_rounded,
                                    color: AppColors.success, size: 18),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Total Fare', style: AppTheme.bodySmall),
                                    Row(
                                      children: [
                                        if (widget.isShareCab) ...[
                                          Text(
                                            '₹${widget.driver.price.toInt()}',
                                            style: AppTheme.body.copyWith(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: AppColors.grey,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '₹${_splitFare.toInt()} (split)',
                                            style: AppTheme.heading3
                                                .copyWith(color: AppColors.teal),
                                          ),
                                        ] else
                                          Text(
                                            '₹${widget.driver.price.toInt()}',
                                            style: AppTheme.heading3
                                                .copyWith(color: AppColors.teal),
                                          ),
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
                        .animate(delay: 300.ms)
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 24),

                    // Payment method
                    Text('Payment Method', style: AppTheme.heading3),
                    const SizedBox(height: 12),
                    Row(
                      children: _paymentMethods.asMap().entries.map((entry) {
                        final i = entry.key;
                        final method = entry.value;
                        final isSelected = _selectedPayment == i;

                        return Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _selectedPayment = i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: EdgeInsets.only(
                                  right: i < 2 ? 10 : 0),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.teal.withValues(alpha: 0.1)
                                    : AppColors.surface,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.teal
                                      : AppColors.cardBorder,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    method['emoji'] as String,
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    method['label'] as String,
                                    style: AppTheme.bodySmall.copyWith(
                                      color: isSelected
                                          ? AppColors.teal
                                          : AppColors.grey,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    )
                        .animate(delay: 400.ms)
                        .fadeIn(duration: 400.ms),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Confirm button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: GestureDetector(
                onTap: _confirmBooking,
                child: Container(
                  height: 58,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.teal.withValues(alpha: 0.4),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.flash_on_rounded,
                          color: Colors.white, size: 22),
                      const SizedBox(width: 8),
                      Text('Confirm Booking', style: AppTheme.button),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessScreen() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Animated checkmark
              AnimatedBuilder(
                animation: _checkAnimation,
                builder: (context, child) {
                  return Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.success.withValues(alpha: 0.1),
                      border: Border.all(
                        color: AppColors.success
                            .withValues(alpha: _checkAnimation.value),
                        width: 3,
                      ),
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: AppColors.success
                          .withValues(alpha: _checkAnimation.value),
                      size: 48,
                    ),
                  );
                },
              )
                  .animate()
                  .scale(
                    begin: const Offset(0.3, 0.3),
                    end: const Offset(1, 1),
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  ),

              const SizedBox(height: 24),

              Text(
                '🚗 Your ride is on the way!',
                style: AppTheme.heading2,
                textAlign: TextAlign.center,
              )
                  .animate(delay: 300.ms)
                  .fadeIn(duration: 400.ms),

              const SizedBox(height: 8),

              Text(
                'Driver is heading to your pickup location',
                style: AppTheme.body.copyWith(color: AppColors.grey),
                textAlign: TextAlign.center,
              )
                  .animate(delay: 400.ms)
                  .fadeIn(duration: 400.ms),

              const SizedBox(height: 32),

              // Map placeholder
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Stack(
                  children: [
                    // Grid lines (horizontal)
                    ...List.generate(5, (i) {
                      return Positioned(
                        top: (i + 1) * 33.0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 1,
                          color: AppColors.cardBorder.withValues(alpha: 0.3),
                        ),
                      );
                    }),
                    // Grid lines (vertical)
                    ...List.generate(5, (i) {
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
                    // Route line
                    Positioned(
                      top: 60,
                      left: 60,
                      child: Container(
                        width: 200,
                        height: 3,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 60,
                      left: 260,
                      child: Container(
                        width: 3,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.blue, AppColors.pink],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    // Pickup pin
                    Positioned(
                      top: 40,
                      left: 48,
                      child: Column(
                        children: [
                          const Icon(Icons.location_on_rounded,
                              color: AppColors.teal, size: 28),
                          Text('You', style: AppTheme.caption),
                        ],
                      ),
                    )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .moveY(begin: 0, end: -6, duration: 1200.ms),
                    // Driver pin
                    Positioned(
                      top: 110,
                      left: 170,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.amber,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.directions_car_rounded,
                                color: Colors.white, size: 18),
                          ),
                          const SizedBox(height: 4),
                          Text('Driver', style: AppTheme.caption),
                        ],
                      )
                          .animate(onPlay: (c) => c.repeat())
                          .moveX(
                            begin: 0,
                            end: 40,
                            duration: 3000.ms,
                            curve: Curves.easeInOut,
                          )
                          .then()
                          .moveY(
                            begin: 0,
                            end: -30,
                            duration: 2000.ms,
                            curve: Curves.easeInOut,
                          ),
                    ),
                    // Drop pin
                    Positioned(
                      top: 120,
                      right: 30,
                      child: Column(
                        children: [
                          const Icon(Icons.flag_rounded,
                              color: AppColors.pink, size: 24),
                          Text('Drop', style: AppTheme.caption),
                        ],
                      ),
                    ),
                  ],
                ),
              )
                  .animate(delay: 500.ms)
                  .fadeIn(duration: 500.ms),

              const SizedBox(height: 24),

              // ETA countdown
              GlassCard(
                isGlowing: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.teal.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.timer_rounded,
                          color: AppColors.teal, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Estimated Arrival',
                            style: AppTheme.bodySmall),
                        Text(
                          _formattedTime,
                          style: AppTheme.heading1.copyWith(
                            color: AppColors.teal,
                            fontSize: 32,
                            fontFeatures: [
                              const FontFeature.tabularFigures(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
                  .animate(delay: 600.ms)
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: 20),

              // Driver info card
              GlassCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor:
                          widget.driver.avatarColor.withValues(alpha: 0.2),
                      child: Text(
                        widget.driver.initials,
                        style: AppTheme.bodyMedium.copyWith(
                          color: widget.driver.avatarColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.driver.name,
                              style: AppTheme.bodyMedium),
                          Text(
                            '${widget.driver.vehicleType} • ${widget.driver.vehicleNumber}',
                            style: AppTheme.caption,
                          ),
                        ],
                      ),
                    ),
                    // Call button
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.phone_rounded,
                          color: AppColors.success, size: 22),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.chat_rounded,
                          color: AppColors.blue, size: 22),
                    ),
                  ],
                ),
              )
                  .animate(delay: 700.ms)
                  .fadeIn(duration: 400.ms),

              const SizedBox(height: 24),

              // Back to home
              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MainNavigation(userName: widget.userName),
                    ),
                    (route) => false,
                  );
                },
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Center(
                    child: Text(
                      'Back to Home',
                      style: AppTheme.bodyMedium
                          .copyWith(color: AppColors.grey),
                    ),
                  ),
                ),
              )
                  .animate(delay: 800.ms)
                  .fadeIn(duration: 400.ms),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
      IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTheme.bodySmall),
                Text(value, style: AppTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        height: 1,
        color: AppColors.cardBorder.withValues(alpha: 0.5),
      ),
    );
  }

  String _getRideEmoji() {
    switch (widget.rideType) {
      case 'Bike':
        return '🏍️';
      case 'Mini':
        return '🚗';
      case 'Sedan':
        return '🚙';
      case 'SUV':
        return '🚐';
      case 'Bus':
        return '🚌';
      case 'Metro':
        return '🚇';
      case 'Share Cab':
        return '🤝';
      default:
        return '🚗';
    }
  }
}
