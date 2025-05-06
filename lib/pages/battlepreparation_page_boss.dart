import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../main.dart';
import '../models/enemy_model.dart';
import 'battle_screen_boss.dart';
import '../models/girl_farmer_model.dart';
import '../repositories/girl_repository.dart';
import 'battlepreparation_page_shared.dart';

class PreparationScreenBoss extends StatefulWidget {
  final String difficulty;
  final int dungeonLevel;
  final bool isBossBattle;
  final String region;
  final Enemy boss;

  const PreparationScreenBoss({
    super.key,
    required this.difficulty,
    required this.dungeonLevel,
    this.isBossBattle = false,
    required this.region,
    required this.boss,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PreparationScreenBossState createState() => _PreparationScreenBossState();
}

class _PreparationScreenBossState extends State<PreparationScreenBoss> {
  late List<GirlFarmer> availableHeroes;
  final List<GirlFarmer> selectedHeroes = [];

  @override
  void initState() {
    super.initState();
    availableHeroes =
        GirlRepository(Hive.box('eldoria_chronicles')).getAllGirls();
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
          title: "Boss Preparation",
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
              // Boss Preview Section
              PreparationShared.buildEnemyPreview(
                context: context,
                previewEnemies: [widget.boss],
                title: "Boss You'll Face",
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
        builder: (context) => BossBattleScreen(
          heroes: _prepareBattleHeroes(),
          boss: widget.boss,
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
