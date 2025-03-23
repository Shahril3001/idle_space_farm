import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/girl_farmer_model.dart';
import '../models/enemy_model.dart';
import '../providers/battle_provider.dart';

class BattleScreen extends StatelessWidget {
  final List<GirlFarmer> heroes;
  final List<Enemy> enemies;

  BattleScreen({required this.heroes, required this.enemies});

  @override
  Widget build(BuildContext context) {
    final battleProvider = Provider.of<BattleProvider>(context);

    // Start the battle when the screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (battleProvider.heroes == null || battleProvider.enemies == null) {
        print("Initializing battle...");
        battleProvider.startBattle(heroes, 1, "Medium");
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Battle"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Round ${battleProvider.currentRound}",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Row(
                children: [
                  // Heroes Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Heroes",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: heroes.length,
                            itemBuilder: (context, index) {
                              final hero = heroes[index];
                              return Card(
                                child: ListTile(
                                  leading: Image.asset(hero.image, height: 40),
                                  title: Text(hero.name),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("HP: ${hero.hp}"),
                                      LinearProgressIndicator(
                                        value: hero.hp /
                                            100, // Assuming max HP is 100
                                        backgroundColor: Colors.grey[300],
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.green),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  // Enemies Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Enemies",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: enemies.length,
                            itemBuilder: (context, index) {
                              final enemy = enemies[index];
                              return Card(
                                child: ListTile(
                                  leading:
                                      Icon(Icons.dangerous, color: Colors.red),
                                  title: Text(enemy.name),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("HP: ${enemy.hp}"),
                                      LinearProgressIndicator(
                                        value: enemy.hp /
                                            100, // Assuming max HP is 100
                                        backgroundColor: Colors.grey[300],
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Battle Log
            Container(
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(8),
              child: ListView(
                children: battleProvider.battleLog.map((log) {
                  return Text(log);
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: battleProvider.isProcessingTurn
                      ? null
                      : () {
                          print("Next Turn button pressed");
                          battleProvider.nextTurn();
                        },
                  child: Text("Next Turn"),
                ),
                ElevatedButton(
                  onPressed: battleProvider.isProcessingTurn
                      ? null
                      : () {
                          print("Auto Battle button pressed");
                          battleProvider.autoBattle();
                        },
                  child: Text("Auto Battle"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
