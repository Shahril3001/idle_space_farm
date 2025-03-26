import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/enemy_model.dart';
import 'battle_screen.dart';
import '../models/girl_farmer_model.dart';
import '../data/girl_data.dart';
import '../data/enemy_data.dart';
import '../repositories/girl_repository.dart';
import '../repositories/enemy_repository.dart';

class PreparationScreen extends StatefulWidget {
  final String difficulty;
  final int dungeonLevel;
  final String region;

  const PreparationScreen({
    required this.difficulty,
    required this.dungeonLevel,
    required this.region,
  });

  @override
  _PreparationScreenState createState() => _PreparationScreenState();
}

class _PreparationScreenState extends State<PreparationScreen> {
  late List<GirlFarmer> availableHeroes;
  late List<Enemy> previewEnemies;
  final List<GirlFarmer> selectedHeroes = [];

  @override
  void initState() {
    super.initState();
    availableHeroes = GirlRepository(Hive.box('idle_space_farm')).getAllGirls();
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
    return Scaffold(
      appBar: AppBar(title: const Text("Preparation")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeroSelection(),
            const SizedBox(height: 20),
            _buildEnemyPreview(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:
            selectedHeroes.length == 5 ? () => _startBattle(context) : null,
        label: const Text("Start Battle"),
        icon: const Icon(Icons.play_arrow),
      ),
    );
  }

  Widget _buildHeroSelection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Select 5 Heroes", style: TextStyle(fontSize: 20)),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.75,
              ),
              itemCount: availableHeroes.length,
              itemBuilder: (context, index) {
                final hero = availableHeroes[index];
                return HeroCard(
                  hero: hero,
                  isSelected: selectedHeroes.contains(hero),
                  onTap: () => toggleSelection(hero),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnemyPreview() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Enemies You'll Face", style: TextStyle(fontSize: 20)),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: previewEnemies.length,
              itemBuilder: (context, index) {
                final enemy = previewEnemies[index];
                return EnemyPreviewCard(enemy: enemy);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _startBattle(BuildContext context) {
    Navigator.push(
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

class HeroCard extends StatelessWidget {
  final GirlFarmer hero;
  final bool isSelected;
  final VoidCallback onTap;

  const HeroCard({
    required this.hero,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: isSelected ? 8 : 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: isSelected
              ? const BorderSide(color: Colors.blue, width: 3)
              : BorderSide.none,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(hero.image, height: 80),
            Text(hero.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("Lv.${hero.level} HP:${hero.hp}/${hero.maxHp}"),
          ],
        ),
      ),
    );
  }
}

class EnemyPreviewCard extends StatelessWidget {
  final Enemy enemy;

  const EnemyPreviewCard({required this.enemy});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.dangerous, color: Colors.red),
        title: Text(enemy.name),
        subtitle: Text("Lv.${enemy.level} HP:${enemy.hp}/${enemy.maxHp}"),
      ),
    );
  }
}
