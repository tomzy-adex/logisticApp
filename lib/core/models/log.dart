enum LogType {
  login,
  shipmentCreated,
  shipmentUpdated,
}

class Log {
  final String id;
  final LogType type;
  final String userId;
  final String userEmail;
  final String description;
  final Map<String, dynamic>? metadata;
  final DateTime timestamp;

  Log({
    required this.id,
    required this.type,
    required this.userId,
    required this.userEmail,
    required this.description,
    this.metadata,
    required this.timestamp,
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      id: json['id'],
      type: LogType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      userId: json['userId'],
      userEmail: json['userEmail'],
      description: json['description'],
      metadata: json['metadata'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'userId': userId,
      'userEmail': userEmail,
      'description': description,
      'metadata': metadata,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  String get typeText {
    switch (type) {
      case LogType.login:
        return 'Login';
      case LogType.shipmentCreated:
        return 'Shipment Created';
      case LogType.shipmentUpdated:
        return 'Shipment Updated';
    }
  }
} 