import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/girl_farmer_model.dart';

class GachaMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Gacha System',
            style: TextStyle(
              fontFamily: 'GameFont', // Use a custom font
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.face)), // Icon for Girls
              Tab(icon: Icon(Icons.shopping_bag)), // Icon for Items
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.deepPurple, Colors.purpleAccent],
            ),
          ),
          child: TabBarView(
            children: [
              GachaGirlPage(),
              GachaItemPage(),
            ],
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

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Gacha Cost',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  Text(
                    '💰 10 Credits (1x)\n💰 90 Credits (10x)',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          _buildGachaButton(
              context, gameProvider, '1x Pull', 1, Icons.casino, Colors.blue),
          SizedBox(height: 10),
          _buildGachaButton(context, gameProvider, '10x Pull', 10,
              Icons.auto_awesome, Colors.purple),
        ],
      ),
    );
  }

  Widget _buildGachaButton(BuildContext context, GameProvider gameProvider,
      String label, int pulls, IconData icon, Color color) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          backgroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      onPressed: () {
        final girls = gameProvider.performGachaGirl(pulls: pulls);
        if (girls.isNotEmpty) {
          for (var girl in girls) {
            gameProvider.addGirl(girl);
          }
          // Show a popup dialog with the results
          _showGachaResultsDialog(context, girls);
        } else {
          // Show an error dialog if not enough credits
          _showErrorDialog(context, 'Not enough Credits!');
        }
      },
      icon: Icon(icon, size: 24),
      label: Text(label, style: TextStyle(fontSize: 18)),
    );
  }

  // Function to show the gacha results in a popup dialog
  void _showGachaResultsDialog(BuildContext context, List<GirlFarmer> girls) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('✨ Gacha Results ✨'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('You got ${girls.length} girl(s):'),
                SizedBox(height: 10),
                ...girls.map((girl) {
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        girl.image,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.person, size: 40),
                      ),
                    ),
                    title: Text(girl.name),
                    subtitle: Text('${girl.rarity} - ⭐${girl.stars}'),
                  );
                }).toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Function to show an error dialog
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('❌ Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class GachaItemPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Gacha Cost',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  Text(
                    '💰 10 Credits (1x)\n💰 90 Credits (10x)',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          _buildGachaButton(
              context, gameProvider, '1x Pull', 1, Icons.casino, Colors.green),
          SizedBox(height: 10),
          _buildGachaButton(context, gameProvider, '10x Pull', 10,
              Icons.auto_awesome, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildGachaButton(BuildContext context, GameProvider gameProvider,
      String label, int pulls, IconData icon, Color color) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          backgroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      onPressed: () {
        final items = gameProvider.performEquipmentGacha(pulls: pulls);
        if (items.isNotEmpty) {
          for (var item in items) {
            gameProvider.addEquipment(item);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✨ You got ${items.length} item(s)!'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Not enough Credits!'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      icon: Icon(icon, size: 24),
      label: Text(label, style: TextStyle(fontSize: 18)),
    );
  }
}
