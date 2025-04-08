import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/equipment_model.dart';
import '../providers/game_provider.dart';
import 'equipment_details_page.dart';

class EquipmentListPage extends StatefulWidget {
  @override
  _EquipmentListPageState createState() => _EquipmentListPageState();
}

class _EquipmentListPageState extends State<EquipmentListPage> {
  String _sortBy = 'Rarity';
  String _filterQuery = '';
  EquipmentSlot? _selectedSlot;
  EquipmentRarity? _selectedRarity;
  bool _showAssignedOnly = false;

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    List<Equipment> equipmentList = gameProvider.equipment;

    // Apply filters
    if (_filterQuery.isNotEmpty) {
      equipmentList = equipmentList
          .where((eq) =>
              eq.name.toLowerCase().contains(_filterQuery.toLowerCase()))
          .toList();
    }

    if (_selectedSlot != null) {
      equipmentList =
          equipmentList.where((eq) => eq.slot == _selectedSlot).toList();
    }

    if (_selectedRarity != null) {
      equipmentList =
          equipmentList.where((eq) => eq.rarity == _selectedRarity).toList();
    }

    if (_showAssignedOnly) {
      equipmentList =
          equipmentList.where((eq) => eq.assignedTo != null).toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'Rarity':
        equipmentList.sort((a, b) => b.rarity.index.compareTo(a.rarity.index));
        break;
      case 'Name':
        equipmentList.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Level':
        equipmentList
            .sort((a, b) => b.enhancementLevel.compareTo(a.enhancementLevel));
        break;
    }

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Equipment',
          height: 40,
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ImageCacheManager.getImage('assets/images/ui/app-bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                _buildFilterControls(),
                Expanded(
                  child: equipmentList.isEmpty
                      ? Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'No equipment available.',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ),
                        )
                      : GridView.builder(
                          physics: BouncingScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: equipmentList.length,
                          itemBuilder: (context, index) {
                            final equipment = equipmentList[index];
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EquipmentDetailsPage(
                                      equipment: equipment),
                                ),
                              ),
                              child: Card(
                                color: Colors.black.withOpacity(0.8),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color:
                                              _getRarityColor(equipment.rarity)
                                                  .withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          border: Border.all(
                                            color: _getRarityColor(
                                                equipment.rarity),
                                            width: 2,
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            _getSlotIcon(equipment.slot),
                                            color: _getRarityColor(
                                                equipment.rarity),
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        equipment.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              _getRarityColor(equipment.rarity),
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        _getSlotName(equipment.slot),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      if (equipment.enhancementLevel > 0)
                                        Text(
                                          '+${equipment.enhancementLevel}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.amber,
                                          ),
                                        ),
                                      if (equipment.assignedTo != null)
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 16,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                _buildBackButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFCAA04D),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          minimumSize: Size(double.infinity, 50),
        ),
        child: Text("Back",
            style: TextStyle(
                color: Colors.white, fontFamily: 'GameFont', fontSize: 16)),
      ),
    );
  }

  Widget _buildFilterControls() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.search, color: Colors.black),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    ),
                    style: TextStyle(color: Colors.black),
                    onChanged: (value) => setState(() => _filterQuery = value),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFCAA04D),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: DropdownButton<String>(
                  value: _sortBy,
                  onChanged: (String? newValue) =>
                      setState(() => _sortBy = newValue!),
                  items: ['Rarity', 'Name', 'Level'].map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  dropdownColor: Color(0xFFCAA04D),
                  icon: Icon(Icons.sort, color: Colors.white),
                  underline: SizedBox(),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFCAA04D),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: DropdownButton<EquipmentSlot>(
                    value: _selectedSlot,
                    hint: Text('All Slots',
                        style: TextStyle(color: Colors.white)),
                    onChanged: (EquipmentSlot? newValue) =>
                        setState(() => _selectedSlot = newValue),
                    items: EquipmentSlot.values.map((slot) {
                      return DropdownMenuItem(
                        value: slot,
                        child: Text(
                          _getSlotName(slot),
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    dropdownColor: Color(0xFFCAA04D),
                    icon: Icon(Icons.category, color: Colors.white),
                    underline: SizedBox(),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFCAA04D),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: DropdownButton<EquipmentRarity>(
                    value: _selectedRarity,
                    hint: Text('All Rarities',
                        style: TextStyle(color: Colors.white)),
                    onChanged: (EquipmentRarity? newValue) =>
                        setState(() => _selectedRarity = newValue),
                    items: EquipmentRarity.values.map((rarity) {
                      return DropdownMenuItem(
                        value: rarity,
                        child: Text(
                          rarity.toString().split('.').last,
                          style: TextStyle(color: _getRarityColor(rarity)),
                        ),
                      );
                    }).toList(),
                    dropdownColor: Color(0xFFCAA04D),
                    icon: Icon(Icons.star, color: Colors.white),
                    underline: SizedBox(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Checkbox(
                value: _showAssignedOnly,
                onChanged: (value) =>
                    setState(() => _showAssignedOnly = value ?? false),
                activeColor: Color(0xFFCAA04D),
              ),
              Text(
                'Show Assigned Only',
                style: TextStyle(color: Colors.white),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.refresh, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _filterQuery = '';
                    _selectedSlot = null;
                    _selectedRarity = null;
                    _showAssignedOnly = false;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getRarityColor(EquipmentRarity rarity) {
    return switch (rarity) {
      EquipmentRarity.common => Colors.grey,
      EquipmentRarity.uncommon => Colors.green,
      EquipmentRarity.rare => Colors.blue,
      EquipmentRarity.epic => Colors.purple,
      EquipmentRarity.legendary => Colors.orange,
      EquipmentRarity.mythic => Colors.red,
    };
  }

  String _getSlotName(EquipmentSlot slot) {
    return slot.toString().split('.').last;
  }

  IconData _getSlotIcon(EquipmentSlot slot) {
    return switch (slot) {
      EquipmentSlot.weapon => Icons.sports_martial_arts,
      EquipmentSlot.armor => Icons.security,
      EquipmentSlot.accessory => Icons.emoji_events,
    };
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
