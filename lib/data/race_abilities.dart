// lib/data/race_abilities.dart
import '../models/ability_model.dart';

class RaceAbilities {
  static final Map<String, List<AbilitiesModel>> _starterAbilities = {
    'Human': [
      AbilitiesModel(
        abilitiesID: "human_001",
        name: "Second Wind",
        description: "Restores a small amount of HP in a pinch.",
        hpBonus: 15,
        spCost: 5,
        cooldown: 4,
        type: AbilityType.heal,
        targetType: TargetType.single,
        affectsEnemies: false,
      ),
    ],
    'Eldren': [
      AbilitiesModel(
        abilitiesID: "eldren_001",
        name: "Nature's Blessing",
        description: "Increases agility and defense with natural magic.",
        defenseBonus: 15,
        agilityBonus: 10,
        spCost: 10,
        cooldown: 3,
        type: AbilityType.buff,
        targetType: TargetType.single,
        affectsEnemies: false,
      ),
    ],
    'Therian': [
      AbilitiesModel(
        abilitiesID: "therian_001",
        name: "Bestial Fury",
        description: "Increases attack and agility with animalistic rage.",
        attackBonus: 15,
        agilityBonus: 10,
        spCost: 12,
        cooldown: 6,
        type: AbilityType.buff,
        targetType: TargetType.single,
        affectsEnemies: false,
      ),
    ],
    'Dracovar': [
      AbilitiesModel(
        abilitiesID: "dracovar_001",
        name: "Dragon's Breath",
        description: "Unleashes elemental fury on all enemies.",
        hpBonus: 25,
        spCost: 15,
        cooldown: 5,
        type: AbilityType.attack,
        targetType: TargetType.all,
        affectsEnemies: true,
        criticalPoint: 10,
      ),
    ],
    'Daemon': [
      AbilitiesModel(
        abilitiesID: "daemon_001",
        name: "Shadow Step",
        description: "Teleports behind the enemy, increasing agility.",
        agilityBonus: 10,
        spCost: 7,
        cooldown: 3,
        type: AbilityType.buff,
        targetType: TargetType.single,
        affectsEnemies: false,
      ),
    ],
  };

  static List<AbilitiesModel> getStarterAbilities(String race) {
    return _starterAbilities[race]?.map((a) => a.freshCopy()).toList() ?? [];
  }
}
