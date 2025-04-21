import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../main.dart';
import '../providers/game_provider.dart';
import '../models/girl_farmer_model.dart';
import '../models/equipment_model.dart';

class GachaMainPage extends StatefulWidget {
  @override
  _GachaMainPageState createState() => _GachaMainPageState();
}

class _GachaMainPageState extends State<GachaMainPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Summoning Altar',
          height: 40,
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48), // Adjust height as needed
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.9),
                borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
              ),
              child: TabBar(
                labelColor: Color(0xFFCAA04D),
                unselectedLabelColor: Colors.white70,
                indicatorColor: Color(0xFFCAA04D),
                indicatorSize: TabBarIndicatorSize.tab,
                labelPadding: EdgeInsets.symmetric(horizontal: 16),
                controller: _tabController,
                tabs: [
                  Tab(
                    icon: Image.asset(
                      'assets/images/icons/summon-girl.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                  Tab(
                    icon: Image.asset(
                      'assets/images/icons/summon-equipment.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ImageCacheManager.getImage('assets/images/ui/summon.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    GachaGirlPage(),
                    GachaItemPage(),
                  ],
                ),
              ),
              _buildBackButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFA12626), //Top color
              const Color(0xFF611818), // Dark red at bottom
            ],
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Colors.transparent, // Make button background transparent
            shadowColor: Colors.transparent, // Remove shadow
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
          child: Text(
            "Back",
            style: TextStyle(
                color: Colors.white, fontFamily: 'GameFont', fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class GachaAnimation extends StatefulWidget {
  final bool isCharacterGacha;
  final VoidCallback onComplete;

  const GachaAnimation({
    Key? key,
    required this.isCharacterGacha,
    required this.onComplete,
  }) : super(key: key);

  @override
  _GachaAnimationState createState() => _GachaAnimationState();
}

class _GachaAnimationState extends State<GachaAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.2), weight: 0.5),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 0.5),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 0.3),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 0.4),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 0.3),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward().then((_) {
      widget.onComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Light burst effect
              if (_controller.value < 0.8)
                Opacity(
                  opacity: _opacityAnimation.value * 0.7,
                  child: Container(
                    width: 300 * _scaleAnimation.value,
                    height: 300 * _scaleAnimation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.yellow.withOpacity(0.8),
                          Colors.transparent,
                        ],
                        stops: [0.1, 1.0],
                      ),
                    ),
                  ),
                ),

              // Main summoning circle
              Transform.scale(
                scale: _scaleAnimation.value,
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.isCharacterGacha
                            ? Colors.blueAccent
                            : Colors.amber,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.isCharacterGacha
                              ? Colors.blue.withOpacity(0.5)
                              : Colors.amber.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        widget.isCharacterGacha
                            ? "assets/images/ui/transition-girl.png"
                            : "assets/images/ui/transition-equipment.png",
                        width: 250,
                        height: 250,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                ),
              ),

              // Particle effects
              ...List.generate(8, (index) {
                final angle = (index / 8) * 2 * pi;
                final distance = 100 * _controller.value;
                return Positioned(
                  left: 100 + distance * cos(angle),
                  top: 100 + distance * sin(angle),
                  child: Transform.rotate(
                    angle: angle,
                    child: Opacity(
                      opacity: 1 - _controller.value,
                      child: Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 20 * (1 - _controller.value),
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.height = 56.0,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.bottom,
  }) : super(key: key);

  @override
  Size get preferredSize =>
      Size.fromHeight(height + (bottom?.preferredSize.height ?? 0));

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
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'GameFont',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          if (bottom != null) bottom!,
        ],
      ),
    );
  }
}

class GachaGirlPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    return _buildGachaSection(
      context: context,
      title: 'Summon Girl',
      image: Image.asset(
        "assets/images/ui/summon-girl.png",
        width: 250,
        height: 280,
        fit: BoxFit.cover,
      ),
      subtitle: '💰 10 Credits (1x)\n💰 90 Credits (10x)',
      button1: _buildGachaButton(
        context,
        gameProvider,
        '1x Pull',
        1,
        "assets/images/icons/gacha_01scroll.png", // Image asset path instead of IconData
        Colors.blueAccent,
        true,
      ),
      button2: _buildGachaButton(
        context,
        gameProvider,
        '10x Pulls',
        10,
        "assets/images/icons/gacha_10scroll.png", // Image asset path
        Colors.blueAccent,
        true,
      ),
    );
  }
}

class GachaItemPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    return _buildGachaSection(
      context: context,
      title: 'Summon Equipment',
      image: Image.asset(
        "assets/images/ui/summon-equipment.png",
        width: 250,
        height: 280,
        fit: BoxFit.cover,
      ),
      subtitle: '💰 10 Credits (1x)\n💰 90 Credits (10x)',
      button1: _buildGachaButton(
        context,
        gameProvider,
        '1x Pull',
        1,
        "assets/images/icons/gacha_01scroll.png", // Image asset path
        Colors.blueAccent,
        false,
      ),
      button2: _buildGachaButton(
        context,
        gameProvider,
        '10x Pulls',
        10,
        "assets/images/icons/gacha_10scroll.png", // Image asset path
        Colors.blueAccent,
        false,
      ),
    );
  }
}

Widget _buildGachaSection({
  required BuildContext context,
  Widget? image,
  required String title,
  required String subtitle,
  required Widget button1,
  required Widget button2,
}) {
  return Center(
    child: _buildGlassCard(
      image: image,
      title: title,
      content: subtitle,
      button1: button1,
      button2: button2,
    ),
  );
}

