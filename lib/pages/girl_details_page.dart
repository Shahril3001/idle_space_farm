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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Character Portrait with Glow Effect
                _buildCharacterPortrait(),
                SizedBox(height: 10),
                _buildCharacterName(),
                SizedBox(height: 20),

                // Stats with Bars
                _buildStatSection(),
                SizedBox(height: 20),

                // Attributes Section
                _buildAttributesSection(),
                SizedBox(height: 20),

                // Interactive Buttons
                _buildActionButtons(context, gameProvider),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBackButton(context),
      ),
    );
  }

  Widget _buildCharacterPortrait() {
    return Hero(
      tag: 'girl-image-${girl.id}',
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/glow_effect.png',
            width: 180,
            height: 180,
          ),
          CircleAvatar(
            radius: 100,
            backgroundImage: AssetImage(girl.image),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterName() {
    return Text(
      girl.name,
      style: TextStyle(
        fontFamily: 'GameFont',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
          Shadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 5,
            offset: Offset(2, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildStatSection() {
    return Column(
      children: [
        _buildStatBar("HP", girl.hp, Colors.red, Icons.favorite),
        _buildStatBar("MP", girl.mp, Colors.blue, Icons.bolt),
        _buildStatBar("SP", girl.sp, Colors.green, Icons.flash_on),
      ],
    );
  }

  Widget _buildStatBar(String label, int value, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: color),
          SizedBox(width: 10),
          Text('$label:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              )),
          SizedBox(width: 10),
          Expanded(
            child: LinearProgressIndicator(
              value: value / 100, // Assuming max value is 100
              backgroundColor: Colors.grey[800],
              color: color,
              minHeight: 12,
            ),
          ),
          SizedBox(width: 10),
          Text(value.toString(),
              style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildAttributesSection() {
    return Card(
      elevation: 5,
      color: Colors.black54,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildAttributeRow(Icons.star, 'Level', "${girl.level}"),
            _buildAttributeRow(
                Icons.shield, 'Defense', "${girl.defensePoints}"),
            _buildAttributeRow(
                Icons.directions_run, 'Agility', "${girl.agilityPoints}"),
            _buildAttributeRow(Icons.gavel, 'Attack', "${girl.attackPoints}"),
            _buildStarRating(girl.stars),
          ],
        ),
      ),
    );
  }

  Widget _buildAttributeRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(width: 10),
        Text("$label: ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        Spacer(),
        Text(value, style: TextStyle(fontSize: 16, color: Colors.amberAccent)),
      ],
    );
  }

  Widget _buildStarRating(int stars) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Icon(
          index < stars ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 22,
        );
      }),
    );
  }

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

  Widget _buildBackButton(BuildContext context) {
    return Container(
      color: Colors.transparent, // Make the container transparent
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          "Back",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'GameFont',
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Colors.grey[800]!.withOpacity(0.8), // Semi-transparent background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        ),
      ),
    );
  }

  void _showFeedback(BuildContext context, bool success, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? '$name upgraded! 🎉' : '❌ Not enough resources!',
          style: TextStyle(fontFamily: 'GameFont'),
        ),
        backgroundColor: success ? Colors.green : Colors.red,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

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
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
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
