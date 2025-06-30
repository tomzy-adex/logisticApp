import '../models/shipment.dart';
import '../models/log.dart';
import '../models/user.dart';
import 'storage_service.dart';
import '../../data/mock_data.dart';
import 'auth_service.dart';

class ShipmentService {
  static Future<List<Shipment>> getAllShipments() async {
    return await StorageService.getShipments();
  }

  static Future<List<Shipment>> getUserShipments(String userId) async {
    final shipments = await StorageService.getShipments();
    return shipments.where((s) => s.createdBy == userId).toList();
  }

  static Future<Shipment?> getShipmentByTrackingNumber(String trackingNumber) async {
    final shipments = await StorageService.getShipments();
    try {
      return shipments.firstWhere((s) => s.trackingNumber == trackingNumber);
    } catch (e) {
      return null;
    }
  }

  static Future<Shipment> createShipment({
    required String senderName,
    required String receiverName,
    required String originAddress,
    required String destinationAddress,
  }) async {
    final currentUser = AuthService.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    final trackingNumber = MockData.generateTrackingNumber();
    final originCoordinates = MockData.getCoordinatesForAddress(originAddress);
    final destinationCoordinates = MockData.getCoordinatesForAddress(destinationAddress);

    final shipment = Shipment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      trackingNumber: trackingNumber,
      senderName: senderName,
      receiverName: receiverName,
      originAddress: originAddress,
      destinationAddress: destinationAddress,
      originCoordinates: originCoordinates,
      destinationCoordinates: destinationCoordinates,
      status: ShipmentStatus.pending,
      createdBy: currentUser.id,
      createdAt: DateTime.now(),
    );

    final shipments = await StorageService.getShipments();
    shipments.add(shipment);
    await StorageService.saveShipments(shipments);

    // Log the shipment creation
    await _logShipmentActivity(
      LogType.shipmentCreated,
      currentUser,
      'Created shipment $trackingNumber',
      {'trackingNumber': trackingNumber},
    );

    return shipment;
  }

  static Future<Shipment> updateShipmentStatus(
    String shipmentId,
    ShipmentStatus newStatus,
  ) async {
    final currentUser = AuthService.currentUser;
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    if (!currentUser.isAdmin) {
      throw Exception('Only admins can update shipment status');
    }

    final shipments = await StorageService.getShipments();
    final shipmentIndex = shipments.indexWhere((s) => s.id == shipmentId);
    
    if (shipmentIndex == -1) {
      throw Exception('Shipment not found');
    }

    final updatedShipment = shipments[shipmentIndex].copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
    );

    shipments[shipmentIndex] = updatedShipment;
    await StorageService.saveShipments(shipments);

    // Log the shipment update
    await _logShipmentActivity(
      LogType.shipmentUpdated,
      currentUser,
      'Updated shipment ${updatedShipment.trackingNumber} status to ${newStatus.toString().split('.').last}',
      {
        'trackingNumber': updatedShipment.trackingNumber,
        'status': newStatus.toString().split('.').last,
      },
    );

    return updatedShipment;
  }

  static Future<void> _logShipmentActivity(
    LogType type,
    User user,
    String description,
    Map<String, dynamic>? metadata,
  ) async {
    final log = Log(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      userId: user.id,
      userEmail: user.email,
      description: description,
      metadata: metadata,
      timestamp: DateTime.now(),
    );

    final logs = await StorageService.getLogs();
    logs.add(log);
    await StorageService.saveLogs(logs);
  }

  static Future<void> initializeData() async {
    final shipments = await StorageService.getShipments();
    if (shipments.isEmpty) {
      await StorageService.saveShipments(MockData.initialShipments);
    }

    final logs = await StorageService.getLogs();
    if (logs.isEmpty) {
      await StorageService.saveLogs(MockData.initialLogs);
    }
  }
} 