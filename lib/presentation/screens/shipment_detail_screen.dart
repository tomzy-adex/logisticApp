import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../../core/models/shipment.dart';
import '../../core/services/route_service.dart';
import '../widgets/common_widgets.dart';
import '../widgets/shipment_map_widget.dart';
import 'dart:ui';

class ShipmentDetailScreen extends StatelessWidget {
  final Shipment shipment;

  const ShipmentDetailScreen({Key? key, required this.shipment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Shipment Details'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tracking Number Card
            _AnimatedCard(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.qr_code, color: Colors.blue, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          'Tracking Number',
                          style: theme.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 20, color: Colors.blue),
                          tooltip: 'Copy Tracking ID',
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: shipment.trackingNumber));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Tracking ID copied!'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      shipment.trackingNumber,
                      style: theme.textTheme.headlineSmall!.copyWith(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    StatusChip(status: shipment.status),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            _SectionDivider(title: 'Sender'),
            _AnimatedCard(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xFFe3f2fd),
                      child: Icon(Icons.person, color: Colors.blue),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shipment.senderName,
                            style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            shipment.originAddress,
                            style: theme.textTheme.bodyMedium!.copyWith(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            _SectionDivider(title: 'Receiver'),
            _AnimatedCard(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xFFfce4ec),
                      child: Icon(Icons.person_outline, color: Colors.pink),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shipment.receiverName,
                            style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            shipment.destinationAddress,
                            style: theme.textTheme.bodyMedium!.copyWith(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            _SectionDivider(title: 'Delivery Timeline'),
            _AnimatedCard(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTimelineItem(
                      'Shipment Created',
                      DateFormat('MMM dd, yyyy HH:mm').format(shipment.createdAt),
                      Icons.add_circle,
                      Colors.green,
                      true,
                    ),
                    if (shipment.status != ShipmentStatus.pending)
                      _buildTimelineItem(
                        'In Transit',
                        shipment.status == ShipmentStatus.inTransit
                            ? 'Currently in transit'
                            : DateFormat('MMM dd, yyyy HH:mm').format(shipment.updatedAt!),
                        Icons.local_shipping,
                        Colors.blue,
                        shipment.status != ShipmentStatus.pending,
                      ),
                    if (shipment.status == ShipmentStatus.delivered)
                      _buildTimelineItem(
                        'Delivered',
                        DateFormat('MMM dd, yyyy HH:mm').format(shipment.updatedAt!),
                        Icons.check_circle,
                        Colors.green,
                        true,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            _SectionDivider(title: 'Location Details'),
            _AnimatedCard(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.purple),
                        const SizedBox(width: 8),
                        Text(
                          'Origin',
                          style: theme.textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Destination',
                          style: theme.textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            shipment.originAddress,
                            style: theme.textTheme.bodyMedium!.copyWith(color: Colors.grey.shade600),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            shipment.destinationAddress,
                            style: theme.textTheme.bodyMedium!.copyWith(color: Colors.grey.shade600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${shipment.originCoordinates.latitude.toStringAsFixed(4)}, ${shipment.originCoordinates.longitude.toStringAsFixed(4)}',
                            style: theme.textTheme.bodySmall!.copyWith(color: Colors.grey.shade500),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${shipment.destinationCoordinates.latitude.toStringAsFixed(4)}, ${shipment.destinationCoordinates.longitude.toStringAsFixed(4)}',
                            style: theme.textTheme.bodySmall!.copyWith(color: Colors.grey.shade500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.access_time, color: Colors.blue.shade700, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Estimated Travel Time: ${RouteService.getEstimatedTime(shipment.originCoordinates, shipment.destinationCoordinates)}',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            _SectionDivider(title: 'Route Map'),
            _AnimatedCard(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue.shade100, width: 2),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade50,
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ShipmentMapWidget(shipment: shipment),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    bool isCompleted,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(
            icon,
            color: isCompleted ? color : Colors.grey.shade400,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isCompleted ? Colors.black : Colors.grey.shade400,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isCompleted ? Colors.grey.shade600 : Colors.grey.shade400,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  final String title;
  const _SectionDivider({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Colors.blue.shade100,
              thickness: 1.2,
              endIndent: 8,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              letterSpacing: 0.5,
            ),
          ),
          Expanded(
            child: Divider(
              color: Colors.blue.shade100,
              thickness: 1.2,
              indent: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedCard extends StatelessWidget {
  final Widget child;
  const _AnimatedCard({required this.child});
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.85, end: 1),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
} 