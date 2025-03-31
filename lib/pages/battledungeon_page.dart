import 'package:flutter/material.dart';
import '../main.dart';
import 'battlepreparation_page.dart';

class DungeonScreen extends StatelessWidget {
  final List<String> difficulties = ["Easy", "Medium", "Hard"];
  final String dungeonName;
  final String difficulty;
  final int minLevel;
  final int maxLevel;
  final String region;

  DungeonScreen({
    required this.dungeonName,
    required this.difficulty,
    required this.minLevel,
    required this.maxLevel,
    required this.region,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: dungeonName,
          height: 40,
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ImageCacheManager.getImage('assets/images/ui/mine.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              // Spacer to push content to center
              Spacer(),

              // Main Content Card
              Card(
                margin: EdgeInsets.symmetric(horizontal: 20),
                elevation: 8,
                color: Colors.black.withOpacity(0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Dungeon Details Button
                      Container(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _showDungeonInfo(context),
                          icon: Icon(Icons.info_outline),
                          label: Text("Dungeon Details"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple.shade200,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),

                      SizedBox(height: 30),

                      Text(
                        "SELECT DIFFICULTY",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Divider(color: Colors.white54),
                      SizedBox(height: 10),

                      // Difficulty Buttons
                      Column(
                        children: difficulties
                            .map(
                              (difficulty) => Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child:
                                    _buildDifficultyButton(context, difficulty),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),

              // Spacer to push content to center
              Spacer(),

              // Back Button
              _buildBackButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(BuildContext context, String difficulty) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: _getDifficultyColor(difficulty).withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  PreparationScreen(
                difficulty: difficulty,
                dungeonLevel: minLevel,
                region: region,
              ),
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
          backgroundColor: _getDifficultyColor(difficulty),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Container(
          width: double.infinity, // Make container fill the button width
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Center horizontally
            crossAxisAlignment: CrossAxisAlignment.center, // Center vertically
            children: [
              Container(
                width: 50, // Fixed width for the icon container
                height: 50, // Fixed height for the icon container
                alignment: Alignment.center,
                child: Image.asset(
                  _getDifficultyImagePath(difficulty),
                  width: 50,
                  height: 50,
                ),
              ),
              SizedBox(width: 15), // Consistent spacing
              Text(
                difficulty.toUpperCase(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.3),
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      margin: EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        // ignore: sort_child_properties_last
        child: Text(
          "Back",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'GameFont',
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  void _showDungeonInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Dungeon Information"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.deepPurple),
                SizedBox(width: 8),
                Text(
                  "Region: $region",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.stairs, color: Colors.deepPurple),
                SizedBox(width: 8),
                Text(
                  "Levels: $minLevel - $maxLevel",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.star, color: Colors.deepPurple),
                SizedBox(width: 8),
                Text(
                  "Difficulty: $difficulty",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Explore this dungeon and face challenging enemies!",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "Rewards increase with difficulty level.",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case "Easy":
        return Color(0xFFCAA04D);
      case "Medium":
        return Color(0xFFCAA04D);
      case "Hard":
        return Color(0xFFCAA04D);
      default:
        return Color(0xFFCAA04D);
    }
  }

  // New method to get image path based on difficulty
  String _getDifficultyImagePath(String difficulty) {
    switch (difficulty) {
      case "Easy":
        return "assets/images/icons/easy.png";
      case "Medium":
        return "assets/images/icons/medium.png";
      case "Hard":
        return "assets/images/icons/hard.png";
      default:
        return "assets/images/icons/easy.png";
    }
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.height = 56.0,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/ui/wood-ui.png"),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'GameFont',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black,
                blurRadius: 4,
                offset: Offset(1, 1),
              )
            ],
          ),
        ),
      ),
    );
  }
}
