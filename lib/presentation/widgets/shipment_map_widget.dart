import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/models/shipment.dart';
import '../../core/services/route_service.dart';

class ShipmentMapWidget extends StatefulWidget {
  final Shipment? shipment;

  const ShipmentMapWidget({Key? key, this.shipment}) : super(key: key);

  @override
  State<ShipmentMapWidget> createState() => _ShipmentMapWidgetState();
}

class _ShipmentMapWidgetState extends State<ShipmentMapWidget> {
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void didUpdateWidget(ShipmentMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.shipment != widget.shipment) {
      _initializeMap();
    }
  }

  void _initializeMap() {
    if (widget.shipment == null) return;

    final shipment = widget.shipment!;
    
    // Create markers for origin and destination only
    _markers = {
      Marker(
        markerId: const MarkerId('origin'),
        position: shipment.originCoordinates,
        infoWindow: InfoWindow(
          title: 'Origin',
          snippet: shipment.originAddress,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: const MarkerId('destination'),
        position: shipment.destinationCoordinates,
        infoWindow: InfoWindow(
          title: 'Destination',
          snippet: shipment.destinationAddress,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };

    // Create route polyline from origin to destination
    final routePoints = RouteService.generateRouteWaypoints(
      shipment.originCoordinates,
      shipment.destinationCoordinates,
    );

    _polylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        points: routePoints,
        color: Colors.blue,
        width: 4,
        geodesic: true,
      ),
    };

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.shipment == null) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.map, size: 48, color: Colors.grey),
              SizedBox(height: 8),
              Text(
                'No shipment selected',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: widget.shipment?.originCoordinates ?? 
                   const LatLng(6.5244, 3.3792), // Lagos Island as default
            zoom: 12.0,
          ),
          markers: _markers,
          polylines: _polylines,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            // Fit bounds to show both origin and destination
            if (widget.shipment != null) {
              final shipment = widget.shipment!;
              final bounds = LatLngBounds(
                southwest: LatLng(
                  shipment.originCoordinates.latitude < shipment.destinationCoordinates.latitude
                      ? shipment.originCoordinates.latitude
                      : shipment.destinationCoordinates.latitude,
                  shipment.originCoordinates.longitude < shipment.destinationCoordinates.longitude
                      ? shipment.originCoordinates.longitude
                      : shipment.destinationCoordinates.longitude,
                ),
                northeast: LatLng(
                  shipment.originCoordinates.latitude > shipment.destinationCoordinates.latitude
                      ? shipment.originCoordinates.latitude
                      : shipment.destinationCoordinates.latitude,
                  shipment.originCoordinates.longitude > shipment.destinationCoordinates.longitude
                      ? shipment.originCoordinates.longitude
                      : shipment.destinationCoordinates.longitude,
                ),
              );
              controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
            }
          },
        ),
      ),
    );
  }
} 