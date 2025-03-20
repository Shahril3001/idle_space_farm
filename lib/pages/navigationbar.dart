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
            child: Column(
              children: [
                _buildResourceDisplay(gameProvider),
                Expanded(
                  child: _pages[_selectedIndex],
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
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
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/icons/summon.png',
                  width: 30,
                  height: 30,
                ),
                label: 'Summon',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/icons/valkyrie.png',
                  width: 30,
                  height: 30,
                ),
                label: 'Valkyrie',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/icons/farm.png',
                  width: 30,
                  height: 30,
                ),
                label: 'Map',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/icons/shop.png',
                  width: 30,
                  height: 30,
                ),
                label: 'Shop',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResourceDisplay(GameProvider gameProvider) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _resourceText(Icons.monetization_on, "", gameProvider.getCredits(),
                Colors.amberAccent),
            _resourceText(
                Icons.landscape, "", gameProvider.getMinerals(), Colors.cyan),
            _resourceText(
                Icons.flash_on, "", gameProvider.getEnergy(), Colors.redAccent),
          ],
        ),
      ),
    );
  }

  Widget _resourceText(IconData icon, String label, double value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
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
