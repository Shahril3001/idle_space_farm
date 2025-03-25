import 'package:flutter/material.dart';
import 'battlepreparation_page.dart';

class DungeonScreen extends StatelessWidget {
  final List<String> difficulties = ["Easy", "Medium", "Hard"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dungeon",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.deepPurple, // Custom app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Select Difficulty",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple, // Consistent theme color
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: difficulties.length,
                separatorBuilder: (context, index) => SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final difficulty = difficulties[index];
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to PreparationScreen with selected difficulty
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PreparationScreen(difficulty: difficulty),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getDifficultyColor(
                            difficulty), // Custom button color
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        shadowColor: Colors.deepPurple.withOpacity(0.3),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getDifficultyIcon(difficulty),
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: 10),
                          Text(
                            difficulty,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to get difficulty-specific colors
  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case "Easy":
        return Colors.green;
      case "Medium":
        return Colors.orange;
      case "Hard":
        return Colors.red;
      default:
        return Colors.deepPurple;
    }
  }

  // Helper function to get difficulty-specific icons
  IconData _getDifficultyIcon(String difficulty) {
    switch (difficulty) {
      case "Easy":
        return Icons.thumb_up;
      case "Medium":
        return Icons.warning;
      case "Hard":
        return Icons.whatshot;
      default:
        return Icons.help_outline;
    }
  }
}
