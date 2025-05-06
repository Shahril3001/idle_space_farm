import 'package:flutter/material.dart';
import '../main.dart';
import 'battlepreparation_page_invasion.dart';

class MapScreen extends StatelessWidget {
  // Sample dungeon data
  final List<Map<String, dynamic>> dungeons = [
    {
      'name': 'Forest Dungeon',
      'image': 'assets/images/dungeons/dungeon001.png',
      'level': '1-5',
      'monstertype': 'Forest',
      'region': 'Forest',
      'difficulty': 'Easy',
      'color': Colors.green,
    },
    {
      'name': 'Cave of Shadows',
      'image': 'assets/images/dungeons/dungeon002.png',
      'level': '5-10',
      'monstertype': 'Mountain',
      'region': 'Mountain',
      'difficulty': 'Medium',
      'color': Colors.blue,
    },
    {
      'name': 'Tomb of the Dead',
      'image': 'assets/images/dungeons/dungeon006.png',
      'level': '5-10',
      'monstertype': 'Undead',
      'region': 'Mountain',
      'difficulty': 'Medium',
      'color': Colors.yellow,
    },
    {
      'name': 'Sunken Ruin',
      'image': 'assets/images/dungeons/dungeon005.png',
      'level': '10-15',
      'monstertype': 'Sunken',
      'region': 'Sunken',
      'difficulty': 'Hard',
      'color': Colors.blueGrey,
    },
    {
      'name': 'Volcanic Core',
      'image': 'assets/images/dungeons/dungeon003.png',
      'level': '10-15',
      'monstertype': 'Volcanic',
      'region': 'Ruins',
      'difficulty': 'Hard',
      'color': Colors.red,
    },
    {
      'name': 'Eternal Void',
      'image': 'assets/images/dungeons/dungeon004.png',
      'level': '15-20',
      'monstertype': 'Void',
      'region': 'Void',
      'difficulty': 'Very Hard',
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'World Map',
          height: 40,
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image:
                  ImageCacheManager.getImage('assets/images/ui/battle-bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Content (Dungeon Cards)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: dungeons.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildDungeonCard(context, dungeons[index]),
                      );
                    },
                  ),
                ),
              ),
              // Back Button (Bottom of the Screen)
              _buildBackButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDungeonCard(BuildContext context, Map<String, dynamic> dungeon) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showDungeonDialog(context, dungeon),
        child: Container(
          height: 180, // Fixed height for list items
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: dungeon['color'].withOpacity(0.5),
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // Dungeon Image
                Positioned.fill(
                  child: Image.asset(
                    dungeon['image'],
                    fit: BoxFit.cover,
                  ),
                ),

                // Gradient Overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.8),
                        ],
                        stops: [0.5, 1.0],
                      ),
                    ),
                  ),
                ),

                // Dungeon Info
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dungeon['name'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                blurRadius: 4,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.star, size: 16, color: dungeon['color']),
                            SizedBox(width: 6),
                            Text(
                              'Lv. ${dungeon['level']}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: dungeon['color'].withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: dungeon['color'], width: 1),
                              ),
                              child: Text(
                                dungeon['difficulty'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDungeonDialog(BuildContext context, Map<String, dynamic> dungeon) {
    final region = dungeon['region'] as String? ?? 'DefaultRegion';
    final minLevel = int.parse(dungeon['level'].split('-')[0]);
    final maxLevel = int.parse(dungeon['level'].split('-')[1]);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(
            color: dungeon['color'].withOpacity(0.5),
            width: 2,
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Dungeon name and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dungeon['name'],
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            Divider(color: Colors.white54),

            // Dungeon info section
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildInfoRow(
                      Image.asset('assets/images/icons/battle-region.png'),
                      "Region: $region",
                    ),
                    _buildInfoRow(
                      Image.asset('assets/images/icons/battle-level.png'),
                      "Levels: ${dungeon['level']}",
                    ),
                    _buildInfoRow(
                      Image.asset('assets/images/icons/battle-difficulty.png'),
                      "Base Difficulty: ${dungeon['difficulty']}",
                    ),
                    _buildInfoRow(
                      Image.asset('assets/images/icons/battle-monstertype.png'),
                      "Monster Type: ${dungeon['monstertype']}",
                    ),

                    SizedBox(height: 20),
                    Text(
                      "Explore this dungeon and face challenging enemies! Rewards increase with difficulty level.",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 30),
                    Text(
                      "SELECT DIFFICULTY",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Divider(color: Colors.white54),
                    SizedBox(height: 15),

                    // Difficulty buttons
                    _buildDifficultyButton(
                        context, "Easy", dungeon['color'], minLevel, region),
                    SizedBox(height: 10),
                    _buildDifficultyButton(context, "Medium", dungeon['color'],
                        minLevel + 2, region),
                    SizedBox(height: 10),
                    _buildDifficultyButton(context, "Hard", dungeon['color'],
                        minLevel + 5, region),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(Widget imageWidget, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: 30, height: 30, child: imageWidget),
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyButton(BuildContext context, String difficulty,
      Color color, int level, String region) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.8),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(vertical: 15),
      ),
      onPressed: () {
        Navigator.pop(context); // Close the dialog
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) =>
                PreparationScreenNormal(
              difficulty: difficulty,
              dungeonLevel: level,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            _getDifficultyImagePath(difficulty),
            width: 30,
            height: 30,
          ),
          SizedBox(width: 10),
          Text(
            difficulty.toUpperCase(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 10),
          Text(
            "Lv. $level",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

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

  Widget _buildBackButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFA12626), //Top color
              const Color(0xFF611818), // Dark red at bottom
            ],
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Colors.transparent, // Make button background transparent
            shadowColor: Colors.transparent, // Remove shadow
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
          child: Text(
            "Back",
            style: TextStyle(
                color: Colors.white, fontFamily: 'GameFont', fontSize: 16),
          ),
        ),
      ),
    );
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
