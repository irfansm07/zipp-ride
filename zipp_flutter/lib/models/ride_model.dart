import 'package:flutter/material.dart';

class RideCategory {
  final String name;
  final IconData icon;
  final String emoji;
  final String priceRange;

  const RideCategory({
    required this.name,
    required this.icon,
    required this.emoji,
    required this.priceRange,
  });
}

List<RideCategory> getRideCategories() {
  return [
    RideCategory(
      name: 'Bike',
      icon: Icons.two_wheeler,
      emoji: '🏍️',
      priceRange: '₹30-80',
    ),
    RideCategory(
      name: 'Mini',
      icon: Icons.directions_car,
      emoji: '🚗',
      priceRange: '₹80-150',
    ),
    RideCategory(
      name: 'Sedan',
      icon: Icons.directions_car_filled,
      emoji: '🚙',
      priceRange: '₹150-250',
    ),
    RideCategory(
      name: 'SUV',
      icon: Icons.airport_shuttle,
      emoji: '🚐',
      priceRange: '₹250-400',
    ),
    RideCategory(
      name: 'Bus',
      icon: Icons.directions_bus,
      emoji: '🚌',
      priceRange: '₹20-50',
    ),
    RideCategory(
      name: 'Metro',
      icon: Icons.train,
      emoji: '🚇',
      priceRange: '₹15-40',
    ),
    RideCategory(
      name: 'Share Cab',
      icon: Icons.people,
      emoji: '🤝',
      priceRange: '₹50-120',
    ),
  ];
}

class RecommendationChip {
  final String label;
  final String emoji;

  const RecommendationChip({required this.label, required this.emoji});
}

List<RecommendationChip> getRecommendations(int passengerCount) {
  if (passengerCount == 1) {
    return [
      RecommendationChip(label: 'Bike', emoji: '🏍️'),
      RecommendationChip(label: 'Mini', emoji: '🚗'),
    ];
  } else if (passengerCount == 2) {
    return [
      RecommendationChip(label: 'Mini', emoji: '🚗'),
      RecommendationChip(label: 'Share Cab', emoji: '🤝'),
    ];
  } else if (passengerCount <= 4) {
    return [
      RecommendationChip(label: 'Sedan', emoji: '🚙'),
      RecommendationChip(label: 'Share Cab', emoji: '🤝'),
    ];
  } else {
    return [
      RecommendationChip(label: 'SUV', emoji: '🚐'),
      RecommendationChip(label: 'Bus', emoji: '🚌'),
      RecommendationChip(label: 'Metro', emoji: '🚇'),
    ];
  }
}
