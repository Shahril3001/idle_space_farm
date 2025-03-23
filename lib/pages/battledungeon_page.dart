import 'package:flutter/material.dart';
import 'battlepreparation_page.dart';

class DungeonScreen extends StatelessWidget {
  final List<String> difficulties = ["Easy", "Medium", "Hard"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dungeon"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Select Difficulty", style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ...difficulties.map((difficulty) {
              return ElevatedButton(
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
                child: Text(difficulty),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
