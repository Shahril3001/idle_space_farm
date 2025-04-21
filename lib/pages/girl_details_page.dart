import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/ability_model.dart';
import '../models/equipment_model.dart';
import '../models/girl_farmer_model.dart';
import '../providers/game_provider.dart';

class GirlDetailsPage extends StatelessWidget {
  final GirlFarmer girl;

  const GirlDetailsPage({Key? key, required this.girl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    return DefaultTabController(
      length: 4,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    ImageCacheManager.getImage('assets/images/ui/app-bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                // Top section with portrait and name
                _buildTopSection(context),

                // Tab bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.9),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(5)),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: TabBar(
                            labelColor: Color(0xFFCAA04D),
                            unselectedLabelColor: Colors.white70,
                            indicatorColor: Color(0xFFCAA04D),
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelPadding: EdgeInsets.symmetric(horizontal: 16),
                            tabs: [
                              Tab(
                                icon: Image.asset(
                                  'assets/images/icons/girl-bio.png',
                                  width: 34,
                                  height: 34,
                                ),
                              ),
                              Tab(
                                icon: Image.asset(
                                  'assets/images/icons/girl-stats.png',
                                  width: 34,
                                  height: 34,
                                ),
                              ),
                              Tab(
                                icon: Image.asset(
                                  'assets/images/icons/girl-abilities.png',
                                  width: 34,
                                  height: 34,
                                ),
                              ),
                              Tab(
                                icon: Image.asset(
                                  'assets/images/icons/girl-equipment.png',
                                  width: 34,
                                  height: 34,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Tab content
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildDetailsTab(),
                      _buildStatsTab(),
                      _buildAbilitiesTab(),
                      _buildEquipmentTab(context),
                    ],
                  ),
                ),

                // Action buttons
                _buildActionButtons(context, gameProvider),

                // Back button
                _buildBackButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection(context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          _buildCharacterPortrait(context),
          SizedBox(height: 10),
          _buildCharacterName(),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildStatsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildStatSection(),
          SizedBox(height: 20),
          Card(
            elevation: 5,
            color: Colors.black.withOpacity(0.8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildStarRating(girl.stars),
                  SizedBox(height: 15),
                  _buildAttributeRow('assets/images/icons/stats-level.png',
                      'Level', "${girl.level}"),
                  Divider(color: Colors.white54),
                  SizedBox(height: 10),
                  _buildAttributeRow('assets/images/icons/stats-attack.png',
                      'Attack', "${girl.attackPoints}"),
                  SizedBox(height: 10),
                  _buildAttributeRow('assets/images/icons/stats-defense.png',
                      'Defense', "${girl.defensePoints}"),
                  SizedBox(height: 10),
                  _buildAttributeRow('assets/images/icons/stats-agility.png',
                      'Agility', "${girl.agilityPoints}"),
                  SizedBox(height: 10),
                  _buildAttributeRow('assets/images/icons/stats-critical.png',
                      'Critical', "${girl.criticalPoint}%"),
                  SizedBox(height: 10),
                  _buildAttributeRow('assets/images/icons/stats-mine.png',
                      'Mining', girl.miningEfficiency.toStringAsFixed(2)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Card(
        elevation: 5,
        color: Colors.black.withOpacity(0.8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAttributeRow(
                  'assets/images/icons/stats-race.png', 'Race', girl.race),
              SizedBox(height: 10),
              _buildAttributeRow(
                  'assets/images/icons/stats-class.png', 'Class', girl.type),
              SizedBox(height: 10),
              _buildAttributeRow('assets/images/icons/stats-region.png',
                  'Region', girl.region),
              SizedBox(height: 10),
              Divider(color: Colors.white54),
              SizedBox(height: 10),
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                girl.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAbilitiesTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: _buildAbilitiesSection(),
    );
  }

  Widget _buildCharacterPortrait(BuildContext context) {
    // Add context parameter here
    return Hero(
      tag: 'girl-image-${girl.id}',
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main Image with Shadow
          Container(
            width: 220,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  blurRadius: 1,
                  spreadRadius: 2,
                  offset: Offset(0, 5),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  blurRadius: 0,
                  spreadRadius: 2,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                girl.image,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // View Full Button
          Positioned(
            bottom: 15,
            left: 15,
            child: InkWell(
              onTap: () => _showFullImage(
                  context, girl.image), // Now context is available
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.fullscreen, size: 20, color: Colors.white),
                    SizedBox(width: 5),
                    Text(
                      'View',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFullImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      barrierColor:
          Colors.transparent, // Make the actual dialog barrier transparent
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.pop(context), // Close when tapping outside
          child: Stack(
            children: [
              // Blurred background that's tappable
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
              ),

              // Image content (won't close when tapping this)
              Center(
                child: GestureDetector(
                  onTap:
                      () {}, // Empty handler to prevent closing when tapping image
                  child: Hero(
                    tag: 'girl-image-${girl.id}',
                    child: InteractiveViewer(
                      panEnabled: true,
                      minScale: 1,
                      maxScale: 3,
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCharacterName() {
    return Text(
      girl.name,
      style: TextStyle(
        fontFamily: 'GameFont',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black.withOpacity(0.7),
      ),
    );
  }

  Widget _buildStatSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatBox("HP", girl.hp, girl.maxHp, Colors.redAccent,
            'assets/images/icons/stats-healthp.png'),
        _buildStatBox("MP", girl.mp, girl.maxMp, Colors.blueAccent,
            'assets/images/icons/stats-manap.png'),
        _buildStatBox("SP", girl.sp, girl.maxSp, Colors.greenAccent,
            'assets/images/icons/stats-specialp.png'),
      ],
    );
  }

  Widget _buildStatBox(
      String label, int value, int maxValue, Color color, String iconPath) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Image.asset(iconPath, width: 30, height: 30),
          SizedBox(height: 5),
          Text(label,
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.bold, color: color)),
          SizedBox(height: 5),
          Container(
            width: 70,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: value / maxValue,
                backgroundColor: Colors.grey[800],
                color: color,
                minHeight: 10,
              ),
            ),
          ),
          SizedBox(height: 5),
          Text("$value / $maxValue",
              style: TextStyle(fontSize: 13, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildAttributeRow(String iconPath, String label, String value) {
    return Row(
      children: [
        Image.asset(iconPath, width: 24, height: 24),
        SizedBox(width: 10),
        Text("$label:",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        Spacer(),
        Text(value, style: TextStyle(fontSize: 12, color: Colors.amberAccent)),
      ],
    );
  }

  Widget _buildStarRating(int stars) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Icon(index < stars ? Icons.star : Icons.star_border,
            color: Color(0xFFCAA04D), size: 22);
      }),
    );
  }

  Widget _buildAbilitiesSection() {
    return Card(
      elevation: 5,
      color: Colors.black.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Abilities',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            if (girl.abilities.isEmpty)
              Center(
                child: Text(
                  '- None -',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              )
            else
              ...girl.abilities
                  .map((ability) => _buildAbilityRow(ability))
                  .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAbilityRow(AbilitiesModel ability) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Image.asset(
                ability.elementType.iconAsset,
                width: 20,
                height: 20,
              ),
            ),

            SizedBox(width: 4),
            Expanded(
              child: Text(
                ability.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            // Resource costs
            if (ability.mpCost > 0)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome,
                        size: 14, color: Colors.blueAccent),
                    SizedBox(width: 4),
                    Text(
                      "${ability.mpCost}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
            if (ability.spCost > 0)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bolt, size: 14, color: Colors.orangeAccent),
                    SizedBox(width: 4),
                    Text(
                      "${ability.spCost}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orangeAccent,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        SizedBox(height: 5),
        // Description with targeting info
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: ability.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
              if (ability.elementType != ElementType.none)
                TextSpan(
                  text: " (${ability.elementType.displayName})",
                  style: TextStyle(
                    fontSize: 12,
                    color: _getElementColor(ability.elementType),
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
        // Additional info row
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Wrap(
            spacing: 12,
            children: [
              if (ability.cooldown > 0)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timer, size: 12, color: Colors.white54),
                    SizedBox(width: 4),
                    Text(
                      "${ability.cooldown}t",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    ability.affectsEnemies ? Icons.warning : Icons.favorite,
                    size: 12,
                    color: ability.affectsEnemies
                        ? Colors.redAccent
                        : Colors.greenAccent,
                  ),
                  SizedBox(width: 4),
                  Text(
                    ability.targetingDescription,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(color: Colors.white54),
      ],
    );
  }

  Color _getElementColor(ElementType element) {
    switch (element) {
      case ElementType.fire:
        return Colors.orangeAccent;
      case ElementType.water:
        return Colors.blueAccent;
      case ElementType.earth:
        return Colors.brown;
      case ElementType.wind:
        return Colors.blueGrey;
      case ElementType.thunder:
        return Colors.yellowAccent;
      case ElementType.snow:
        return Colors.lightBlueAccent;
      case ElementType.nature:
        return Colors.greenAccent;
      case ElementType.dark:
        return Colors.deepPurpleAccent;
      case ElementType.light:
        return Colors.yellow;
      case ElementType.poison:
        return Colors.purpleAccent;
      case ElementType.divine:
        return Colors.white;
      default:
        return Colors.white70;
    }
  }

// Add this new method to build the equipment tab
  Widget _buildEquipmentTab(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final equippedItems = gameProvider.getGirlEquipment(girl.id);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Weapon Slots
          _buildEquipmentSlotCard(
            context,
            'Weapons',
            EquipmentSlot.weapon,
            equippedItems.where((e) => e.slot == EquipmentSlot.weapon).toList(),
            maxSlots: 2,
          ),
          SizedBox(height: 16),

          // Armor Slots
          _buildEquipmentSlotCard(
            context,
            'Armor',
            EquipmentSlot.armor,
            equippedItems.where((e) => e.slot == EquipmentSlot.armor).toList(),
            maxSlots: 2,
          ),
          SizedBox(height: 16),

          // Accessory Slots
          _buildEquipmentSlotCard(
            context,
            'Accessories',
            EquipmentSlot.accessory,
            equippedItems
                .where((e) => e.slot == EquipmentSlot.accessory)
                .toList(),
            maxSlots: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentSlotCard(
    BuildContext context,
    String title,
    EquipmentSlot slot,
    List<Equipment> equippedItems, {
    required int maxSlots,
  }) {
    final gameProvider = Provider.of<GameProvider>(context);
    final availableSlots = maxSlots - equippedItems.length;

    return Card(
      elevation: 5,
      // ignore: deprecated_member_use
      color: Colors.black.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Spacer(),
                Text(
                  '${equippedItems.length}/$maxSlots',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            if (equippedItems.isEmpty) _buildEmptySlot(slot),
            ...equippedItems
                .map((item) =>
                    _buildEquippedItemRow(context, item, gameProvider))
                .toList(),
            if (availableSlots > 0)
              _buildAddEquipmentButton(context, slot, gameProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySlot(EquipmentSlot slot) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.grey[900]!.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Center(
        child: Text(
          'Empty ${slot.toString().split('.').last} slot',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }

  Widget _buildEquippedItemRow(
      BuildContext context, Equipment item, GameProvider gameProvider) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.grey[900]!.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _getRarityColor(item.rarity)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: _getRarityColor(item.rarity).withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _getRarityColor(item.rarity)),
            ),
            child: Center(
              child: Icon(
                _getSlotIcon(item.slot),
                color: _getRarityColor(item.rarity),
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.displayName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _getRarityColor(item.rarity),
                  ),
                ),
                SizedBox(height: 4),
                _buildEquipmentStatsText(item), // Updated to use new method
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.remove_circle, color: Colors.red),
            onPressed: () {
              gameProvider.unequipItem(item.id);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentStatsText(Equipment item) {
    final stats = <Widget>[];

    // Handle different equipment types
    switch (item.slot) {
      case EquipmentSlot.weapon:
        if (item.weaponType == WeaponType.oneHandedShield) {
          // Special display for shields
          if (item.scaledDefense > 0) {
            stats.add(_buildStatText('DEF', item.scaledDefense));
          }
          if (item.scaledHp > 0) stats.add(_buildStatText('HP', item.scaledHp));
          if (item.scaledAgility != 0) {
            stats.add(_buildStatText(
              'AGI',
              item.scaledAgility,
              isNegative: item.scaledAgility < 0,
            ));
          }
        } else {
          // Normal weapons
          if (item.scaledAttack > 0) {
            stats.add(_buildStatText('ATK', item.scaledAttack));
          }
          if (item.scaledDefense > 0) {
            stats.add(_buildStatText('DEF', item.scaledDefense));
          }
          if (item.scaledCriticalPoint > 0) {
            stats.add(_buildStatText('CRIT', item.scaledCriticalPoint,
                isPercent: true));
          }
        }
        break;

      case EquipmentSlot.armor:
        if (item.scaledDefense > 0) {
          stats.add(_buildStatText('DEF', item.scaledDefense));
        }
        if (item.scaledHp > 0) stats.add(_buildStatText('HP', item.scaledHp));
        if (item.scaledAgility != 0) {
          stats.add(_buildStatText(
            'AGI',
            item.scaledAgility,
            isNegative: item.scaledAgility < 0,
          ));
        }
        break;

      case EquipmentSlot.accessory:
        if (item.scaledAgility > 0) {
          stats.add(_buildStatText('AGI', item.scaledAgility));
        }
        if (item.scaledAttack > 0) {
          stats.add(_buildStatText('ATK', item.scaledAttack));
        }
        if (item.scaledDefense > 0) {
          stats.add(_buildStatText('DEF', item.scaledDefense));
        }
        if (item.scaledCriticalPoint > 0) {
          stats.add(_buildStatText('CRIT', item.scaledCriticalPoint,
              isPercent: true));
        }
        break;
    }

    // Universal stats (appear on all equipment types)
    if (item.scaledMp > 0) stats.add(_buildStatText('MP', item.scaledMp));
    if (item.scaledSp > 0) stats.add(_buildStatText('SP', item.scaledSp));

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: stats,
    );
  }

  Widget _buildStatText(String label, num value,
      {bool isPercent = false, bool isNegative = false}) {
    return Text(
      '$label: ${isNegative ? '' : '+'}${value.toStringAsFixed(0)}${isPercent ? '%' : ''}',
      style: TextStyle(
        fontSize: 12,
        color: isNegative ? Colors.redAccent : Colors.white70,
      ),
    );
  }

  Widget _buildAddEquipmentButton(
    BuildContext context,
    EquipmentSlot slot,
    GameProvider gameProvider,
  ) {
    return TextButton(
      style: TextButton.styleFrom(
        // ignore: deprecated_member_use
        backgroundColor: Colors.grey[800]!.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
        _showEquipmentSelectionDialog(context, slot, gameProvider);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, color: Color(0xFFCAA04D), size: 20),
          SizedBox(width: 8),
          Text(
            'Add ${slot.toString().split('.').last}',
            style: TextStyle(color: Color(0xFFCAA04D)),
          ),
        ],
      ),
    );
  }

  void _showEquipmentSelectionDialog(
    BuildContext context,
    EquipmentSlot slot,
    GameProvider gameProvider,
  ) {
    final availableEquipment = gameProvider
        .filterEquipment(
      slot: slot,
      onlyUnassigned: true,
    )
        .where((e) {
      // Check if girl can equip this item
      if (e.allowedTypes.isNotEmpty && !e.allowedTypes.contains(girl.type)) {
        return false;
      }
      if (e.allowedRaces.isNotEmpty && !e.allowedRaces.contains(girl.race)) {
        return false;
      }
      return true;
    }).toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select ${slot.toString().split('.').last}'),
          content: Container(
            width: double.maxFinite,
            child: availableEquipment.isEmpty
                ? Center(
                    child: Text(
                      'No available ${slot.toString().split('.').last}s',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: availableEquipment.length,
                    itemBuilder: (context, index) {
                      final equipment = availableEquipment[index];
                      return ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _getRarityColor(equipment.rarity)
                                .withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: _getRarityColor(equipment.rarity)),
                          ),
                          child: Center(
                            child: Icon(
                              _getSlotIcon(equipment.slot),
                              color: _getRarityColor(equipment.rarity),
                              size: 20,
                            ),
                          ),
                        ),
                        title: Text(
                          equipment.displayName,
                          style: TextStyle(
                            color: _getRarityColor(equipment.rarity),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (equipment.slot == EquipmentSlot.weapon)
                              Text('ATK: ${equipment.scaledAttack}'),
                            if (equipment.slot == EquipmentSlot.armor)
                              Text('DEF: ${equipment.scaledDefense}'),
                            if (equipment.slot == EquipmentSlot.accessory)
                              Text(
                                  'Bonus: ${_getAccessoryBonusText(equipment)}'),
                            if (_getAllEquipmentStats(equipment).isNotEmpty)
                              Text(
                                  'Stats: ${_getAllEquipmentStats(equipment)}'),
                          ],
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          gameProvider.equipToGirl(equipment.id, girl.id);
                        },
                      );
                    },
                  ),
          ),
        );
      },
    );
  }

  String _getAllEquipmentStats(Equipment equipment) {
    final bonuses = <String>[];

    // Universal stats (for all equipment types)
    if (equipment.scaledAttack > 0) {
      bonuses.add('ATK +${equipment.scaledAttack}');
    }
    if (equipment.scaledDefense > 0) {
      bonuses.add('DEF +${equipment.scaledDefense}');
    }
    if (equipment.scaledHp > 0) bonuses.add('HP +${equipment.scaledHp}');
    if (equipment.scaledAgility > 0) {
      bonuses.add('AGI +${equipment.scaledAgility}');
    }
    if (equipment.scaledMp > 0) bonuses.add('MP +${equipment.scaledMp}');
    if (equipment.scaledSp > 0) bonuses.add('SP +${equipment.scaledSp}');
    if (equipment.scaledCriticalPoint > 0) {
      bonuses.add('CRIT +${equipment.scaledCriticalPoint}%');
    }

    return bonuses.join(', ');
  }

  String _getAccessoryBonusText(Equipment equipment) {
    final bonuses = <String>[];
    if (equipment.hpBonus > 0) bonuses.add('HP +${equipment.scaledHp}');
    if (equipment.mpBonus > 0) bonuses.add('MP +${equipment.scaledMp}');
    if (equipment.spBonus > 0) bonuses.add('SP +${equipment.scaledSp}');
    if (equipment.agilityBonus > 0) {
      bonuses.add('AGI +${equipment.scaledAgility}');
    }
    if (equipment.criticalPoint > 0) {
      bonuses.add('CRIT +${equipment.scaledCriticalPoint}%');
    }
    return bonuses.join(', ');
  }

// Add these helper methods if not already defined
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

  IconData _getSlotIcon(EquipmentSlot slot) {
    return switch (slot) {
      EquipmentSlot.weapon => Icons.sports_martial_arts,
      EquipmentSlot.armor => Icons.security,
      EquipmentSlot.accessory => Icons.emoji_events,
    };
  }

  Widget _buildActionButtons(BuildContext context, GameProvider gameProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildButton("Upgrade", "assets/images/icons/stats-upgrade.png",
              Colors.black.withOpacity(0.8), () {
            _showUpgradeConfirmation(context, gameProvider);
          }),
          SizedBox(width: 20),
          _buildButton("Sell", "assets/images/icons/stats-sell.png",
              Colors.black.withOpacity(0.8), () {
            _confirmSell(context, gameProvider, girl);
          }),
        ],
      ),
    );
  }

  Widget _buildButton(
      String text, String imagePath, Color color, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFA12626), //Top color
              const Color(0xFF611818), // Dark red at bottom
            ],
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Colors.transparent, // Make button background transparent
            shadowColor: Colors.transparent, // Remove shadow
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
          child: Text(
            "Back",
            style: TextStyle(
                color: Colors.white, fontFamily: 'GameFont', fontSize: 16),
          ),
        ),
      ),
    );
  }

  void _showUpgradeConfirmation(
      BuildContext context, GameProvider gameProvider) {
    final upgradeCost = (150 + (girl.level - 1) * 150).toInt();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Color(0xFFCAA04D)),
          ),
          title: Text(
            'Upgrade ${girl.name}?',
            style: TextStyle(
              color: Color(0xFFCAA04D),
              fontFamily: 'GameFont',
              fontSize: 20,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upgrade cost:',
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 8),
              _buildCostRow(
                  'Minerals', '$upgradeCost', Icons.terrain, Colors.blueGrey),
              SizedBox(height: 16),
              Text(
                'Current level: ${girl.level} → New level: ${girl.level + 1}',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                'Stat increases:',
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 4),
              _buildStatIncreaseRow('Attack/Defense', '+2'),
              _buildStatIncreaseRow('Agility', '+1'),
              _buildStatIncreaseRow('HP', '+20'),
              _buildStatIncreaseRow('MP', '+10'),
              _buildStatIncreaseRow('SP', '+5'),
              _buildStatIncreaseRow('Critical', '+1%'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                bool success = gameProvider.upgradeGirl(girl.id);
                Navigator.pop(context);
                _showUpgradeResult(context, success, girl.name);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFCAA04D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Upgrade',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatIncreaseRow(String stat, String increase) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(Icons.arrow_forward, size: 14, color: Colors.green),
          SizedBox(width: 8),
          Text(
            stat,
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Spacer(),
          Text(
            increase,
            style: TextStyle(color: Colors.green, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildCostRow(
      String resource, String amount, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(width: 8),
          Text(
            resource,
            style: TextStyle(color: Colors.white70),
          ),
          Spacer(),
          Text(
            amount,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _showUpgradeResult(BuildContext context, bool success, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: success ? Colors.green : Colors.red),
          ),
          title: Row(
            children: [
              Icon(
                success ? Icons.check_circle : Icons.error,
                color: success ? Colors.green : Colors.red,
              ),
              SizedBox(width: 8),
              Text(
                success ? 'Success!' : 'Failed',
                style: TextStyle(
                  color: success ? Colors.green : Colors.red,
                  fontFamily: 'GameFont',
                ),
              ),
            ],
          ),
          content: Text(
            success ? '$name leveled up! 🎉' : 'Not enough resources! ❌',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'OK',
                style: TextStyle(color: Color(0xFFCAA04D)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmSell(
      BuildContext context, GameProvider gameProvider, GirlFarmer girl) {
    double sellPrice = 0;
    switch (girl.rarity) {
      case 'Common':
        sellPrice = 2.5;
        break;
      case 'Rare':
        sellPrice = 5;
        break;
      case 'Unique':
        sellPrice = 20;
        break;
    }
    sellPrice *= (1 + girl.attackPoints * 0.01);
    final formattedPrice = sellPrice.toStringAsFixed(2);
    final basePrice = switch (girl.rarity) {
      'Common' => 2.5,
      'Rare' => 5,
      'Unique' => 20,
      _ => 0,
    };
    final attackBonus = sellPrice - basePrice;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Colors.red),
          ),
          title: Text(
            'Sell ${girl.name}?',
            style: TextStyle(
              color: Colors.red,
              fontFamily: 'GameFont',
              fontSize: 20,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'You will receive:',
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 8),
              _buildCostRow('Credits', formattedPrice, Icons.monetization_on,
                  Colors.amber),
              SizedBox(height: 8),
              Text(
                'Based on:',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              _buildSellCalculationRow(
                  'Base (${girl.rarity})', '\$${basePrice.toStringAsFixed(2)}'),
              _buildSellCalculationRow('Attack bonus (${girl.attackPoints}%)',
                  '+\$${attackBonus.toStringAsFixed(2)}'),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.withOpacity(0.5)),
                ),
                child: Text(
                  'This action cannot be undone!',
                  style: TextStyle(
                    color: Colors.red,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                gameProvider.sellGirl(girl.id);
                Navigator.pop(context);
                _showSellResult(context, girl.name,
                    sellPrice); // Now passing double instead of String
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Confirm Sell',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSellResult(BuildContext context, String name, double sellPrice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Color(0xFFCAA04D)),
          ),
          title: Row(
            children: [
              Icon(Icons.attach_money, color: Colors.amber),
              SizedBox(width: 8),
              Text(
                'Sold!',
                style: TextStyle(
                  color: Color(0xFFCAA04D),
                  fontFamily: 'GameFont',
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$name has been sold for:',
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 8),
              _buildCostRow('Credits', sellPrice.toStringAsFixed(2),
                  Icons.monetization_on, Colors.amber),
              SizedBox(height: 16),
              Icon(Icons.celebration, color: Colors.amber, size: 40),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Also pop the details page
              },
              child: Text(
                'OK',
                style: TextStyle(color: Color(0xFFCAA04D)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSellCalculationRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Spacer(),
          Text(
            value,
            style: TextStyle(color: Colors.amber, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
