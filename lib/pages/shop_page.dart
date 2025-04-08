import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/resource_model.dart';
import '../models/shop_model.dart';
import '../providers/game_provider.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeShop();
  }

  Future<void> _initializeShop() async {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    if (gameProvider.shopCategories.isEmpty) {
      await gameProvider.initializeShop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    // Show loading indicator while shop is initializing
    if (gameProvider.isShopLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final shopCategories = gameProvider.shopCategories;
    if (shopCategories.isEmpty) {
      return const Center(child: Text('No shop items available'));
    }

    final currentCategory = shopCategories[_selectedCategoryIndex];
    final currentItems = currentCategory.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Category Tabs
          _buildCategoryTabs(shopCategories),

          // Items Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: currentItems.length,
                itemBuilder: (context, index) {
                  return _buildShopItemCard(
                      context, currentItems[index], gameProvider);
                },
              ),
            ),
          ),

          // Resource Bar
          _buildResourceBar(context),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs(List<ShopCategory> categories) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChoiceChip(
              label: Text(category.name),
              selected: _selectedCategoryIndex == index,
              onSelected: (selected) {
                setState(() {
                  _selectedCategoryIndex = index;
                });
              },
              avatar: Icon(_getCategoryIcon(category.id)),
            ),
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(String categoryId) {
    switch (categoryId) {
      case 'girls':
        return Icons.person;
      case 'equipment':
        return Icons.shield;
      case 'potions':
        return Icons.local_drink;
      case 'abilities':
        return Icons.menu_book;
      default:
        return Icons.shopping_cart;
    }
  }

  Widget _buildShopItemCard(
      BuildContext context, ShopItem item, GameProvider gameProvider) {
    final isPurchased = gameProvider.isItemPurchased(item.id);
    final canAfford = gameProvider.canAffordItem(item);
    final hasStock = item.hasStock;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isPurchased || !canAfford || !hasStock
            ? null
            : () => _attemptPurchase(context, item, gameProvider),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Item Image
                Expanded(
                  child: Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(
                        _getItemIcon(item.type),
                        size: 48,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),

                // Item Info
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      _buildPriceTags(item.prices),
                      if (item.stock != null)
                        Text('Stock: ${item.stock}',
                            style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),

            // Status Badges
            if (isPurchased) _buildStatusBadge('Purchased', Colors.green),
            if (!canAfford && !isPurchased)
              _buildStatusBadge('Can\'t Afford', Colors.red),
            if (!hasStock && !isPurchased)
              _buildStatusBadge('Out of Stock', Colors.orange),
          ],
        ),
      ),
    );
  }

  IconData _getItemIcon(ShopItemType type) {
    switch (type) {
      case ShopItemType.girl:
        return Icons.person;
      case ShopItemType.equipment:
        return Icons.shield;
      case ShopItemType.potion:
        return Icons.local_drink;
      case ShopItemType.abilityScroll:
        return Icons.menu_book;
    }
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPriceTags(Map<String, int> prices) {
    return Wrap(
      spacing: 4,
      children: prices.entries.map((entry) {
        return Chip(
          label: Text('${entry.value} ${entry.key}'),
          backgroundColor: _getCurrencyColor(entry.key),
          labelStyle: const TextStyle(fontSize: 12),
          visualDensity: VisualDensity.compact,
        );
      }).toList(),
    );
  }

  Color _getCurrencyColor(String currency) {
    switch (currency) {
      case 'Energy':
        return Colors.amber[200]!;
      case 'Minerals':
        return Colors.blue[200]!;
      case 'Credits':
        return Colors.green[200]!;
      default:
        return Colors.grey[200]!;
    }
  }

  Widget _buildResourceBar(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final resources = gameProvider.resources;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildResourceChip(context, 'Energy', Icons.bolt),
          _buildResourceChip(context, 'Minerals', Icons.terrain),
          _buildResourceChip(context, 'Credits', Icons.monetization_on),
        ],
      ),
    );
  }

  Widget _buildResourceChip(
      BuildContext context, String resourceName, IconData icon) {
    final gameProvider = Provider.of<GameProvider>(context);
    final resource = gameProvider.resources.firstWhere(
      (r) => r.name == resourceName,
      orElse: () => Resource(name: resourceName, amount: 0),
    );

    return Row(
      children: [
        Icon(icon, color: _getCurrencyColor(resourceName)),
        const SizedBox(width: 4),
        Text(
          resource.amount.toStringAsFixed(0),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _getCurrencyColor(resourceName),
          ),
        ),
      ],
    );
  }

  Future<void> _attemptPurchase(
      BuildContext context, ShopItem item, GameProvider gameProvider) async {
    final success = await gameProvider.purchaseItem(item);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success
            ? 'Successfully purchased ${item.name}'
            : 'Failed to purchase ${item.name}'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }
}
