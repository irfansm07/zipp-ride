import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../services/alternative_train_service.dart';
import 'main_navigation.dart';
import 'active_ride_screen.dart';

class PnrBookingScreen extends StatefulWidget {
  const PnrBookingScreen({super.key});

  @override
  State<PnrBookingScreen> createState() => _PnrBookingScreenState();
}

class _PnrBookingScreenState extends State<PnrBookingScreen> {
  final _trainController = TextEditingController();
  final _pickupStationController = TextEditingController();
  final _destinationController = TextEditingController();
  bool _isTracking = false;
  bool _showStatus = false;
  Map<String, dynamic>? _trainData;
  final TrainService _trainService = TrainService();
  String _requestStatus = 'No request sent yet.';
  String _passengerNotification =
      'No updates yet. Search your train to send a cab request.';
  int? _etaToSelectedDestinationMin;
  String _etaArrivalText = '--:--';

  @override
  void dispose() {
    _trainController.dispose();
    _pickupStationController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  void _trackTrain() async {
    if (_trainController.text.length < 5 ||
        _pickupStationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter train number and pickup station',
            style: AppTheme.body,
          ),
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
      // Call real API to get train live status
      final trainData = await _trainService.getLiveTrainStatus(_trainController.text);
      
      if (trainData != null) {
        setState(() {
          _trainData = trainData;
          _showStatus = true;
          _requestStatus =
              'Request sent to nearby drivers in driver app for ${_pickupStationController.text.trim()}.';
          _passengerNotification =
              'Searching nearby drivers for Train ${_trainController.text.trim()} pickup at ${_pickupStationController.text.trim()}...';
        });
        _updateSelectedDestinationEta();

        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted || !_showStatus) return;
          
          setState(() {
            _requestStatus = 'Driver assigned';
            _passengerNotification =
                'Driver assigned. Navigating to My Ride...';
          });
          
          Future.delayed(const Duration(seconds: 1), () {
            if (!mounted) return;
            RideState.hasActiveRide.value = true;
            MainNavigation.currentTab.value = 1;
            Navigator.pop(context);
          });
        });
      } else {
        throw Exception('Unable to fetch train data');
      }
    } catch (e) {
      debugPrint('Error tracking train: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Live status unavailable. Check train number/API key or provider subscription and retry.',
              style: AppTheme.body,
            ),
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

  void _updateSelectedDestinationEta() {
    if (_trainData == null) return;
    final selectedDestination = _destinationController.text.trim();
    if (selectedDestination.isEmpty) {
      setState(() {
        _etaToSelectedDestinationMin = null;
        _etaArrivalText = '--:--';
      });
      return;
    }

    // Estimate ETA for selected destination.
    // If selected destination matches train destination, use arrival time if parseable.
    final trainDestination =
        (_trainData!['destinationName'] ?? _trainData!['destination'] ?? '')
            .toString()
            .toLowerCase();
    final userDestination = selectedDestination.toLowerCase();
    final delay = (_trainData!['delay'] as int?) ?? 0;

    int etaMin;
    if (trainDestination.isNotEmpty &&
        (trainDestination.contains(userDestination) ||
            userDestination.contains(trainDestination))) {
      etaMin = _minutesUntilTimeString((_trainData!['arrivalTime'] ?? '').toString()) ??
          (30 + delay);
    } else {
      // For intermediate/other stops, keep practical estimate with delay adjustment.
      etaMin = 18 + delay;
    }
    if (etaMin < 1) etaMin = 1;

    final etaArrival = DateTime.now().add(Duration(minutes: etaMin));
    final hh = etaArrival.hour.toString().padLeft(2, '0');
    final mm = etaArrival.minute.toString().padLeft(2, '0');

    setState(() {
      _etaToSelectedDestinationMin = etaMin;
      _etaArrivalText = '$hh:$mm';
    });
  }

  int? _minutesUntilTimeString(String value) {
    if (value.isEmpty || !value.contains(':')) return null;
    final parts = value.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    final now = DateTime.now();
    var target = DateTime(now.year, now.month, now.day, h, m);
    if (target.isBefore(now)) {
      target = target.add(const Duration(days: 1));
    }
    return target.difference(now).inMinutes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.darkGrey),
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
                      'Smart Train Sync',
                      style: AppTheme.heading2,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your train number to track live location and schedule your cab pickup. We will adjust the pickup automatically if your train is delayed!',
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
                    color: AppColors.darkGrey,
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

              Text('Pickup Station', style: AppTheme.bodyMedium),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: TextField(
                  controller: _pickupStationController,
                  style: AppTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'e.g., Chennai Central',
                    hintStyle: AppTheme.bodySmall.copyWith(color: AppColors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    prefixIcon: const Icon(
                      Icons.location_on_rounded,
                      color: AppColors.teal,
                    ),
                  ),
                ),
              ).animate(delay: 250.ms).fadeIn(),

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
                            const SizedBox(height: 4),
                            Text(
                              'Updated: ${_trainData!['lastUpdated'] ?? 'Just now'}'
                              '${_trainData!['dataSource'] != null ? ' · ${_trainData!['dataSource']}' : ''}',
                              style: AppTheme.caption.copyWith(color: AppColors.grey),
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
                      const SizedBox(height: 20),
                      
                      // Route
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_trainData!['source'],
                                    style: AppTheme.heading2
                                        .copyWith(color: AppColors.grey)),
                                Text(_trainData!['sourceName'], style: AppTheme.caption),
                                const SizedBox(height: 4),
                                Text('Mar 5, 20:15', style: AppTheme.bodySmall),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              const Icon(Icons.train_rounded,
                                  color: AppColors.teal),
                              Container(
                                width: 60,
                                height: 2,
                                color: AppColors.cardBorder,
                              ),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(_trainData!['destination'],
                                    style: AppTheme.heading2
                                        .copyWith(color: AppColors.teal)),
                                Text(_trainData!['destinationName'], style: AppTheme.caption),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(_trainData!['scheduledArrival'],
                                        style: AppTheme.bodySmall.copyWith(
                                            decoration: TextDecoration
                                                .lineThrough,
                                            color: AppColors.grey)),
                                    const SizedBox(width: 4),
                                    Text(_trainData!['arrivalTime'],
                                        style: AppTheme.bodySmall.copyWith(
                                            color: AppColors.teal,
                                            fontWeight: FontWeight.bold)),
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
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.1, end: 0),

                const SizedBox(height: 24),

                // Destination Input
                Text('Where to?', style: AppTheme.bodyMedium)
                    .animate()
                    .fadeIn(),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: TextField(
                    controller: _destinationController,
                    onChanged: (_) => _updateSelectedDestinationEta(),
                    style: AppTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Enter drop location',
                      hintStyle: AppTheme.bodySmall.copyWith(color: AppColors.grey),
                      border: InputBorder.none,
                      icon: const Icon(Icons.location_on_rounded, color: AppColors.pink),
                    ),
                  ),
                ).animate().fadeIn(),

                const SizedBox(height: 20),
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ETA To Your Selected Destination',
                          style: AppTheme.bodyMedium),
                      const SizedBox(height: 8),
                      if (_destinationController.text.trim().isEmpty)
                        Text(
                          'Enter destination to see train ETA for your stop.',
                          style: AppTheme.bodySmall,
                        )
                      else
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _destinationController.text.trim(),
                                    style: AppTheme.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    _etaToSelectedDestinationMin == null
                                        ? 'ETA: calculating...'
                                        : 'Train reaches in $_etaToSelectedDestinationMin min',
                                    style: AppTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.teal.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                _etaArrivalText,
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppColors.teal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: 0.1, end: 0),

                const SizedBox(height: 16),
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Plan Your Ride Mode', style: AppTheme.bodyMedium),
                      const SizedBox(height: 8),
                      Text(
                        'Choose bike, car, public transport, route-line, or share cab based on this ETA.',
                        style: AppTheme.bodySmall,
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: const [
                          _ModeChip(label: 'Bike', icon: Icons.two_wheeler_rounded),
                          _ModeChip(label: 'Car', icon: Icons.directions_car_rounded),
                          _ModeChip(label: 'Public', icon: Icons.directions_bus_rounded),
                          _ModeChip(label: 'Route-Line', icon: Icons.route_rounded),
                          _ModeChip(label: 'Share Cab', icon: Icons.people_alt_rounded),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: 0.1, end: 0),

                const SizedBox(height: 16),
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cab Request Status', style: AppTheme.bodyMedium),
                      const SizedBox(height: 8),
                      Text(_requestStatus, style: AppTheme.bodySmall),
                      const SizedBox(height: 14),
                      Text('Passenger Notification', style: AppTheme.bodyMedium),
                      const SizedBox(height: 8),
                      Text(_passengerNotification, style: AppTheme.bodySmall),
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: 0.1, end: 0),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _ModeChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.teal, size: 14),
          const SizedBox(width: 6),
          Text(label, style: AppTheme.bodySmall),
        ],
      ),
    );
  }
}
