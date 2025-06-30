import 'package:flutter/foundation.dart';
import '../../core/models/shipment.dart';
import '../../core/services/shipment_service.dart';
import '../../core/services/auth_service.dart';

class ShipmentProvider with ChangeNotifier {
  List<Shipment> _shipments = [];
  bool _isLoading = false;
  String? _error;
  Shipment? _selectedShipment;

  List<Shipment> get shipments => _shipments;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Shipment? get selectedShipment => _selectedShipment;

  List<Shipment> get filteredShipments {
    final currentUser = AuthService.currentUser;
    if (currentUser?.isAdmin == true) {
      return _shipments;
    } else {
      return _shipments.where((s) => s.createdBy == currentUser?.id).toList();
    }
  }

  Future<void> loadShipments() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final currentUser = AuthService.currentUser;
      if (currentUser?.isAdmin == true) {
        _shipments = await ShipmentService.getAllShipments();
      } else {
        _shipments = await ShipmentService.getUserShipments(currentUser!.id);
      }
      _error = null;
    } catch (e) {
      _error = 'Failed to load shipments: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createShipment({
    required String senderName,
    required String receiverName,
    required String originAddress,
    required String destinationAddress,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final shipment = await ShipmentService.createShipment(
        senderName: senderName,
        receiverName: receiverName,
        originAddress: originAddress,
        destinationAddress: destinationAddress,
      );

      _shipments.add(shipment);
      _error = null;
      return true;
    } catch (e) {
      _error = 'Failed to create shipment: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateShipmentStatus(String shipmentId, ShipmentStatus newStatus) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedShipment = await ShipmentService.updateShipmentStatus(
        shipmentId,
        newStatus,
      );

      final index = _shipments.indexWhere((s) => s.id == shipmentId);
      if (index != -1) {
        _shipments[index] = updatedShipment;
      }

      _error = null;
      return true;
    } catch (e) {
      _error = 'Failed to update shipment: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Shipment?> trackShipment(String trackingNumber) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final shipment = await ShipmentService.getShipmentByTrackingNumber(trackingNumber);
      _selectedShipment = shipment;
      _error = null;
      return shipment;
    } catch (e) {
      _error = 'Failed to track shipment: ${e.toString()}';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearSelectedShipment() {
    _selectedShipment = null;
    notifyListeners();
  }
} 