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
  Potion? _selectedPotion;
  GirlFarmer? _selectedGirl;
  bool _showGirlSelection = false;
  PotionRarity? _selectedRarity;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  int _selectedQuantity = 1;

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
        if (!_showGirlSelection) ...[
          _buildFilterBar(),
          _buildSearchBar(),
        ],
        Expanded(
          child: _showGirlSelection && _selectedPotion != null
              ? _buildGirlSelectionView(gameProvider, _selectedPotion!)
              : _buildPotionGridView(potions, gameProvider),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search potions...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onChanged: (value) => setState(() => _searchQuery = value),
      ),
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
                  label: Text(
                    rarity.toString().split('.').last,
                    style: TextStyle(
                      color: _selectedRarity == rarity ? Colors.white : null,
                    ),
                  ),
                  selected: _selectedRarity == rarity,
                  selectedColor: _getRarityColor(rarity),
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
                  _showSellOptions(context, potion, gameProvider);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete Potion',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteOptions(context, potion, gameProvider);
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

  Future<void> _showSellOptions(
      BuildContext context, Potion potion, GameProvider gameProvider) async {
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

  Future<void> _showDeleteOptions(
      BuildContext context, Potion potion, GameProvider gameProvider) async {
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

              // Quantity indicator
              Text(
                'Quantity: ${potion.quantity}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
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
