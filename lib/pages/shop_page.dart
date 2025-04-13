import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/girl_data.dart';
import '../models/girl_farmer_model.dart';
import '../models/shop_model.dart';
import '../providers/game_provider.dart';
import '../main.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int _selectedCategoryIndex = 0;
  final Map<String, int> _purchaseQuantities = {};

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
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip:
                  'Refresh (${3 - (gameProvider.shop?.refreshCountToday ?? 0)} left today)',
              onPressed: () => _showRefreshDialog(context, gameProvider),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ImageCacheManager.getImage('assets/images/ui/app-bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              _buildCategoryTabs(shopCategories),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.6,
                    ),
                    itemCount: currentItems.length,
                    itemBuilder: (context, index) {
                      return _buildShopItemCard(
                          context, currentItems[index], gameProvider);
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  // New method for refresh dialog
  Future<void> _showRefreshDialog(
      BuildContext context, GameProvider gameProvider) async {
    final refreshesLeft = 3 - (gameProvider.shop?.refreshCountToday ?? 0);

    if (refreshesLeft <= 0) {
      await showDialog(
        context: context,
        builder: (context) => _buildBasicDialog(
          title: "No Refreshes Left",
          content: "You've used all 3 refreshes for today.",
          backgroundColor: Colors.grey[900]!,
          borderColor: Colors.redAccent,
        ),
      );
      return;
    }

    final shouldRefresh = await showDialog<bool>(
      context: context,
      builder: (context) => _buildBasicDialog(
        title: "Refresh Shop?",
        content:
            "You have $refreshesLeft refresh${refreshesLeft == 1 ? '' : 'es'} left today.",
        backgroundColor: Colors.grey[850]!,
        borderColor: Colors.blueAccent,
        showActions: true,
        confirmText: "Refresh",
      ),
    );

    if (shouldRefresh == true) {
      gameProvider.manualRefreshShop();
    }
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
              onSelected: (selected) =>
                  setState(() => _selectedCategoryIndex = index),
              avatar: Icon(_getCategoryIcon(category.id)),
              selectedColor: Colors.blue[200],
              labelStyle: TextStyle(
                color: _selectedCategoryIndex == index ? Colors.black : null,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShopItemCard(
      BuildContext context, ShopItem item, GameProvider gameProvider) {
    final isPurchased = gameProvider.isItemPurchased(item.id);
    final canAfford = gameProvider.canAffordItem(item);
    final hasStock = item.hasStock;
    final isPotion = item.type == ShopItemType.potion;

    final bool isGirlItem = item.type == ShopItemType.girl;
    GirlFarmer? girl;
    if (isGirlItem) {
      try {
        girl = girlsData.firstWhere((g) => g.id == item.itemId);
      } catch (_) {
        girl = null;
      }
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isPurchased || !canAfford || !hasStock
            ? null
            : () => isPotion
                ? _showPurchaseQuantityDialog(context, item, gameProvider)
                : _showPurchaseConfirmationDialog(context, item, gameProvider),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: Center(
                      child: isGirlItem && girl != null
                          ? ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              child: Image.asset(
                                girl.imageFace,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildFallbackIcon(item.type),
                              ),
                            )
                          : _buildFallbackIcon(item.type),
                    ),
                  ),
                ),
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
                      if (isPotion && _purchaseQuantities[item.id] != null)
                        Text(
                          'Qty: ${_purchaseQuantities[item.id]}',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (isPurchased) _buildStatusBadge('P', Colors.green),
            if (!canAfford && !isPurchased)
              _buildStatusBadge('Can\'t Afford', Colors.red),
            if (!hasStock && !isPurchased)
              _buildStatusBadge('Out of Stock', Colors.orange),
            if (isGirlItem && girl != null)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getRarityColor(girl.rarity),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    girl.rarity,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // New method for purchase confirmation dialog
  Future<void> _showPurchaseConfirmationDialog(
      BuildContext context, ShopItem item, GameProvider gameProvider) async {
    final shouldPurchase = await showDialog<bool>(
      context: context,
      builder: (context) => _buildBasicDialog(
        title: "Confirm Purchase",
        content:
            "Are you sure you want to buy ${item.name} for ${_formatPrices(item.prices)}?",
        backgroundColor: Colors.grey[850]!,
        borderColor: Colors.blueAccent,
        showActions: true,
        confirmText: "Buy",
      ),
    );

    if (shouldPurchase == true) {
      await _attemptPurchase(context, item, gameProvider);
    }
  }

  Future<void> _showPurchaseQuantityDialog(
      BuildContext context, ShopItem item, GameProvider gameProvider) async {
    final maxAffordable = gameProvider.getMaxAffordableQuantity(item);
    final maxStock = item.stock ?? 99;
    final maxQuantity =
        [maxAffordable, maxStock, 99].reduce((a, b) => a < b ? a : b);

    int quantity = _purchaseQuantities[item.id] ?? 1;

    final shouldPurchase = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return _buildBasicDialog(
            title: "Purchase ${item.name}",
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("How many would you like to purchase?"),
                const SizedBox(height: 16),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: quantity > 1
                          ? () => setState(() => quantity--)
                          : null,
                    ),
                    Expanded(
                      child: Slider(
                        value: quantity.toDouble(),
                        min: 1,
                        max: maxQuantity.toDouble(),
                        divisions: maxQuantity - 1,
                        label: quantity.toString(),
                        onChanged: (value) =>
                            setState(() => quantity = value.toInt()),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: quantity < maxQuantity
                          ? () => setState(() => quantity++)
                          : null,
                    ),
                  ],
                ),
                Text('$quantity', style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 8),
                Text('Total Cost:'),
                _buildPriceTags(item.prices
                    .map((key, value) => MapEntry(key, value * quantity))),
              ],
            ),
            backgroundColor: Colors.grey[850]!,
            borderColor: Colors.blueAccent,
            showActions: true,
            confirmText: "Purchase",
          );
        },
      ),
    );

    if (shouldPurchase == true) {
      _purchaseQuantities[item.id] = quantity;
      await _attemptPurchase(context, item, gameProvider, quantity: quantity);
    }
  }

  Future<void> _attemptPurchase(
      BuildContext context, ShopItem item, GameProvider gameProvider,
      {int quantity = 1}) async {
    final success = await gameProvider.purchaseItem(item, quantity: quantity);
    if (!context.mounted) return;

    await showDialog(
      context: context,
      builder: (context) => _buildBasicDialog(
        title: success ? "Success!" : "Failed",
        content: success
            ? 'Purchased ${quantity > 1 ? '$quantity ' : ''}${item.name}${quantity > 1 ? 's' : ''}'
            : 'Failed to purchase ${item.name}',
        backgroundColor: success ? Colors.green[800]! : Colors.red[800]!,
        borderColor: success ? Colors.greenAccent : Colors.redAccent,
      ),
    );
  }

  // Reusable dialog builder
  Widget _buildBasicDialog({
    required String title,
    required dynamic content,
    required Color backgroundColor,
    Color borderColor = Colors.transparent,
    bool showActions = false,
    String confirmText = "OK",
  }) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 20, color: Colors.white)),
            const SizedBox(height: 10),
            if (content is String)
              Text(content, style: const TextStyle(color: Colors.white70))
            else if (content is Widget)
              content,
            const SizedBox(height: 20),
            if (showActions)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Cancel",
                        style: TextStyle(color: Colors.white70)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(confirmText,
                        style: const TextStyle(color: Colors.lightBlueAccent)),
                  ),
                ],
              )
            else
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:
                    const Text("OK", style: TextStyle(color: Colors.white70)),
              ),
          ],
        ),
      ),
    );
  }

  // Helper method to format prices for display
  String _formatPrices(Map<String, int> prices) {
    return prices.entries.map((e) => '${e.value} ${e.key}').join(', ');
  }

  // ... (keep all other existing methods the same)
  Color _getRarityColor(String rarity) {
    return switch (rarity) {
      'Common' => Colors.grey,
      'Rare' => Colors.blue,
      'Unique' => Colors.purple,
      _ => Colors.grey,
    };
  }

  Widget _buildFallbackIcon(ShopItemType type) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Icon(
        _getItemIcon(type),
        size: 48,
        color: Colors.grey[600],
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
}
