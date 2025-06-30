import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteService {
  static List<LatLng> generateRouteWaypoints(LatLng origin, LatLng destination) {
    // Generate a simple route with just origin and destination for clean display
    return [origin, destination];
  }

  static List<LatLng> generateOptimizedRoute(LatLng origin, LatLng destination) {
    // This would typically call Google Directions API for Lagos routes
    // For now, return a route with waypoints that follow Lagos road patterns
    return generateRouteWaypoints(origin, destination);
  }

  static double calculateDistance(LatLng origin, LatLng destination) {
    // Simple distance calculation (in degrees)
    final double latDiff = destination.latitude - origin.latitude;
    final double lngDiff = destination.longitude - origin.longitude;
    return sqrt(latDiff * latDiff + lngDiff * lngDiff);
  }

  static String getEstimatedTime(LatLng origin, LatLng destination) {
    // Estimate travel time based on distance (Lagos traffic considerations)
    final double distance = calculateDistance(origin, destination);
    
    if (distance < 0.02) {
      return '15-30 mins'; // Short distance
    } else if (distance < 0.05) {
      return '30-45 mins'; // Medium distance
    } else if (distance < 0.1) {
      return '45-60 mins'; // Longer distance
    } else {
      return '1-2 hours'; // Long distance
    }
  }
} 