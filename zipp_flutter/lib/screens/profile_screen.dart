import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;

  const ProfileScreen({super.key, required this.userName});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _userName;
  late TextEditingController _nameController;
  bool _isEditing = false;

  final List<Map<String, dynamic>> _rideHistory = [
    {
      'from': 'Home - Koramangala',
      'to': 'MG Road Metro Station',
      'driver': 'Rahul Sharma',
      'rating': 4.8,
      'vehicle': 'Sedan • KA 01 AB 1234',
      'distance': '8.2 km',
      'duration': '22 min',
      'fare': '₹189',
      'date': 'Today, 3:45 PM',
      'status': 'Completed',
      'color': Color(0xFF00E5CC),
    },
    {
      'from': 'Office - Whitefield',
      'to': 'Kempegowda Airport',
      'driver': 'Priya Nair',
      'rating': 4.9,
      'vehicle': 'Mini • KA 05 CD 5678',
      'distance': '38.5 km',
      'duration': '55 min',
      'fare': '₹649',
      'date': 'Yesterday, 6:20 AM',
      'status': 'Completed',
      'color': Color(0xFFFF6B9D),
    },
    {
      'from': 'Indiranagar',
      'to': 'HSR Layout',
      'driver': 'Amit Patel',
      'rating': 4.6,
      'vehicle': 'SUV • MH 12 EF 9012',
      'distance': '12.1 km',
      'duration': '35 min',
      'fare': '₹299',
      'date': 'Mar 4, 9:15 PM',
      'status': 'Completed',
      'color': Color(0xFFFFB347),
    },
    {
      'from': 'Jayanagar',
      'to': 'Electronic City',
      'driver': 'Sneha Reddy',
      'rating': 4.7,
      'vehicle': 'Sedan • TN 09 GH 3456',
      'distance': '18.7 km',
      'duration': '42 min',
      'fare': '₹349',
      'date': 'Mar 3, 2:30 PM',
      'status': 'Completed',
      'color': Color(0xFFFF6B9D),
    },
    {
      'from': 'Marathahalli',
      'to': 'Silk Board Junction',
      'driver': 'Vikram Singh',
      'rating': 4.5,
      'vehicle': 'Bike • DL 02 IJ 7890',
      'distance': '5.4 km',
      'duration': '18 min',
      'fare': '₹79',
      'date': 'Mar 2, 8:00 AM',
      'status': 'Cancelled',
      'color': Color(0xFF0099FF),
    },
    {
      'from': 'Banashankari',
      'to': 'Hebbal Flyover',
      'driver': 'Deepak Kumar',
      'rating': 4.4,
      'vehicle': 'Mini • KA 03 MN 4567',
      'distance': '22.3 km',
      'duration': '48 min',
      'fare': '₹279',
      'date': 'Mar 1, 11:00 AM',
      'status': 'Completed',
      'color': Color(0xFF00E5CC),
    },
  ];

  @override
  void initState() {
    super.initState();
    _userName = widget.userName;
    _nameController = TextEditingController(text: _userName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveName() {
    setState(() {
      _userName = _nameController.text.isNotEmpty
          ? _nameController.text
          : widget.userName;
      _isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: AppColors.teal, size: 20),
            const SizedBox(width: 8),
            Text('Name updated to $_userName! ✨',
                style: AppTheme.body),
          ],
        ),
        backgroundColor: AppColors.card,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedRides =
        _rideHistory.where((r) => r['status'] == 'Completed').length;
    final totalSpent = _rideHistory
        .where((r) => r['status'] == 'Completed')
        .fold<int>(0, (sum, r) {
      final fare = r['fare'] as String;
      return sum + int.parse(fare.replaceAll('₹', '').replaceAll(',', ''));
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Header
              Text('My Profile', style: AppTheme.heading1)
                  .animate()
                  .fadeIn(duration: 400.ms),

              const SizedBox(height: 24),

              // Profile card
              GlassCard(
                isGlowing: true,
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Avatar
                        Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.teal.withValues(alpha: 0.4),
                                AppColors.blue.withValues(alpha: 0.4),
                              ],
                            ),
                            border: Border.all(
                              color: AppColors.teal.withValues(alpha: 0.6),
                              width: 2.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _userName[0].toUpperCase(),
                              style: GoogleFonts.syne(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_isEditing)
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: AppColors.surface,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: AppColors.teal,
                                          ),
                                        ),
                                        child: TextField(
                                          controller: _nameController,
                                          style: AppTheme.bodyMedium,
                                          autofocus: true,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 10),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: _saveName,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColors.teal,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.check_rounded,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        _userName,
                                        style: AppTheme.heading3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () =>
                                          setState(() => _isEditing = true),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: AppColors.teal
                                              .withValues(alpha: 0.15),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: const Icon(
                                          Icons.edit_rounded,
                                          color: AppColors.teal,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 4),
                              Text(
                                'Member since Mar 2026',
                                style: AppTheme.bodySmall,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded,
                                      color: AppColors.amber, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '4.9 rider rating',
                                    style: AppTheme.bodySmall
                                        .copyWith(color: AppColors.amber),
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
                  .animate(delay: 100.ms)
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: 20),

              // Stats row
              Row(
                children: [
                  _buildStatCard(
                    Icons.directions_car_rounded,
                    '$completedRides',
                    'Total Rides',
                    AppColors.teal,
                    0,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    Icons.currency_rupee_rounded,
                    '₹$totalSpent',
                    'Total Spent',
                    AppColors.amber,
                    1,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    Icons.local_offer_rounded,
                    '3',
                    'Coupons',
                    AppColors.pink,
                    2,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Quick settings
              Text('Settings', style: AppTheme.heading3),
              const SizedBox(height: 12),
              _buildSettingTile(
                Icons.person_outline_rounded,
                'Personal Info',
                'Phone, Email, Address',
                AppColors.teal,
                0,
              ),
              _buildSettingTile(
                Icons.payment_rounded,
                'Payment Methods',
                'UPI, Wallet, Cards',
                AppColors.blue,
                1,
              ),
              _buildSettingTile(
                Icons.shield_outlined,
                'Safety',
                'Emergency contacts, SOS',
                AppColors.pink,
                2,
              ),
              _buildSettingTile(
                Icons.notifications_outlined,
                'Notifications',
                'Ride updates, Offers',
                AppColors.amber,
                3,
              ),
              _buildSettingTile(
                Icons.help_outline_rounded,
                'Help & Support',
                'FAQs, Contact us',
                AppColors.grey,
                4,
              ),

              const SizedBox(height: 24),

              // Ride history
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Ride History', style: AppTheme.heading3),
                  Text(
                    '${_rideHistory.length} rides',
                    style: AppTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Ride history list
              ..._rideHistory.asMap().entries.map((entry) {
                final i = entry.key;
                final ride = entry.value;
                final isCancelled = ride['status'] == 'Cancelled';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date & status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ride['date'] as String,
                              style: AppTheme.caption,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isCancelled
                                    ? Colors.red.withValues(alpha: 0.1)
                                    : AppColors.success.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                ride['status'] as String,
                                style: AppTheme.caption.copyWith(
                                  color: isCancelled
                                      ? Colors.red
                                      : AppColors.success,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Route
                        Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.teal,
                                    border: Border.all(
                                        color: AppColors.teal, width: 2),
                                  ),
                                ),
                                Container(
                                  width: 2,
                                  height: 24,
                                  color: AppColors.cardBorder,
                                ),
                                const Icon(Icons.location_on_rounded,
                                    color: AppColors.pink, size: 14),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ride['from'] as String,
                                    style: AppTheme.body,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    ride['to'] as String,
                                    style: AppTheme.body,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  ride['fare'] as String,
                                  style: AppTheme.heading3.copyWith(
                                    color: isCancelled
                                        ? AppColors.grey
                                        : AppColors.teal,
                                    decoration: isCancelled
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  ride['distance'] as String,
                                  style: AppTheme.caption,
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),
                        Container(
                          height: 1,
                          color: AppColors.cardBorder.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 10),

                        // Driver info
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor:
                                  (ride['color'] as Color).withValues(alpha: 0.2),
                              child: Text(
                                (ride['driver'] as String)[0],
                                style: AppTheme.bodySmall.copyWith(
                                  color: ride['color'] as Color,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ride['driver'] as String,
                                    style: AppTheme.bodySmall
                                        .copyWith(color: AppColors.white),
                                  ),
                                  Text(
                                    ride['vehicle'] as String,
                                    style: AppTheme.caption
                                        .copyWith(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded,
                                    color: AppColors.amber, size: 14),
                                Text(
                                  ' ${ride['rating']}',
                                  style: AppTheme.caption
                                      .copyWith(color: AppColors.amber),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Text(
                              ride['duration'] as String,
                              style: AppTheme.caption,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                    .animate(delay: (300 + i * 80).ms)
                    .fadeIn(duration: 400.ms)
                    .slideX(begin: 0.05, end: 0);
              }),

              const SizedBox(height: 24),

              // Logout button
              GestureDetector(
                onTap: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.logout_rounded,
                            color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Log Out',
                          style: AppTheme.bodyMedium
                              .copyWith(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  .animate(delay: 800.ms)
                  .fadeIn(duration: 400.ms),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
      IconData icon, String value, String label, Color color, int index) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTheme.heading3.copyWith(color: color, fontSize: 16),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTheme.caption.copyWith(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    )
        .animate(delay: (200 + index * 100).ms)
        .fadeIn(duration: 400.ms)
        .scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
          duration: 400.ms,
        );
  }

  Widget _buildSettingTile(
      IconData icon, String title, String subtitle, Color color, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTheme.bodyMedium),
                  Text(subtitle, style: AppTheme.caption),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: AppColors.grey, size: 22),
          ],
        ),
      ),
    )
        .animate(delay: (300 + index * 80).ms)
        .fadeIn(duration: 300.ms)
        .slideX(begin: 0.05, end: 0);
  }
}
