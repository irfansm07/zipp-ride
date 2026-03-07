import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../models/ride_model.dart';
import '../widgets/glass_card.dart';
import 'ride_options_screen.dart';
import 'pnr_booking_screen.dart';
import 'active_ride_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _passengerCount = 1;
  int _selectedCategoryIndex = -1;
  String _destination = '';
  final _categories = getRideCategories();

  void _onRecommendationTap(String label) {
    final index = _categories.indexWhere((c) => c.name == label);
    if (index != -1) {
      setState(() => _selectedCategoryIndex = index);
    }
  }

  void _navigateToRideOptions() {
    final selectedType = _selectedCategoryIndex >= 0
        ? _categories[_selectedCategoryIndex].name
        : 'Sedan';

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => RideOptionsScreen(
          rideType: selectedType,
          destination: _destination.isEmpty ? 'MG Road, Bangalore' : _destination,
          passengerCount: _passengerCount,
          userName: widget.userName,
        ),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
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
    final recommendations = getRecommendations(_passengerCount);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hey ${widget.userName} 👋',
                                style: AppTheme.heading2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Where to?',
                                style: AppTheme.body
                                    .copyWith(color: AppColors.grey),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.teal.withValues(alpha: 0.3),
                                AppColors.blue.withValues(alpha: 0.3),
                              ],
                            ),
                            border: Border.all(
                              color: AppColors.teal.withValues(alpha: 0.5),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              widget.userName[0].toUpperCase(),
                              style: AppTheme.heading3
                                  .copyWith(color: AppColors.teal),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms),

                  const SizedBox(height: 24),

                  // Search bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: TextField(
                        onChanged: (v) => setState(() => _destination = v),
                        style: AppTheme.body,
                        decoration: InputDecoration(
                          hintText: 'Enter destination...',
                          hintStyle: AppTheme.body
                              .copyWith(color: AppColors.grey),
                          prefixIcon: const Icon(
                            Icons.location_on_rounded,
                            color: AppColors.teal,
                            size: 20,
                          ),
                          suffixIcon: const Icon(
                            Icons.my_location_rounded,
                            color: AppColors.amber,
                            size: 20,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  )
                      .animate(delay: 100.ms)
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 24),

                  // Passenger selector
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Passengers', style: AppTheme.heading3),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildStepperButton(
                                Icons.remove_rounded,
                                () {
                                  if (_passengerCount > 1) {
                                    setState(() => _passengerCount--);
                                  }
                                },
                                _passengerCount > 1,
                              ),
                              const SizedBox(width: 24),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                transitionBuilder: (child, animation) {
                                  return ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  );
                                },
                                child: Text(
                                  '$_passengerCount',
                                  key: ValueKey(_passengerCount),
                                  style: AppTheme.heading1.copyWith(
                                    fontSize: 36,
                                    color: AppColors.teal,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 24),
                              _buildStepperButton(
                                Icons.add_rounded,
                                () {
                                  if (_passengerCount < 6) {
                                    setState(() => _passengerCount++);
                                  }
                                },
                                _passengerCount < 6,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Recommendations
                          Text(
                            'Recommended for you',
                            style: AppTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: recommendations.map((rec) {
                              final isSelected = _selectedCategoryIndex >= 0 &&
                                  _categories[_selectedCategoryIndex].name ==
                                      rec.label;
                              return GestureDetector(
                                onTap: () => _onRecommendationTap(rec.label),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.amber.withValues(alpha: 0.2)
                                        : AppColors.amber.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.amber
                                          : AppColors.amber.withValues(alpha: 0.3),
                                      width: isSelected ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Text(
                                    '${rec.emoji} ${rec.label}',
                                    style: AppTheme.bodySmall.copyWith(
                                      color: AppColors.amber,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate(delay: 200.ms)
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 24),

                  // No Delay Train Cab Feature
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PnrBookingScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.teal.withValues(alpha: 0.15),
                              AppColors.blue.withValues(alpha: 0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.teal.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.teal.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.train_rounded,
                                color: AppColors.teal,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text('No Delay Cab ',
                                          style: AppTheme.bodyMedium),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.pink,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'NEW',
                                          style: AppTheme.caption.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 9,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Sync cab with train PNR arrival',
                                    style: AppTheme.caption,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: AppColors.teal,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ).animate(delay: 250.ms).fadeIn().slideY(begin: 0.1, end: 0),
                  ),

                  const SizedBox(height: 24),

                  // Ride categories
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text('Choose Your Ride',
                        style: AppTheme.heading3),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                            margin: const EdgeInsets.symmetric(horizontal: 4),
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
                  )
                      .animate(delay: 300.ms)
                      .fadeIn(duration: 400.ms),

                  const SizedBox(height: 24),

                  // Recent trips
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Recent Trips', style: AppTheme.heading3),
                  ),
                  const SizedBox(height: 12),
                  ..._buildRecentTrips(),
                ],
              ),
            ),

            // Book Now floating button
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: GestureDetector(
                onTap: _navigateToRideOptions,
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
                      Text('Book Now', style: AppTheme.button),
                    ],
                  ),
                ),
              )
                  .animate(delay: 500.ms)
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.5, end: 0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepperButton(
      IconData icon, VoidCallback onTap, bool enabled) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.teal.withValues(alpha: 0.15)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: enabled
                ? AppColors.teal.withValues(alpha: 0.3)
                : AppColors.cardBorder,
          ),
        ),
        child: Icon(
          icon,
          color: enabled ? AppColors.teal : AppColors.darkGrey,
          size: 22,
        ),
      ),
    );
  }

  List<Widget> _buildRecentTrips() {
    final trips = [
      {'from': 'Home', 'to': 'MG Road', 'price': '₹149', 'date': 'Yesterday'},
      {'from': 'Office', 'to': 'Airport', 'price': '₹389', 'date': '2 days ago'},
    ];

    return trips.asMap().entries.map((entry) {
      final trip = entry.value;
      final i = entry.key;
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        child: GlassCard(
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.teal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.history_rounded,
                  color: AppColors.teal,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${trip['from']} → ${trip['to']}',
                      style: AppTheme.bodyMedium,
                    ),
                    Text(trip['date']!, style: AppTheme.bodySmall),
                  ],
                ),
              ),
              Text(
                trip['price']!,
                style: AppTheme.bodyMedium.copyWith(color: AppColors.teal),
              ),
            ],
          ),
        ),
      )
          .animate(delay: (400 + i * 100).ms)
          .fadeIn(duration: 400.ms)
          .slideX(begin: 0.1, end: 0);
    }).toList();
  }
}
