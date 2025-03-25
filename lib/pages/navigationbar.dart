import 'package:flutter/material.dart';
import 'package:idle_space_farm/pages/map_page.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'exchange_page.dart';
import 'farm_page.dart';
import 'gacha_page.dart';
import 'girl_list_page.dart';
import 'dashboard_page.dart'; // Import the DashboardPage

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2; // Set default index to 0 (DashboardPage)

  final List<Widget> _pages = [
    GachaMainPage(),
    ManageGirlListPage(),
    DashboardPage(),
    MapPage(),
    TransactionExchangePage(),
  ];

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    await gameProvider.onAppStart();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          if (!gameProvider.isInitialized) {
            return Center(child: CircularProgressIndicator());
          }

          return Container(
            child: Column(
              children: [
                _buildResourceDisplay(gameProvider),
                Expanded(
                  child: _pages[_selectedIndex], // Display the selected page
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
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
            selectedIconTheme:
                IconThemeData(size: 35), // Zoom effect for selected icon
            unselectedIconTheme:
                IconThemeData(size: 30), // Default size for unselected icons
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: _buildBottomNavIcon(
                  'assets/images/icons/summon.png',
                  _selectedIndex == 0, // Check if this item is selected
                ),
                label: 'Summon',
              ),
              BottomNavigationBarItem(
                icon: _buildBottomNavIcon(
                  'assets/images/icons/valkyrie.png',
                  _selectedIndex == 1, // Check if this item is selected
                ),
                label: 'Girl',
              ),
              BottomNavigationBarItem(
                icon: _buildBottomNavIcon(
                  'assets/images/icons/adventure.png',
                  _selectedIndex == 2, // Check if this item is selected
                ),
                label: 'Castle',
              ),
              BottomNavigationBarItem(
                icon: _buildBottomNavIcon(
                  'assets/images/icons/farm.png',
                  _selectedIndex == 3, // Check if this item is selected
                ),
                label: 'Map',
              ),
              BottomNavigationBarItem(
                icon: _buildBottomNavIcon(
                  'assets/images/icons/shop.png',
                  _selectedIndex == 4, // Check if this item is selected
                ),
                label: 'Shop',
              ),
            ],
          ),
        ),
      ),
    ));
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
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _resourceText(
              Image.asset('assets/images/icons/golds.png',
                  width: 24, height: 24),
              "",
              gameProvider.getCredits(),
              Colors.amberAccent,
            ),
            _resourceText(
              Image.asset('assets/images/icons/minerals.png',
                  width: 24, height: 24),
              "",
              gameProvider.getMinerals(),
              Colors.cyan,
            ),
            _resourceText(
              Image.asset('assets/images/icons/mana.png',
                  width: 24, height: 24),
              "",
              gameProvider.getEnergy(),
              Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _resourceText(Widget icon, String label, double value, Color color) {
    return Row(
      children: [
        icon, // Accepts any widget (Icon or Image)
        SizedBox(width: 4),
        Text(
          "$label: ${value.toStringAsFixed(0)}",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
