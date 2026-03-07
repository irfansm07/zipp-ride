import 'dart:ui';

class DriverModel {
  final String name;
  final double rating;
  final String vehicleType;
  final String vehicleNumber;
  final String eta;
  final double price;
  final bool isFemale;
  final bool sharingOpen;
  final Color avatarColor;

  const DriverModel({
    required this.name,
    required this.rating,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.eta,
    required this.price,
    required this.isFemale,
    required this.sharingOpen,
    required this.avatarColor,
  });

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}';
    }
    return name[0];
  }
}

class SharedRideModel {
  final String riderName;
  final String route;
  final int overlapPercent;
  final double originalFare;
  final double splitFare;

  const SharedRideModel({
    required this.riderName,
    required this.route,
    required this.overlapPercent,
    required this.originalFare,
    required this.splitFare,
  });
}

List<DriverModel> getMockDrivers() {
  return [
    DriverModel(
      name: 'Rahul Sharma',
      rating: 4.8,
      vehicleType: 'Sedan',
      vehicleNumber: 'KA 01 AB 1234',
      eta: '3 min',
      price: 189.0,
      isFemale: false,
      sharingOpen: true,
      avatarColor: const Color(0xFF00E5CC),
    ),
    DriverModel(
      name: 'Priya Nair',
      rating: 4.9,
      vehicleType: 'Mini',
      vehicleNumber: 'KA 05 CD 5678',
      eta: '5 min',
      price: 149.0,
      isFemale: true,
      sharingOpen: false,
      avatarColor: const Color(0xFFFF6B9D),
    ),
    DriverModel(
      name: 'Amit Patel',
      rating: 4.6,
      vehicleType: 'SUV',
      vehicleNumber: 'MH 12 EF 9012',
      eta: '7 min',
      price: 299.0,
      isFemale: false,
      sharingOpen: true,
      avatarColor: const Color(0xFFFFB347),
    ),
    DriverModel(
      name: 'Sneha Reddy',
      rating: 4.7,
      vehicleType: 'Sedan',
      vehicleNumber: 'TN 09 GH 3456',
      eta: '4 min',
      price: 199.0,
      isFemale: true,
      sharingOpen: true,
      avatarColor: const Color(0xFFFF6B9D),
    ),
    DriverModel(
      name: 'Vikram Singh',
      rating: 4.5,
      vehicleType: 'Mini',
      vehicleNumber: 'DL 02 IJ 7890',
      eta: '6 min',
      price: 139.0,
      isFemale: false,
      sharingOpen: false,
      avatarColor: const Color(0xFF0099FF),
    ),
  ];
}

List<SharedRideModel> getMockSharedRides() {
  return [
    SharedRideModel(
      riderName: 'Rider A',
      route: 'MG Road → Koramangala',
      overlapPercent: 78,
      originalFare: 189.0,
      splitFare: 112.0,
    ),
    SharedRideModel(
      riderName: 'Rider B',
      route: 'Indiranagar → HSR Layout',
      overlapPercent: 65,
      originalFare: 159.0,
      splitFare: 95.0,
    ),
    SharedRideModel(
      riderName: 'Rider C',
      route: 'Whitefield → Marathahalli',
      overlapPercent: 85,
      originalFare: 129.0,
      splitFare: 72.0,
    ),
  ];
}
