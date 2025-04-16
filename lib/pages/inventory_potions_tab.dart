import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/girl_farmer_model.dart';
import '../models/potion_model.dart';
import '../providers/game_provider.dart';

class PotionsTab extends StatefulWidget {
  @override
  _PotionsTabState createState() => _PotionsTabState();
}

class _PotionsTabState extends State<PotionsTab> {
  String _sortBy = 'Rarity';
  String _filterQuery = '';
  PotionRarity? _selectedRarity;
  bool _showAssignedOnly = false;
  Potion? _selectedPotion;
  GirlFarmer? _selectedGirl;
  bool _showGirlSelection = false;
  int _selectedQuantity = 1;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    List<Potion> potionsList = gameProvider.potions;
    potionsList = _applyFiltersAndSorting(potionsList);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          if (!_showGirlSelection) _buildFilterControls(),
          Expanded(
            child: _showGirlSelection && _selectedPotion != null
                ? _buildGirlSelectionView(gameProvider, _selectedPotion!)
                : potionsList.isEmpty
                    ? _buildEmptyState()
                    : _buildPotionsGrid(potionsList),
          ),
        ],
      ),
    );
  }

  List<Potion> _applyFiltersAndSorting(List<Potion> potionsList) {
    // Apply filters
    if (_filterQuery.isNotEmpty) {
      potionsList = potionsList
          .where((potion) =>
              potion.name.toLowerCase().contains(_filterQuery.toLowerCase()))
          .toList();
    }

    if (_selectedRarity != null) {
      potionsList = potionsList
          .where((potion) => potion.rarity == _selectedRarity)
          .toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'Rarity':
        potionsList.sort((a, b) => b.rarity.index.compareTo(a.rarity.index));
        break;
      case 'Name':
        potionsList.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Quantity':
        potionsList.sort((a, b) => b.quantity.compareTo(a.quantity));
        break;
    }

    return potionsList;
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
          'No potions available.',
          style: TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildPotionsGrid(List<Potion> potionsList) {
    return GridView.builder(
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.7,
      ),
      itemCount: potionsList.length,
      itemBuilder: (context, index) {
        final potion = potionsList[index];
        return GestureDetector(
          onTap: () => _showPotionActions(context, potion),
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
                      color: _getRarityColor(potion.rarity).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: _getRarityColor(potion.rarity),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Image.asset(
                        potion.iconAsset,
                        width: 40,
                        height: 40,
                        errorBuilder: (_, __, ___) =>
                            Icon(Icons.local_drink, size: 40),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    potion.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getRarityColor(potion.rarity),
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'x${potion.quantity}',
                    style: TextStyle(fontSize: 10, color: Colors.white70),
                  ),
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
                  items: ['Rarity', 'Name', 'Quantity'].map((value) {
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
                  child: DropdownButton<PotionRarity>(
                    value: _selectedRarity,
                    hint: Text('All Rarities',
                        style: TextStyle(color: Colors.white)),
                    onChanged: (PotionRarity? newValue) =>
                        setState(() => _selectedRarity = newValue),
                    items: PotionRarity.values.map((rarity) {
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
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.refresh, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _filterQuery = '';
                    _selectedRarity = null;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGirlSelectionView(GameProvider gameProvider, Potion potion) {
    final girls = gameProvider.getEligibleGirlsForPotion(potion);

    return Column(
      children: [
        _PotionSummaryCard(potion: potion),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Select quantity (${potion.quantity} available):',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 16),
              _buildQuantitySelector(potion),
            ],
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
              backgroundColor: _getRarityColor(potion.rarity),
            ),
            child: Text(
              'Use ${_selectedQuantity}x Potion',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector(Potion potion) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            if (_selectedQuantity > 1) {
              setState(() => _selectedQuantity--);
            }
          },
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '$_selectedQuantity',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            if (_selectedQuantity < potion.quantity) {
              setState(() => _selectedQuantity++);
            }
          },
        ),
      ],
    );
  }

  Future<void> _showPotionActions(BuildContext context, Potion potion) {
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
              if (potion.quantity > 1) ...[
                ListTile(
                  leading: const Icon(Icons.local_drink),
                  title: const Text('Use Multiple Potions'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedPotion = potion;
                      _selectedQuantity = 1;
                      _showGirlSelection = true;
                    });
                  },
                ),
                const Divider(),
              ],
              ListTile(
                leading: const Icon(Icons.local_drink),
                title: const Text('Use 1 Potion'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedPotion = potion;
                    _selectedQuantity = 1;
                    _showGirlSelection = true;
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('Sell Potion'),
                onTap: () {
                  Navigator.pop(context);
                  _showSellOptions(context, potion);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete Potion',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteOptions(context, potion);
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

  Future<void> _showSellOptions(BuildContext context, Potion potion) async {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    if (potion.quantity == 1) {
      await _sellPotion(context, potion, gameProvider);
      return;
    }

    final action = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sell Options'),
        content: const Text('How would you like to sell this potion?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'one'),
            child: const Text('Sell 1'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'some'),
            child: const Text('Sell Multiple'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'all'),
            child: const Text('Sell All'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'cancel'),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    switch (action) {
      case 'one':
        await _sellPotion(context, potion, gameProvider);
        break;
      case 'some':
        await _showQuantityDialog(
          context,
          potion,
          gameProvider,
          maxQuantity: potion.quantity,
          action: 'Sell',
          onConfirmed: (quantity) =>
              _sellPotion(context, potion, gameProvider, quantity: quantity),
        );
        break;
      case 'all':
        await _sellPotion(context, potion, gameProvider,
            quantity: potion.quantity);
        break;
    }
  }

  Future<void> _showDeleteOptions(BuildContext context, Potion potion) async {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    if (potion.quantity == 1) {
      await _deletePotion(context, potion, gameProvider);
      return;
    }

    final action = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Options'),
        content: const Text('How would you like to delete this potion?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'one'),
            child: const Text('Delete 1'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'some'),
            child: const Text('Delete Multiple'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'all'),
            child: const Text('Delete All'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'cancel'),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    switch (action) {
      case 'one':
        await _deletePotion(context, potion, gameProvider);
        break;
      case 'some':
        await _showQuantityDialog(
          context,
          potion,
          gameProvider,
          maxQuantity: potion.quantity,
          action: 'Delete',
          onConfirmed: (quantity) =>
              _deletePotion(context, potion, gameProvider, quantity: quantity),
        );
        break;
      case 'all':
        await _deletePotion(context, potion, gameProvider,
            quantity: potion.quantity);
        break;
    }
  }

  Future<void> _showQuantityDialog(
    BuildContext context,
    Potion potion,
    GameProvider gameProvider, {
    required int maxQuantity,
    required String action,
    required Function(int) onConfirmed,
  }) async {
    int quantity = 1;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('$action Potion'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Select quantity to $action (max: $maxQuantity)'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (quantity > 1) {
                          setState(() => quantity--);
                        }
                      },
                    ),
                    Container(
                      width: 60,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '$quantity',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        if (quantity < maxQuantity) {
                          setState(() => quantity++);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onConfirmed(quantity);
                },
                child: Text(action),
              ),
            ],
          );
        },
      ),
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
                'Quantity: ${potion.quantity}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
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
        quantity: _selectedQuantity,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Used ${_selectedQuantity}x ${potion.name} on ${girl.name}!'),
            duration: const Duration(seconds: 2),
          ),
        );

        setState(() {
          _showGirlSelection = false;
          _selectedGirl = null;
          _selectedPotion = null;
          _selectedQuantity = 1;
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
      BuildContext context, Potion potion, GameProvider gameProvider,
      {int quantity = 1}) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sell Potion'),
        content: Text(
            'Sell ${quantity}x ${potion.name} for ${gameProvider.calculatePotionSellPrice(potion) * quantity} credits?'),
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
        final success = await gameProvider.sellPotion(
          potionId: potion.id,
          quantity: quantity,
        );

        if (!mounted) return;

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Sold ${quantity}x ${potion.name} for ${gameProvider.calculatePotionSellPrice(potion) * quantity} credits'),
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
      BuildContext context, Potion potion, GameProvider gameProvider,
      {int quantity = 1}) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Potion'),
        content: Text('Permanently delete ${quantity}x ${potion.name}?'),
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
        final success = await gameProvider.deletePotion(
          potionId: potion.id,
          quantity: quantity,
        );

        if (!mounted) return;

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Deleted ${quantity}x ${potion.name}'),
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
}

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
                        '${potion.rarity.toString().split('.').last} • ${potion.quantity} available',
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
