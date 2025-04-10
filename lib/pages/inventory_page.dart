import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/equipment_model.dart';
import '../models/girl_farmer_model.dart';
import '../models/potion_model.dart';
import '../providers/game_provider.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Inventory',
          height: 40,
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Equipment'),
              Tab(text: 'Potions'),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ImageCacheManager.getImage('assets/images/ui/app-bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: TabBarView(
            controller: _tabController,
            children: [
              EquipmentTab(),
              PotionsTab(),
            ],
          ),
        ),
      ),
    );
  }
}

// Equipment Tab - Extracted from EquipmentListPage
class EquipmentTab extends StatefulWidget {
  @override
  _EquipmentTabState createState() => _EquipmentTabState();
}

class _EquipmentTabState extends State<EquipmentTab> {
  String _sortBy = 'Rarity';
  String _filterQuery = '';
  EquipmentSlot? _selectedSlot;
  EquipmentRarity? _selectedRarity;
  bool _showAssignedOnly = false;

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    List<Equipment> equipmentList = gameProvider.equipment;
    equipmentList = _applyFiltersAndSorting(equipmentList);

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
                      child: Icon(
                        _getSlotIcon(equipment.slot),
                        color: _getRarityColor(equipment.rarity),
                        size: 30,
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
              Text('Show Assigned Only', style: TextStyle(color: Colors.white)),
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

  // ... [Keep all the same methods from EquipmentListPage] ...
  // _applyFiltersAndSorting, _buildEmptyState, _buildEquipmentGrid,
  // _buildFilterControls, _getRarityColor, _getSlotName, _getSlotIcon
}

// Potions Tab - Extracted from PotionManagementPage
class PotionsTab extends StatefulWidget {
  @override
  _PotionsTabState createState() => _PotionsTabState();
}

class _PotionsTabState extends State<PotionsTab> {
  Potion? _selectedPotion;
  GirlFarmer? _selectedGirl;
  bool _showGirlSelection = false;
  PotionRarity? _selectedRarity;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final potions = gameProvider.getFilteredPotions(
      rarity: _selectedRarity,
      searchQuery: _searchQuery,
    );

