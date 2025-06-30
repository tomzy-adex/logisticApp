import 'package:google_maps_flutter/google_maps_flutter.dart';

enum ShipmentStatus {
  pending,
  inTransit,
  delivered,
}

class Shipment {
  final String id;
  final String trackingNumber;
  final String senderName;
  final String receiverName;
  final String originAddress;
  final String destinationAddress;
  final LatLng originCoordinates;
  final LatLng destinationCoordinates;
  final ShipmentStatus status;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Shipment({
    required this.id,
    required this.trackingNumber,
    required this.senderName,
    required this.receiverName,
    required this.originAddress,
    required this.destinationAddress,
    required this.originCoordinates,
    required this.destinationCoordinates,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    this.updatedAt,
  });

  factory Shipment.fromJson(Map<String, dynamic> json) {
    return Shipment(
      id: json['id'],
      trackingNumber: json['trackingNumber'],
      senderName: json['senderName'],
      receiverName: json['receiverName'],
      originAddress: json['originAddress'],
      destinationAddress: json['destinationAddress'],
      originCoordinates: LatLng(
        json['originCoordinates']['latitude'],
        json['originCoordinates']['longitude'],
      ),
      destinationCoordinates: LatLng(
        json['destinationCoordinates']['latitude'],
        json['destinationCoordinates']['longitude'],
      ),
      status: ShipmentStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      createdBy: json['createdBy'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trackingNumber': trackingNumber,
      'senderName': senderName,
      'receiverName': receiverName,
      'originAddress': originAddress,
      'destinationAddress': destinationAddress,
      'originCoordinates': {
        'latitude': originCoordinates.latitude,
        'longitude': originCoordinates.longitude,
      },
      'destinationCoordinates': {
        'latitude': destinationCoordinates.latitude,
        'longitude': destinationCoordinates.longitude,
      },
      'status': status.toString().split('.').last,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Shipment copyWith({
    String? id,
    String? trackingNumber,
    String? senderName,
    String? receiverName,
    String? originAddress,
    String? destinationAddress,
    LatLng? originCoordinates,
    LatLng? destinationCoordinates,
    ShipmentStatus? status,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Shipment(
      id: id ?? this.id,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      senderName: senderName ?? this.senderName,
      receiverName: receiverName ?? this.receiverName,
      originAddress: originAddress ?? this.originAddress,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      originCoordinates: originCoordinates ?? this.originCoordinates,
      destinationCoordinates: destinationCoordinates ?? this.destinationCoordinates,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get statusText {
    switch (status) {
      case ShipmentStatus.pending:
        return 'Pending';
      case ShipmentStatus.inTransit:
        return 'In Transit';
      case ShipmentStatus.delivered:
        return 'Delivered';
    }
  }
} 