import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../main.dart';
import '../models/enemy_model.dart';
import 'battle_screen_invasion.dart';
import '../models/girl_farmer_model.dart';
import '../data/enemy_data.dart';
import '../repositories/girl_repository.dart';
import 'battlepreparation_page_shared.dart';

class PreparationScreenNormal extends StatefulWidget {
  final String difficulty;
  final int dungeonLevel;
  final String region;

  const PreparationScreenNormal({
    required this.difficulty,
    required this.dungeonLevel,
    required this.region,
  });

  @override
  _PreparationScreenNormalState createState() =>
      _PreparationScreenNormalState();
}

class _PreparationScreenNormalState extends State<PreparationScreenNormal> {
  late List<GirlFarmer> availableHeroes;
  late List<Enemy> previewEnemies;
  final List<GirlFarmer> selectedHeroes = [];

  @override
  void initState() {
    super.initState();
    availableHeroes =
        GirlRepository(Hive.box('eldoria_chronicles')).getAllGirls();
    previewEnemies = generateEnemies(
      widget.dungeonLevel,
      widget.difficulty,
      region: widget.region,
    );
  }

  List<Enemy> _prepareBattleEnemies() {
    return previewEnemies.map((enemy) => Enemy.freshCopy(enemy)).toList();
  }

  List<GirlFarmer> _prepareBattleHeroes() {
    return selectedHeroes.map((hero) => hero.copyWithFreshStats()).toList();
  }

  void toggleSelection(GirlFarmer hero) {
    setState(() {
      if (selectedHeroes.contains(hero)) {
        selectedHeroes.remove(hero);
      } else if (selectedHeroes.length < 5) {
        selectedHeroes.add(hero);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Dungeon Preparation",
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
            children: [
              // Enemy Preview Section
              PreparationShared.buildEnemyPreview(
                context: context,
                previewEnemies: previewEnemies,
                title: "Enemies You'll Face",
              ),
              const Divider(height: 20, thickness: 2),
              // Hero Selection Section
              PreparationShared.buildHeroSelection(
                context: context,
                availableHeroes: availableHeroes,
                selectedHeroes: selectedHeroes,
                toggleSelection: toggleSelection,
              ),
              // Bottom action buttons
              PreparationShared.buildActionButtons(
                context: context,
                selectedHeroes: selectedHeroes,
                onBack: () => Navigator.pop(context),
                onStart: () => _startBattle(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startBattle(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BattleScreen(
          heroes: _prepareBattleHeroes(),
          enemies: _prepareBattleEnemies(),
          difficulty: widget.difficulty,
          region: widget.region,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
