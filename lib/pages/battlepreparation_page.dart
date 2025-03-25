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

  PreparationScreen({required this.difficulty});

  @override
  _PreparationScreenState createState() => _PreparationScreenState();
}

class _PreparationScreenState extends State<PreparationScreen> {
  late List<GirlFarmer> availableHeroes;
  late List<Enemy> enemies;
  final List<GirlFarmer> selectedHeroes = [];

  final GirlRepository _girlRepository =
      GirlRepository(Hive.box('idle_space_farm'));
  final EnemyRepository _enemyRepository =
      EnemyRepository(Hive.box('idle_space_farm'));

  @override
  void initState() {
    super.initState();
    availableHeroes = _girlRepository.getAllGirls();
    enemies =
        generateEnemies(1, widget.difficulty); // Call the function directly
  }

  void toggleSelection(GirlFarmer hero) {
    setState(() {
      if (selectedHeroes.contains(hero)) {
        selectedHeroes.remove(hero);
      } else {
        if (selectedHeroes.length < 5) {
          selectedHeroes.add(hero);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text("Preparation", style: TextStyle(fontSize: 24))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select 5 Heroes",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            // Hero Selection Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: availableHeroes.length,
                itemBuilder: (context, index) {
                  final hero = availableHeroes[index];
                  final isSelected = selectedHeroes.contains(hero);

                  return GestureDetector(
                    onTap: () => toggleSelection(hero),
                    child: HeroCard(hero: hero, isSelected: isSelected),
                  );
                },
              ),
            ),
            SizedBox(height: 20),

            Text("Enemies You'll Face",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            // Enemy List
            Expanded(
              child: ListView.builder(
                itemCount: enemies.length,
                itemBuilder: (context, index) {
                  final enemy = enemies[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: CircleAvatar(
                          child: Icon(Icons.dangerous, color: Colors.red)),
                      title: Text(enemy.name,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Level: ${enemy.level} | HP: ${enemy.hp}"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button for Navigation
      floatingActionButton: FloatingActionButton.extended(
        onPressed: selectedHeroes.length == 5
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BattleScreen(heroes: selectedHeroes, enemies: enemies),
                  ),
                );
              }
            : null,
        label: Text("Start Battle"),
        icon: Icon(Icons.play_arrow),
        backgroundColor: selectedHeroes.length == 5 ? Colors.blue : Colors.grey,
      ),
    );
  }
}

class HeroCard extends StatelessWidget {
  final GirlFarmer hero;
  final bool isSelected;

  HeroCard({required this.hero, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 8 : 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: isSelected
            ? BorderSide(color: Colors.blue, width: 3)
            : BorderSide.none,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(hero.image, height: 80),
          SizedBox(height: 5),
          Text(hero.name, style: TextStyle(fontWeight: FontWeight.bold)),
          Text("Level: ${hero.level}", style: TextStyle(fontSize: 14)),
          Text("HP: ${hero.hp}", style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
