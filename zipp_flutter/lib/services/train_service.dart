import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class TrainService {
  // Using IndianRailAPI - Correct endpoint from documentation
  static const String _baseUrl = 'https://indianrailapi.com/api/v2';
  static const String _apiKey = 'YOUR_API_KEY_HERE'; // Replace with actual API key
  
  // Alternative: Use RapidAPI (requires signup)
  // static const String _rapidApiUrl = 'https://indian-railway-irctc.p.rapidapi.com';
  // static const String _rapidApiKey = 'YOUR_RAPIDAPI_KEY';

  /// Get live train status by train number
  Future<Map<String, dynamic>?> getLiveTrainStatus(String trainNumber) async {
    try {
      debugPrint('Fetching live status for train: $trainNumber');
      
      // Get today's date in yyyymmdd format
      final now = DateTime.now();
      final dateStr = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
      
      // Correct API endpoint from documentation
      final response = await http.get(
        Uri.parse('$_baseUrl/LiveTrainStatus/apikey/$_apiKey/TrainNumber/$trainNumber/Date/$dateStr/'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      debugPrint('Train API Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseTrainData(data, trainNumber);
      } else {
        debugPrint('API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to fetch train status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Train service error: $e');
      // Return fallback data for demo
      return _getFallbackTrainData(trainNumber);
    }
  }

  /// Parse API response and format it for our app
  Map<String, dynamic> _parseTrainData(Map<String, dynamic> data, String trainNumber) {
    try {
      // Check if API returned valid response
      if (data['ResponseCode'] != '200') {
        throw Exception('API returned error: ${data['ResponseMessage'] ?? 'Unknown error'}');
      }
      
      // Extract data from IndianRailAPI response structure
      final currentPosition = data['CurrentPosition'] ?? {};
      final currentStation = data['CurrentStation'] ?? {};
      final trainInfo = data; // Main response contains train info
      
      return {
        'trainNumber': trainInfo['TrainNumber'] ?? trainNumber.toUpperCase(),
        'trainName': _getTrainName(trainNumber), // API doesn't provide train name
        'currentLocation': currentStation['StationName'] ?? 'Unknown Location',
        'nextStation': _getNextStation(currentStation), // Calculate next station
        'delay': int.tryParse(currentStation['DelayInArrival']?.toString() ?? '0') ?? 0,
        'arrivalTime': currentStation['ActualArrival'] ?? 'Unknown',
        'scheduledArrival': currentStation['ScheduleArrival'] ?? 'Unknown',
        'source': _getSourceStation(trainNumber), // Not provided by API
        'sourceName': _getSourceStationName(trainNumber),
        'destination': _getDestinationStation(trainNumber),
        'destinationName': _getDestinationStationName(trainNumber),
        'platform': currentStation['Platform']?.toString() ?? '1',
        'speed': '${currentPosition['Speed'] ?? '0'} km/h',
        'status': currentPosition['Status'] ?? 'Running',
        'lastUpdated': 'Just now',
        'distance': currentPosition['Distance']?.toString() ?? '0',
      };
    } catch (e) {
      debugPrint('Error parsing train data: $e');
      return _getFallbackTrainData(trainNumber);
    }
  }

  /// Helper methods to get train information (since API doesn't provide all details)
  String _getTrainName(String trainNumber) {
    // Map of popular train numbers to names
    final trainNames = {
      '12628': 'Karnataka Express',
      '12622': 'Tamil Nadu Express',
      '12220': 'Duronto Express',
      '12608': 'Lalbagh Express',
      '12028': 'Shatabdi Express',
      '12246': 'Duronto Express',
      '12578': 'Bagmati Express',
      '12786': 'Kacheguda Express',
      '22691': 'KSR Bengaluru - Hazrat Nizamuddin Rajdhani Express',
    };
    return trainNames[trainNumber] ?? 'Express Train';
  }

  String _getNextStation(Map<String, dynamic> currentStation) {
    // This would require route data to calculate next station
    // For now, return a placeholder
    return 'Next Station';
  }

  String _getSourceStation(String trainNumber) {
    final sources = {
      '12628': 'NDLS',
      '12622': 'NDLS',
      '12220': 'NDLS',
      '12608': 'SBC',
      '12028': 'SBC',
      '22691': 'SBC',
    };
    return sources[trainNumber] ?? 'SRC';
  }

  String _getSourceStationName(String trainNumber) {
    final sourceNames = {
      '12628': 'New Delhi',
      '12622': 'New Delhi',
      '12220': 'New Delhi',
      '12608': 'KSR Bengaluru',
      '12028': 'KSR Bengaluru',
      '22691': 'KSR Bengaluru',
    };
    return sourceNames[trainNumber] ?? 'Source Station';
  }

  String _getDestinationStation(String trainNumber) {
    final destinations = {
      '12628': 'SBC',
      '12622': 'MAS',
      '12220': 'YPR',
      '12608': 'MAS',
      '12028': 'MAS',
      '22691': 'NZM',
    };
    return destinations[trainNumber] ?? 'DST';
  }

  String _getDestinationStationName(String trainNumber) {
    final destinationNames = {
      '12628': 'KSR Bengaluru',
      '12622': 'Chennai Central',
      '12220': 'Yesvantpur',
      '12608': 'Chennai Central',
      '12028': 'Chennai Central',
      '22691': 'Hazrat Nizamuddin',
    };
    return destinationNames[trainNumber] ?? 'Destination Station';
  }

  /// Fallback data when API fails (for demo purposes)
  Map<String, dynamic> _getFallbackTrainData(String trainNumber) {
    debugPrint('Using fallback data for train: $trainNumber');
    
    return {
      'trainNumber': trainNumber.toUpperCase(),
      'trainName': 'Express Train',
      'currentLocation': 'Bangalore City Junction',
      'nextStation': 'Yeshwantpur',
      'delay': 15,
      'arrivalTime': '14:15',
      'scheduledArrival': '14:00',
      'source': 'SBC',
      'sourceName': 'KSR Bengaluru',
      'destination': 'MAS',
      'destinationName': 'Chennai Central',
      'platform': '3',
      'speed': '65 km/h',
      'status': 'Running',
      'lastUpdated': '2 min ago',
    };
  }

  /// Search trains by number (for autocomplete)
  Future<List<Map<String, dynamic>>> searchTrains(String query) async {
    if (query.length < 3) return [];
    
    try {
      // This would be a real API call in production
      // For now, return some popular train numbers
      final popularTrains = [
        {'number': '12628', 'name': 'Karnataka Express'},
        {'number': '12622', 'name': 'Tamil Nadu Express'},
        {'number': '12220', 'name': 'Duronto Express'},
        {'number': '12608', 'name': 'Lalbagh Express'},
        {'number': '12028', 'name': 'Shatabdi Express'},
      ];
      
      return popularTrains
          .where((train) => 
              train['number']!.toLowerCase().contains(query.toLowerCase()) ||
              train['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      debugPrint('Error searching trains: $e');
      return [];
    }
  }
}
