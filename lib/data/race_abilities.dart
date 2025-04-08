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
        elementType: ElementType.none,
        affectsEnemies: false,
        healsCaster: true, // Explicitly mark as self-heal
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
        elementType: ElementType.nature, // Added elemental affinity
        statusEffects: [
          StatusEffect(
            id: "natures_blessing",
            name: "Nature's Blessing",
            duration: 3,
            defenseModifier: 15,
            agilityModifier: 10,
          ),
        ],
      ),
    ],
    'Therian': [
      AbilitiesModel(
        abilitiesID: "therian_001",
        name: "Bestial Fury",
        description:
            "Increases attack and agility with animalistic rage for 3 turns.",
        attackBonus: 15,
        agilityBonus: 10,
        spCost: 12,
        cooldown: 6,
        type: AbilityType.buff,
        targetType: TargetType.single,
        affectsEnemies: false,
        elementType: ElementType.nature,
        statusEffects: [
          StatusEffect(
            id: "bestial_fury",
            name: "Bestial Fury",
            duration: 3,
            attackModifier: 15,
            agilityModifier: 10,
          ),
        ],
      ),
    ],
    'Dracovar': [
      AbilitiesModel(
        abilitiesID: "dracovar_001",
        name: "Dragon's Breath",
        description: "Deals 25 fire damage to all enemies.",
        hpBonus: 25,
        spCost: 15,
        cooldown: 5,
        type: AbilityType.attack,
        targetType: TargetType.all,
        affectsEnemies: true,
        criticalPoint: 10,
        elementType: ElementType.fire,
      ),
    ],
    'Daemon': [
      AbilitiesModel(
        abilitiesID: "daemon_001",
        name: "Shadow Step",
        description: "Teleports, increasing AGI by 20 for 2 turns.",
        agilityBonus: 20,
        mpCost: 7,
        cooldown: 3,
        type: AbilityType.buff,
        targetType: TargetType.single,
        affectsEnemies: false,
        elementType: ElementType.dark,
        statusEffects: [
          StatusEffect(
            id: "shadow_step",
            name: "Phased",
            duration: 2,
            agilityModifier: 20,
          ),
        ],
      ),
    ],
  };

  static List<AbilitiesModel> getStarterAbilities(String race) {
    return _starterAbilities[race]?.map((a) => a.freshCopy()).toList() ?? [];
  }
}
