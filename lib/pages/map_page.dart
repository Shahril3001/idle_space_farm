import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/farm_model.dart';
import '../providers/game_provider.dart';
import 'farm_page.dart'; // Import the farm page

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late TransformationController _controller;
  bool _initialized = false;

  final double mapWidth = 1500;
  final double mapHeight = 1500;

  @override
  void initState() {
    super.initState();
    _controller = TransformationController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _centerMap();
      _initialized = true;
    }
  }

  void _centerMap() {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    // Calculate the required translation to center the map
    double offsetX = (screenWidth / 2) - (mapWidth / 2);
    double offsetY = (screenHeight / 2) - (mapHeight / 2);

    _controller.value = Matrix4.identity()..translate(offsetX, offsetY);
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final farms = gameProvider.farms;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Eldoria Map',
        height: 40,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
      ),
      body: Center(
        child: InteractiveViewer(
          transformationController: _controller, // Center the map on load
          minScale: 0.5,
          maxScale: 4.0,
          panEnabled: true,
          constrained: false,
          child: Stack(
            children: [
              Image(
                image: ImageCacheManager.getImage(
                    "assets/images/map/eldoria_map.png"),
                width: mapWidth,
                height: mapHeight,
                fit: BoxFit.cover,
              ),
              ...farms.map((farm) {
                return Positioned(
                  left: farm.position.dx,
                  top: farm.position.dy,
                  child: GestureDetector(
                    onTap: () => _showFarmDetails(context, farm),
                    child: Column(
                      children: [
                        Icon(Icons.location_on, size: 60, color: Colors.red),
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
                              fontSize: 18,
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
          backgroundColor: Colors.white,
          title: Text(
            farm.name,
            style: TextStyle(color: Colors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Resource: ${farm.resourceType}",
                  style: TextStyle(color: Colors.black)),
              Text("Production: ${farm.resourcePerSecond} per sec",
                  style: TextStyle(color: Colors.black)),
              Text("Level: ${farm.level}",
                  style: TextStyle(color: Colors.black)),
              Text("Upgrade Cost: ${farm.upgradeCost}",
                  style: TextStyle(color: Colors.black)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close", style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FarmPage(farm: farm)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFCAA04D),
              ),
              child: Text("Go to Farm", style: TextStyle(color: Colors.white)),
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
