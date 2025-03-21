import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No AppBar
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/ui/castle.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Settings Icon Button at Top Right (using image asset)
            Positioned(
              top: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: () {
                  // Add button functionality here
                  print('Button pressed');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.black.withOpacity(0.8), // Button background color
                  padding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12), // Button padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // Ensure the Column takes only the space it needs
                  children: [
                    Image.asset(
                      'assets/images/icons/settings.png', // Path to icon image
                      width: 30,
                      height: 30,
                    ),
                    SizedBox(height: 2), // Space between icon and text
                    Text(
                      'Setting',
                      style: TextStyle(
                        color: Colors.white, // Text color
                        fontSize: 12, // Text weight
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Icon Button at Bottom Left (using image asset)
            Positioned(
              bottom: 16,
              left: 16,
              child: ElevatedButton(
                onPressed: () {
                  // Add button functionality here
                  print('Button pressed');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.black.withOpacity(0.8), // Button background color
                  padding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12), // Button padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // Ensure the Column takes only the space it needs
                  children: [
                    Image.asset(
                      'assets/images/icons/settings.png', // Path to icon image
                      width: 30,
                      height: 30,
                    ),
                    SizedBox(height: 2), // Space between icon and text
                    Text(
                      'Setting',
                      style: TextStyle(
                        color: Colors.white, // Text color
                        fontSize: 12, // Text weight
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Icon Button at Bottom Right (using image asset)
            Positioned(
              bottom: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: () {
                  // Add button functionality here
                  print('Button pressed');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.black.withOpacity(0.8), // Button background color
                  padding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12), // Button padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // Ensure the Column takes only the space it needs
                  children: [
                    Image.asset(
                      'assets/images/icons/battle.png', // Path to icon image
                      width: 30,
                      height: 30,
                    ),
                    SizedBox(height: 2), // Space between icon and text
                    Text(
                      'Dungeon',
                      style: TextStyle(
                        color: Colors.white, // Text color
                        fontSize: 12, // Text weight
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
