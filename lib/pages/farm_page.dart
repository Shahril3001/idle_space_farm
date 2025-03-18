import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/floor_model.dart';
import '../models/girl_farmer_model.dart';
import '../models/farm_model.dart';
import '../providers/game_provider.dart';

class FarmPage extends StatelessWidget {
  final Farm farm; // Selected farm

  const FarmPage({Key? key, required this.farm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final girlFarmers = gameProvider.girlFarmers;

    // Filter out girls who are already assigned to any floor in the farm
    final unassignedGirls = girlFarmers.where((girl) {
      return !farm.floors.any((floor) => floor.assignedGirlId == girl.id);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${farm.name}', // Show the farm name in the title
          style: TextStyle(
            fontFamily: 'GameFont',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        _buildSectionTitle("Girls"),
                        Expanded(
                          child: ListView.builder(
                            itemCount:
                                unassignedGirls.length, // Use filtered list
                            itemBuilder: (context, index) {
                              final girlFarmer = unassignedGirls[index];
                              return Draggable<GirlFarmer>(
                                data: girlFarmer,
                                feedback: _buildDraggableFeedback(girlFarmer),
                                childWhenDragging: _buildGirlCard(
                                    context, girlFarmer,
                                    opacity: 0.5),
                                child: _buildGirlCard(context, girlFarmer),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Column(
                      children: [
                        _buildSectionTitle("Floors"),
                        Expanded(
                          child: ListView.builder(
                            itemCount: farm.floors.length,
                            itemBuilder: (context, index) {
                              final floor = farm.floors[index];
                              final assignedGirl = floor.assignedGirlId != null
                                  ? girlFarmers.firstWhere(
                                      (girl) => girl.id == floor.assignedGirlId)
                                  : null;

                              return DragTarget<GirlFarmer>(
                                onAccept: (girlFarmer) {
                                  gameProvider.assignGirlToFloor(
                                      farm.name, floor.id, girlFarmer.id);
                                },
                                builder:
                                    (context, candidateData, rejectedData) {
                                  return _buildFloorCard(context, floor,
                                      assignedGirl, gameProvider,
                                      highlight: candidateData.isNotEmpty);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildGirlCard(BuildContext context, GirlFarmer girlFarmer,
      {double opacity = 1.0}) {
    return Opacity(
      opacity: opacity,
      child: GestureDetector(
        onTap: () => _showGirlDetails(context, girlFarmer),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(girlFarmer.image),
                  radius: 30,
                ),
                SizedBox(height: 8),
                Text(girlFarmer.name,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDraggableFeedback(GirlFarmer girlFarmer) {
    return Material(
      color: Colors.transparent,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CircleAvatar(
                  backgroundImage: NetworkImage(girlFarmer.image), radius: 25),
              SizedBox(height: 8),
              Text(girlFarmer.name,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloorCard(BuildContext context, Floor floor,
      GirlFarmer? assignedGirl, GameProvider gameProvider,
      {bool highlight = false}) {
    final unlockCost = (150 * pow(2, floor.level - 1)).toInt();
    return Stack(
      children: [
        // Floor Card
        Card(
          color: floor.isUnlocked
              ? (highlight ? Colors.green[300] : Colors.greenAccent)
              : Colors.grey[400], // Locked floors appear dimmed
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Floor ${floor.id}',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Assigned: ${assignedGirl?.name ?? "None"}'),
                Text('Level: ${floor.level}'),
                Text('Unlocked: ${floor.isUnlocked ? "Yes" : "No"}'),
                SizedBox(height: 8),

                // Drag Target to accept girl only if floor is unlocked
                DragTarget<GirlFarmer>(
                  onWillAccept: (data) => floor.isUnlocked,
                  onAccept: (girl) {
                    if (floor.isUnlocked) {
                      gameProvider.assignGirlToFloor(
                          farm.name, floor.id, girl.id);
                    }
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      height: 50,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color:
                                floor.isUnlocked ? Colors.green : Colors.grey,
                            width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        floor.isUnlocked ? 'Drop Here' : 'Locked',
                        style: TextStyle(
                            color:
                                floor.isUnlocked ? Colors.green : Colors.red),
                      ),
                    );
                  },
                ),

                SizedBox(height: 8),
                // Upgrade & Clear buttons (only shown if unlocked)
                if (floor.isUnlocked)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            gameProvider.upgradeFloor(farm.name, floor.id),
                        child: Text('Upgrade'),
                      ),
                      if (floor.assignedGirlId != null)
                        ElevatedButton(
                          onPressed: () {
                            gameProvider.unassignGirlFromFloor(
                                farm.name, floor.id);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: Text('Clear'),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),

        // Lock Overlay for Locked Floors
        if (!floor.isUnlocked)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3), // Semi-transparent overlay
              child: Center(
                child: Icon(Icons.lock, color: Colors.white, size: 40),
              ),
            ),
          ),

        // Unlock Button (Moved Outside Card)
        if (!floor.isUnlocked)
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  // Attempt to unlock the floor
                  final success = gameProvider.unlockFloor(farm.name, floor.id);
                  if (!success) {
                    // Show a message if there are not enough resources
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Not enough minerals to unlock floor!"),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: Text('Unlock (Cost: $unlockCost)'),
              ),
            ),
          ),
      ],
    );
  }

  void _showGirlDetails(BuildContext context, GirlFarmer girlFarmer) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(girlFarmer.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                  backgroundImage: NetworkImage(girlFarmer.image), radius: 40),
              SizedBox(height: 12),
              Text(
                  'Efficiency: ${girlFarmer.miningEfficiency.toStringAsFixed(2)}'),
              Text('Current Farm: ${girlFarmer.assignedFarm ?? "None"}'),
            ],
          ),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Close'))
          ],
        );
      },
    );
  }
}
