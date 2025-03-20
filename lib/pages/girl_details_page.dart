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
              image: AssetImage("assets/background_status.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Character Portrait with Glow Effect
                Hero(
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
                ),
                SizedBox(height: 10),
                Text(
                  girl.name,
                  style: TextStyle(
                      fontFamily: 'GameFont',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 20),

                // Stats with Bars
                _buildStatBar("HP", girl.hp, Colors.red, Icons.favorite),
                _buildStatBar("MP", girl.mp, Colors.blue, Icons.bolt),
                _buildStatBar("SP", girl.sp, Colors.green, Icons.flash_on),
                SizedBox(height: 20),

                // Attributes Section
                _buildAttributes(),
                SizedBox(height: 20),

                // Interactive Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButton("Upgrade", Icons.arrow_upward, Colors.purple,
                        () {
                      bool success = gameProvider.upgradeGirl(girl.id);
                      _showFeedback(context, success, girl.name);
                    }),
                    SizedBox(width: 20),
                    _buildButton("Sell", Icons.sell, Colors.red, () {
                      _confirmSell(context, gameProvider, girl);
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Back"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[800],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ),
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
                  fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          SizedBox(width: 10),
          Expanded(
            child: LinearProgressIndicator(
              value: 1.0, // Always full
              backgroundColor: Colors.grey[800],
              color: color,
              minHeight: 12,
            ),
          ),
          SizedBox(width: 10),
          Text(value.toString(), style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildAttributes() {
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

  Widget _buildButton(
      String text, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(text, style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
        return Icon(
          index < stars ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 22,
        );
      }),
    );
  }

  void _showFeedback(BuildContext context, bool success, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(success ? '$name upgraded! 🎉' : '❌ Not enough resources!'),
        backgroundColor: success ? Colors.green : Colors.red,
        duration: Duration(seconds: 2),
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
                onPressed: () => Navigator.pop(context), child: Text('Cancel')),
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
