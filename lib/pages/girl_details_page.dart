import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/girl_farmer_model.dart';
import '../providers/game_provider.dart';

class GirlDetailsPage extends StatelessWidget {
  final GirlFarmer girl;

  const GirlDetailsPage({Key? key, required this.girl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/ui/app-bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildCharacterPortrait(),
                SizedBox(height: 10),
                _buildCharacterName(),
                SizedBox(height: 10),
                _buildStatSection(), // Custom stat icons
                SizedBox(height: 10),
                _buildAttributesSection(), // Custom attribute icons
                SizedBox(height: 10),
                _buildActionButtons(context, gameProvider),
                Spacer(),
                _buildBackButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Character portrait with glowing effect
  Widget _buildCharacterPortrait() {
    return Hero(
      tag: 'girl-image-${girl.id}',
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/images/ui/glow_effect.png',
              width: 180, height: 180),
          CircleAvatar(radius: 100, backgroundImage: AssetImage(girl.image)),
        ],
      ),
    );
  }

  /// Character name styling
  Widget _buildCharacterName() {
    return Text(
      girl.name,
      style: TextStyle(
        fontFamily: 'GameFont',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
          Shadow(color: Colors.black, blurRadius: 5, offset: Offset(2, 2))
        ],
      ),
    );
  }

  /// Stat Section with custom icons
  Widget _buildStatSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatBox(
            "HP", girl.hp, Colors.redAccent, 'assets/images/icons/healthp.png'),
        _buildStatBox(
            "MP", girl.mp, Colors.blueAccent, 'assets/images/icons/manap.png'),
        _buildStatBox("SP", girl.sp, Colors.greenAccent,
            'assets/images/icons/specialp.png'),
      ],
    );
  }

  /// Custom stat box with image icons
  Widget _buildStatBox(String label, int value, Color color, String iconPath) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Image.asset(iconPath, width: 30, height: 30), // Custom icon
          SizedBox(height: 5),
          Text(label,
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold, color: color)),
          SizedBox(height: 5),
          Container(
            width: 80,
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(8), // Adjust the radius as needed
              child: LinearProgressIndicator(
                value: value / value, // Ensure `maxValue` is defined
                backgroundColor: Colors.grey[800],
                color: color,
                minHeight: 12,
              ),
            ),
          ),

          SizedBox(height: 5),
          Text(value.toString(),
              style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }

  /// Attributes section with custom icons
  Widget _buildAttributesSection() {
    return Card(
      elevation: 5,
      color: Colors.black.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildStarRating(girl.stars),
            SizedBox(height: 10),
            _buildAttributeRow(
                'assets/images/icons/level.png', 'Level', "${girl.level}"),
            SizedBox(height: 10),
            _buildAttributeRow('assets/images/icons/defense.png', 'Defense',
                "${girl.defensePoints}"),
            SizedBox(height: 10),
            _buildAttributeRow('assets/images/icons/agility.png', 'Agility',
                "${girl.agilityPoints}"),
            SizedBox(height: 10),
            _buildAttributeRow('assets/images/icons/attack.png', 'Attack',
                "${girl.attackPoints}"),
          ],
        ),
      ),
    );
  }

  /// Custom attribute row with image icons
  Widget _buildAttributeRow(String iconPath, String label, String value) {
    return Row(
      children: [
        Image.asset(iconPath, width: 24, height: 24), // Custom icon
        SizedBox(width: 10),
        Text("$label:",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        Spacer(),
        Text(value, style: TextStyle(fontSize: 16, color: Colors.amberAccent)),
      ],
    );
  }

  Widget _buildStarRating(int stars) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Icon(index < stars ? Icons.star : Icons.star_border,
            color: Color(0xFFCAA04D), size: 22);
      }),
    );
  }

  /// Action buttons (Upgrade, Sell)
  Widget _buildActionButtons(BuildContext context, GameProvider gameProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton("Upgrade", Icons.arrow_upward, Colors.purple, () {
          bool success = gameProvider.upgradeGirl(girl.id);
          _showFeedback(context, success, girl.name);
        }),
        SizedBox(width: 20),
        _buildButton("Sell", Icons.sell, Colors.red, () {
          _confirmSell(context, gameProvider, girl);
        }),
      ],
    );
  }

  Widget _buildButton(
      String text, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(text, style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }

  /// Back button
  Widget _buildBackButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        child: Text("Back",
            style: TextStyle(
                color: Colors.white, fontFamily: 'GameFont', fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  /// Show upgrade/sell feedback
  void _showFeedback(BuildContext context, bool success, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            success ? '$name upgraded! 🎉' : '❌ Not enough resources!',
            style: TextStyle(fontFamily: 'GameFont')),
        backgroundColor: success ? Colors.green : Colors.red,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Confirm sell dialog
  void _confirmSell(
      BuildContext context, GameProvider gameProvider, GirlFarmer girl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sell ${girl.name}?'),
          content: Text('Are you sure you want to sell ${girl.name}?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(color: Colors.grey))),
            ElevatedButton(
              onPressed: () {
                gameProvider.sellGirl(girl.id);
                Navigator.pop(context);
                _showFeedback(context, true, '${girl.name} sold! 💰');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Sell', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
