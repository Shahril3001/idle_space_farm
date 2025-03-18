import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/farm_model.dart';
import '../providers/game_provider.dart';
import 'farm_page.dart'; // Import the farm page

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final farms = gameProvider.farms;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Map',
          style: TextStyle(
            fontFamily: 'GameFont', // Use a custom font
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple, // Match the game theme
        elevation: 10,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple, Colors.purpleAccent],
          ),
        ),
        child: InteractiveViewer(
          boundaryMargin: EdgeInsets.all(20),
          minScale: 0.5,
          maxScale: 4.0,
          child: Center(
            child: Stack(
              children: farms.map((farm) {
                return Positioned(
                  left: farm.position.dx,
                  top: farm.position.dy,
                  child: Container(
                    color: Colors
                        .transparent, // Ensure the container is transparent
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque, // Add this line
                      onTap: () {
                        print("DEBUG: Tapped farm - ${farm.name}");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FarmPage(farm: farm),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Icon(Icons.location_on, size: 40, color: Colors.red),
                          Text(
                            farm.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
