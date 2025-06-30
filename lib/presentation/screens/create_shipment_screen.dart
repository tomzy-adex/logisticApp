import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shipment_provider.dart';
import '../widgets/common_widgets.dart';

class CreateShipmentScreen extends StatefulWidget {
  const CreateShipmentScreen({Key? key}) : super(key: key);

  @override
  State<CreateShipmentScreen> createState() => _CreateShipmentScreenState();
}

class _CreateShipmentScreenState extends State<CreateShipmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _senderNameController = TextEditingController();
  final _receiverNameController = TextEditingController();
  final _originAddressController = TextEditingController();
  final _destinationAddressController = TextEditingController();

  @override
  void dispose() {
    _senderNameController.dispose();
    _receiverNameController.dispose();
    _originAddressController.dispose();
    _destinationAddressController.dispose();
    super.dispose();
  }

  Future<void> _createShipment() async {
    if (_formKey.currentState!.validate()) {
      final shipmentProvider = Provider.of<ShipmentProvider>(context, listen: false);
      final success = await shipmentProvider.createShipment(
        senderName: _senderNameController.text.trim(),
        receiverName: _receiverNameController.text.trim(),
        originAddress: _originAddressController.text.trim(),
        destinationAddress: _destinationAddressController.text.trim(),
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Shipment created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        _formKey.currentState!.reset();
        _senderNameController.clear();
        _receiverNameController.clear();
        _originAddressController.clear();
        _destinationAddressController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Consumer<ShipmentProvider>(
        builder: (context, shipmentProvider, child) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: const Icon(
                            Icons.add_circle,
                            color: Colors.blue,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          'Create New Shipment',
                          style: theme.textTheme.headlineSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Fill in the details below to create a new shipment',
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CustomTextField(
                                label: 'Sender Name',
                                hint: 'Enter sender\'s full name',
                                controller: _senderNameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter sender name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),
                              CustomTextField(
                                label: 'Receiver Name',
                                hint: 'Enter receiver\'s full name',
                                controller: _receiverNameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter receiver name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),
                              CustomTextField(
                                label: 'Origin Address',
                                hint: 'e.g., Victoria Island, Lagos, Nigeria',
                                controller: _originAddressController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter origin address';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),
                              CustomTextField(
                                label: 'Destination Address',
                                hint: 'e.g., Ikeja, Lagos, Nigeria',
                                controller: _destinationAddressController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter destination address';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.blue.shade100),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Lagos Area Tips',
                                          style: TextStyle(
                                            color: Colors.blue.shade700,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '• Popular areas: Victoria Island, Ikeja, Lekki, Surulere, Yaba\n'
                                      '• Include area name and "Lagos, Nigeria" for better accuracy\n'
                                      '• Coordinates will be automatically generated',
                                      style: TextStyle(
                                        color: Colors.blue.shade700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 18),
                              if (shipmentProvider.error != null)
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.red.shade200),
                                  ),
                                  child: Text(
                                    shipmentProvider.error!,
                                    style: TextStyle(
                                      color: Colors.red.shade700,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              if (shipmentProvider.error != null)
                                const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.local_shipping),
                                  label: const Text('Create Shipment', style: TextStyle(fontWeight: FontWeight.bold)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade700,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    textStyle: const TextStyle(fontSize: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: shipmentProvider.isLoading ? null : _createShipment,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 