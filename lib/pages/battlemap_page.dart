import 'package:flutter/material.dart';
import 'battledungeon_page.dart';

class MapScreen extends StatelessWidget {
  // Sample dungeon data
  final List<Map<String, dynamic>> dungeons = [
    {
      'name': 'Forest Dungeon',
      'image': 'assets/images/dungeons/forest.jpg',
      'level': '1-5',
      'region': 'Forest',
      'difficulty': 'Easy',
      'color': Colors.green,
    },
    {
      'name': 'Cave of Shadows',
      'image': 'assets/images/dungeons/cave.jpg',
      'level': '5-10',
      'region': 'Mountain',
      'difficulty': 'Medium',
      'color': Colors.blue,
    },
    {
      'name': 'Volcanic Core',
      'image': 'assets/images/dungeons/volcano.jpg',
      'level': '10-15',
      'region': 'Ruins',
      'difficulty': 'Hard',
      'color': Colors.red,
    },
    {
      'name': 'Abyssal Depths',
      'image': 'assets/images/dungeons/abyss.jpg',
      'level': '15-20',
      'region': 'Easy',
      'difficulty': 'Very Hard',
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background Image with dark overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/map_background.jpg"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.4),
                      BlendMode.darken,
                    ),
                  ),
                ),
              ),
            ),

            // Main Content Column
            Column(
              children: [
                // Custom App Bar with SafeArea consideration
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomAppBar(
                    title: 'World Map',
                    height: 50,
                  ),
                ),

                // Dungeon List with expanded space
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: GridView.builder(
                      physics: BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _getCrossAxisCount(context),
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: dungeons.length,
                      itemBuilder: (context, index) {
                        return _buildDungeonCard(context, dungeons[index]);
                      },
                    ),
                  ),
                ),

                // Back Button with bottom SafeArea consideration
                Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: MediaQuery.of(context).padding.bottom > 0
                        ? 10
                        : 20, // Adjust for devices with bottom notch
                  ),
                  child: _buildBackButton(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 3; // Tablet layout
    return 2; // Mobile layout
  }

  Widget _buildDungeonCard(BuildContext context, Map<String, dynamic> dungeon) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          final region = dungeon['region'] as String? ?? 'DefaultRegion';
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DungeonScreen(
                dungeonName: dungeon['name'],
                difficulty: dungeon['difficulty'],
                minLevel: int.parse(dungeon['level'].split('-')[0]),
                maxLevel: int.parse(dungeon['level'].split('-')[1]),
                region: region, // Add this line
              ),
            ),
          );
        },
        child: Container(
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

  Widget _buildBackButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.pop(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFCAA04D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        minimumSize: Size(double.infinity, 50),
        padding: EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(
        "Back",
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'GameFont',
          fontSize: 16,
          fontWeight: FontWeight.bold,
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
