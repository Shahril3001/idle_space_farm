import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/equipment_model.dart';
import '../models/girl_farmer_model.dart';
import '../providers/game_provider.dart';

class EquipmentDetailsPage extends StatefulWidget {
  final Equipment equipment;

  const EquipmentDetailsPage({Key? key, required this.equipment})
      : super(key: key);

  @override
  _EquipmentDetailsPageState createState() => _EquipmentDetailsPageState();
}

class _EquipmentDetailsPageState extends State<EquipmentDetailsPage> {
  late Equipment _equipment;
  GirlFarmer? _currentlyAssignedGirl;

  @override
  void initState() {
    super.initState();
    _equipment = widget.equipment;
    _loadAssignedGirl();
  }

  void _loadAssignedGirl() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    if (_equipment.assignedTo != null) {
      _currentlyAssignedGirl = gameProvider.girlFarmers.firstWhere(
        (girl) => girl.id == _equipment.assignedTo,
        orElse: () => null as GirlFarmer,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final credits = gameProvider.getCredits();
    final enhancementCost = _calculateEnhancementCost();

    return Scaffold(
      appBar: AppBar(
        title: Text('Equipment Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/ui/app-bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Equipment Card
                Card(
                  color: Colors.black.withOpacity(0.8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Equipment Icon
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: _getRarityColor(_equipment.rarity)
                                    .withOpacity(0.3),
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                  color: _getRarityColor(_equipment.rarity),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  _getSlotIcon(_equipment.slot),
                                  color: _getRarityColor(_equipment.rarity),
                                  size: 40,
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            // Equipment Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _equipment.name,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: _getRarityColor(_equipment.rarity),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${_getSlotName(_equipment.slot)} • ${_equipment.rarity.toString().split('.').last}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  if (_equipment.enhancementLevel > 0)
                                    Text(
                                      'Enhancement: +${_equipment.enhancementLevel}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.amber,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        // Assigned Info
                        if (_currentlyAssignedGirl != null)
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage(
                                      _currentlyAssignedGirl!.imageFace),
                                  radius: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Equipped by: ${_currentlyAssignedGirl!.name}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Stats Section
                Card(
                  color: Colors.black.withOpacity(0.8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Stats',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        _buildStatRow('Attack', _equipment.attackBonus,
                            _equipment.scaledAttack),
                        _buildStatRow('Defense', _equipment.defenseBonus,
                            _equipment.scaledDefense),
                        _buildStatRow(
                            'HP', _equipment.hpBonus, _equipment.scaledHp),
                        _buildStatRow('Agility', _equipment.agilityBonus,
                            _equipment.scaledAgility),
                        if (_equipment.mpBonus > 0)
                          _buildStatRow(
                              'MP', _equipment.mpBonus, _equipment.scaledMp),
                        if (_equipment.spBonus > 0)
                          _buildStatRow(
                              'SP', _equipment.spBonus, _equipment.scaledSp),
                        if (_equipment.criticalPoint > 0)
                          _buildStatRow('Crit %', _equipment.criticalPoint,
                              _equipment.scaledCriticalPoint),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Action Buttons
                if (_currentlyAssignedGirl == null)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFCAA04D),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => _showEquipDialog(gameProvider),
                    child: Text('EQUIP', style: TextStyle(fontSize: 16)),
                  ),
                if (_currentlyAssignedGirl != null)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => _unequipItem(gameProvider),
                    child: Text('UNEQUIP', style: TextStyle(fontSize: 16)),
                  ),
                SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () =>
                      _enhanceEquipment(gameProvider, enhancementCost),
                  child: Column(
                    children: [
                      Text('ENHANCE (+1)', style: TextStyle(fontSize: 16)),
                      Text(
                        'Cost: ${enhancementCost.toInt()} Credits',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[800],
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () => _showSellDialog(gameProvider),
                  child: Text('SELL', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, int baseValue, int scaledValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(color: Colors.white70),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '$baseValue',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '→',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '$scaledValue',
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateEnhancementCost() {
    return 100 *
        (_equipment.enhancementLevel + 1) *
        (_equipment.rarity.index + 1);
  }

  double _calculateSellValue() {
    double value = switch (_equipment.rarity) {
      EquipmentRarity.common => 50,
      EquipmentRarity.uncommon => 100,
      EquipmentRarity.rare => 250,
      EquipmentRarity.epic => 500,
      EquipmentRarity.legendary => 1000,
      EquipmentRarity.mythic => 2500,
    };
    return value * (1 + _equipment.enhancementLevel * 0.5);
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

  void _showEquipDialog(GameProvider gameProvider) {
    final availableGirls = gameProvider.girlFarmers.where((girl) {
      final typeMatch = _equipment.allowedTypes.isEmpty ||
          _equipment.allowedTypes.contains(girl.type);
      final raceMatch = _equipment.allowedTypes.isEmpty ||
          _equipment.allowedRaces.contains(girl.race);
      return typeMatch && raceMatch;
    }).toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Equip to which girl?'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: availableGirls.length,
              itemBuilder: (context, index) {
                final girl = availableGirls[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(girl.imageFace),
                  ),
                  title: Text(girl.name),
                  subtitle: Text('Lv. ${girl.level} ${girl.type}'),
                  onTap: () {
                    Navigator.pop(context);
                    _equipItem(gameProvider, girl);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _equipItem(GameProvider gameProvider, GirlFarmer girl) {
    final equippedItems = gameProvider.equipment
        .where((eq) => eq.assignedTo == girl.id && eq.slot == _equipment.slot)
        .toList();

    for (var item in equippedItems) {
      item.assignedTo = null;
      gameProvider.updateEquipment(item);
    }

    setState(() {
      _equipment.assignedTo = girl.id;
      _currentlyAssignedGirl = girl;
    });
    gameProvider.updateEquipment(_equipment);

    _showResultDialog(
      'Success',
      '${_equipment.name} equipped to ${girl.name}',
    );
  }

  void _unequipItem(GameProvider gameProvider) {
    setState(() {
      _equipment.assignedTo = null;
      _currentlyAssignedGirl = null;
    });
    gameProvider.updateEquipment(_equipment);

    _showResultDialog(
      'Success',
      '${_equipment.name} unequipped',
    );
  }

  void _enhanceEquipment(GameProvider gameProvider, double cost) {
    if (gameProvider.getCredits() < cost) {
      _showResultDialog(
        'Error',
        'Not enough credits to enhance!',
        isError: true,
      );
      return;
    }

    if (_equipment.enhancementLevel >= 5) {
      _showResultDialog(
        'Error',
        'Maximum enhancement level reached!',
        isError: true,
      );
      return;
    }

    gameProvider.exchangeResources('Credits', 'Credits', cost, 0);
    setState(() {
      _equipment.enhancementLevel++;
    });
    gameProvider.updateEquipment(_equipment);

    _showResultDialog(
      'Success',
      '${_equipment.name} enhanced to +${_equipment.enhancementLevel}!',
    );
  }

  void _showSellDialog(GameProvider gameProvider) {
    final sellValue = _calculateSellValue();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Sale'),
          content:
              Text('Sell ${_equipment.name} for ${sellValue.toInt()} credits?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _sellItem(gameProvider, sellValue);
              },
              child: Text('Sell', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _sellItem(GameProvider gameProvider, double sellValue) {
    if (_equipment.assignedTo != null) {
      _unequipItem(gameProvider);
    }

    gameProvider.exchangeResources('Credits', 'Credits', -sellValue, sellValue);
    gameProvider.deleteEquipment(_equipment.id);

    Navigator.pop(context); // Return to previous screen

    _showResultDialog(
      'Success',
      'Sold ${_equipment.name} for ${sellValue.toInt()} credits',
    );
  }

  void _showResultDialog(String title, String message, {bool isError = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
