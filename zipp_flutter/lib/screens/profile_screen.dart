import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import 'profile_sub_screens.dart';

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

  // Responsive helper - scales value based on screen width
  double _rs(BuildContext context, double value) {
    final screenWidth = MediaQuery.of(context).size.width;
    return value * (screenWidth / 390).clamp(0.8, 1.3);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = (screenWidth * 0.05).clamp(14.0, 24.0);

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
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: _rs(context, 16)),

              // Header
              Text('My Profile', style: AppTheme.heading1.copyWith(
                fontSize: _rs(context, 28),
              ))
                  .animate()
                  .fadeIn(duration: 400.ms),

              SizedBox(height: _rs(context, 24)),

              // Profile card
              GlassCard(
                isGlowing: true,
                padding: EdgeInsets.all(_rs(context, 16)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Avatar
                        Container(
                          width: _rs(context, 68),
                          height: _rs(context, 68),
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
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.teal.withValues(alpha: 0.25),
                                blurRadius: 16,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _userName[0].toUpperCase(),
                              style: GoogleFonts.syne(
                                fontSize: _rs(context, 28),
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: _rs(context, 16)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_isEditing)
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: _rs(context, 12)),
                                        decoration: BoxDecoration(
                                          color: AppColors.surface,
                                          borderRadius:
                                              BorderRadius.circular(_rs(context, 10)),
                                          border: Border.all(
                                            color: AppColors.teal,
                                          ),
                                        ),
                                        child: TextField(
                                          controller: _nameController,
                                          style: AppTheme.bodyMedium.copyWith(
                                            fontSize: _rs(context, 16),
                                          ),
                                          autofocus: true,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: _rs(context, 10)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: _rs(context, 8)),
                                    Material(
                                      color: AppColors.teal,
                                      borderRadius: BorderRadius.circular(_rs(context, 8)),
                                      child: InkWell(
                                        onTap: _saveName,
                                        borderRadius: BorderRadius.circular(_rs(context, 8)),
                                        splashColor: Colors.white.withValues(alpha: 0.3),
                                        child: Padding(
                                          padding: EdgeInsets.all(_rs(context, 8)),
                                          child: Icon(
                                            Icons.check_rounded,
                                            color: Colors.white,
                                            size: _rs(context, 18),
                                          ),
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
                                        style: AppTheme.heading3.copyWith(
                                          fontSize: _rs(context, 18),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: _rs(context, 8)),
                                    Material(
                                      color: AppColors.teal.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(_rs(context, 6)),
                                      child: InkWell(
                                        onTap: () =>
                                            setState(() => _isEditing = true),
                                        borderRadius: BorderRadius.circular(_rs(context, 6)),
                                        splashColor: AppColors.teal.withValues(alpha: 0.3),
                                        child: Padding(
                                          padding: EdgeInsets.all(_rs(context, 6)),
                                          child: Icon(
                                            Icons.edit_rounded,
                                            color: AppColors.teal,
                                            size: _rs(context, 14),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              SizedBox(height: _rs(context, 4)),
                              Text(
                                'Member since Mar 2026',
                                style: AppTheme.bodySmall.copyWith(
                                  fontSize: _rs(context, 13),
                                ),
                              ),
                              SizedBox(height: _rs(context, 4)),
                              Row(
                                children: [
                                  Icon(Icons.star_rounded,
                                      color: AppColors.amber, size: _rs(context, 16)),
                                  SizedBox(width: _rs(context, 4)),
                                  Text(
                                    '4.9 rider rating',
                                    style: AppTheme.bodySmall
                                        .copyWith(
                                          color: AppColors.amber,
                                          fontSize: _rs(context, 13),
                                        ),
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

              SizedBox(height: _rs(context, 20)),

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
                  SizedBox(width: _rs(context, 12)),
                  _buildStatCard(
                    Icons.currency_rupee_rounded,
                    '₹$totalSpent',
                    'Total Spent',
                    AppColors.amber,
                    1,
                  ),
                  SizedBox(width: _rs(context, 12)),
                  _buildStatCard(
                    Icons.local_offer_rounded,
                    '3',
                    'Coupons',
                    AppColors.pink,
                    2,
                  ),
                ],
              ),

              SizedBox(height: _rs(context, 24)),

              // Quick settings
              Text('Settings', style: AppTheme.heading3.copyWith(
                fontSize: _rs(context, 18),
              )),
              SizedBox(height: _rs(context, 12)),
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

              SizedBox(height: _rs(context, 24)),

              // Ride history
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Ride History', style: AppTheme.heading3.copyWith(
                    fontSize: _rs(context, 18),
                  )),
                  Text(
                    '${_rideHistory.length} rides',
                    style: AppTheme.bodySmall.copyWith(
                      fontSize: _rs(context, 13),
                    ),
                  ),
                ],
              ),
              SizedBox(height: _rs(context, 12)),

              // Ride history list
              ..._rideHistory.asMap().entries.map((entry) {
                final i = entry.key;
                final ride = entry.value;
                final isCancelled = ride['status'] == 'Cancelled';

                return Padding(
                  padding: EdgeInsets.only(bottom: _rs(context, 12)),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Viewing details for ${ride['from']} to ${ride['to']}', style: AppTheme.body),
                            backgroundColor: AppColors.card,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(_rs(context, 16)),
                      splashColor: AppColors.teal.withValues(alpha: 0.08),
                      highlightColor: AppColors.teal.withValues(alpha: 0.04),
                      child: GlassCard(
                        padding: EdgeInsets.all(_rs(context, 16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Date & status
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    ride['date'] as String,
                                    style: AppTheme.caption.copyWith(
                                      fontSize: _rs(context, 12),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: _rs(context, 8),
                                      vertical: _rs(context, 3)),
                                  decoration: BoxDecoration(
                                    color: isCancelled
                                        ? Colors.red.withValues(alpha: 0.1)
                                        : AppColors.success.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(_rs(context, 6)),
                                  ),
                                  child: Text(
                                    ride['status'] as String,
                                    style: AppTheme.caption.copyWith(
                                      color: isCancelled
                                          ? Colors.red
                                          : AppColors.success,
                                      fontSize: _rs(context, 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: _rs(context, 10)),

                            // Route
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: _rs(context, 10),
                                      height: _rs(context, 10),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.teal,
                                        border: Border.all(
                                            color: AppColors.teal, width: 2),
                                      ),
                                    ),
                                    Container(
                                      width: 2,
                                      height: _rs(context, 24),
                                      color: AppColors.cardBorder,
                                    ),
                                    Icon(Icons.location_on_rounded,
                                        color: AppColors.pink, size: _rs(context, 14)),
                                  ],
                                ),
                                SizedBox(width: _rs(context, 10)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ride['from'] as String,
                                        style: AppTheme.body.copyWith(
                                          fontSize: _rs(context, 14),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: _rs(context, 14)),
                                      Text(
                                        ride['to'] as String,
                                        style: AppTheme.body.copyWith(
                                          fontSize: _rs(context, 14),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: _rs(context, 8)),
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
                                        fontSize: _rs(context, 18),
                                      ),
                                    ),
                                    SizedBox(height: _rs(context, 4)),
                                    Text(
                                      ride['distance'] as String,
                                      style: AppTheme.caption.copyWith(
                                        fontSize: _rs(context, 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            SizedBox(height: _rs(context, 12)),
                            Container(
                              height: 1,
                              color: AppColors.cardBorder.withValues(alpha: 0.5),
                            ),
                            SizedBox(height: _rs(context, 10)),

                            // Driver info
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: _rs(context, 16),
                                  backgroundColor:
                                      (ride['color'] as Color).withValues(alpha: 0.2),
                                  child: Text(
                                    (ride['driver'] as String)[0],
                                    style: AppTheme.bodySmall.copyWith(
                                      color: ride['color'] as Color,
                                      fontWeight: FontWeight.w700,
                                      fontSize: _rs(context, 13),
                                    ),
                                  ),
                                ),
                                SizedBox(width: _rs(context, 8)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ride['driver'] as String,
                                        style: AppTheme.bodySmall.copyWith(
                                          color: AppColors.darkGrey,
                                          fontSize: _rs(context, 13),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        ride['vehicle'] as String,
                                        style: AppTheme.caption.copyWith(
                                          fontSize: _rs(context, 10),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.star_rounded,
                                        color: AppColors.amber, size: _rs(context, 14)),
                                    Text(
                                      ' ${ride['rating']}',
                                      style: AppTheme.caption.copyWith(
                                        color: AppColors.amber,
                                        fontSize: _rs(context, 12),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: _rs(context, 12)),
                                Text(
                                  ride['duration'] as String,
                                  style: AppTheme.caption.copyWith(
                                    fontSize: _rs(context, 12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                    .animate(delay: (300 + i * 80).ms)
                    .fadeIn(duration: 400.ms)
                    .slideX(begin: 0.05, end: 0);
              }),

              SizedBox(height: _rs(context, 24)),

              // Logout button
              Material(
                color: Colors.red.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(_rs(context, 16)),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  borderRadius: BorderRadius.circular(_rs(context, 16)),
                  splashColor: Colors.red.withValues(alpha: 0.15),
                  highlightColor: Colors.red.withValues(alpha: 0.08),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: _rs(context, 16)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(_rs(context, 16)),
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.logout_rounded,
                              color: Colors.red, size: _rs(context, 20)),
                          SizedBox(width: _rs(context, 8)),
                          Text(
                            'Log Out',
                            style: AppTheme.bodyMedium.copyWith(
                              color: Colors.red,
                              fontSize: _rs(context, 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
                  .animate(delay: 800.ms)
                  .fadeIn(duration: 400.ms),

              SizedBox(height: _rs(context, 16)),

              // App version
              Center(
                child: Text(
                  'ZIPP v2.1.0 • Made with 💙 in India',
                  style: AppTheme.caption.copyWith(
                    fontSize: _rs(context, 11),
                    color: AppColors.grey.withValues(alpha: 0.6),
                  ),
                ),
              ),

              SizedBox(height: _rs(context, 32)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
      IconData icon, String value, String label, Color color, int index) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$label details not available yet.', style: AppTheme.body),
                backgroundColor: AppColors.card,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          borderRadius: BorderRadius.circular(_rs(context, 16)),
          splashColor: color.withValues(alpha: 0.1),
          highlightColor: color.withValues(alpha: 0.05),
          child: GlassCard(
            padding: EdgeInsets.all(_rs(context, 14)),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(_rs(context, 8)),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(_rs(context, 10)),
                  ),
                  child: Icon(icon, color: color, size: _rs(context, 20)),
                ),
                SizedBox(height: _rs(context, 8)),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: AppTheme.heading3.copyWith(
                      color: color,
                      fontSize: _rs(context, 16),
                    ),
                  ),
                ),
                SizedBox(height: _rs(context, 2)),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: AppTheme.caption.copyWith(
                      fontSize: _rs(context, 10),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
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
      padding: EdgeInsets.only(bottom: _rs(context, 8)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Widget screen;
            if (title == 'Personal Info') {
              screen = PersonalInfoScreen(userName: _userName);
            } else if (title == 'Payment Methods') {
              screen = const PaymentMethodsScreen();
            } else if (title == 'Safety') {
              screen = const SafetyScreen();
            } else if (title == 'Notifications') {
              screen = const NotificationsScreen();
            } else if (title == 'Help & Support') {
              screen = const HelpSupportScreen();
            } else {
              // Fallback shouldn't usually hit, but just in case
              screen = const Scaffold(body: Center(child: Text('Coming Soon!')));
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => screen,
              ),
            );
          },
          borderRadius: BorderRadius.circular(_rs(context, 16)),
          splashColor: color.withValues(alpha: 0.1),
          highlightColor: color.withValues(alpha: 0.05),
          child: GlassCard(
            padding: EdgeInsets.symmetric(
              horizontal: _rs(context, 14),
              vertical: _rs(context, 14),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(_rs(context, 10)),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(_rs(context, 10)),
                    border: Border.all(
                      color: color.withValues(alpha: 0.15),
                      width: 1,
                    ),
                  ),
                  child: Icon(icon, color: color, size: _rs(context, 20)),
                ),
                SizedBox(width: _rs(context, 14)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTheme.bodyMedium.copyWith(
                          fontSize: _rs(context, 15),
                        ),
                      ),
                      SizedBox(height: _rs(context, 2)),
                      Text(
                        subtitle,
                        style: AppTheme.caption.copyWith(
                          fontSize: _rs(context, 12),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(_rs(context, 6)),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(_rs(context, 8)),
                  ),
                  child: Icon(Icons.chevron_right_rounded,
                      color: color.withValues(alpha: 0.6), size: _rs(context, 20)),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate(delay: (300 + index * 80).ms)
        .fadeIn(duration: 300.ms)
        .slideX(begin: 0.05, end: 0);
  }
}
