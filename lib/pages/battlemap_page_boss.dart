import 'package:flutter/material.dart';
import '../main.dart';
import '../models/ability_model.dart';
import '../models/enemy_model.dart';
import 'battlepreparation_page_boss.dart';

// ignore: use_key_in_widget_constructors
class BossBattleMapScreen extends StatelessWidget {
  // Boss dungeon data organized by region
  final List<Map<String, dynamic>> bossDungeons = [
    {
      'name': 'Forest Guardian',
      'image': 'assets/images/bosses/boss001.png',
      'level': '20',
      'monstertype': 'Forest',
      'region': 'Forest',
      'difficulty': 'Boss',
      'color': Colors.green,
    },
    {
      'name': 'Mountain Colossus',
      'image': 'assets/images/bosses/boss002.png',
      'level': '25',
      'monstertype': 'Mountain',
      'region': 'Mountain',
      'difficulty': 'Boss',
      'color': Colors.blue,
    },
    {
      'name': 'Lich King',
      'image': 'assets/images/bosses/boss003.png',
      'level': '30',
      'monstertype': 'Undead',
      'region': 'Mountain',
      'difficulty': 'Boss',
      'color': Colors.yellow,
    },
    {
      'name': 'Abyssal Horror',
      'image': 'assets/images/bosses/boss004.png',
      'level': '35',
      'monstertype': 'Sunken',
      'region': 'Sunken',
      'difficulty': 'Boss',
      'color': Colors.blueGrey,
    },
    {
      'name': 'Magma Titan',
      'image': 'assets/images/bosses/boss005.png',
      'level': '40',
      'monstertype': 'Volcanic',
      'region': 'Ruins',
      'difficulty': 'Boss',
      'color': Colors.red,
    },
    {
      'name': 'Void Harbinger',
      'image': 'assets/images/bosses/boss006.png',
      'level': '50',
      'monstertype': 'Void',
      'region': 'Void',
      'difficulty': 'Boss',
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Boss Arenas',
          height: 40,
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ImageCacheManager.getImage('assets/images/ui/boss-bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Content (Boss Cards)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: bossDungeons.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildBossCard(context, bossDungeons[index]),
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

  Widget _buildBossCard(BuildContext context, Map<String, dynamic> boss) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      elevation: 6,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showBossDialog(context, boss),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: boss['color'].withOpacity(0.8),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: boss['color'].withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // Boss Image
                Positioned.fill(
                  child: Image.asset(
                    boss['image'],
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

                // Boss Info
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
                          boss['name'],
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                blurRadius: 6,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.star, size: 20, color: boss['color']),
                            SizedBox(width: 8),
                            Text(
                              'Lv. ${boss['level']}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: boss['color'].withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: boss['color'], width: 2),
                              ),
                              child: Text(
                                boss['difficulty'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
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

  void _showBossDialog(BuildContext context, Map<String, dynamic> boss) {
    final region = boss['region'] as String? ?? 'DefaultRegion';
    final level = int.parse(boss['level']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(
            color: boss['color'].withOpacity(0.8),
            width: 3,
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Boss name and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  boss['name'],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: boss['color'],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            Divider(color: boss['color'].withOpacity(0.5)),

            // Boss info section
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildBossInfoRow(
                      Icon(Icons.public, color: boss['color']),
                      "Region: $region",
                    ),
                    _buildBossInfoRow(
                      Icon(Icons.leaderboard, color: boss['color']),
                      "Level: ${boss['level']}",
                    ),
                    _buildBossInfoRow(
                      Icon(Icons.warning, color: boss['color']),
                      "Type: ${boss['monstertype']}",
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Face this mighty boss in an epic battle! Defeating it will grant you special rewards and unlock new areas.",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: boss['color'].withOpacity(0.8),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 500),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      PreparationScreenBoss(
                                difficulty: 'Boss',
                                dungeonLevel: level,
                                region: region,
                                isBossBattle: true,
                                boss: Enemy(
                                  id: 'boss_${boss['name'].replaceAll(' ', '_').toLowerCase()}',
                                  name: boss['name'],
                                  level: level,
                                  attackPoints: (level * 3).round(),
                                  defensePoints: (level * 2).round(),
                                  agilityPoints: (level * 1.5).round(),
                                  hp: (level * 50).round(),
                                  maxHp: (level * 50).round(),
                                  mp: (level * 20).round(),
                                  maxMp: (level * 20).round(),
                                  sp: 100,
                                  maxSp: 100,
                                  imageE: boss['image'],
                                  abilities: [
                                    AbilitiesModel(
                                      abilitiesID: "boss_ability_001",
                                      name: "Devastating Strike",
                                      description:
                                          "A powerful attack that hits all enemies",
                                      attackBonus: 30,
                                      hpBonus: 50,
                                      mpCost: 20,
                                      cooldown: 4,
                                      type: AbilityType.attack,
                                      targetType: TargetType.all,
                                      affectsEnemies: true,
                                      criticalPoint: 20,
                                    ),
                                    AbilitiesModel(
                                      abilitiesID: "boss_ability_002",
                                      name: "Berserk Rage",
                                      description:
                                          "Increases attack and agility",
                                      attackBonus: 20,
                                      agilityBonus: 15,
                                      mpCost: 15,
                                      cooldown: 5,
                                      type: AbilityType.buff,
                                      targetType: TargetType.single,
                                      affectsEnemies: false,
                                      criticalPoint: 0,
                                    ),
                                  ],
                                  rarity: "Boss",
                                  type: boss['monstertype'],
                                  region: region,
                                  description:
                                      "A mighty boss that guards this region",
                                  criticalPoint: 20,
                                ),
                              ),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
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
                            Icon(Icons.campaign, size: 30),
                            SizedBox(width: 10),
                            Text(
                              "CHALLENGE BOSS",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBossInfoRow(Widget icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          SizedBox(width: 30, height: 30, child: icon),
          SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
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
          child: Text(
            "Back",
            style: TextStyle(
                color: Colors.white, fontFamily: 'GameFont', fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.symmetric(vertical: 10),
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
