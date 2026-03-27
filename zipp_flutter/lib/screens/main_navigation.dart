import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'offers_screen.dart';
import 'profile_screen.dart';
import 'active_ride_screen.dart';

class MainNavigation extends StatefulWidget {
  final String userName;
  static final ValueNotifier<int> currentTab = ValueNotifier(0);

  const MainNavigation({super.key, required this.userName});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = MainNavigation.currentTab.value;
    MainNavigation.currentTab.addListener(_onGlobalTabChanged);
  }

  void _onGlobalTabChanged() {
    if (mounted && _currentIndex != MainNavigation.currentTab.value) {
      setState(() {
        _currentIndex = MainNavigation.currentTab.value;
      });
    }
  }

  @override
  void dispose() {
    MainNavigation.currentTab.removeListener(_onGlobalTabChanged);
    super.dispose();
  }

  void _onNavItemTapped(int index) {
    if (_currentIndex != index) {
      MainNavigation.currentTab.value = index;
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(userName: widget.userName),
      const ActiveRideScreen(),
      const OffersScreen(),
      ProfileScreen(userName: widget.userName),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(
              color: AppColors.cardBorder.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, 'Home'),
                _buildNavItem(1, Icons.directions_car_rounded, Icons.directions_car_outlined, 'My Ride'),
                _buildNavItem(2, Icons.local_offer_rounded, Icons.local_offer_outlined, 'Offers'),
                _buildNavItem(3, Icons.person_rounded, Icons.person_outline_rounded, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onNavItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 20 : 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.teal.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? activeIcon : inactiveIcon,
                key: ValueKey(isActive),
                color: isActive ? AppColors.teal : AppColors.grey,
                size: 24,
              ),
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTheme.bodySmall.copyWith(
                  color: AppColors.teal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
