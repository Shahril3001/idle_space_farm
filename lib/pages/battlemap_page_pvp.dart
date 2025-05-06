import 'dart:math';

import 'package:flutter/material.dart';
import '../data/girl_data.dart';
import '../main.dart';
import '../models/girl_farmer_model.dart';
import 'battle_screen_pvp.dart';
import 'battlepreparation_page_pvp.dart';

class PvPBattleMapScreen extends StatelessWidget {
  // PvP arena data based on races
  final List<Map<String, dynamic>> pvpArenas = [
    {
      'name': 'Human Colosseum',
      'image': 'assets/images/arenas/arena001.png',
      'race': 'Human',
      'color': Colors.blue,
    },
    {
      'name': 'Eldren Grove',
      'image': 'assets/images/arenas/arena002.png',
      'race': 'Eldren',
      'color': Colors.green,
    },
    {
      'name': 'Therian Hunting Grounds',
      'image': 'assets/images/arenas/arena003.png',
      'race': 'Therian',
      'color': Colors.orange,
    },
    {
      'name': 'Dracovar Lair',
      'image': 'assets/images/arenas/arena004.png',
      'race': 'Dracovar',
      'color': Colors.red,
    },
    {
      'name': 'Daemon Citadel',
      'image': 'assets/images/arenas/arena005.png',
      'race': 'Daemon',
      'color': Colors.purple,
    },
  ];

  final Random _random = Random();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'PvP Arenas',
          height: 40,
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ImageCacheManager.getImage('assets/images/ui/pvp-bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Content (Arena Cards)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: pvpArenas.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildArenaCard(context, pvpArenas[index]),
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

  Widget _buildArenaCard(BuildContext context, Map<String, dynamic> arena) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      elevation: 6,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showArenaDialog(context, arena),
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: arena['color'].withOpacity(0.8),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: arena['color'].withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // Arena Image
                Positioned.fill(
                  child: Image.asset(
                    arena['image'],
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

                // Arena Info
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
                          arena['name'],
                          style: TextStyle(
                            fontSize: 20,
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
                            Icon(Icons.people, size: 20, color: arena['color']),
                            SizedBox(width: 8),
                            Text(
                              "Race: ${arena['race']}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
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

  void _showArenaDialog(BuildContext context, Map<String, dynamic> arena) {
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
            color: arena['color'].withOpacity(0.8),
            width: 3,
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Arena name and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  arena['name'],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: arena['color'],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            Divider(color: arena['color'].withOpacity(0.5)),

            // Arena info section
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildArenaInfoRow(
                      Icon(Icons.flag, color: arena['color']),
                      "Arena: ${arena['name']}",
                    ),
                    _buildArenaInfoRow(
                      Icon(Icons.people, color: arena['color']),
                      "Primary Race: ${arena['race']}",
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Challenge other players in this arena! You'll face opponents with similar power level. Win to earn honor points and special rewards.",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: arena['color'].withOpacity(0.8),
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
                                      PreparationScreenPvP(
                                difficulty: 'PvP',
                                dungeonLevel: 0, // Not used for PvP
                                region: arena['race'],
                                isPvPBattle: true,
                                opponentTeam:
                                    _generateOpponentTeam(arena['race']),
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
                            Icon(Icons.sports_esports, size: 30),
                            SizedBox(width: 10),
                            Text(
                              "ENTER ARENA",
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

  List<GirlFarmer> _generateOpponentTeam(String race) {
    // Filter girls by race and rarity
    var raceGirls = girlsData.where((g) => g.race == race).toList();

    // Take 5 random girls of varying rarities
    var opponentTeam = <GirlFarmer>[];
    opponentTeam.addAll(raceGirls.where((g) => g.rarity == 'Common').take(2));
    opponentTeam.addAll(raceGirls.where((g) => g.rarity == 'Rare').take(2));
    opponentTeam.addAll(raceGirls.where((g) => g.rarity == 'Unique').take(1));

    // Ensure we have exactly 5 members
    while (opponentTeam.length < 5 && raceGirls.isNotEmpty) {
      opponentTeam.add(raceGirls[_random.nextInt(raceGirls.length)]);
    }

    // Clone with safe defaults
    return opponentTeam.map((girl) {
      return GirlFarmer(
        id: girl.id,
        name: girl.name,
        rarity: girl.rarity,
        stars: girl.stars,
        miningEfficiency: 0.0,
        image: girl.image,
        imageFace: girl.imageFace,
        race: girl.race,
        type: girl.type,
        region: girl.region,
        description: girl.description,
        hp: girl.maxHp,
        maxHp: girl.maxHp,
        mp: girl.maxMp,
        maxMp: girl.maxMp,
        sp: girl.maxSp,
        maxSp: girl.maxSp,
        attackPoints: girl.attackPoints,
        defensePoints: girl.defensePoints,
        agilityPoints: girl.agilityPoints,
        criticalPoint: girl.criticalPoint,
        abilities: girl.abilities.map((a) => a.freshCopy()).toList(),
        level: girl.level,
        // optional fields
        currentCooldowns: {},
        elementAffinities: List.from(girl.elementAffinities),
        statusEffects: [],
        partyMemberIds: [],
        equippedItems: [],
      );
    }).toList();
  }

  Widget _buildArenaInfoRow(Widget icon, String text) {
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
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
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
