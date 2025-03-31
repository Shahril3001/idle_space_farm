import 'package:flutter/material.dart';
import '../main.dart';
import 'battlemap_page.dart';
import 'codex_page_girl.dart';
import 'gacha_page.dart';

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
              child: _buildTopButtons(context), // Pass context for navigation
            ),
            // Bottom buttons row
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: _buildBottomButtonRow(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtonRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCodexButton(context),
          _buildCenterButton(context),
          _buildRightButton(context),
        ],
      ),
    );
  }

  Widget _buildCodexButton(BuildContext context) {
    return _buildIconButton(
      'assets/images/icons/summon.png',
      'Summon',
      () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) =>
                GachaMainPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildRightButton(BuildContext context) {
    return _buildIconButton(
      'assets/images/icons/inventory.png',
      'Inventory',
      () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) =>
                MapScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCenterButton(BuildContext context) {
    return Container(
      width: 180, // Wider than other buttons
      height: 80, // Same height as others
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  MapScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0, 0.5),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black.withOpacity(0.8),
          padding: EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image:
                  ImageCacheManager.getImage('assets/images/icons/battle.png'),
              width: 30,
              height: 30,
            ),
            SizedBox(width: 8),
            Text(
              'Battle',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopButtons(BuildContext context) {
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
            _buildIconButton('assets/images/icons/codex.png', 'Codex', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GirlCodexPage()));
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: ImageCacheManager.getImage(iconPath),
            width: 30,
            height: 30,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
