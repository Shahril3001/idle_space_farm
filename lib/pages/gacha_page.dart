import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../providers/game_provider.dart';
import '../models/girl_farmer_model.dart';
import '../models/equipment_model.dart';

class GachaMainPage extends StatefulWidget {
  @override
  _GachaMainPageState createState() => _GachaMainPageState();
}

class _GachaMainPageState extends State<GachaMainPage> {
  int _currentPageIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Summoning Altar',
          height: 40,
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ImageCacheManager.getImage('assets/images/ui/app-bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              _buildCustomNavigationBar(),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPageIndex = index;
                    });
                  },
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
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          minimumSize: Size(double.infinity, 50),
        ),
        child: Text("Back",
            style: TextStyle(
                color: Colors.white, fontFamily: 'GameFont', fontSize: 16)),
      ),
    );
  }

  Widget _buildCustomNavigationBar() {
    return Container(
      height: 48,
      color: Colors.black.withOpacity(0.9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNavButton('Girl', 0),
          SizedBox(width: 20),
          _buildNavButton('Equipment', 1),
        ],
      ),
    );
  }

  Widget _buildNavButton(String label, int index) {
    return TextButton(
      onPressed: () {
        setState(() {
          _currentPageIndex = index;
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      },
      style: TextButton.styleFrom(
        foregroundColor:
            _currentPageIndex == index ? Colors.amberAccent : Colors.white,
        textStyle: TextStyle(
          fontFamily: 'GameFont',
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Text(label),
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
      ),
      child: Center(
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
    );
  }
}

class GachaGirlPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    return _buildGachaSection(
      context: context,
      image: Image.asset(
        "assets/images/icons/summon-girl.png",
        width: 150,
        height: 150,
        fit: BoxFit.cover,
      ),
      title: 'Summon Girl',
      subtitle: '💰 10 Credits (1x)\n💰 90 Credits (10x)',
      button1: _buildGachaButton(context, gameProvider, '1x Pull', 1,
          Icons.casino, Color(0xFFCAA04D), true),
      button2: _buildGachaButton(context, gameProvider, '10x Pulls', 10,
          Icons.auto_awesome, Color(0xFFCAA04D), true),
    );
  }
}

class GachaItemPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    return _buildGachaSection(
      context: context,
      image: Image.asset(
        "assets/images/icons/summon-item.png",
        width: 150,
        height: 150,
        fit: BoxFit.cover,
      ),
      title: 'Summon Equipment',
      subtitle: '💰 10 Credits (1x)\n💰 90 Credits (10x)',
      button1: _buildGachaButton(context, gameProvider, '1x Pull', 1,
          Icons.shield, Color(0xFFCAA04D), false),
      button2: _buildGachaButton(context, gameProvider, '10x Pulls', 10,
          Icons.backpack, Color(0xFFCAA04D), false),
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
      ),
      color: Colors.black.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (image != null) image,
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'GameFont',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.amberAccent,
              ),
            ),
            Divider(color: Colors.white54),
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
    IconData icon,
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
    icon: Icon(icon, size: 18, color: Colors.white),
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
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.grey.withOpacity(0.7),
        title: Text(
          'Summoning Results',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'GameFont',
            color: Colors.amberAccent,
          ),
        ),
        content: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                width: results.length > 4 ? 360 : results.length * 80,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    return isCharacter
                        ? _buildGirlCard(results[index] as GirlFarmer)
                        : _buildEquipmentCard(results[index] as Equipment);
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: TextStyle(fontFamily: 'GameFont', color: Colors.white),
            ),
          ),
        ],
      );
    },
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

Widget _buildEquipmentCard(Equipment equipment) {
  return Column(
    children: [
      Container(
        width: 90,
        height: 90,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _getRarityColor(equipment.rarity).withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _getRarityColor(equipment.rarity),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getEquipmentIcon(equipment.slot),
              size: 30,
              color: _getRarityColor(equipment.rarity),
            ),
            SizedBox(height: 4),
            Text(
              equipment.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'GameFont',
                fontSize: 10,
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
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

void _showSuccessSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
    ),
  );
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
