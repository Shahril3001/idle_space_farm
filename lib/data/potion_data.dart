import '../models/potion_model.dart';

class PotionDatabase {
  static final Map<String, Potion> _potions = {
    'potion_health_perm': Potion(
      id: 'potion_health_perm',
      name: 'Permanent Health Elixir',
      description: 'Permanently increases max HP by 20',
      iconAsset: 'assets/potions/health_perm.png',
      hpIncrease: 20,
      rarity: PotionRarity.uncommon,
    ),
    'potion_attack_perm': Potion(
      id: 'potion_attack_perm',
      name: 'Permanent Strength Draught',
      description: 'Permanently increases Attack by 5',
      iconAsset: 'assets/potions/attack_perm.png',
      attackIncrease: 5,
      rarity: PotionRarity.rare,
      allowedTypes: ['warrior', 'berserker'],
    ),
    'potion_crit_perm': Potion(
      id: 'potion_crit_perm',
      name: 'Permanent Critical Essence',
      description: 'Permanently increases Critical Chance by 3%',
      iconAsset: 'assets/potions/crit_perm.png',
      criticalPointIncrease: 3,
      rarity: PotionRarity.epic,
    ),
    // Add more potions as needed
  };

  static Potion? getPotion(String id) => _potions[id];
  static List<Potion> get allPotions => _potions.values.toList();
}
