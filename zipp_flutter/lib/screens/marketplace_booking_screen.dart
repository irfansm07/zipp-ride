import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';
import '../models/ride_model.dart';
import '../services/alternative_train_service.dart';

class PnrBookingScreen extends StatefulWidget {
  const PnrBookingScreen({super.key});

  @override
  State<PnrBookingScreen> createState() => _PnrBookingScreenState();
}

class _PnrBookingScreenState extends State<PnrBookingScreen> {
  final _trainController = TextEditingController();
  bool _isTracking = false;
  bool _showStatus = false;
  bool _showStationSelection = false;
  bool _showBookingConfirmation = false;
  int _selectedCategoryIndex = -1;
  final _categories = getRideCategories();
  Map<String, dynamic>? _trainData;
  String? _selectedStation;
  final TrainService _trainService = TrainService();

  // Popular stations list
  final List<Map<String, String>> _popularStations = [
    {'code': 'SBC', 'name': 'KSR Bengaluru', 'city': 'Bangalore'},
    {'code': 'MAS', 'name': 'Chennai Central', 'city': 'Chennai'},
    {'code': 'NDLS', 'name': 'New Delhi', 'city': 'Delhi'},
    {'code': 'CSTM', 'name': 'Chhatrapati Shivaji Terminus', 'city': 'Mumbai'},
    {'code': 'HWH', 'name': 'Howrah Junction', 'city': 'Kolkata'},
    {'code': 'PNBE', 'name': 'Patna Junction', 'city': 'Patna'},
    {'code': 'BPL', 'name': 'Bhopal Junction', 'city': 'Bhopal'},
    {'code': 'NGP', 'name': 'Nagpur Junction', 'city': 'Nagpur'},
  ];

  @override
  void dispose() {
    _trainController.dispose();
    super.dispose();
  }