    return Column(
      children: [
        if (!_showGirlSelection) _buildFilterBar(),
        Expanded(
          child: _showGirlSelection && _selectedPotion != null
              ? _buildGirlSelectionView(gameProvider, _selectedPotion!)
              : _buildPotionGridView(potions, gameProvider),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            FilterChip(
              label: const Text('All'),
              selected: _selectedRarity == null,
              onSelected: (selected) => setState(() => _selectedRarity = null),
            ),
            ...PotionRarity.values.map((rarity) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FilterChip(
                  label: Text(rarity.toString().split('.').last),
                  selected: _selectedRarity == rarity,
                  onSelected: (selected) => setState(
                    () => _selectedRarity = selected ? rarity : null,
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPotionGridView(List<Potion> potions, GameProvider gameProvider) {
    if (potions.isEmpty) {
      return const Center(
        child: Text(
          'No potions found\n\nTry adjusting your filters or check the shop',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: potions.length,
      itemBuilder: (context, index) {
        final potion = potions[index];
        return _PotionCard(
          potion: potion,
          onTap: () => _showPotionActions(context, potion, gameProvider),
        );
      },
    );
  }

  Widget _buildGirlSelectionView(GameProvider gameProvider, Potion potion) {
    final girls = gameProvider.getEligibleGirlsForPotion(potion);

    return Column(
      children: [
        _PotionSummaryCard(potion: potion),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Select a girl to use this potion on:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: girls.isEmpty
              ? const Center(
                  child: Text('No eligible girls can use this potion'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: girls.length,
                  itemBuilder: (context, index) {
                    final girl = girls[index];
                    return _GirlListItem(
                      girl: girl,
                      isSelected: _selectedGirl?.id == girl.id,
                      onTap: () => setState(() => _selectedGirl = girl),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _selectedGirl != null
                ? () => _usePotion(gameProvider, potion, _selectedGirl!)
                : null,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Use Potion', style: TextStyle(fontSize: 18)),
          ),
        ),
      ],
    );
  }

  Future<void> _showPotionActions(
      BuildContext context, Potion potion, GameProvider gameProvider) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('View Details'),
                onTap: () {
                  Navigator.pop(context);
                  _showPotionDetails(context, potion);
                },
              ),
              ListTile(
                leading: const Icon(Icons.local_drink),
                title: const Text('Use Potion'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedPotion = potion;
                    _showGirlSelection = true;
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('Sell Potion'),
                onTap: () {
                  Navigator.pop(context);
                  _sellPotion(context, potion, gameProvider);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete Potion',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _deletePotion(context, potion, gameProvider);
                },
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPotionDetails(BuildContext context, Potion potion) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(potion.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Image.asset(
                  potion.iconAsset,
                  width: 64,
                  height: 64,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.local_drink, size: 64),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Rarity: ${potion.rarity.toString().split('.').last}',
                style: TextStyle(
                  color: _getRarityColor(potion.rarity),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(potion.description),
              const SizedBox(height: 16),
              const Text('Effects:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              _buildDetailedStats(potion),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _usePotion(
      GameProvider gameProvider, Potion potion, GirlFarmer girl) async {
    try {
      final success = await gameProvider.usePotion(
        potionId: potion.id,
        girlId: girl.id,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${potion.name} used on ${girl.name}!'),
            duration: const Duration(seconds: 2),
          ),
        );

        setState(() {
          _showGirlSelection = false;
          _selectedGirl = null;
          _selectedPotion = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to use potion'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _sellPotion(
      BuildContext context, Potion potion, GameProvider gameProvider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sell Potion'),
        content: Text(
            'Sell ${potion.name} for ${gameProvider.calculatePotionSellPrice(potion)} credits?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sell'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final success = await gameProvider.sellPotion(potion.id);

        if (!mounted) return;

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Sold ${potion.name} for ${gameProvider.calculatePotionSellPrice(potion)} credits'),
              duration: const Duration(seconds: 2),
            ),
          );
          setState(() {});
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to sell potion'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deletePotion(
      BuildContext context, Potion potion, GameProvider gameProvider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Potion'),
        content: Text('Permanently delete ${potion.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final success = await gameProvider.deletePotion(potion.id);

        if (!mounted) return;

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Deleted ${potion.name}'),
              duration: const Duration(seconds: 2),
            ),
          );
          setState(() {});
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to delete potion'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showSearchDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Potions'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search by name or description...',
          ),
          onChanged: (value) {
            setState(() => _searchQuery = value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              _searchController.clear();
              setState(() => _searchQuery = '');
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Color _getRarityColor(PotionRarity rarity) {
    return switch (rarity) {
      PotionRarity.common => Colors.grey,
      PotionRarity.uncommon => Colors.green,
      PotionRarity.rare => Colors.blue,
      PotionRarity.epic => Colors.purple,
      PotionRarity.legendary => Colors.orange,
    };
  }

  Widget _buildDetailedStats(Potion potion) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        if (potion.hpIncrease != 0)
          _StatBadge(stat: 'HP', value: potion.hpIncrease),
        if (potion.mpIncrease != 0)
          _StatBadge(stat: 'MP', value: potion.mpIncrease),
        if (potion.spIncrease != 0)
          _StatBadge(stat: 'SP', value: potion.spIncrease),
        if (potion.attackIncrease != 0)
          _StatBadge(stat: 'ATK', value: potion.attackIncrease),
        if (potion.defenseIncrease != 0)
          _StatBadge(stat: 'DEF', value: potion.defenseIncrease),
        if (potion.agilityIncrease != 0)
          _StatBadge(stat: 'AGI', value: potion.agilityIncrease),
        if (potion.criticalPointIncrease != 0)
          _StatBadge(stat: 'CRIT', value: potion.criticalPointIncrease),
      ],
    );
  }
  // ... [Keep all the same methods from PotionManagementPage] ...
  // _buildFilterBar, _buildPotionGridView, _buildGirlSelectionView,
  // _showPotionActions, _showPotionDetails, _usePotion, etc.
}

// Custom App Bar Implementation (same as before)
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.height = 56.0,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.bottom,
  }) : super(key: key);

  @override
  Size get preferredSize =>
      Size.fromHeight(height + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/ui/wood-ui.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (bottom == null) Spacer(),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'GameFont',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (bottom == null) Spacer(),
          if (bottom != null) bottom!,
        ],
      ),
    );
  }
}

// Equipment Details Page (same as before)
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
                    child: Icon(
                      _getSlotIcon(_equipment.slot),
                      color: _getRarityColor(_equipment.rarity),
                      size: 40,
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
                  color: Colors.white),
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
    if (gameProvider.getCredits() < cost) {
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

// Potion Card Widget (extracted from PotionManagementPage)
class _PotionCard extends StatelessWidget {
  final Potion potion;
  final VoidCallback onTap;

  const _PotionCard({
    Key? key,
    required this.potion,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Potion Image and Rarity
              Center(
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Image.asset(
                      potion.iconAsset,
                      width: 64,
                      height: 64,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.local_drink, size: 64),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getRarityColor(potion.rarity),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        potion.rarity.toString().split('.').last[0],
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Potion Name
              Text(
                potion.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              // Potion Stats Summary
              Expanded(
                child: _buildStatSummary(potion),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatSummary(Potion potion) {
    final stats = <String, int>{};
    if (potion.hpIncrease != 0) stats['HP'] = potion.hpIncrease;
    if (potion.mpIncrease != 0) stats['MP'] = potion.mpIncrease;
    if (potion.attackIncrease != 0) stats['ATK'] = potion.attackIncrease;
    if (potion.defenseIncrease != 0) stats['DEF'] = potion.defenseIncrease;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: stats.entries
          .map((e) => _StatRow(stat: e.key, value: e.value))
          .toList(),
    );
  }

  Color _getRarityColor(PotionRarity rarity) {
    return switch (rarity) {
      PotionRarity.common => Colors.grey,
      PotionRarity.uncommon => Colors.green,
      PotionRarity.rare => Colors.blue,
      PotionRarity.epic => Colors.purple,
      PotionRarity.legendary => Colors.orange,
    };
  }
}

// Other supporting widgets (_PotionSummaryCard, _StatBadge, _GirlListItem, _StatRow)
class _PotionSummaryCard extends StatelessWidget {
  final Potion potion;

  const _PotionSummaryCard({Key? key, required this.potion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  potion.iconAsset,
                  width: 48,
                  height: 48,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.local_drink, size: 48),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        potion.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        potion.rarity.toString().split('.').last,
                        style: TextStyle(
                          color: _getRarityColor(potion.rarity),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(potion.description),
            const SizedBox(height: 12),
            _buildDetailedStats(potion),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedStats(Potion potion) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        if (potion.hpIncrease != 0)
          _StatBadge(stat: 'HP', value: potion.hpIncrease),
        if (potion.mpIncrease != 0)
          _StatBadge(stat: 'MP', value: potion.mpIncrease),
        if (potion.spIncrease != 0)
          _StatBadge(stat: 'SP', value: potion.spIncrease),
        if (potion.attackIncrease != 0)
          _StatBadge(stat: 'ATK', value: potion.attackIncrease),
        if (potion.defenseIncrease != 0)
          _StatBadge(stat: 'DEF', value: potion.defenseIncrease),
        if (potion.agilityIncrease != 0)
          _StatBadge(stat: 'AGI', value: potion.agilityIncrease),
        if (potion.criticalPointIncrease != 0)
          _StatBadge(stat: 'CRIT', value: potion.criticalPointIncrease),
      ],
    );
  }

  Color _getRarityColor(PotionRarity rarity) {
    return switch (rarity) {
      PotionRarity.common => Colors.grey,
      PotionRarity.uncommon => Colors.green,
      PotionRarity.rare => Colors.blue,
      PotionRarity.epic => Colors.purple,
      PotionRarity.legendary => Colors.orange,
    };
  }
}

class _StatBadge extends StatelessWidget {
  final String stat;
  final int value;

  const _StatBadge({Key? key, required this.stat, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(stat),
          const SizedBox(width: 4),
          Text(
            value > 0 ? '+$value' : '$value',
            style: TextStyle(
              color: value > 0 ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _GirlListItem extends StatelessWidget {
  final GirlFarmer girl;
  final bool isSelected;
  final VoidCallback onTap;

  const _GirlListItem({
    Key? key,
    required this.girl,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isSelected
          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
          : null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(girl.imageFace),
                radius: 24,
                onBackgroundImageError: (_, __) =>
                    const Icon(Icons.person, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      girl.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${girl.type} • Lv. ${girl.level}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'HP: ${girl.hp}/${girl.maxHp}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    'ATK: ${girl.attackPoints}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String stat;
  final int value;

  const _StatRow({Key? key, required this.stat, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            stat,
            style: const TextStyle(fontSize: 12),
          ),
          const Spacer(),
          Text(
            value > 0 ? '+$value' : '$value',
            style: TextStyle(
              fontSize: 12,
              color: value > 0 ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
