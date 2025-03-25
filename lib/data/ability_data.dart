import '../models/ability_model.dart';

final List<AbilitiesModel> abilitiesList = [
  // Human Ability
  AbilitiesModel(
    abilitiesID: "ability_001",
    name: "Second Wind",
    description: "Restores a small amount of HP.",
    hpBonus: 10,
    spCost: 5,
    cooldown: 4,
  ),
  // Elves Ability
  AbilitiesModel(
    abilitiesID: "ability_002",
    name: "Nature's Blessing",
    description: "Increases agility and defense.",
    attackBonus: 15,
    spCost: 10,
    cooldown: 3,
  ),
  // Demi Human Ability
  AbilitiesModel(
    abilitiesID: "ability_003",
    name: "Beastial Fury",
    description: "Increases attack and agility for a short duration.",
    attackBonus: 10,
    agilityBonus: 10,
    spCost: 12,
    cooldown: 6,
  ),
  // Dragonoid Ability
  AbilitiesModel(
    abilitiesID: "ability_004",
    name: "Dragon's Breath",
    description: "Deals fire damage to all enemies.",
    attackBonus: 20,
    spCost: 15,
    cooldown: 5,
  ),
  // Demon Ability
  AbilitiesModel(
    abilitiesID: "ability_005",
    name: "Shadow Step",
    description: "Teleports behind the enemy, increasing agility.",
    agilityBonus: 10,
    spCost: 7,
    cooldown: 3,
  ),
  AbilitiesModel(
    abilitiesID: "ability_006",
    name: "Fireball",
    description: "A fiery projectile that deals damage to the enemy.",
    attackBonus: 15,
    mpCost: 10,
    cooldown: 3,
    criticalPoint: 10, // 10% chance for a critical hit
  ),
  AbilitiesModel(
    abilitiesID: "ability_007",
    name: "Heal",
    description: "Restores HP to the user.",
    hpBonus: 20,
    mpCost: 15,
    cooldown: 5,
  ),
  AbilitiesModel(
    abilitiesID: "ability_008",
    name: "Agility Boost",
    description: "Increases agility for a short duration.",
    agilityBonus: 10,
    spCost: 5,
    cooldown: 4,
  ),
  AbilitiesModel(
    abilitiesID: "ability_009",
    name: "Shield Bash",
    description: "A powerful strike that stuns the enemy.",
    attackBonus: 10,
    defenseBonus: 5,
    mpCost: 8,
    cooldown: 4,
    criticalPoint: 15, // 15% chance for a critical hit
  ),
  AbilitiesModel(
    abilitiesID: "ability_010",
    name: "Poison Dart",
    description: "A dart coated with poison that deals damage over time.",
    attackBonus: 5,
    mpCost: 6,
    cooldown: 2,
    criticalPoint: 20, // 20% chance for a critical hit
  ),
  AbilitiesModel(
    abilitiesID: "ability_011",
    name: "Mana Surge",
    description: "Restores MP to the user.",
    mpCost: -20, // Negative cost means it restores MP
    cooldown: 6,
  ),
  AbilitiesModel(
    abilitiesID: "ability_012",
    name: "Berserk",
    description: "Increases attack power at the cost of defense.",
    attackBonus: 25,
    defenseBonus: -10, // Negative bonus reduces defense
    spCost: 15,
    cooldown: 6,
  ),
  AbilitiesModel(
    abilitiesID: "ability_013",
    name: "Earthquake",
    description: "A powerful ground attack that damages all enemies.",
    attackBonus: 30,
    mpCost: 20,
    cooldown: 8,
    criticalPoint: 5, // 5% chance for a critical hit
  ),
  AbilitiesModel(
    abilitiesID: "ability_014",
    name: "Stealth",
    description: "Makes the user invisible for a short duration.",
    agilityBonus: 20,
    spCost: 10,
    cooldown: 7,
  ),
  AbilitiesModel(
    abilitiesID: "ability_015",
    name: "Revive",
    description: "Revives a fallen ally with partial HP.",
    hpBonus: 50,
    mpCost: 30,
    cooldown: 10,
  ),
  // Divine Cleric Abilities
  AbilitiesModel(
    abilitiesID: "ability_016",
    name: "Holy Light",
    description: "A radiant light heals allies and damages undead enemies.",
    hpBonus: 25,
    attackBonus: 10,
    mpCost: 15,
    cooldown: 5,
  ),
  AbilitiesModel(
    abilitiesID: "ability_017",
    name: "Divine Shield",
    description: "Grants temporary immunity to damage for one turn.",
    defenseBonus: 50,
    mpCost: 20,
    cooldown: 8,
  ),
  AbilitiesModel(
    abilitiesID: "ability_018",
    name: "Purify",
    description: "Removes all negative effects from an ally.",
    mpCost: 10,
    cooldown: 6,
  ),

  // Phantom Reaver Abilities
  AbilitiesModel(
    abilitiesID: "ability_019",
    name: "Phantom Slash",
    description:
        "A spectral blade cuts through enemies, ignoring some defense.",
    attackBonus: 20,
    criticalPoint: 15,
    mpCost: 12,
    cooldown: 4,
  ),
  AbilitiesModel(
    abilitiesID: "ability_020",
    name: "Soul Drain",
    description: "Steals HP from an enemy and restores it to the user.",
    attackBonus: 15,
    hpBonus: 15,
    mpCost: 10,
    cooldown: 5,
  ),
  AbilitiesModel(
    abilitiesID: "ability_021",
    name: "Shadow Veil",
    description: "Increases evasion and reduces damage taken for 2 turns.",
    agilityBonus: 15,
    defenseBonus: 10,
    mpCost: 18,
    cooldown: 7,
  ),

  // Runebinder Abilities
  AbilitiesModel(
    abilitiesID: "ability_022",
    name: "Rune Explosion",
    description: "Triggers a stored rune to deal massive damage.",
    attackBonus: 30,
    mpCost: 25,
    cooldown: 8,
  ),
  AbilitiesModel(
    abilitiesID: "ability_023",
    name: "Arcane Barrier",
    description: "Creates a protective shield that absorbs magic damage.",
    defenseBonus: 25,
    mpCost: 20,
    cooldown: 6,
  ),
  AbilitiesModel(
    abilitiesID: "ability_024",
    name: "Mana Infusion",
    description: "Restores MP to all allies over time.",
    mpCost: -25,
    cooldown: 10,
  ),

  // Arcane Sage Abilities
  AbilitiesModel(
    abilitiesID: "ability_025",
    name: "Mystic Bolt",
    description: "Unleashes a concentrated magical energy bolt at the enemy.",
    attackBonus: 22,
    mpCost: 14,
    cooldown: 4,
    criticalPoint: 10,
  ),
  AbilitiesModel(
    abilitiesID: "ability_026",
    name: "Spell Echo",
    description: "Grants a chance to recast the last spell for free.",
    mpCost: 0,
    cooldown: 7,
  ),
  AbilitiesModel(
    abilitiesID: "ability_027",
    name: "Arcane Torrent",
    description: "A surge of magic weakens enemy spellcasters' MP.",
    attackBonus: 10,
    mpCost: 15,
    cooldown: 6,
  ),

  // Blademaster Abilities
  AbilitiesModel(
    abilitiesID: "ability_028",
    name: "Blade Dance",
    description: "A flurry of strikes hitting multiple enemies.",
    attackBonus: 18,
    agilityBonus: 10,
    spCost: 12,
    cooldown: 5,
  ),
  AbilitiesModel(
    abilitiesID: "ability_029",
    name: "Counter Stance",
    description: "Enters a stance to counter enemy attacks for 2 turns.",
    defenseBonus: 20,
    agilityBonus: 5,
    spCost: 15,
    cooldown: 8,
  ),
  AbilitiesModel(
    abilitiesID: "ability_030",
    name: "Crimson Slash",
    description: "A brutal slash that deals extra damage if below 50% HP.",
    attackBonus: 25,
    criticalPoint: 20,
    spCost: 15,
    cooldown: 6,
  ),

  // Warden Abilities
  AbilitiesModel(
    abilitiesID: "ability_031",
    name: "Guardian's Wrath",
    description: "A powerful counterattack after blocking an enemy hit.",
    attackBonus: 20,
    defenseBonus: 15,
    spCost: 10,
    cooldown: 5,
  ),
  AbilitiesModel(
    abilitiesID: "ability_032",
    name: "Iron Fortress",
    description: "Greatly increases defense for 3 turns.",
    defenseBonus: 30,
    spCost: 20,
    cooldown: 7,
  ),
  AbilitiesModel(
    abilitiesID: "ability_033",
    name: "Taunt",
    description: "Forces enemies to attack the user for 2 turns.",
    defenseBonus: 10,
    spCost: 8,
    cooldown: 4,
  ),

  // Elementalist Abilities
  AbilitiesModel(
    abilitiesID: "ability_034",
    name: "Lightning Storm",
    description: "Summons lightning to strike multiple enemies.",
    attackBonus: 28,
    mpCost: 22,
    cooldown: 7,
    criticalPoint: 10,
  ),
  AbilitiesModel(
    abilitiesID: "ability_035",
    name: "Ice Barricade",
    description: "Reduces enemy movement and increases defense.",
    defenseBonus: 20,
    mpCost: 18,
    cooldown: 6,
  ),
  AbilitiesModel(
    abilitiesID: "ability_036",
    name: "Inferno",
    description: "Unleashes a blazing fire that deals damage over time.",
    attackBonus: 25,
    mpCost: 20,
    cooldown: 6,
  ),

  // Dread Knight Abilities
  AbilitiesModel(
    abilitiesID: "ability_037",
    name: "Dark Cleave",
    description: "A heavy attack that drains some HP from enemies.",
    attackBonus: 25,
    hpBonus: 10,
    mpCost: 15,
    cooldown: 6,
  ),
  AbilitiesModel(
    abilitiesID: "ability_038",
    name: "Unholy Resilience",
    description: "Grants temporary immunity to death for 1 turn.",
    hpBonus: 50,
    mpCost: 25,
    cooldown: 10,
  ),
  AbilitiesModel(
    abilitiesID: "ability_039",
    name: "Cursed Strike",
    description: "Inflicts a debuff that reduces enemy defense.",
    attackBonus: 20,
    defenseBonus: -10,
    mpCost: 12,
    cooldown: 5,
  ),
];

// Helper function to find an ability by its ID
AbilitiesModel? getAbilityById(String abilitiesID) {
  return abilitiesList.firstWhere(
    (ability) => ability.abilitiesID == abilitiesID,
    orElse: () => throw Exception("Ability not found"),
  );
}