Widget _buildGlassCard({
  Widget? image,
  required String title,
  required String content,
  required Widget button1,
  required Widget button2,
}) {
  return Container(
    margin: EdgeInsets.all(20),
    child: Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Colors.blueAccent, // Border color
          width: 2.0, // Border thickness
        ),
      ),
      color: Colors.black.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'GameFont',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            Divider(color: Colors.white54),
            if (image != null) image,
            SizedBox(height: 18),
            Text(
              content,
              style: TextStyle(
                fontFamily: 'GameFont',
                fontSize: 14,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: button1),
                SizedBox(width: 10),
                Expanded(child: button2),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildGachaButton(
    BuildContext context,
    GameProvider gameProvider,
    String label,
    int pulls,
    String iconAsset,
    Color color,
    bool isCharacterGacha) {
  return ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      backgroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      shadowColor: Colors.black.withOpacity(0.3),
      elevation: 8,
    ),
    onPressed: () {
      // Show loading overlay with animation
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: GachaAnimation(
            isCharacterGacha: isCharacterGacha,
            onComplete: () {
              Navigator.of(context).pop(); // Close animation
              // Perform gacha after animation completes
              if (isCharacterGacha) {
                final girls = gameProvider.performGachaGirl(pulls: pulls);
                if (girls.isNotEmpty) {
                  _showGachaResultsDialog(context, girls, true);
                } else {
                  _showErrorSnackbar(context, '❌ Not enough Credits!');
                }
              } else {
                final items = gameProvider.performEquipmentGacha(pulls: pulls);
                if (items.isNotEmpty) {
                  _showGachaResultsDialog(context, items, false);
                } else {
                  _showErrorSnackbar(context, '❌ Not enough Credits!');
                }
              }
            },
          ),
        ),
      );
    },
    icon: Image.asset(
      iconAsset,
      width: 30,
      height: 30,
    ),
    label: Text(
      label,
      style: TextStyle(
        fontFamily: 'GameFont',
        fontSize: 14,
        color: Colors.white,
      ),
    ),
  );
}

void _showGachaResultsDialog(
    BuildContext context, List<dynamic> results, bool isCharacter) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black.withOpacity(0.7),
    transitionDuration: Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[900]!.withOpacity(0.9),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.amberAccent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(13)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Summoning Results',
                        style: TextStyle(
                          fontFamily: 'GameFont',
                          fontSize: 20,
                          color: Colors.amberAccent,
                        ),
                      ),
                      Text(
                        '${results.length} Items',
                        style: TextStyle(
                          fontFamily: 'GameFont',
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                // Results Grid
                Flexible(
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.7,
                    ),
                    padding: EdgeInsets.all(16),
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            _calculateCrossAxisCount(context, results.length),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        return isCharacter
                            ? _buildGirlCard(results[index] as GirlFarmer)
                            : _buildEnhancedEquipmentCard(
                                results[index] as Equipment);
                      },
                    ),
                  ),
                ),

                // Close Button
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(13)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 10),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Close',
                          style: TextStyle(
                            fontFamily: 'GameFont',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: animation.drive(Tween(begin: 0.8, end: 1.0).chain(
            CurveTween(curve: Curves.easeOutBack),
          )),
          child: child,
        ),
      );
    },
  );
}

int _calculateCrossAxisCount(BuildContext context, int itemCount) {
  final screenWidth = MediaQuery.of(context).size.width;
  if (screenWidth > 600) {
    return itemCount > 3 ? 4 : itemCount;
  } else {
    return itemCount > 2 ? 3 : itemCount;
  }
}

Widget _buildEnhancedEquipmentCard(Equipment equipment) {
  final rarityColor = _getRarityColor(equipment.rarity);

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: rarityColor.withOpacity(0.1),
      border: Border.all(
        color: rarityColor,
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: rarityColor.withOpacity(0.3),
          blurRadius: 8,
          spreadRadius: 1,
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Rarity indicator
        Container(
          width: 90,
          padding: EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: rarityColor.withOpacity(0.3),
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Text(
            equipment.rarity.toString().split('.').last.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'GameFont',
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Equipment icon
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Icon(
              _getEquipmentIcon(equipment.slot),
              size: 40,
              color: rarityColor,
            ),
          ),
        ),

        // Equipment name
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            equipment.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'GameFont',
              fontSize: 12,
              color: Colors.white,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

Widget _buildGirlCard(GirlFarmer girl) {
  return Column(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          girl.imageFace,
          width: 90,
          height: 90,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(
            Icons.person,
            size: 60,
            color: Colors.white,
          ),
        ),
      ),
      SizedBox(height: 4),
      Text(
        girl.name,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: 'GameFont', color: Colors.white, fontSize: 12),
      ),
    ],
  );
}

IconData _getEquipmentIcon(EquipmentSlot slot) {
  return switch (slot) {
    EquipmentSlot.weapon => Icons.bolt,
    EquipmentSlot.armor => Icons.security,
    EquipmentSlot.accessory => Icons.workspace_premium,
  };
}

Color _getRarityColor(EquipmentRarity rarity) {
  return switch (rarity) {
    EquipmentRarity.common => Colors.grey,
    EquipmentRarity.uncommon => Colors.green,
    EquipmentRarity.rare => Colors.blue,
    EquipmentRarity.epic => Colors.purple,
    EquipmentRarity.legendary => Colors.orange,
    EquipmentRarity.mythic => Colors.red,
  };
}

void _showErrorSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
    ),
  );
}
