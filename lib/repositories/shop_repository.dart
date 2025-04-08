import 'package:hive/hive.dart';
import '../models/shop_model.dart';

class ShopRepository {
  final Box<dynamic> _box;
  static const String _shopKey = 'shop';

  ShopRepository(this._box);

  Future<void> initializeDefaultShop() async {
    if (!_box.containsKey(_shopKey) || _box.get(_shopKey) == null) {
      final defaultShop = ShopModel(
        categories: createDefaultShopCategories(),
      );
      await saveShop(defaultShop);
    }
  }

  Future<void> saveShop(ShopModel shop) async {
    await _box.put(_shopKey, shop);
  }

  ShopModel? getShop() {
    return _box.get(_shopKey);
  }

  Future<void> clearShop() async {
    await _box.delete(_shopKey);
  }

  Future<void> addPurchasedItem(String itemId) async {
    final shop = getShop();
    if (shop != null) {
      shop.recordPurchase(itemId);
      await saveShop(shop);
    }
  }

  Future<void> removePurchasedItem(String itemId) async {
    final shop = getShop();
    if (shop != null) {
      shop.purchasedItemIds.remove(itemId);
      await saveShop(shop);
    }
  }

  bool isItemPurchased(String itemId) {
    final shop = getShop();
    return shop?.purchasedItemIds.contains(itemId) ?? false;
  }

  Future<void> updateCategory(ShopCategory category) async {
    final shop = getShop();
    if (shop != null) {
      final index = shop.categories.indexWhere((c) => c.id == category.id);
      if (index >= 0) {
        final updatedCategories = List<ShopCategory>.from(shop.categories);
        updatedCategories[index] = category;
        await saveShop(shop.copyWith(categories: updatedCategories));
      }
    }
  }

  Future<void> updateItemStock(String itemId, int newStock) async {
    final shop = getShop();
    if (shop != null) {
      final updatedCategories = shop.categories.map((category) {
        final itemIndex = category.items.indexWhere((i) => i.id == itemId);
        if (itemIndex >= 0) {
          final updatedItem =
              category.items[itemIndex].copyWith(stock: newStock);
          final updatedItems = List<ShopItem>.from(category.items);
          updatedItems[itemIndex] = updatedItem;
          return category.copyWith(items: updatedItems);
        }
        return category;
      }).toList();

      await saveShop(shop.copyWith(categories: updatedCategories));
    }
  }

  Future<void> refreshShop() async {
    final shop = getShop();
    if (shop != null) {
      final refreshedShop = shop.copyWith(
        categories: createDefaultShopCategories(),
        lastRefreshTime: DateTime.now(),
      );
      await saveShop(refreshedShop);
    }
  }

  void debugPrintShop() {
    final shop = getShop();
    if (shop == null) {
      print('No shop data found');
      return;
    }

    print('Shop last refreshed: ${shop.lastRefreshTime}');
    print('Purchased items: ${shop.purchasedItemIds.join(', ')}');

    for (final category in shop.categories) {
      print('\nCategory: ${category.name}');
      for (final item in category.items) {
        print('- ${item.name} (${item.id})');
        print('  Type: ${item.type}, Price: ${item.prices}');
        print(
            '  Stock: ${item.stock ?? "∞"}, Limit: ${item.purchaseLimit ?? "∞"}');
        print('  Purchased: ${isItemPurchased(item.id)}');
      }
    }
  }
}
