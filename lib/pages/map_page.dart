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
      appBar: CustomAppBar(
        title: 'Eldoria Map',
        height: 40, // Adjust the height of the custom app bar
        padding: EdgeInsets.zero, // Custom padding
        margin: EdgeInsets.zero, // Custom margin
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          panEnabled: true, // Allow panning
          constrained: false, // Let the content be larger than the screen
          child: Stack(
            children: [
              // Map Image as the Background
              Image.asset(
                "assets/images/map/eldoria_map.png",
                width: 1500, // Large width for scrolling
                height: 1500, // Large height for scrolling
                fit: BoxFit.cover,
              ),

              // Overlay the farm locations
              ...farms.map((farm) {
                return Positioned(
                  left: farm.position.dx,
                  top: farm.position.dy,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _showFarmDetails(context, farm),
                    child: Column(
                      children: [
                        Icon(Icons.location_on,
                            size: 60, color: Colors.red), // Bigger Icon
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            farm.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18, // Bigger Text
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  void _showFarmDetails(BuildContext context, Farm farm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(farm.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Resource: ${farm.resourceType}"),
              Text("Production: ${farm.resourcePerSecond} per sec"),
              Text("Level: ${farm.level}"),
              Text("Upgrade Cost: ${farm.upgradeCost}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FarmPage(farm: farm)),
                );
              },
              child: Text("Go to Farm"),
            ),
          ],
        );
      },
    );
  }
}

// Custom App Bar Implementation
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.height = 56.0, // Default height similar to AppBar
    this.padding = EdgeInsets.zero, // Custom padding
    this.margin = EdgeInsets.zero, // Custom margin
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: padding, // Apply custom padding
      margin: margin, // Apply custom margin
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
