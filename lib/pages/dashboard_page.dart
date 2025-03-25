import 'package:flutter/material.dart';
import '../main.dart';
import 'battlemap_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No AppBar
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ImageCacheManager.getImage('assets/images/ui/castle.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Your main content here (e.g., background, character, UI elements)

            Align(
              alignment: Alignment.bottomCenter, // Align buttons to the bottom
              child:
                  _buildBottomButtons(context), // Pass context for navigation
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly, // Evenly spaced buttons
          children: [
            _buildIconButton(
                'assets/images/icons/achievements.png', 'Milestone', () {
              print('Dungeon pressed');
            }),
            _buildIconButton('assets/images/icons/reward.png', 'Reward', () {
              print('Dungeon pressed');
            }),
            _buildIconButton('assets/images/icons/battle.png', 'Dungeon', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MapScreen()));
            }),
            _buildIconButton('assets/images/icons/settings.png', 'Setting', () {
              print('Dungeon pressed');
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(
      String iconPath, String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black.withOpacity(0.8),
        padding: EdgeInsets.zero,
        minimumSize: Size(80, 80),
        fixedSize: Size(80, 80),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(
              image: ImageCacheManager.getImage(iconPath),
              width: 30,
              height: 30),
          SizedBox(height: 2),
          Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}
