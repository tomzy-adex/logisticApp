import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../providers/shipment_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/common_widgets.dart' as common;
import '../../core/models/shipment.dart';
import 'shipment_detail_screen.dart';

class ShipmentsScreen extends StatefulWidget {
  const ShipmentsScreen({Key? key}) : super(key: key);

  @override
  State<ShipmentsScreen> createState() => _ShipmentsScreenState();
}

class _ShipmentsScreenState extends State<ShipmentsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ShipmentProvider>(context, listen: false).loadShipments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer2<ShipmentProvider, AuthProvider>(
      builder: (context, shipmentProvider, authProvider, child) {
        if (shipmentProvider.isLoading) {
          return const common.LoadingWidget(message: 'Loading shipments...');
        }

        if (shipmentProvider.error != null) {
          return common.ErrorWidget(
            message: shipmentProvider.error!,
            onRetry: () => shipmentProvider.loadShipments(),
          );
        }

        final shipments = shipmentProvider.filteredShipments;

        if (shipments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No shipments found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  authProvider.isAdmin
                      ? 'No shipments have been created yet'
                      : 'You haven\'t created any shipments yet',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => shipmentProvider.loadShipments(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: shipments.length,
            itemBuilder: (context, index) {
              final shipment = shipments[index];
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.92, end: 1),
                duration: Duration(milliseconds: 350 + index * 40),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ShipmentDetailScreen(shipment: shipment),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      shipment.trackingNumber,
                                      style: theme.textTheme.titleMedium!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade800,
                                        letterSpacing: 1.1,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.copy, size: 18, color: Colors.blue),
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
                              ),
                              common.StatusChip(status: shipment.status),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.blue.shade50,
                                child: Text(
                                  shipment.senderName.substring(0, 1).toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  shipment.senderName,
                                  style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Icon(Icons.arrow_forward, color: Colors.blue, size: 18),
                              const SizedBox(width: 8),
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.pink.shade50,
                                child: Text(
                                  shipment.receiverName.substring(0, 1).toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.pink.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  shipment.receiverName,
                                  style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 16, color: Colors.green),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  shipment.originAddress,
                                  style: theme.textTheme.bodySmall!.copyWith(color: Colors.grey.shade600),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.flag, size: 16, color: Colors.red),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  shipment.destinationAddress,
                                  style: theme.textTheme.bodySmall!.copyWith(color: Colors.grey.shade600),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                'Created: ${DateFormat('MMM dd, yyyy').format(shipment.createdAt)}',
                                style: theme.textTheme.bodySmall!.copyWith(color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
} 