import '../core/models/user.dart';
import '../core/models/shipment.dart';
import '../core/models/log.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MockData {
  static final List<User> users = [
    User(
      id: '1',
      email: 'admin@example.com',
      name: 'Admin User',
      role: 'admin',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    User(
      id: '2',
      email: 'user@example.com',
      name: 'Regular User',
      role: 'user',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];

  static final List<Shipment> initialShipments = [
    Shipment(
      id: '1',
      trackingNumber: 'TRK001234567',
      senderName: 'John Doe',
      receiverName: 'Jane Smith',
      originAddress: 'Victoria Island, Lagos, Nigeria',
      destinationAddress: 'Ikeja, Lagos, Nigeria',
      originCoordinates: const LatLng(6.4281, 3.4219), // Victoria Island
      destinationCoordinates: const LatLng(6.6018, 3.3515), // Ikeja
      status: ShipmentStatus.inTransit,
      createdBy: '2',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Shipment(
      id: '2',
      trackingNumber: 'TRK007654321',
      senderName: 'Alice Johnson',
      receiverName: 'Bob Wilson',
      originAddress: 'Lekki, Lagos, Nigeria',
      destinationAddress: 'Surulere, Lagos, Nigeria',
      originCoordinates: const LatLng(6.4550, 3.4720), // Lekki
      destinationCoordinates: const LatLng(6.4924, 3.3594), // Surulere
      status: ShipmentStatus.pending,
      createdBy: '2',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Shipment(
      id: '3',
      trackingNumber: 'TRK009876543',
      senderName: 'Charlie Brown',
      receiverName: 'Diana Prince',
      originAddress: 'Alimosho, Lagos, Nigeria',
      destinationAddress: 'Oshodi, Lagos, Nigeria',
      originCoordinates: const LatLng(6.6161, 3.2553), // Alimosho
      destinationCoordinates: const LatLng(6.5550, 3.3326), // Oshodi
      status: ShipmentStatus.delivered,
      createdBy: '2',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  static final List<Log> initialLogs = [
    Log(
      id: '1',
      type: LogType.login,
      userId: '1',
      userEmail: 'admin@example.com',
      description: 'Admin user logged in',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Log(
      id: '2',
      type: LogType.login,
      userId: '2',
      userEmail: 'user@example.com',
      description: 'Regular user logged in',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Log(
      id: '3',
      type: LogType.shipmentCreated,
      userId: '2',
      userEmail: 'user@example.com',
      description: 'Created shipment TRK001234567',
      metadata: {'trackingNumber': 'TRK001234567'},
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Log(
      id: '4',
      type: LogType.shipmentCreated,
      userId: '2',
      userEmail: 'user@example.com',
      description: 'Created shipment TRK007654321',
      metadata: {'trackingNumber': 'TRK007654321'},
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Log(
      id: '5',
      type: LogType.shipmentUpdated,
      userId: '1',
      userEmail: 'admin@example.com',
      description: 'Updated shipment TRK001234567 status to In Transit',
      metadata: {'trackingNumber': 'TRK001234567', 'status': 'inTransit'},
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  static User? authenticateUser(String email, String password) {
    if (password != 'password') return null;
    
    return users.firstWhere(
      (user) => user.email == email,
      orElse: () => throw Exception('User not found'),
    );
  }

  static String generateTrackingNumber() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    final trackingNumber = 'TRK${random.toString().substring(random.toString().length - 8)}';
    return trackingNumber;
  }

  static LatLng getCoordinatesForAddress(String address) {
    // Mock geocoding service - returns coordinates based on Lagos areas
    final addressLower = address.toLowerCase();
    
    if (addressLower.contains('victoria island') || addressLower.contains('vi')) {
      return const LatLng(6.4281, 3.4219);
    } else if (addressLower.contains('ikeja')) {
      return const LatLng(6.6018, 3.3515);
    } else if (addressLower.contains('lekki')) {
      return const LatLng(6.4550, 3.4720);
    } else if (addressLower.contains('surulere')) {
      return const LatLng(6.4924, 3.3594);
    } else if (addressLower.contains('alimosho')) {
      return const LatLng(6.6161, 3.2553);
    } else if (addressLower.contains('oshodi')) {
      return const LatLng(6.5550, 3.3326);
    } else if (addressLower.contains('ajah')) {
      return const LatLng(6.4667, 3.5667);
    } else if (addressLower.contains('yaba')) {
      return const LatLng(6.5083, 3.3833);
    } else if (addressLower.contains('maryland')) {
      return const LatLng(6.5833, 3.3667);
    } else if (addressLower.contains('ogba')) {
      return const LatLng(6.6167, 3.3333);
    } else if (addressLower.contains('agege')) {
      return const LatLng(6.6167, 3.3167);
    } else if (addressLower.contains('ikorodu')) {
      return const LatLng(6.6167, 3.5167);
    } else if (addressLower.contains('lagos')) {
      // Default Lagos coordinates (Lagos Island)
      return const LatLng(6.5244, 3.3792);
    } else {
      // Default coordinates (Lagos Island)
      return const LatLng(6.5244, 3.3792);
    }
  }
} 