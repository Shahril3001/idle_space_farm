import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'daily_reward_page.dart';
import 'inventory_page.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../providers/game_provider.dart';
import 'battlemap_page.dart';
import 'codex_page_girl.dart';
import 'gacha_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late AudioPlayer _audioPlayer;
  bool _isMusicPlaying = true;

  @override
  void initState() {
    super.initState();
    _audioPlayer = Provider.of<AudioPlayer>(context, listen: false);
    _playBackgroundMusic();
  }

  Future<void> _playBackgroundMusic() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource('audios/mp3/main_audio.mp3'));
      setState(() => _isMusicPlaying = true);
    } catch (e) {
      debugPrint('Error playing background music: $e');
    }
  }

  Future<void> _toggleMusic() async {
    if (_isMusicPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    setState(() => _isMusicPlaying = !_isMusicPlaying);
  }

  @override
  void dispose() {
    // Don't dispose the audio player here since it's managed globally
    super.dispose();
  }

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
                padding: EdgeInsets.only(bottom: 10),
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
          _buildSummonButton(context),
          _buildCenterButton(context),
          _buildRightButton(context),
        ],
      ),
    );
  }

  Widget _buildSummonButton(BuildContext context) {
    return _buildIconButton(
      'assets/images/icons/nav-summon.png',
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
      'assets/images/icons/nav-inventory.png',
      'Inventory',
      () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) =>
                InventoryPage(),
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
      width: 200,
      height: 62,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFA12626), //Top color
            const Color(0xFF380A0A), // Dark red at bottom
          ],
        ),
        border: Border.all(
          color: Color(0xFF742C2C), // Gold border color
          width: 1, // Border width
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          _showAdventurePopup(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Make button transparent
          shadowColor: Colors.transparent, // Remove default shadow
          padding: EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: ImageCacheManager.getImage(
                  'assets/images/icons/nav-battle.png'),
              width: 35,
              height: 35,
            ),
            SizedBox(width: 8),
            Text(
              'BATTLE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
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
        padding: const EdgeInsets.only(top: 5.0),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly, // Evenly spaced buttons
          children: [
            _buildIconButton(
                'assets/images/icons/nav-achievements.png', 'Milestone', () {
              print('Dungeon pressed');
            }),
            _buildIconButton('assets/images/icons/nav-reward.png', 'Reward',
                () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 500),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      DailyRewardPage(),
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
            }),
            _buildIconButton('assets/images/icons/nav-codex.png', 'Codex', () {
              _showCodexPopup(context);
            }),
            _buildIconButton('assets/images/icons/nav-settings.png', 'Setting',
                () {
              _showSettingsPopup(context);
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
        minimumSize: Size(65, 65),
        fixedSize: Size(65, 65),
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
            width: 35,
            height: 35,
          ),
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

  // Inside DashboardPage class
  void _showSettingsPopup(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey,
                width: 2.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title with minimal padding
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Game Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                Divider(color: Colors.grey),
                _buildSettingsButton(
                  icon: Icons.music_note,
                  label: 'Music',
                  onPressed:
                      () {}, // Empty callback, handled in _buildSettingsButton
                ),
                // Save Management Section
                _buildSettingsButton(
                  icon: Icons.save,
                  label: 'Save Game',
                  onPressed: () async {
                    Navigator.pop(context);
                    final success = await gameProvider.saveGame();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success
                            ? 'Game saved successfully'
                            : 'Failed to save game'),
                        backgroundColor: success ? Colors.green : Colors.red,
                      ),
                    );
                  },
                ),

                _buildSettingsButton(
                  icon: Icons.upload,
                  label: 'Load Game',
                  onPressed: () async {
                    Navigator.pop(context);
                    final success = await gameProvider.loadGame();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success
                            ? 'Game loaded successfully'
                            : 'No save file found or error loading'),
                        backgroundColor: success ? Colors.green : Colors.red,
                      ),
                    );
                  },
                ),

                _buildSettingsButton(
                  icon: Icons.delete,
                  label: 'Delete Save',
                  onPressed: () {
                    Navigator.pop(context);
                    _showDeleteConfirmation(context);
                  },
                ),

                Divider(color: Colors.grey),

                // Resource Management Section
                _buildSettingsButton(
                  icon: Icons.restart_alt,
                  label: 'Reset Resources',
                  onPressed: () {
                    Navigator.pop(context);
                    _showResetConfirmation(context, gameProvider);
                  },
                ),

                _buildSettingsButton(
                  icon: Icons.warning,
                  label: 'Reset All Game Data',
                  onPressed: () {
                    Navigator.pop(context);
                    _showFullResetConfirmation(context, gameProvider);
                  },
                ),

                SizedBox(height: 8),

                // Close button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.7),
                  ),
                  child: Text(
                    'Close',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          title: Text(
            'Delete Save File',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to delete your save file? This cannot be undone.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.pop(context);
                final success = await gameProvider.deleteSave();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success
                        ? 'Save file deleted'
                        : 'Error deleting save file'),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingsButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    if (label == 'Music') {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: ElevatedButton.icon(
          icon: Icon(icon, color: Colors.white),
          label: Text(
            '$label ${_isMusicPlaying ? 'ON' : 'OFF'}',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: _toggleMusic,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black.withOpacity(0.5),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            alignment: Alignment.centerLeft,
          ),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black.withOpacity(0.5),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }

  void _showResetConfirmation(BuildContext context, GameProvider gameProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          title: Text(
            'Reset Resources',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'This will set all resources (Energy, Minerals, Credits) to zero. Continue?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Reset', style: TextStyle(color: Colors.orange)),
              onPressed: () {
                gameProvider.resetResources();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Resources reset to zero')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showFullResetConfirmation(
      BuildContext context, GameProvider gameProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          title: Text(
            'Reset All Game Data',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'This will reset ALL game data including resources, girls, and progress. Continue?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Reset All', style: TextStyle(color: Colors.red)),
              onPressed: () {
                gameProvider.resetAllGameData();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('All game data has been reset')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // In your DashboardPage class
  void _showCodexPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey,
                width: 2.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Codex',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                Divider(color: Colors.grey),

                // Codex Buttons Grid
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: [
                    _buildCodexButton(
                      context,
                      icon: Icons.people,
                      label: 'Girls',
                      page: GirlCodexPage(), // Your existing page
                    ),
                    _buildCodexButton(
                      context,
                      icon: Icons.dangerous,
                      label: 'Enemies',
                      page: GirlCodexPage(), // You'll need to create this
                    ),
                    _buildCodexButton(
                      context,
                      icon: Icons.auto_awesome,
                      label: 'Abilities',
                      page: GirlCodexPage(),
                    ),
                    _buildCodexButton(
                      context,
                      icon: Icons.gamepad,
                      label: 'Gameplay',
                      page: GirlCodexPage(),
                    ),
                    _buildCodexButton(
                      context,
                      icon: Icons.shield,
                      label: 'Equipment',
                      page: GirlCodexPage(),
                    ),
                    _buildCodexButton(
                      context,
                      icon: Icons.inventory,
                      label: 'Items',
                      page: GirlCodexPage(),
                    ),
                    _buildCodexButton(
                      context,
                      icon: Icons.currency_exchange,
                      label: 'Resources',
                      page: GirlCodexPage(),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Close button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.7),
                  ),
                  child: Text(
                    'Close',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCodexButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Widget page,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        Navigator.pop(context); // Close codex dialog
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black.withOpacity(0.5),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        alignment: Alignment.centerLeft,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showAdventurePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey,
                width: 2.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Battle',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                Divider(color: Colors.grey),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 1, // Single column
                  childAspectRatio: 4, // Wider buttons
                  mainAxisSpacing: 8,
                  children: [
                    _buildAdventureButtonRow(
                      iconPath: 'assets/images/icons/battle-dungeon.png',
                      label: 'Dungeon Invasion',
                      onPressed: () => _navigateTo(context, MapScreen()),
                    ),
                    _buildAdventureButtonRow(
                      iconPath: 'assets/images/icons/battle-girl.png',
                      label: 'Champion Arena',
                      onPressed: () => _navigateTo(context, MapScreen()),
                    ),
                    _buildAdventureButtonRow(
                      iconPath: 'assets/images/icons/battle-boss.png',
                      label: 'Boss Raid',
                      onPressed: () => _navigateTo(context, MapScreen()),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

// Helper method for navigation
  void _navigateTo(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

// Modified button builder with icon and text in a row
  Widget _buildAdventureButtonRow({
    required String iconPath,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black.withOpacity(0.5),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.withOpacity(0.5)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: ImageCacheManager.getImage(iconPath),
            width: 40,
            height: 40,
          ),
          SizedBox(width: 12), // Space between icon and text
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
