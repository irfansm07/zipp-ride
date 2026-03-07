import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;

  final List<Map<String, dynamic>> _coupons = [
    {
      'code': 'ZIPFIRST',
      'title': '50% OFF your first ride!',
      'description': 'Max discount ₹100. Valid on all ride types.',
      'discount': '50%',
      'validTill': 'Mar 15, 2026',
      'color': AppColors.teal,
      'icon': Icons.flash_on_rounded,
      'isNew': true,
      'used': false,
    },
    {
      'code': 'WEEKEND25',
      'title': '25% OFF weekend rides',
      'description': 'Valid on Sat-Sun. Max discount ₹75.',
      'discount': '25%',
      'validTill': 'Mar 31, 2026',
      'color': AppColors.amber,
      'icon': Icons.weekend_rounded,
      'isNew': true,
      'used': false,
    },
    {
      'code': 'SHARE30',
      'title': '₹30 OFF on Share Cab',
      'description': 'Save more by sharing your ride! ₹30 flat off.',
      'discount': '₹30',
      'validTill': 'Apr 10, 2026',
      'color': AppColors.blue,
      'icon': Icons.people_rounded,
      'isNew': false,
      'used': false,
    },
    {
      'code': 'NIGHT20',
      'title': '20% OFF late-night rides',
      'description': 'Valid between 10 PM - 6 AM. Max discount ₹50.',
      'discount': '20%',
      'validTill': 'Mar 20, 2026',
      'color': AppColors.pink,
      'icon': Icons.nightlight_round,
      'isNew': false,
      'used': false,
    },
    {
      'code': 'ZIPSUV',
      'title': 'Flat ₹100 OFF on SUV rides',
      'description': 'Travel in style. Flat ₹100 off on any SUV ride.',
      'discount': '₹100',
      'validTill': 'Apr 5, 2026',
      'color': AppColors.teal,
      'icon': Icons.airport_shuttle_rounded,
      'isNew': false,
      'used': false,
    },
  ];

  final List<Map<String, dynamic>> _offers = [
    {
      'title': '🎉 Refer & Earn ₹200',
      'description':
          'Invite your friends to ZipRide! Both of you get ₹100 ride credits when they complete their first ride.',
      'image': Icons.card_giftcard_rounded,
      'gradient': [AppColors.teal, AppColors.blue],
      'cta': 'Share Invite Link',
    },
    {
      'title': '⭐ ZipRide Gold Membership',
      'description':
          'Get priority booking, 10% off all rides, free cancellation & exclusive deals. Only ₹149/month.',
      'image': Icons.workspace_premium_rounded,
      'gradient': [AppColors.amber, Color(0xFFFF6B00)],
      'cta': 'Subscribe Now',
    },
    {
      'title': '🏍️ Bike Rides at ₹9',
      'description':
          'Limited-time launch offer! Short-distance bike rides starting at just ₹9. Up to 3 km.',
      'image': Icons.two_wheeler_rounded,
      'gradient': [AppColors.pink, Color(0xFFAA336A)],
      'cta': 'Book Bike Ride',
    },
    {
      'title': '🚌 Metro Pass Integration',
      'description':
          'Link your metro smart card and get ₹20 off on every first/last-mile ZipRide connected to metro.',
      'image': Icons.train_rounded,
      'gradient': [Color(0xFF6C63FF), AppColors.blue],
      'cta': 'Link Metro Pass',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() => _selectedTab = _tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _copyCoupon(String code) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.copy_rounded, color: AppColors.teal, size: 18),
            const SizedBox(width: 8),
            Text('Coupon "$code" copied! 🎉', style: AppTheme.body),
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Offers & Coupons', style: AppTheme.heading1),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 20),

            // Tab bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    _buildTab('🎟️ Coupons', 0),
                    _buildTab('🔥 Offers', 1),
                  ],
                ),
              ),
            )
                .animate(delay: 100.ms)
                .fadeIn(duration: 400.ms),

            const SizedBox(height: 20),

            // Content
            Expanded(
              child: _selectedTab == 0
                  ? _buildCouponsTab()
                  : _buildOffersTab(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    final isActive = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? AppColors.teal : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              text,
              style: AppTheme.bodyMedium.copyWith(
                color: isActive ? AppColors.background : AppColors.grey,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCouponsTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _coupons.length,
      itemBuilder: (context, index) {
        final coupon = _coupons[index];
        final color = coupon['color'] as Color;

        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Stack(
            children: [
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            coupon['icon'] as IconData,
                            color: color,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                coupon['title'] as String,
                                style: AppTheme.bodyMedium,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                coupon['description'] as String,
                                style: AppTheme.caption,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Discount badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: color.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            coupon['discount'] as String,
                            style: GoogleFonts.syne(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Dotted line
                    Row(
                      children: List.generate(
                        30,
                        (i) => Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            height: 1,
                            color: i % 2 == 0
                                ? AppColors.cardBorder
                                : Colors.transparent,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Code row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.cardBorder,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                coupon['code'] as String,
                                style: GoogleFonts.dmSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () =>
                                    _copyCoupon(coupon['code'] as String),
                                child: const Icon(
                                  Icons.copy_rounded,
                                  color: AppColors.teal,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.schedule_rounded,
                            color: AppColors.grey, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'Valid till ${coupon['validTill']}',
                          style: AppTheme.caption.copyWith(fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // New badge
              if (coupon['isNew'] == true)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'NEW',
                      style: AppTheme.caption.copyWith(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        )
            .animate(delay: (150 + index * 80).ms)
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.05, end: 0);
      },
    );
  }

  Widget _buildOffersTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _offers.length,
      itemBuilder: (context, index) {
        final offer = _offers[index];
        final gradientColors = offer['gradient'] as List<Color>;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  gradientColors[0].withValues(alpha: 0.15),
                  gradientColors[1].withValues(alpha: 0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: gradientColors[0].withValues(alpha: 0.2),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              gradientColors[0].withValues(alpha: 0.2),
                              gradientColors[1].withValues(alpha: 0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          offer['image'] as IconData,
                          color: gradientColors[0],
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          offer['title'] as String,
                          style: AppTheme.heading3.copyWith(fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    offer['description'] as String,
                    style: AppTheme.body.copyWith(
                      color: AppColors.grey,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${offer['title']} activated! 🎉',
                            style: AppTheme.body,
                          ),
                          backgroundColor: AppColors.card,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: gradientColors),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: gradientColors[0].withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          offer['cta'] as String,
                          style: AppTheme.button.copyWith(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
            .animate(delay: (150 + index * 100).ms)
            .fadeIn(duration: 400.ms)
            .slideY(begin: 0.08, end: 0);
      },
    );
  }
}
