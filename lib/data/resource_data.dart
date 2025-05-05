import '../models/resource_model.dart';
import 'package:flutter/material.dart'; // Required for Colors

class ResourceData {
  static const Map<String, ResourceConfig> resources = {
    'Default': ResourceConfig(
      name: 'Default',
      imagePath: 'assets/images/resources/resources-default.png',
      color: Color(0xFF373737),
    ),
    'Gold': ResourceConfig(
      name: 'Gold',
      imagePath: 'assets/images/resources/resources-gold.png',
      color: Color(0xFFFFD700),
    ),
    'Silver': ResourceConfig(
      name: 'Silver',
      imagePath: 'assets/images/resources/resources-silver.png',
      color: Color(0xFFBCC6CC),
    ),
    'Metal': ResourceConfig(
      name: 'Metal',
      imagePath: 'assets/images/resources/resources-metal.png',
      color: Color(0xFF596369),
    ),
    'Rune': ResourceConfig(
      name: 'Rune',
      imagePath: 'assets/images/resources/resources-rune.png',
      color: Color(0xFFFF5555),
    ),

    'Minerals': ResourceConfig(
      name: 'Minerals',
      imagePath: 'assets/images/resources/resources-metal.png',
      color: Color(0xFF3CB371),
    ),
    'Credits': ResourceConfig(
      name: 'Credits',
      imagePath: 'assets/images/resources/resources-gold.png',
      color: Color(0xFF9370DB),
    ),

    // Upgrade War Maiden Resources
    'Skill Book': ResourceConfig(
      name: 'Skill Book',
      imagePath: 'assets/images/resources/resources-skillbook.png',
      color: Color(0xFF79E2FF),
    ),
    'Awakening Shard': ResourceConfig(
      name: 'Awakening Shard',
      imagePath: 'assets/images/resources/resources-awakeningshard.png',
      color: Color(0xFFF7FC79),
    ),

    // Upgrade Equipment Resources
    'Enhancement Stone': ResourceConfig(
      name: 'Enhancement Stone',
      imagePath: 'assets/images/resources/resources-enhancementstone.png',
      color: Color(0xFFBB69FF),
    ),
    'Forge Material': ResourceConfig(
      name: 'Forge Material',
      imagePath: 'assets/images/resources/resources-forgematerial.png',
      color: Color(0xFFD67E43),
    ),

    // Summoning Resources
    'Girl Scroll': ResourceConfig(
      name: 'Girl Scroll',
      imagePath: 'assets/images/resources/resources-summongirlscroll.png',
      color: Color(0xFF00C3FF),
    ),
    'Equipment Chest': ResourceConfig(
      name: 'Equipment Chest',
      imagePath: 'assets/images/resources/resources-summonequipmentchest.png',
      color: Color(0xFF00AAFF),
    ),

    // Premium Resources
    'Gem': ResourceConfig(
      name: 'Gem',
      imagePath: 'assets/images/resources/resources-gem.png',
      color: Color(0xFF00E5FF),
    ),
    'Diamond': ResourceConfig(
      name: 'Diamond',
      imagePath: 'assets/images/resources/resources-diamond.png',
      color: Color(0xFFFF6200),
    ),

    // Enter Battle Consume Requirements
    'Stamina': ResourceConfig(
      name: 'Stamina',
      imagePath: 'assets/images/resources/resources-stamina.png',
      color: Color(0xFFF4CD71),
    ),
    'Dungeon Key': ResourceConfig(
      name: 'Dungeon Key',
      imagePath: 'assets/images/resources/resources-dungeonkey.png',
      color: Color(0xFFA8FF3E),
    ),
    'Arena Ticket': ResourceConfig(
      name: 'Arena Ticket',
      imagePath: 'assets/images/resources/resources-arenaticket.png',
      color: Color(0xFFFF3E68),
    ),
    'Raid Ticket': ResourceConfig(
      name: 'Raid Ticket',
      imagePath: 'assets/images/resources/resources-raidticket.png',
      color: Color(0xFFFF5E2C),
    ),
  };

  static ResourceConfig? getConfig(String name) => resources[name];
}

class ResourceConfig {
  final String name;
  final String imagePath;
  final Color color;

  const ResourceConfig({
    required this.name,
    required this.imagePath,
    required this.color,
  });
}
