import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/girl_farmer_model.dart';
import '../models/enemy_model.dart';
import '../providers/battle_provider.dart';
import 'navigationbar.dart';

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

      // Check if the battle is already over (e.g., when returning to this screen)
      if (battleProvider.isBattleOver) {
        _showBattleResultDialog(context, battleProvider.battleResult);
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
                          child: Consumer<BattleProvider>(
                            builder: (context, battleProvider, child) {
                              print("Rebuilding heroes list"); // Debug log
                              return ListView.builder(
                                itemCount: battleProvider.heroes?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final hero = battleProvider.heroes![index];
                                  return Card(
                                    child: ListTile(
                                      leading:
                                          Image.asset(hero.image, height: 40),
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
                                          Text("MP: ${hero.mp}"),
                                          Text("SP: ${hero.sp}"),
                                          // Display abilities
                                          Wrap(
                                            spacing: 5,
                                            children:
                                                hero.abilities.map((ability) {
                                              return Chip(
                                                label: Text(ability.name),
                                                backgroundColor:
                                                    ability.cooldownTimer > 0
                                                        ? Colors.grey
                                                        : Colors.blue,
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
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
                          child: Consumer<BattleProvider>(
                            builder: (context, battleProvider, child) {
                              print("Rebuilding enemies list"); // Debug log
                              return ListView.builder(
                                itemCount: battleProvider.enemies?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final enemy = battleProvider.enemies![index];
                                  return Card(
                                    child: ListTile(
                                      leading: Icon(Icons.dangerous,
                                          color: Colors.red),
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
            Consumer<BattleProvider>(
              builder: (context, battleProvider, child) {
                print("Rebuilding battle log"); // Debug log
                return Container(
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
                );
              },
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

                          // Check if the battle is over after each turn
                          if (battleProvider.isBattleOver) {
                            _showBattleResultDialog(
                                context, battleProvider.battleResult);
                          }
                        },
                  child: Text("Next Turn"),
                ),
                ElevatedButton(
                  onPressed: battleProvider.isProcessingTurn
                      ? null
                      : () {
                          print("Auto Battle button pressed");
                          battleProvider.autoBattle();

                          // Check if the battle is over after starting auto-battle
                          if (battleProvider.isBattleOver) {
                            _showBattleResultDialog(
                                context, battleProvider.battleResult);
                          }
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

  // Helper method to show the battle result dialog
  void _showBattleResultDialog(BuildContext context, String result) {
    String message = result == "Win"
        ? "Congratulations! You won the battle!"
        : "Oh no! You lost the battle. Better luck next time!";

    showDialog(
      context: context,
      barrierDismissible: false, // User must tap a button to close the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(result == "Win" ? "Victory!" : "Defeat!"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HomePage())); // Navigate back to the dashboard
              },
            ),
          ],
        );
      },
    );
  }
}
