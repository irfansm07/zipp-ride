import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../models/driver_model.dart';
import '../widgets/glass_card.dart';
import 'booking_confirmation_screen.dart';
import 'main_navigation.dart';
import 'active_ride_screen.dart';

class RideOptionsScreen extends StatefulWidget {
  final String rideType;
  final String destination;
  final int passengerCount;
  final String userName;

  const RideOptionsScreen({
    super.key,
    required this.rideType,
    required this.destination,
    required this.passengerCount,
    required this.userName,
  });

  @override
  State<RideOptionsScreen> createState() => _RideOptionsScreenState();
}

class _RideOptionsScreenState extends State<RideOptionsScreen> {
  bool _ladyDriverOnly = false;
  int _selectedDriverIndex = -1;
  final _drivers = getMockDrivers();
  final _sharedRides = getMockSharedRides();
  int? _joiningRideIndex;
  bool _rideAccepted = false;

  List<DriverModel> get _filteredDrivers {
    if (_ladyDriverOnly) {
      return _drivers.where((d) => d.isFemale).toList();
    }
    return _drivers;
  }

  bool get _isShareCab => widget.rideType == 'Share Cab';

  void _joinSharedRide(int index) {
    setState(() {
      _joiningRideIndex = index;
      _rideAccepted = false;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        Future.delayed(const Duration(seconds: 2), () {
          if (ctx.mounted) {
            Navigator.pop(ctx);
            setState(() => _rideAccepted = true);
            
            // Navigate to active rides after brief delay
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) {
                RideState.hasActiveRide.value = true;
                MainNavigation.currentTab.value = 1;
                Navigator.popUntil(context, (route) => route.isFirst);
              }
            });
          }
        });

