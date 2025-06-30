import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/shipment_provider.dart';
import 'shipments_screen.dart';
import 'create_shipment_screen.dart';
import 'track_shipment_screen.dart';
import 'logs_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ShipmentProvider>(context, listen: false).loadShipments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final isAdmin = authProvider.isAdmin;
        
        final List<Widget> screens = [
          const ShipmentsScreen(),
          const CreateShipmentScreen(),
          const TrackShipmentScreen(),
          if (isAdmin) const LogsScreen(),
        ];

        final List<BottomNavigationBarItem> items = [
          const BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Shipments',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Create',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Track',
          ),
          if (isAdmin)
            const BottomNavigationBarItem(
              icon: Icon(Icons.analytics),
              label: 'Logs',
            ),
        ];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Lagos Logistics'),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'logout') {
                    await authProvider.logout();
                    if (mounted) {
                      Navigator.of(context).pushReplacementNamed('/login');
                    }
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: const [
                        Icon(Icons.logout, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Logout'),
                      ],
                    ),
                  ),
                ],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: Text(
                          authProvider.user?.name.substring(0, 1).toUpperCase() ?? 'U',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        authProvider.user?.name ?? 'User',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
          body: IndexedStack(
            index: _currentIndex,
            children: screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            items: items,
          ),
        );
      },
    );
  }
} 