import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';
import '../services/alternative_train_service.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  final List<Map<String, dynamic>> _bookingRequests = [
    {
      'id': '1',
      'trainNumber': '12628',
      'trainName': 'Karnataka Express',
      'pickupStation': 'KSR Bengaluru',
      'arrivalTime': '14:25',
      'delay': 15,
      'passengerName': 'John Doe',
      'rideType': 'Sedan',
      'estimatedFare': '₹450',
      'distance': '2.5 km',
      'time': '2 min ago',
    },
    {
      'id': '2',
      'trainNumber': '12622',
      'trainName': 'Tamil Nadu Express',
      'pickupStation': 'Chennai Central',
      'arrivalTime': '16:45',
      'delay': 0,
      'passengerName': 'Jane Smith',
      'rideType': 'SUV',
      'estimatedFare': '₹650',
      'distance': '3.8 km',
      'time': '5 min ago',
    },
  ];

  bool _isOnline = true;
  String? _acceptedRequestId;

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
        title: Text('Driver Dashboard', style: AppTheme.heading3),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Switch(
              value: _isOnline,
              onChanged: (value) {
                setState(() {
                  _isOnline = value;
                });
              },
              activeColor: AppColors.teal,
              activeTrackColor: AppColors.teal.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Status Bar
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isOnline
                      ? [AppColors.teal.withValues(alpha: 0.2), AppColors.teal.withValues(alpha: 0.1)]
                      : [AppColors.grey.withValues(alpha: 0.2), AppColors.grey.withValues(alpha: 0.1)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isOnline ? AppColors.teal : AppColors.grey,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _isOnline ? Icons.online_prediction_rounded : Icons.offline_bolt_rounded,
                    color: _isOnline ? AppColors.teal : AppColors.grey,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isOnline ? 'You\'re Online' : 'You\'re Offline',
                          style: AppTheme.bodyMedium.copyWith(
                            color: _isOnline ? AppColors.teal : AppColors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _isOnline ? 'Receiving booking requests' : 'Not receiving requests',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _isOnline ? AppColors.teal : AppColors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _isOnline ? 'Active' : 'Inactive',
                      style: AppTheme.caption.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(),

            // Booking Requests Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Booking Requests',
                    style: AppTheme.heading3,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.pink.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_bookingRequests.length} New',
                      style: AppTheme.caption.copyWith(
                        color: AppColors.pink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 16),

            // Booking Requests List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _bookingRequests.length,
                itemBuilder: (context, index) {
                  final request = _bookingRequests[index];
                  final isAccepted = _acceptedRequestId == request['id'];
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: GlassCard(
                      isGlowing: isAccepted,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with Train Info
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.teal.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.train_rounded,
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
                                      '${request['trainNumber']} - ${request['trainName']}',
                                      style: AppTheme.bodyMedium.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Pickup: ${request['pickupStation']}',
                                      style: AppTheme.bodySmall.copyWith(color: AppColors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: request['delay'] > 0 
                                      ? Colors.red.withValues(alpha: 0.1)
                                      : Colors.green.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  request['delay'] > 0 
                                      ? '${request['delay']} min delay'
                                      : 'On time',
                                  style: AppTheme.caption.copyWith(
                                    color: request['delay'] > 0 ? Colors.red : Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Train Status
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.access_time_rounded, 
                                       color: AppColors.teal, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  'Arriving at ${request['arrivalTime']}',
                                  style: AppTheme.bodySmall.copyWith(
                                    color: AppColors.teal,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  request['time'],
                                  style: AppTheme.caption.copyWith(color: AppColors.grey),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Passenger and Ride Details
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Passenger', style: AppTheme.caption),
                                    Text(
                                      request['passengerName'],
                                      style: AppTheme.bodySmall.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Ride Type', style: AppTheme.caption),
                                    Text(
                                      request['rideType'],
                                      style: AppTheme.bodySmall.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('Est. Fare', style: AppTheme.caption),
                                    Text(
                                      request['estimatedFare'],
                                      style: AppTheme.bodySmall.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.teal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Distance and Actions
                          Row(
                            children: [
                              Icon(Icons.location_on_rounded, 
                                     color: AppColors.pink, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${request['distance']} away',
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppColors.pink,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              if (isAccepted) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.check_circle_rounded, 
                                             color: AppColors.success, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Accepted',
                                        style: AppTheme.caption.copyWith(
                                          color: AppColors.success,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ] else ...[
                                OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      _acceptedRequestId = request['id'];
                                    });
                                    _showAcceptanceDialog(request);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: AppColors.teal),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  ),
                                  child: Text(
                                    'Accept',
                                    style: AppTheme.button.copyWith(
                                      color: AppColors.teal,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      _bookingRequests.removeWhere((r) => r['id'] == request['id']);
                                    });
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: AppColors.grey),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  ),
                                  child: Text(
                                    'Decline',
                                    style: AppTheme.button.copyWith(
                                      color: AppColors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: (index * 100).ms);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAcceptanceDialog(Map<String, dynamic> request) {
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
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 40,
                ),
              )
                  .animate()
                  .scale(duration: 600.ms, curve: Curves.elasticOut),
              const SizedBox(height: 20),
              Text(
                'Booking Accepted!',
                style: AppTheme.heading2,
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 12),
              Text(
                'Navigate to ${request['pickupStation']} to pick up ${request['passengerName']}',
                style: AppTheme.body.copyWith(color: AppColors.grey),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 8),
              Text(
                'Train arrives at ${request['arrivalTime']} • ${request['distance']} away',
                style: AppTheme.bodySmall.copyWith(color: AppColors.teal),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        setState(() {
                          _acceptedRequestId = null;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.grey),
                      ),
                      child: Text('Cancel', style: AppTheme.button.copyWith(color: AppColors.grey)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GradientButton(
                      text: 'Navigate',
                      icon: Icons.navigation_rounded,
                      onPressed: () {
                        Navigator.pop(ctx);
                        // Here you would integrate with Google Maps or similar
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
}