        return Dialog(
          backgroundColor: Colors.transparent,
          child: _JoinRideDialog(),
        );
      },
    );
  }

  void _navigateToConfirmation() {
    final driver = _selectedDriverIndex >= 0
        ? _filteredDrivers[_selectedDriverIndex]
        : _filteredDrivers[0];

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => BookingConfirmationScreen(
          driver: driver,
          rideType: widget.rideType,
          destination: widget.destination,
          passengerCount: widget.passengerCount,
          isShareCab: _isShareCab,
          isLadyDriver: driver.isFemale,
          userName: widget.userName,
        ),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredDrivers;

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
                          color: AppColors.darkGrey, size: 20),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Available Rides', style: AppTheme.heading3),
                        Text(
                          '${widget.rideType} • ${widget.destination}',
                          style: AppTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),

            const SizedBox(height: 16),

            // Lady driver toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.pink.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('👩', style: TextStyle(fontSize: 18)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text('Lady Driver Only',
                              style: AppTheme.bodyMedium),
                        ),
                        Transform.scale(
                          scale: 0.85,
                          child: Switch(
                            value: _ladyDriverOnly,
                            onChanged: (v) {
                              setState(() {
                                _ladyDriverOnly = v;
                                _selectedDriverIndex = -1;
                              });
                            },
                            activeColor: AppColors.pink,
                            activeTrackColor: AppColors.pink.withValues(alpha: 0.3),
                            inactiveThumbColor: AppColors.grey,
                            inactiveTrackColor: AppColors.darkGrey,
                          ),
                        ),
                      ],
                    ),
                    if (_ladyDriverOnly)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline_rounded,
                                color: AppColors.pink.withValues(alpha: 0.7),
                                size: 14),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'This option is available for the safety and comfort of female passengers',
                                style: AppTheme.caption
                                    .copyWith(color: AppColors.pink.withValues(alpha: 0.8)),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.2, end: 0),
                  ],
                ),
              ),
            ).animate(delay: 100.ms).fadeIn(duration: 400.ms),

            const SizedBox(height: 12),

            // Driver list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  // Drivers
                  ...filtered.asMap().entries.map((entry) {
                    final i = entry.key;
                    final driver = entry.value;
                    final isSelected = _selectedDriverIndex == i;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedDriverIndex = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(16),
                          decoration: isSelected
                              ? AppTheme.glowCardDecoration
                              : AppTheme.cardDecoration,
                          child: Row(
                            children: [
                              // Avatar
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 26,
                                    backgroundColor: driver.avatarColor.withValues(alpha: 0.2),
                                    child: Text(
                                      driver.initials,
                                      style: AppTheme.bodyMedium.copyWith(
                                        color: driver.avatarColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  if (driver.isFemale)
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        width: 18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          color: AppColors.pink,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.card,
                                            width: 2,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text('♀',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 14),
                              // Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            driver.name,
                                            style: AppTheme.bodyMedium,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Icon(Icons.star_rounded,
                                            color: AppColors.amber, size: 16),
                                        Text(
                                          ' ${driver.rating}',
                                          style: AppTheme.bodySmall
                                              .copyWith(color: AppColors.amber),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${driver.vehicleType} • ${driver.vehicleNumber}',
                                      style: AppTheme.caption,
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: AppColors.teal.withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '⏱ ${driver.eta}',
                                            style: AppTheme.caption
                                                .copyWith(color: AppColors.teal),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: driver.sharingOpen
                                                ? AppColors.success.withValues(alpha: 0.1)
                                                : AppColors.grey.withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            driver.sharingOpen
                                                ? '🤝 Sharing Open'
                                                : '🔒 No Sharing',
                                            style: AppTheme.caption.copyWith(
                                              color: driver.sharingOpen
                                                  ? AppColors.success
                                                  : AppColors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Price
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '₹${driver.price.toInt()}',
                                    style: AppTheme.heading3
                                        .copyWith(color: AppColors.teal),
                                  ),
                                  if (isSelected)
                                    const Icon(Icons.check_circle_rounded,
                                        color: AppColors.teal, size: 20),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                          .animate(delay: (200 + i * 100).ms)
                          .fadeIn(duration: 400.ms)
                          .slideX(begin: 0.1, end: 0),
                    );
                  }),

                  // Share Cab section
                  if (_isShareCab) ...[
                    const SizedBox(height: 8),
                    Text('🤝 Available Shared Rides',
                        style: AppTheme.heading3),
                    const SizedBox(height: 12),
                    ..._sharedRides.asMap().entries.map((entry) {
                      final i = entry.key;
                      final ride = entry.value;
                      final isJoining = _joiningRideIndex == i;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.blue.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(Icons.people_rounded,
                                        color: AppColors.blue, size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(ride.riderName,
                                            style: AppTheme.bodyMedium),
                                        Text(ride.route,
                                            style: AppTheme.bodySmall),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.teal.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${ride.overlapPercent}% match',
                                      style: AppTheme.caption
                                          .copyWith(color: AppColors.teal),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Text(
                                    '₹${ride.originalFare.toInt()}',
                                    style: AppTheme.body.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      color: AppColors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '→ ₹${ride.splitFare.toInt()} after split 🎉',
                                    style: AppTheme.bodyMedium
                                        .copyWith(color: AppColors.teal),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              if (isJoining && _rideAccepted)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.check_circle_rounded,
                                          color: AppColors.success, size: 18),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Rider accepted! 🎉',
                                        style: AppTheme.bodySmall
                                            .copyWith(color: AppColors.success),
                                      ),
                                    ],
                                  ),
                                ).animate().fadeIn().scale(
                                      begin: const Offset(0.8, 0.8),
                                      end: const Offset(1, 1),
                                    )
                              else
                                GestureDetector(
                                  onTap: () => _joinSharedRide(i),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                      gradient: AppColors.primaryGradient,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text('Join Ride',
                                          style: AppTheme.button
                                              .copyWith(fontSize: 14)),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )
                          .animate(delay: (500 + i * 100).ms)
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: 0.1, end: 0);
                    }),
                  ],

                  const SizedBox(height: 80),
                ],
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: GestureDetector(
                onTap: _navigateToConfirmation,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.teal.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_rounded,
                          color: Colors.white, size: 22),
                      const SizedBox(width: 8),
                      Text('Select & Continue', style: AppTheme.button),
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
}

class _JoinRideDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.teal),
            ),
          ).animate().fadeIn(),
          const SizedBox(height: 20),
          Text(
            'Request Sent! 🚗',
            style: AppTheme.heading3,
          ).animate(delay: 200.ms).fadeIn(),
          const SizedBox(height: 8),
          Text(
            'Waiting for rider approval...',
            style: AppTheme.bodySmall,
            textAlign: TextAlign.center,
          ).animate(delay: 300.ms).fadeIn(),
        ],
      ),
    ).animate().scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          duration: 300.ms,
          curve: Curves.easeOutBack,
        );
  }
}
