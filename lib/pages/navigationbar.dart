import 'package:flutter/material.dart';
import 'package:idle_space_farm/pages/map_page.dart';
import 'package:provider/provider.dart';
import '../data/resource_data.dart';
import '../providers/game_provider.dart';
import 'exchange_page.dart';
import 'girl_list_page.dart';
import 'dashboard_page.dart';
import 'shop_page.dart'; // Import the DashboardPage
import 'dart:async'; // Add this for Timer
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;
  DateTime? _lastBackPressed;
  Timer? _dialogTimer;

  final List<Widget> _pages = [
    TransactionExchangePage(),
    ManageGirlListPage(),
    DashboardPage(),
    MapPage(),
    ShopScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  @override
  void dispose() {
    _dialogTimer?.cancel();
    super.dispose();
  }

  Future<void> _initializeGame() async {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    await gameProvider.onAppStart();
  }

  Future<bool> _onWillPop() async {
    final now = DateTime.now();

    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > Duration(seconds: 2)) {
      _lastBackPressed = now;

      _dialogTimer?.cancel();
      _showExitDialog();
      return false;
    }

    // Clear the dialog if still showing
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    return true;
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        _dialogTimer = Timer(Duration(seconds: 2), () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        });

        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Colors.amberAccent, width: 2),
          ),
          title: Row(
            children: [
              Icon(Icons.exit_to_app, color: Colors.amberAccent),
              SizedBox(width: 10),
              Text("Exit Game?", style: TextStyle(color: Colors.white)),
            ],
          ),
          content: Text("Press back again to exit",
              style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () {
                _dialogTimer?.cancel();
                Navigator.of(context).pop();
              },
              child: Text("CANCEL", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                _dialogTimer?.cancel();
                Navigator.of(context).pop();
                SystemNavigator.pop(); // Force exit the app
              },
              child: Text("EXIT", style: TextStyle(color: Colors.amberAccent)),
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
        onWillPop: _onWillPop,
        child: SafeArea(
            child: Scaffold(
          body: Consumer<GameProvider>(
            builder: (context, gameProvider, child) {
              if (!gameProvider.isInitialized) {
                return Center(child: CircularProgressIndicator());
              }

              return Column(
                children: [
                  _buildResourceDisplay(gameProvider),
                  Expanded(
                    child: _pages[_selectedIndex],
                  ),
                ],
              );
            },
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.9),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.amberAccent,
                unselectedItemColor: Colors.grey,
                selectedIconTheme: IconThemeData(size: 35),
                unselectedIconTheme: IconThemeData(size: 30),
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: _buildBottomNavIcon(
                      'assets/images/icons/nav-exchange.png',
                      _selectedIndex == 0, // Check if this item is selected
                    ),
                    label: 'Exchange',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildBottomNavIcon(
                      'assets/images/icons/nav-barrack.png',
                      _selectedIndex == 1, // Check if this item is selected
                    ),
                    label: 'Barrack',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildBottomNavIcon(
                      'assets/images/icons/nav-adventure.png',
                      _selectedIndex == 2, // Check if this item is selected
                    ),
                    label: 'Castle',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildBottomNavIcon(
                      'assets/images/icons/nav-farm.png',
                      _selectedIndex == 3, // Check if this item is selected
                    ),
                    label: 'Mine',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildBottomNavIcon(
                      'assets/images/icons/nav-shop.png',
                      _selectedIndex == 4, // Check if this item is selected
                    ),
                    label: 'Shop',
                  ),
                ],
              ),
            ),
          ),
        )));
  }

  Widget _buildBottomNavIcon(String iconPath, bool isSelected) {
    return Container(
      padding: EdgeInsets.all(8), // Add padding for the background
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.amberAccent.withOpacity(0.2)
            : Colors.transparent,
        borderRadius:
            BorderRadius.circular(10), // Rounded corners for the background
      ),
      child: Image.asset(
        iconPath,
        width:
            isSelected ? 35 : 30, // Zoom effect: larger size for selected icon
        height: isSelected ? 35 : 30, // Change icon color if selected
      ),
    );
  }

  Widget _buildResourceDisplay(GameProvider gameProvider) {
    // Define which resources to display
    final resourcesToShow = ['Gold', 'Stamina', 'Gem'];

    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: resourcesToShow.map((resourceName) {
            // Get the resource data from provider
            final resource = gameProvider.getResourceByName(resourceName);
            final amount = resource?.amount ?? 0.0;

            return _ResourceItem(
              resourceName: resourceName,
              amount: amount,
            );
          }).toList(),
        ),
      ),
    );
  }
}

String _formatAmount(double amount) {
  if (amount >= 1000000) {
    return '${(amount / 1000000).toStringAsFixed(1)}M';
  } else if (amount >= 1000) {
    return '${(amount / 1000).toStringAsFixed(1)}K';
  }
  return amount.toStringAsFixed(0);
}

// New reusable widget for resource items
class _ResourceItem extends StatelessWidget {
  final String resourceName;
  final double amount;

  const _ResourceItem({
    required this.resourceName,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    // Get the resource config (image path and color)
    final config = ResourceData.getConfig(resourceName);

    return Row(
      children: [
        Image.asset(
          config?.imagePath ?? 'assets/images/resources/default.png',
          width: 20,
          height: 20,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.monetization_on,
            size: 24,
            color: config?.color ?? Colors.grey,
          ),
        ),
        SizedBox(width: 4),
        Text(
          _formatAmount(amount),
          style: TextStyle(
            color: config?.color ?? Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