  void _trackTrain() async {
    if (_trainController.text.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid train number', style: AppTheme.body),
          backgroundColor: AppColors.card,
        ),
      );
      return;
    }

    setState(() {
      _isTracking = true;
      _showStatus = false;
    });

    try {
      final trainData = await _trainService.getLiveTrainStatus(_trainController.text);
      
      if (trainData != null) {
        setState(() {
          _trainData = trainData;
          _showStatus = true;
          _showStationSelection = true;
        });
      } else {
        throw Exception('Unable to fetch train data');
      }
    } catch (e) {
      debugPrint('Error tracking train: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to track train. Please check the train number.', style: AppTheme.body),
            backgroundColor: AppColors.card,
            action: SnackBarAction(
              label: 'Retry',
              textColor: AppColors.teal,
              onPressed: _trackTrain,
            ),
          ),
        );
      }
    } finally {
      setState(() {
        _isTracking = false;
      });
    }
  }

  void _selectStation(String stationCode, String stationName) {
    setState(() {
      _selectedStation = stationName;
    });
  }

  void _requestCab() {
    if (_selectedStation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a pickup station', style: AppTheme.body),
          backgroundColor: AppColors.card,
        ),
      );
      return;
    }

    if (_selectedCategoryIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a ride type', style: AppTheme.body),
          backgroundColor: AppColors.card,
        ),
      );
      return;
    }

    setState(() {
      _showBookingConfirmation = true;
    });

    // Simulate driver matching
    _simulateDriverMatching();
  }

  void _simulateDriverMatching() async {
    await Future.delayed(const Duration(seconds: 3));
    
    if (mounted) {
      setState(() {
        _showBookingConfirmation = false;
      });
      
      _showDriverFoundDialog();
    }
  }

  void _showDriverFoundDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
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
                  border: Border.all(color: AppColors.success, width: 2),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.success,
                  size: 40,
                ),
              )
                  .animate()
                  .scale(duration: 600.ms, curve: Curves.elasticOut),
              const SizedBox(height: 20),
              Text(
                'Driver Found!',
                style: AppTheme.heading2,
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 12),
              Text(
                'Rajesh Kumar is on the way to $_selectedStation',
                style: AppTheme.body.copyWith(color: AppColors.grey),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 8),
              Text(
                'Arriving in 5 minutes • Swift Dzire • KA-01-AB-1234',
                style: AppTheme.bodySmall.copyWith(color: AppColors.teal),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.teal),
                      ),
                      child: Text('Cancel', style: AppTheme.button.copyWith(color: AppColors.teal)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GradientButton(
                      text: 'Track Driver',
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 500.ms),
            ],
          ),
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
                      'Smart Train Cab Booking',
                      style: AppTheme.heading2,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your train number, select pickup station, and get matched with nearby drivers. Track your train and driver in real-time!',
                      style: AppTheme.bodySmall.copyWith(color: AppColors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.05, end: 0),

              const SizedBox(height: 32),

              // Train Number Input
              Text('Enter Train Number', style: AppTheme.bodyMedium),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: TextField(
                  controller: _trainController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.characters,
                  style: GoogleFonts.dmSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g., 12628',
                    hintStyle: GoogleFonts.dmSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.grey.withValues(alpha: 0.5),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    prefixIcon: const Icon(
                      Icons.train_rounded,
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
                    onPressed: _isTracking ? null : _trackTrain,
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
                            'Track Train',
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
                      // Train Name and Number
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_trainData!['trainNumber']} - ${_trainData!['trainName']}',
                                  style: AppTheme.heading3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _trainData!['delay'] > 0 
                                        ? Colors.red.withValues(alpha: 0.1)
                                        : Colors.green.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _trainData!['delay'] > 0 
                                        ? 'Delayed by ${_trainData!['delay']} mins'
                                        : 'On Time',
                                    style: AppTheme.caption.copyWith(
                                        color: _trainData!['delay'] > 0 
                                            ? Colors.red
                                            : Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Live Location Section
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.teal.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on_rounded, 
                                       color: AppColors.teal, size: 16),
                                const SizedBox(width: 4),
                                Text('Live Location', style: AppTheme.bodySmall.copyWith(
                                  color: AppColors.teal,
                                  fontWeight: FontWeight.bold,
                                )),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _trainData!['currentLocation'],
                              style: AppTheme.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Next: ${_trainData!['nextStation']}',
                              style: AppTheme.bodySmall.copyWith(color: AppColors.grey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Train Details
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Platform', style: AppTheme.caption),
                                Text(_trainData!['platform'], 
                                     style: AppTheme.bodyMedium.copyWith(
                                       fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Speed', style: AppTheme.caption),
                                Text(_trainData!['speed'], 
                                     style: AppTheme.bodyMedium.copyWith(
                                       fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Arrival', style: AppTheme.caption),
                                Text(_trainData!['arrivalTime'], 
                                     style: AppTheme.bodyMedium.copyWith(
                                       fontWeight: FontWeight.bold,
                                       color: AppColors.teal)),
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

                const SizedBox(height: 32),

                // Station Selection
                if (_showStationSelection) ...[
                  Text('Select Pickup Station', style: AppTheme.bodyMedium)
                      .animate()
                      .fadeIn(),
                  const SizedBox(height: 12),
                  
                  // Popular Stations Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _popularStations.length,
                    itemBuilder: (context, index) {
                      final station = _popularStations[index];
                      final isSelected = _selectedStation == station['name'];
                      
                      return GestureDetector(
                        onTap: () => _selectStation(station['code']!, station['name']!),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? AppColors.teal.withValues(alpha: 0.2)
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? AppColors.teal : AppColors.cardBorder,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                station['code']!,
                                style: AppTheme.caption.copyWith(
                                  color: isSelected ? AppColors.teal : AppColors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                station['name']!,
                                style: AppTheme.bodySmall.copyWith(
                                  color: isSelected ? AppColors.teal : AppColors.white,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                station['city']!,
                                style: AppTheme.caption.copyWith(
                                  color: AppColors.grey,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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

                  // Book Cab Button
                  GradientButton(
                    text: 'Book No Delay Cab',
                    icon: Icons.flash_on_rounded,
                    onPressed: _requestCab,
                  ).animate().fadeIn().slideY(begin: 0.1, end: 0),

                  // Loading Overlay
                  if (_showBookingConfirmation)
                    Container(
                      color: Colors.black.withValues(alpha: 0.5),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: AppColors.teal),
                            SizedBox(height: 20),
                            Text(
                              'Finding nearby drivers...',
                              style: TextStyle(color: AppColors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
