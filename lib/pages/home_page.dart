import 'package:flutter/material.dart';
import 'package:idle_space_farm/pages/map_page.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'exchange_page.dart';
import 'farm_page.dart';
import 'gacha_page.dart';
import 'girl_list_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    GachaMainPage(),
    ManageGirlListPage(),
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
    return Scaffold(
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          if (!gameProvider.isInitialized) {
            return Center(child: CircularProgressIndicator());
          }

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.deepPurple, Colors.purpleAccent],
              ),
            ),
            child: Column(
              children: [
                // Display Resources at the top
                _buildResourceDisplay(gameProvider),

                // Display the selected page
                Expanded(
                  child: _pages[_selectedIndex],
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: 'Gacha',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: 'Girl List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.agriculture),
            label: 'Farm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Exchange',
          ),
        ],
      ),
    );
  }

  /// Builds the resource display
  Widget _buildResourceDisplay(GameProvider gameProvider) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _compactResourceCard(
                Icons.monetization_on, gameProvider.getCredits()),
            _compactResourceCard(Icons.landscape, gameProvider.getMinerals()),
            _compactResourceCard(Icons.flash_on, gameProvider.getEnergy()),
          ],
        ),
      ),
    );
  }

  /// Builds an individual compact resource card
  Widget _compactResourceCard(IconData icon, double amount) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.all(2),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: Colors.deepPurple, // Set icon color to deepPurple
            ),
            SizedBox(width: 4),
            Text(
              amount.toStringAsFixed(2),
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
