import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../main.dart';
import '../models/enemy_model.dart';
import 'battle_screen.dart';
import '../models/girl_farmer_model.dart';
import '../data/enemy_data.dart';
import '../repositories/girl_repository.dart';

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

  void _showCharacterDetail(BuildContext context, dynamic character) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(character.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (character is GirlFarmer)
                Image.asset(character.imageFace, height: 60)
              else
                const Icon(Icons.dangerous, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              Text('Level: ${character.level}'),
              Text('HP: ${character.hp}/${character.maxHp}'),
              Text('MP: ${character.mp}/${character.maxMp}'),
              Text('ATK: ${character.attackPoints}'),
              if (character is GirlFarmer) ...[
                Text('DEF: ${character.defensePoints}'),
                Text('AGI: ${character.agilityPoints}'),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Preparation",
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
              // Enemy Preview Section at the top
              _buildEnemyPreview(),
              const Divider(height: 20, thickness: 2),
              // Hero Selection Section at the bottom
              _buildHeroSelection(),
              // Bottom action buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSelection() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select 5 Heroes",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Chip(
                    label: Text(
                      "${selectedHeroes.length}/5",
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    backgroundColor: const Color(0xFFCAA04D), // Gold color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.8,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: availableHeroes.length,
                itemBuilder: (context, index) {
                  final hero = availableHeroes[index];
                  return HeroCard(
                    hero: hero,
                    isSelected: selectedHeroes.contains(hero),
                    onTap: () => toggleSelection(hero),
                    onDetail: () => _showCharacterDetail(context, hero),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnemyPreview() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity, // Makes container take full width of parent
            padding: EdgeInsets.all(8.0), // Add some padding
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8), // 70% opacity black
              borderRadius:
                  BorderRadius.circular(4), // Optional rounded corners
            ),
            child: const Text(
              "Enemies You'll Face",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign:
                  TextAlign.center, // Center the text within the container
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: previewEnemies.length,
              itemBuilder: (context, index) {
                final enemy = previewEnemies[index];
                return EnemyCard(
                  enemy: enemy,
                  onDetail: () => _showCharacterDetail(context, enemy),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.arrow_back, size: 24, color: Colors.white),
              label: const Text(
                "BACK",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow, size: 24, color: Colors.white),
              label: const Text(
                "START BATTLE",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: selectedHeroes.length == 5
                    ? Colors.green[500]
                    : Colors.grey,
              ),
              onPressed: selectedHeroes.length == 5
                  ? () => _startBattle(context)
                  : null,
            ),
          ),
        ],
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

class HeroCard extends StatelessWidget {
  final GirlFarmer hero;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDetail;

  const HeroCard({
    required this.hero,
    required this.isSelected,
    required this.onTap,
    required this.onDetail,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onDetail,
      child: Card(
        elevation: isSelected ? 8 : 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: isSelected
              ? const BorderSide(color: Colors.blue, width: 3)
              : BorderSide.none,
        ),
        color: isSelected ? Colors.blue[50] : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Image.asset(
                  hero.imageFace,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                hero.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "Lv.${hero.level}",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EnemyCard extends StatelessWidget {
  final Enemy enemy;
  final VoidCallback onDetail;

  const EnemyCard({
    required this.enemy,
    required this.onDetail,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDetail,
      child: Card(
        elevation: 3,
        color: Colors.red[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.dangerous, color: Colors.red, size: 30),
              const SizedBox(height: 5),
              Text(
                enemy.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "Lv.${enemy.level}",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 11,
                ),
              ),
            ],
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
