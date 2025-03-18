import 'package:flutter/material.dart';
import '../models/girl_farmer_model.dart';

class GirlFarmerWidget extends StatelessWidget {
  final GirlFarmer girlFarmer;

  const GirlFarmerWidget({required this.girlFarmer});

  @override
  Widget build(BuildContext context) {
    return Draggable<GirlFarmer>(
      data: girlFarmer,
      feedback: Material(
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.pinkAccent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            girlFarmer.name,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
      childWhenDragging: Container(), // Hide when dragging
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.pinkAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          girlFarmer.name,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
