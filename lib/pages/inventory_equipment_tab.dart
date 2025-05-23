import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/equipment_model.dart';
import '../models/girl_farmer_model.dart';
import '../providers/game_provider.dart';

class EquipmentTab extends StatefulWidget {
  @override
  _EquipmentTabState createState() => _EquipmentTabState();
}

class _EquipmentTabState extends State<EquipmentTab> {
  String _sortBy = 'Rarity';
  EquipmentSlot? _selectedSlot;
  EquipmentRarity? _selectedRarity;
  bool _showAssignedOnly = false;

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    List<Equipment> equipmentList =
        _applyFiltersAndSorting(gameProvider.equipment);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          _buildFilterControls(),
          Expanded(
            child: equipmentList.isEmpty
                ? _buildEmptyState()
                : _buildEquipmentGrid(equipmentList),
          ),
        ],
      ),
    );
  }

  List<Equipment> _applyFiltersAndSorting(List<Equipment> equipmentList) {
    // Apply filters
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

    return equipmentList;
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          'No equipment available.',
          style: TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildEquipmentGrid(List<Equipment> equipmentList) {
    return GridView.builder(
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
              builder: (context) => EquipmentDetailsPage(equipment: equipment),
            ),
          ),
          child: Card(
            color: Colors.black.withOpacity(0.8),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _getRarityColor(equipment.rarity).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: _getRarityColor(equipment.rarity),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Image.asset(
                        equipment.imageEquip ??
                            'assets/images/equipments/default_icon.png',
                        width: 70,
                        height: 70,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    equipment.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getRarityColor(equipment.rarity),
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _getSlotName(equipment.slot),
                    style: TextStyle(fontSize: 10, color: Colors.white70),
                  ),
                  if (equipment.enhancementLevel > 0)
                    Text(
                      '+${equipment.enhancementLevel}',
                      style: TextStyle(fontSize: 12, color: Colors.amber),
                    ),
                  if (equipment.assignedTo != null)
                    Icon(Icons.check_circle, color: Colors.green, size: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterControls() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFilterDropdown<EquipmentSlot>(
                value: _selectedSlot,
                hint: 'All Slots',
                items: EquipmentSlot.values,
                itemBuilder: (slot) => _getSlotName(slot),
                onChanged: (value) => setState(() => _selectedSlot = value),
                icon: Icons.category,
              ),
              _buildFilterDropdown<EquipmentRarity>(
                value: _selectedRarity,
                hint: 'All Rarities',
                items: EquipmentRarity.values,
                itemBuilder: (rarity) => rarity.toString().split('.').last,
                onChanged: (value) => setState(() => _selectedRarity = value),
                icon: Icons.star,
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSortDropdown(),
              Row(
                children: [
                  Checkbox(
                    value: _showAssignedOnly,
                    onChanged: (value) =>
                        setState(() => _showAssignedOnly = value ?? false),
                    activeColor: Color(0xFFCAA04D),
                  ),
                  Text('Assigned Only', style: TextStyle(color: Colors.black)),
                ],
              ),
              IconButton(
                icon: Icon(Icons.refresh, color: Colors.black),
                onPressed: _resetFilters,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown<T>({
    required T? value,
    required String hint,
    required List<T> items,
    required String Function(T) itemBuilder,
    required void Function(T?) onChanged,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFCAA04D),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButton<T>(
        value: value,
        hint: Text(hint, style: TextStyle(color: Colors.white)),
        onChanged: onChanged,
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              itemBuilder(item),
              style: TextStyle(
                color: item is EquipmentRarity
                    ? _getRarityColor(item)
                    : Colors.white,
              ),
            ),
          );
        }).toList(),
        dropdownColor: Color(0xFFCAA04D),
        icon: Icon(icon, color: Colors.white),
        underline: SizedBox(),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFCAA04D),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButton<String>(
        value: _sortBy,
        onChanged: (String? newValue) => setState(() => _sortBy = newValue!),
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
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedSlot = null;
      _selectedRarity = null;
      _showAssignedOnly = false;
    });
  }

  Color _getRarityColor(EquipmentRarity rarity) {
    switch (rarity) {
      case EquipmentRarity.common:
        return Colors.grey;
      case EquipmentRarity.uncommon:
        return Colors.green;
      case EquipmentRarity.rare:
        return Colors.blue;
      case EquipmentRarity.epic:
        return Colors.purple;
      case EquipmentRarity.legendary:
        return Colors.orange;
      case EquipmentRarity.mythic:
        return Colors.red;
    }
  }

  String _getSlotName(EquipmentSlot slot) {
    return slot.toString().split('.').last;
  }

  IconData _getSlotIcon(EquipmentSlot slot) {
    switch (slot) {
      case EquipmentSlot.weapon:
        return Icons.sports_martial_arts;
      case EquipmentSlot.armor:
        return Icons.security;
      case EquipmentSlot.accessory:
        return Icons.emoji_events;
    }
  }
}

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
        orElse: () => null!,
      );
    }
  }

  bool _canEquipToGirl(GirlFarmer girl, GameProvider gameProvider) {
    if (_equipment.allowedTypes.isNotEmpty &&
        !_equipment.allowedTypes.contains(girl.type)) {
      return false;
    }
    if (_equipment.allowedRaces.isNotEmpty &&
        !_equipment.allowedRaces.contains(girl.race)) {
      return false;
    }

    final equippedItems =
        gameProvider.equipment.where((eq) => eq.assignedTo == girl.id).toList();

    switch (_equipment.slot) {
      case EquipmentSlot.weapon:
        final weapons = equippedItems
            .where((eq) => eq.slot == EquipmentSlot.weapon)
            .toList();

        if (weapons.length >= 2) return false;
        if (weapons.length == 1) {
          final existingWeapon = weapons.first;
          if (existingWeapon.weaponType == WeaponType.twoHandedWeapon ||
              _equipment.weaponType == WeaponType.twoHandedWeapon) {
            return false;
          }
          if (existingWeapon.weaponType == WeaponType.oneHandedShield &&
              _equipment.weaponType == WeaponType.oneHandedShield) {
            return false;
          }
        }
        break;

      case EquipmentSlot.armor:
        final armors = equippedItems
            .where((eq) => eq.slot == EquipmentSlot.armor)
            .toList();

        if (armors.length >= 2) return false;
        if (armors.length == 1 &&
            armors.first.armorType == _equipment.armorType) {
          return false;
        }
        break;

      case EquipmentSlot.accessory:
        final accessories = equippedItems
            .where((eq) => eq.slot == EquipmentSlot.accessory)
            .toList();

        if (accessories.length >= 3) return false;
        if (accessories
            .any((a) => a.accessoryType == _equipment.accessoryType)) {
          return false;
        }
        break;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
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
                _buildEquipmentCard(),
                SizedBox(height: 16),
                _buildStatsCard(),
                SizedBox(height: 16),
                _buildActionButtons(gameProvider, enhancementCost),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEquipmentCard() {
    return Card(
      color: Colors.black.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: _getRarityColor(_equipment.rarity).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: _getRarityColor(_equipment.rarity),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      _equipment.imageEquip ??
                          'assets/images/equipments/default_icon.png',
                      width: 70,
                      height: 70,
                    ),
                  ),
                ),
                SizedBox(width: 16),
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
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      if (_equipment.enhancementLevel > 0)
                        Text(
                          'Enhancement: +${_equipment.enhancementLevel}',
                          style: TextStyle(fontSize: 16, color: Colors.amber),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
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
                      backgroundImage:
                          AssetImage(_currentlyAssignedGirl!.imageFace),
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
    );
  }

  Widget _buildStatsCard() {
    return Card(
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
            _buildStatRow(
                'Attack', _equipment.attackBonus, _equipment.scaledAttack),
            _buildStatRow(
                'Defense', _equipment.defenseBonus, _equipment.scaledDefense),
            _buildStatRow('HP', _equipment.hpBonus, _equipment.scaledHp),
            _buildStatRow(
                'Agility', _equipment.agilityBonus, _equipment.scaledAgility),
            if (_equipment.mpBonus > 0)
              _buildStatRow('MP', _equipment.mpBonus, _equipment.scaledMp),
            if (_equipment.spBonus > 0)
              _buildStatRow('SP', _equipment.spBonus, _equipment.scaledSp),
            if (_equipment.criticalPoint > 0)
              _buildStatRow('Crit %', _equipment.criticalPoint,
                  _equipment.scaledCriticalPoint),
          ],
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

  Widget _buildActionButtons(
      GameProvider gameProvider, double enhancementCost) {
    return Column(
      children: [
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
          onPressed: () => _enhanceEquipment(gameProvider, enhancementCost),
          child: Column(
            children: [
              Text('ENHANCE (+1)', style: TextStyle(fontSize: 16)),
              Text('Cost: ${enhancementCost.toInt()} Credits',
                  style: TextStyle(fontSize: 12)),
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
    switch (rarity) {
      case EquipmentRarity.common:
        return Colors.grey;
      case EquipmentRarity.uncommon:
        return Colors.green;
      case EquipmentRarity.rare:
        return Colors.blue;
      case EquipmentRarity.epic:
        return Colors.purple;
      case EquipmentRarity.legendary:
        return Colors.orange;
      case EquipmentRarity.mythic:
        return Colors.red;
    }
  }

  String _getSlotName(EquipmentSlot slot) {
    return slot.toString().split('.').last;
  }

  void _showEquipDialog(GameProvider gameProvider) {
    final availableGirls = gameProvider.girlFarmers.where((girl) {
      return _canEquipToGirl(girl, gameProvider);
    }).toList();

    if (availableGirls.isEmpty) {
      _showResultDialog(
        'No Valid Girls',
        'No girls can equip this item due to type/race restrictions or slot limitations',
        isError: true,
      );
      return;
    }

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
                  leading:
                      CircleAvatar(backgroundImage: AssetImage(girl.imageFace)),
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
    final equippedItems =
        gameProvider.equipment.where((eq) => eq.assignedTo == girl.id).toList();

    if (_equipment.slot == EquipmentSlot.weapon) {
      final weapons =
          equippedItems.where((eq) => eq.slot == EquipmentSlot.weapon).toList();
      if (_equipment.weaponType == WeaponType.twoHandedWeapon) {
        for (var weapon in weapons) {
          weapon.assignedTo = null;
          gameProvider.updateEquipment(weapon);
        }
      } else if (_equipment.weaponType == WeaponType.oneHandedShield) {
        final shields = weapons
            .where((w) => w.weaponType == WeaponType.oneHandedShield)
            .toList();
        for (var shield in shields) {
          shield.assignedTo = null;
          gameProvider.updateEquipment(shield);
        }
      }
    }

    if (_equipment.slot == EquipmentSlot.armor) {
      final sameTypeArmor = equippedItems
          .where((eq) =>
              eq.slot == EquipmentSlot.armor &&
              eq.armorType == _equipment.armorType)
          .toList();
      for (var armor in sameTypeArmor) {
        armor.assignedTo = null;
        gameProvider.updateEquipment(armor);
      }
    }

    if (_equipment.slot == EquipmentSlot.accessory) {
      final sameTypeAccessories = equippedItems
          .where((eq) =>
              eq.slot == EquipmentSlot.accessory &&
              eq.accessoryType == _equipment.accessoryType)
          .toList();
      for (var accessory in sameTypeAccessories) {
        accessory.assignedTo = null;
        gameProvider.updateEquipment(accessory);
      }
    }

    setState(() {
      _equipment.assignedTo = girl.id;
      _currentlyAssignedGirl = girl;
    });
    gameProvider.updateEquipment(_equipment);
    _showResultDialog('Success', '${_equipment.name} equipped to ${girl.name}');
  }

  void _unequipItem(GameProvider gameProvider) {
    setState(() {
      _equipment.assignedTo = null;
      _currentlyAssignedGirl = null;
    });
    gameProvider.updateEquipment(_equipment);
    _showResultDialog('Success', '${_equipment.name} unequipped');
  }

  void _enhanceEquipment(GameProvider gameProvider, double cost) {
    if (gameProvider.getGold() < cost) {
      _showResultDialog('Error', 'Not enough credits to enhance!',
          isError: true);
      return;
    }

    if (_equipment.enhancementLevel >= 5) {
      _showResultDialog('Error', 'Maximum enhancement level reached!',
          isError: true);
      return;
    }

    gameProvider.exchangeResources('Credits', 'Credits', cost, 0);
    setState(() => _equipment.enhancementLevel++);
    gameProvider.updateEquipment(_equipment);
    _showResultDialog('Success',
        '${_equipment.name} enhanced to +${_equipment.enhancementLevel}!');
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
                onPressed: () => Navigator.pop(context), child: Text('Cancel')),
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
    if (_equipment.assignedTo != null) _unequipItem(gameProvider);
    gameProvider.exchangeResources('Credits', 'Credits', -sellValue, sellValue);
    gameProvider.deleteEquipment(_equipment.id);
    Navigator.pop(context);
    _showResultDialog(
        'Success', 'Sold ${_equipment.name} for ${sellValue.toInt()} credits');
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
                onPressed: () => Navigator.pop(context), child: Text('OK')),
          ],
        );
      },
    );
  }
}
