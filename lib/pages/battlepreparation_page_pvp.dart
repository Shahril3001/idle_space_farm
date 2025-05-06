import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../main.dart';
import 'battle_screen_pvp.dart';
import '../models/girl_farmer_model.dart';
import '../repositories/girl_repository.dart';
import 'battlepreparation_page_shared.dart';

class PreparationScreenPvP extends StatefulWidget {
  final List<GirlFarmer> opponentTeam;
  final String difficulty;
  final int dungeonLevel;
  final String region;
  final bool isPvPBattle;
  const PreparationScreenPvP({
    required this.difficulty,
    required this.dungeonLevel,
    required this.region,
    this.isPvPBattle = false,
    required this.opponentTeam,
  });

  @override
  _PreparationScreenPvPState createState() => _PreparationScreenPvPState();
}

class _PreparationScreenPvPState extends State<PreparationScreenPvP> {
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
          title: "PvP Preparation",
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
              // Opponent Preview Section
              PreparationShared.buildOpponentPreview(
                context: context,
                opponentTeam: widget.opponentTeam,
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
        builder: (context) => PvPBattleScreen(
          playerTeam: _prepareBattleHeroes(),
          opponentTeam: widget.opponentTeam,
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
