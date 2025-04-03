import 'package:flutter/material.dart';
import 'package:idle_space_farm/pages/navigationbar.dart';
import 'package:provider/provider.dart';
import '../main.dart';
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BattleProvider(),
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: region,
            height: 40,
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
          ),
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        ImageCacheManager.getImage('assets/images/ui/mine.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              _BattleContent(
                heroes: heroes,
                enemies: enemies,
                difficulty: difficulty,
              ),
            ],
          ),
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
    Key? key,
  }) : super(key: key);

  @override
  State<_BattleContent> createState() => __BattleContentState();
}

class __BattleContentState extends State<_BattleContent> {
  bool _showBattleLog = true;
  late final ScrollController _logScrollController;
  bool _showingResultDialog = false; // Add this flag

  @override
  void initState() {
    super.initState();
    _logScrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BattleProvider>(context, listen: false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.startBattle(
          widget.heroes,
          widget.enemies.first.level,
          widget.difficulty,
          predefinedEnemies: widget.enemies,
        );
      });
      // Add this listener
      provider.addListener(() {
        if (provider.isBattleOver && !_showingResultDialog) {
          _showingResultDialog = true;
          _showBattleResultDialog(context, provider);
        }
      });
    });
  }

  void _showBattleResultDialog(BuildContext context, BattleProvider provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(provider.battleResult),
        content: Text(provider.battleResult == "Victory"
            ? "Congratulations! You won the battle!"
            : "Your party was defeated..."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 500),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      HomePage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
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
              ); // Close the dialog
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 500),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      HomePage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
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
              ); // Go back to previous screen
              provider.resetBattle(); // Clean up battle state
            },
            child: const Text("OK"),
          ),
        ],
      ),
    ).then((_) {
      _showingResultDialog = false;
    });
  }

  @override
  void dispose() {
    _logScrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_logScrollController.hasClients) {
      _logScrollController.animateTo(
        _logScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _buildBattleLog(BattleProvider provider) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_showBattleLog) _scrollToBottom();
    });

    return Container(
      height: 120,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8),
      child: ListView.builder(
        controller: _logScrollController,
        itemCount: provider.battleLog.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              provider.battleLog[index],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTeamPanel({required String title, required List? units}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: units?.length ?? 0,
              itemBuilder: (context, index) {
                final unit = units![index];
                final hpPercent = unit.hp / unit.maxHp;
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: unit is GirlFarmer
                        ? Image.asset(unit.image, height: 40)
                        : const Icon(Icons.dangerous,
                            color: Colors.red, size: 30),
                    title: Text(unit.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: hpPercent,
                          backgroundColor: Colors.grey[300],
                          color: _getHpColor(hpPercent),
                          minHeight: 6,
                        ),
                        const SizedBox(height: 4),
                        Text("HP: ${unit.hp}/${unit.maxHp}"),
                        if (unit is GirlFarmer) ...[
                          Text("MP: ${unit.mp}"),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 5,
                            children: unit.abilities
                                .map((ability) => Chip(
                                      label: Text(
                                        ability.name,
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      backgroundColor: ability.cooldownTimer > 0
                                          ? Colors.grey[400]
                                          : Colors.blue[200],
                                      padding: const EdgeInsets.all(2),
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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BattleProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Round ${provider.currentRound}",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
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
          if (_showBattleLog) _buildBattleLog(provider),
          Row(
            children: [
              // Both buttons now have equal flex values
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(
                      _showBattleLog
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 24,
                      color: Colors.white),
                  label: Text(
                    _showBattleLog ? "HIDE LOG" : "SHOW LOG",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.blueGrey[800],
                  ),
                  onPressed: () =>
                      setState(() => _showBattleLog = !_showBattleLog),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.play_circle_outline,
                      size: 24, color: Colors.white),
                  label: const Text(
                    "AUTO BATTLE",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.green[800],
                  ),
                  onPressed: provider.isProcessingTurn
                      ? null
                      : () => provider.autoBattle(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getHpColor(double percent) {
    if (percent > 0.6) return Colors.green;
    if (percent > 0.3) return Colors.orange;
    return Colors.red;
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
