import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/girl_farmer_model.dart';
import '../models/enemy_model.dart';
import '../providers/battle_provider.dart';

class BattleScreen extends StatelessWidget {
  final List<GirlFarmer> heroes;
  final List<Enemy> enemies;
  final String difficulty;
  final String region;

  const BattleScreen({
    required this.heroes,
    required this.enemies,
    required this.difficulty,
    required this.region,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BattleProvider(),
      child: Scaffold(
        appBar: AppBar(title: Text('$region Battle')),
        body: _BattleContent(
          heroes: heroes,
          enemies: enemies,
          difficulty: difficulty,
        ),
      ),
    );
  }
}

class _BattleContent extends StatefulWidget {
  final List<GirlFarmer> heroes;
  final List<Enemy> enemies;
  final String difficulty;

  const _BattleContent({
    required this.heroes,
    required this.enemies,
    required this.difficulty,
  });

  @override
  __BattleContentState createState() => __BattleContentState();
}

class __BattleContentState extends State<_BattleContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BattleProvider>(context, listen: false);
      provider.startBattle(
        widget.heroes,
        widget.enemies.first.level,
        widget.difficulty,
        predefinedEnemies: widget.enemies,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BattleProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text("Round ${provider.currentRound}",
              style: TextStyle(fontSize: 24)),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              children: [
                _buildTeamPanel(title: "Heroes", units: provider.heroes),
                const SizedBox(width: 20),
                _buildTeamPanel(title: "Enemies", units: provider.enemies),
              ],
            ),
          ),
          _buildBattleLog(provider),
          _buildBattleControls(provider),
        ],
      ),
    );
  }

  Widget _buildTeamPanel({required String title, required List? units}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: units?.length ?? 0,
              itemBuilder: (context, index) {
                final unit = units![index];
                final hpPercent = unit.hp / unit.maxHp;
                return Card(
                  child: ListTile(
                    leading: unit is GirlFarmer
                        ? Image.asset(unit.image, height: 40)
                        : const Icon(Icons.dangerous, color: Colors.red),
                    title: Text(unit.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          value: hpPercent,
                          backgroundColor: Colors.grey[300],
                          color: _getHpColor(hpPercent),
                        ),
                        Text("HP: ${unit.hp}/${unit.maxHp}"),
                        if (unit is GirlFarmer) ...[
                          Text("MP: ${unit.mp}"),
                          Wrap(
                            spacing: 5,
                            children: unit.abilities
                                .map((ability) => Chip(
                                      label: Text(ability.name),
                                      backgroundColor: ability.cooldownTimer > 0
                                          ? Colors.grey
                                          : Colors.blue,
                                    ))
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBattleLog(BattleProvider provider) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8),
      child: ListView(
        children: provider.battleLog.map((log) => Text(log)).toList(),
      ),
    );
  }

  Widget _buildBattleControls(BattleProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: provider.isProcessingTurn
              ? null
              : () => _handleNextTurn(provider),
          child: const Text("Next Turn"),
        ),
        ElevatedButton(
          onPressed: provider.isProcessingTurn
              ? null
              : () => _handleAutoBattle(provider),
          child: const Text("Auto Battle"),
        ),
      ],
    );
  }

  void _handleNextTurn(BattleProvider provider) {
    provider.nextTurn();
    _checkBattleResult(provider);
  }

  void _handleAutoBattle(BattleProvider provider) {
    provider.autoBattle();
    _checkBattleResult(provider);
  }

  void _checkBattleResult(BattleProvider provider) {
    if (provider.isBattleOver) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(provider.battleResult == "Win" ? "Victory!" : "Defeat!"),
          content: Text(provider.battleResult == "Win"
              ? "Congratulations! You won the battle!"
              : "Oh no! You lost the battle."),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                provider.resetBattle();
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        ),
      );
    }
  }

  Color _getHpColor(double percent) {
    if (percent > 0.6) return Colors.green;
    if (percent > 0.3) return Colors.orange;
    return Colors.red;
  }
}
