import 'package:flutter/material.dart';
import 'package:idle_space_farm/pages/navigationbar.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/girl_farmer_model.dart';
import '../models/enemy_model.dart';
import '../providers/battle_provider.dart';

class BossBattleScreen extends StatelessWidget {
  final List<GirlFarmer> heroes;
  final Enemy boss;
  final String region;

  const BossBattleScreen({
    required this.heroes,
    required this.boss,
    required this.region,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: ChangeNotifierProvider(
        create: (_) => BattleProvider(),
        child: Scaffold(
          appBar: CustomAppBar(
            title: 'Boss Battle: ${boss.name}',
            height: 40,
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
          ),
          body: Stack(
            children: [
              // Special boss background
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ImageCacheManager.getImage(
                        'assets/images/ui/boss-bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              _BossBattleContent(
                heroes: heroes,
                boss: boss,
                region: region,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BossBattleContent extends StatefulWidget {
  final List<GirlFarmer> heroes;
  final Enemy boss;
  final String region;

  const _BossBattleContent({
    required this.heroes,
    required this.boss,
    required this.region,
  });

  @override
  State<_BossBattleContent> createState() => __BossBattleContentState();
}

class __BossBattleContentState extends State<_BossBattleContent> {
  bool _showBattleLog = true;
  late final ScrollController _logScrollController;
  bool _showingResultDialog = false;

  @override
  void initState() {
    super.initState();
    _logScrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BattleProvider>(context, listen: false);
      provider.startBattle(
        widget.heroes,
        widget.boss.level,
        'Boss',
        predefinedEnemies: [widget.boss],
        region: widget.region,
        battleType: BattleType.boss,
      );

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
            ? "Congratulations! You defeated the boss!"
            : "Your party was defeated..."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
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
                (route) => false,
              );
              provider.resetBattle();
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

  Widget _buildBossHealthBar(Enemy boss) {
    final hpPercent = boss.hp / boss.maxHp;
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red, width: 2),
      ),
      child: Column(
        children: [
          Text(
            boss.name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
              shadows: [
                Shadow(
                  color: Colors.black,
                  blurRadius: 4,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: hpPercent,
            backgroundColor: Colors.grey[800],
            color: _getBossHpColor(hpPercent),
            minHeight: 20,
          ),
          SizedBox(height: 8),
          Text(
            "${boss.hp}/${boss.maxHp}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (boss.statusEffects.isNotEmpty) ...[
            SizedBox(height: 8),
            Wrap(
              spacing: 4,
              children: boss.statusEffects
                  .map((effect) => Chip(
                        label: Text(
                          effect.type.toString().split('.').last,
                          style: TextStyle(fontSize: 10),
                        ),
                        backgroundColor: Colors.orange[200],
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBattleLog(BattleProvider provider) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_logScrollController.hasClients) {
        _logScrollController.animateTo(
          _logScrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    return Container(
      height: 120,
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(8),
      child: ListView.builder(
        controller: _logScrollController,
        itemCount: provider.battleLog.length,
        itemBuilder: (context, index) {
          final log = provider.battleLog[index];
          Color? textColor = Colors.white;
          if (log.contains("Critical hit!")) textColor = Colors.yellow;
          if (log.contains("was defeated!")) textColor = Colors.red;
          if (log.contains("healed")) textColor = Colors.green;

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Text(
              log,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroList(List<GirlFarmer> heroes) {
    return Expanded(
      child: ListView.builder(
        itemCount: heroes.length,
        itemBuilder: (context, index) {
          final hero = heroes[index];
          final hpPercent = hero.hp / hero.maxHp;

          return Card(
            margin: EdgeInsets.only(bottom: 8),
            color: Colors.black.withOpacity(0.5),
            child: ListTile(
              leading: Image.asset(hero.imageFace, height: 40),
              title: Text(
                hero.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: hpPercent,
                    backgroundColor: Colors.grey[800],
                    color: _getHpColor(hpPercent),
                    minHeight: 6,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "HP: ${hero.hp}/${hero.maxHp} | MP: ${hero.mp}/${hero.maxMp}",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BattleProvider>(context);

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          if (provider.enemies != null && provider.enemies!.isNotEmpty)
            _buildBossHealthBar(provider.enemies!.first),
          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "Round ${provider.currentRound}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _buildHeroList(provider.heroes ?? []),
                SizedBox(width: 16),
                if (provider.enemies != null && provider.enemies!.isNotEmpty)
                  _buildBossDetails(provider.enemies!.first),
              ],
            ),
          ),
          if (_showBattleLog) _buildBattleLog(provider),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(
                    _showBattleLog
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 24,
                    color: Colors.white,
                  ),
                  label: Text(
                    _showBattleLog ? "HIDE LOG" : "SHOW LOG",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.blueGrey[800],
                  ),
                  onPressed: () =>
                      setState(() => _showBattleLog = !_showBattleLog),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.play_circle_outline,
                      size: 24, color: Colors.white),
                  label: Text(
                    "AUTO BATTLE",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: provider.isProcessingTurn
                        ? Colors.grey
                        : Colors.green[800],
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

  Widget _buildBossDetails(Enemy boss) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.dangerous, size: 60, color: Colors.red),
          SizedBox(height: 8),
          Text(
            boss.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            "Lv. ${boss.level}",
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Icon(Icons.bolt, size: 16, color: Colors.orange),
                  Text("${boss.attackPoints}",
                      style: TextStyle(color: Colors.white)),
                ],
              ),
              SizedBox(width: 8),
              Column(
                children: [
                  Icon(Icons.shield, size: 16, color: Colors.blue),
                  Text("${boss.defensePoints}",
                      style: TextStyle(color: Colors.white)),
                ],
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

  Color _getBossHpColor(double percent) {
    if (percent > 0.6) return Colors.red;
    if (percent > 0.3) return Colors.orange;
    return Colors.yellow;
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
