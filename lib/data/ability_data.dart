import '../models/ability_model.dart';

final List<AbilitiesModel> abilitiesList = [
  // Human Ability
  // 1. Basic - Second Wind
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

// 2. Basic - Tactical Strike
  AbilitiesModel(
    abilitiesID: "human_002",
    name: "Tactical Strike",
    description: "A precise attack that ignores some defense.",
    hpBonus: 25,
    spCost: 8,
    cooldown: 3,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
    criticalPoint: 15,
  ),

// 3. Rare - Rallying Cry
  AbilitiesModel(
    abilitiesID: "human_003",
    name: "Rallying Cry",
    description: "Boosts attack of all allies for 3 turns.",
    attackBonus: 15,
    spCost: 12,
    cooldown: 5,
    type: AbilityType.buff,
    targetType: TargetType.all,
    affectsEnemies: false,
  ),

// 4. Rare - Last Stand
  AbilitiesModel(
    abilitiesID: "human_004",
    name: "Last Stand",
    description: "When HP is below 30%, gain 50% defense and 20% attack.",
    defenseBonus: 50,
    attackBonus: 20,
    spCost: 15,
    cooldown: 7,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
  ),

// 5. Special - Heroic Sacrifice
  AbilitiesModel(
    abilitiesID: "human_005",
    name: "Heroic Sacrifice",
    description:
        "Deals massive damage to one enemy but reduces user's HP to 1.",
    hpBonus: 999, // Special handling needed in code
    spCost: 25,
    cooldown: 10,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
    criticalPoint: 30,
  ),
  // Elves Ability
  // 1. Basic - Nature's Blessing
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

// 2. Basic - Sylvan Arrow
  AbilitiesModel(
    abilitiesID: "eldren_002",
    name: "Sylvan Arrow",
    description: "A magical arrow that never misses its mark.",
    hpBonus: 20,
    spCost: 7,
    cooldown: 2,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
    criticalPoint: 20, // Higher crit chance
  ),

// 3. Rare - Moonlight Veil
  AbilitiesModel(
    abilitiesID: "eldren_003",
    name: "Moonlight Veil",
    description:
        "Creates a protective barrier that absorbs damage for all allies.",
    defenseBonus: 30,
    spCost: 18,
    cooldown: 6,
    type: AbilityType.buff,
    targetType: TargetType.all,
    affectsEnemies: false,
  ),

// 4. Rare - Ancient Whisper
  AbilitiesModel(
    abilitiesID: "eldren_004",
    name: "Ancient Whisper",
    description: "Silences all enemies for 2 turns, preventing magic use.",
    spCost: 20,
    cooldown: 8,
    type: AbilityType.debuff,
    targetType: TargetType.all,
    affectsEnemies: true,
  ),

// 5. Special - World Tree's Gift
  AbilitiesModel(
    abilitiesID: "eldren_005",
    name: "World Tree's Gift",
    description: "Revives all fallen allies with 50% HP and clears debuffs.",
    hpBonus: 50, // For revived allies
    spCost: 30,
    cooldown: 15,
    type: AbilityType.heal,
    targetType: TargetType.all,
    affectsEnemies: false,
  ),
  // Demi Human Ability
  // 1. Basic - Bestial Fury
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

// 2. Basic - Claw Swipe
  AbilitiesModel(
    abilitiesID: "therian_002",
    name: "Claw Swipe",
    description: "A rapid series of slashes that hit multiple times.",
    hpBonus: 15,
    spCost: 5,
    cooldown: 2,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
    criticalPoint: 25, // Multi-hit with crit chance
  ),

// 3. Rare - Pack Tactics
  AbilitiesModel(
    abilitiesID: "therian_003",
    name: "Pack Tactics",
    description: "Increases damage for each living ally (up to +50%).",
    attackBonus: 10, // Base + scaling per ally
    spCost: 15,
    cooldown: 5,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
  ),

// 4. Rare - Primal Howl
  AbilitiesModel(
    abilitiesID: "therian_004",
    name: "Primal Howl",
    description: "Reduces all enemies' defense and causes fear (miss chance).",
    defenseBonus: -20, // Debuff
    spCost: 18,
    cooldown: 7,
    type: AbilityType.debuff,
    targetType: TargetType.all,
    affectsEnemies: true,
  ),

// 5. Special - Blood Moon Frenzy
  AbilitiesModel(
    abilitiesID: "therian_005",
    name: "Blood Moon Frenzy",
    description:
        "Enters unstoppable frenzy for 3 turns, but loses 10% HP per turn.",
    attackBonus: 40,
    agilityBonus: 20,
    hpBonus: -10, // HP cost per turn
    spCost: 25,
    cooldown: 12,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
  ),
  // Dragonoid Ability
  // 1. Basic - Dragon's Breath
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

// 2. Basic - Scales of Protection
  AbilitiesModel(
    abilitiesID: "dracovar_002",
    name: "Scales of Protection",
    description: "Hardens dragon scales to reduce incoming damage.",
    defenseBonus: 25,
    spCost: 10,
    cooldown: 4,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
  ),

// 3. Rare - Wing Buffet
  AbilitiesModel(
    abilitiesID: "dracovar_003",
    name: "Wing Buffet",
    description: "Powerful wings knock back enemies, delaying their turns.",
    agilityBonus: -15, // Reduces enemy agility
    spCost: 12,
    cooldown: 6,
    type: AbilityType.debuff,
    targetType: TargetType.all,
    affectsEnemies: true,
  ),

// 4. Rare - Draconic Awakening
  AbilitiesModel(
    abilitiesID: "dracovar_004",
    name: "Draconic Awakening",
    description: "Temporarily unlocks true dragon form, boosting all stats.",
    attackBonus: 20,
    defenseBonus: 20,
    agilityBonus: 15,
    hpBonus: 30,
    spCost: 20,
    cooldown: 8,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
  ),

// 5. Special - Apocalypse Flame
  AbilitiesModel(
    abilitiesID: "dracovar_005",
    name: "Apocalypse Flame",
    description:
        "Unleashes a devastating firestorm that burns enemies for 3 turns.",
    hpBonus: 40,
    spCost: 30,
    cooldown: 15,
    type: AbilityType.attack,
    targetType: TargetType.all,
    affectsEnemies: true,
    criticalPoint: 20,
  ),
  // Demon Ability
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
  // Fireball - Single target attack
  AbilitiesModel(
    abilitiesID: "ability_006",
    name: "Fireball",
    description: "A fiery projectile that deals damage to the enemy.",
    hpBonus: 15,
    mpCost: 10,
    cooldown: 3,
    criticalPoint: 10,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
  ),
  // Heal - Single target heal
  AbilitiesModel(
    abilitiesID: "ability_007",
    name: "Heal",
    description: "Restores HP to the user.",
    hpBonus: 20,
    mpCost: 15,
    cooldown: 5,
    type: AbilityType.heal,
    targetType: TargetType.single,
    affectsEnemies: false,
  ),
  // Agility Boost - Single target buff
  AbilitiesModel(
    abilitiesID: "ability_008",
    name: "Agility Boost",
    description: "Increases agility for a short duration.",
    agilityBonus: 10,
    spCost: 5,
    cooldown: 4,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
  ),
  // Shield Bash - Single target attack with defense bonus
  AbilitiesModel(
    abilitiesID: "ability_009",
    name: "Shield Bash",
    description: "A powerful strike that stuns the enemy.",
    hpBonus: 10,
    defenseBonus: 5,
    mpCost: 8,
    cooldown: 4,
    criticalPoint: 15,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
  ),
  // Poison Dart - Single target attack with DoT potential
  AbilitiesModel(
    abilitiesID: "ability_010",
    name: "Poison Dart",
    description: "A dart coated with poison that deals damage over time.",
    hpBonus: 5,
    mpCost: 6,
    cooldown: 2,
    criticalPoint: 20,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
  ),
  // Mana Surge - Self-target MP restore
  AbilitiesModel(
    abilitiesID: "ability_011",
    name: "Mana Surge",
    description: "Restores MP to the user.",
    mpCost: -20,
    cooldown: 6,
    type: AbilityType.heal, // Considered a heal for resources
    targetType: TargetType.single,
    affectsEnemies: false,
  ),
  // Berserk - Self-target buff with drawback
  AbilitiesModel(
    abilitiesID: "ability_012",
    name: "Berserk",
    description: "Increases attack power at the cost of defense.",
    attackBonus: 25,
    defenseBonus: -10,
    spCost: 15,
    cooldown: 6,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
  ),
  // Earthquake - AoE attack
  AbilitiesModel(
    abilitiesID: "ability_013",
    name: "Earthquake",
    description: "A powerful ground attack that damages all enemies.",
    hpBonus: 30,
    mpCost: 20,
    cooldown: 8,
    criticalPoint: 5,
    type: AbilityType.attack,
    targetType: TargetType.all,
    affectsEnemies: true,
  ),
  // Stealth - Self-target buff
  AbilitiesModel(
    abilitiesID: "ability_014",
    name: "Stealth",
    description: "Makes the user invisible for a short duration.",
    agilityBonus: 20,
    spCost: 10,
    cooldown: 7,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
  ),
  // Revive - Single target resurrection
  AbilitiesModel(
    abilitiesID: "ability_015",
    name: "Revive",
    description: "Revives a fallen ally with partial HP.",
    hpBonus: 50,
    mpCost: 30,
    cooldown: 10,
    type: AbilityType.heal,
    targetType: TargetType.single,
    affectsEnemies: false,
  ),

  // Warrior
  // Mage
  // Rogue
  // Cleric
  // Paladin
  // Divine Cleric Abilities
  // Holy Light - AoE heal that damages undead
  AbilitiesModel(
    abilitiesID: "ability_016",
    name: "Holy Light",
    description: "A radiant light heals allies and damages undead enemies.",
    hpBonus: 25,
    mpCost: 15,
    cooldown: 5,
    type: AbilityType.heal, // Primary effect is healing
    targetType: TargetType.all,
    affectsEnemies: false,
    // Note: You might need special handling for the undead damage aspect
  ),
  // Divine Shield - Single target defensive buff
  AbilitiesModel(
    abilitiesID: "ability_017",
    name: "Divine Shield",
    description: "Grants temporary immunity to damage for one turn.",
    defenseBonus: 50,
    mpCost: 20,
    cooldown: 8,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
  ),
  // Purify - Single target status cleanse
  AbilitiesModel(
    abilitiesID: "ability_018",
    name: "Purify",
    description: "Removes all negative effects from an ally.",
    mpCost: 10,
    cooldown: 6,
    type: AbilityType.buff, // Considered a buff as it removes debuffs
    targetType: TargetType.single,
    affectsEnemies: false,
  ),
  // Phantom Reaver Abilities
  // Phantom Slash - Single target attack that ignores some defense
  AbilitiesModel(
    abilitiesID: "ability_019",
    name: "Phantom Slash",
    description:
        "A spectral blade cuts through enemies, ignoring some defense.",
    hpBonus: 20,
    criticalPoint: 15,
    mpCost: 12,
    cooldown: 4,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
  ),
  // Soul Drain - Single target attack with self-heal
  AbilitiesModel(
    abilitiesID: "ability_020",
    name: "Soul Drain",
    description: "Steals HP from an enemy and restores it to the user.",
    hpBonus: 15, // Damage to enemy
    mpCost: 10,
    cooldown: 5,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
    // Note: You'll need special handling for the self-heal portion
  ),
  // Shadow Veil - Self-target defensive buff
  AbilitiesModel(
    abilitiesID: "ability_021",
    name: "Shadow Veil",
    description: "Increases evasion and reduces damage taken for 2 turns.",
    agilityBonus: 15,
    defenseBonus: 10,
    mpCost: 18,
    cooldown: 7,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
  ),
  // Runebinder Abilities
  // Rune Explosion - Single target high damage
  AbilitiesModel(
    abilitiesID: "ability_022",
    name: "Rune Explosion",
    description: "Triggers a stored rune to deal massive damage.",
    hpBonus: 30,
    mpCost: 25,
    cooldown: 8,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
  ),
  // Arcane Barrier - Self-target defensive buff
  AbilitiesModel(
    abilitiesID: "ability_023",
    name: "Arcane Barrier",
    description: "Creates a protective shield that absorbs magic damage.",
    defenseBonus: 25,
    mpCost: 20,
    cooldown: 6,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
  ),
  // Mana Infusion - AoE MP restore
  AbilitiesModel(
    abilitiesID: "ability_024",
    name: "Mana Infusion",
    description: "Restores MP to all allies over time.",
    mpCost: -25,
    cooldown: 10,
    type: AbilityType.heal, // For resource restoration
    targetType: TargetType.all,
    affectsEnemies: false,
  ),
  // Arcane Sage Abilities
  // Mystic Bolt - Single target magic attack
  AbilitiesModel(
    abilitiesID: "ability_025",
    name: "Mystic Bolt",
    description: "Unleashes a concentrated magical energy bolt at the enemy.",
    hpBonus: 22,
    mpCost: 14,
    cooldown: 4,
    criticalPoint: 10,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
  ),
  // Spell Echo - Self-target buff
  AbilitiesModel(
    abilitiesID: "ability_026",
    name: "Spell Echo",
    description: "Grants a chance to recast the last spell for free.",
    mpCost: 0,
    cooldown: 7,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
  ),
  // Arcane Torrent - AoE magic debuff
  AbilitiesModel(
    abilitiesID: "ability_027",
    name: "Arcane Torrent",
    description: "A surge of magic weakens enemy spellcasters' MP.",
    hpBonus: 10, // MP damage would need special handling
    mpCost: 15,
    cooldown: 6,
    type: AbilityType.debuff,
    targetType: TargetType.all,
    affectsEnemies: true,
  ),
  // Blademaster Abilities
  // Blade Dance - AoE physical attack
  AbilitiesModel(
    abilitiesID: "ability_028",
    name: "Blade Dance",
    description: "A flurry of strikes hitting multiple enemies.",
    hpBonus: 18,
    spCost: 12,
    cooldown: 5,
    type: AbilityType.attack,
    targetType: TargetType.all,
    affectsEnemies: true,
  ),
  // Counter Stance - Self-target defensive buff
  AbilitiesModel(
    abilitiesID: "ability_029",
    name: "Counter Stance",
    description: "Enters a stance to counter enemy attacks for 2 turns.",
    defenseBonus: 20,
    spCost: 15,
    cooldown: 8,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
  ),
  // Crimson Slash - Single target attack with conditional bonus
  AbilitiesModel(
    abilitiesID: "ability_030",
    name: "Crimson Slash",
    description: "A brutal slash that deals extra damage if below 50% HP.",
    hpBonus: 25,
    criticalPoint: 20,
    spCost: 15,
    cooldown: 6,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
  ),
  // Warden Abilities
  // Guardian's Wrath - Counterattack ability
  AbilitiesModel(
    abilitiesID: "ability_031",
    name: "Guardian's Wrath",
    description: "A powerful counterattack after blocking an enemy hit.",
    hpBonus: 20,
    spCost: 10,
    cooldown: 5,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
  ),
  // Iron Fortress - Self-target defensive buff
  AbilitiesModel(
    abilitiesID: "ability_032",
    name: "Iron Fortress",
    description: "Greatly increases defense for 3 turns.",
    defenseBonus: 30,
    spCost: 20,
    cooldown: 7,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
  ),
  // Taunt - AoE enemy control
  AbilitiesModel(
    abilitiesID: "ability_033",
    name: "Taunt",
    description: "Forces enemies to attack the user for 2 turns.",
    defenseBonus: 10,
    spCost: 8,
    cooldown: 4,
    type: AbilityType.debuff,
    targetType: TargetType.all,
    affectsEnemies: true,
  ),
  // Elementalist Abilities
  // Lightning Storm - AoE magic attack
  AbilitiesModel(
    abilitiesID: "ability_034",
    name: "Lightning Storm",
    description: "Summons lightning to strike multiple enemies.",
    hpBonus: 28,
    mpCost: 22,
    cooldown: 7,
    criticalPoint: 10,
    type: AbilityType.attack,
    targetType: TargetType.all,
    affectsEnemies: true,
  ),
  // Ice Barricade - AoE defensive buff
  AbilitiesModel(
    abilitiesID: "ability_035",
    name: "Ice Barricade",
    description: "Reduces enemy movement and increases defense.",
    defenseBonus: 20,
    mpCost: 18,
    cooldown: 6,
    type: AbilityType.buff,
    targetType: TargetType.all,
    affectsEnemies: false,
  ),
  // Inferno - AoE damage over time
  AbilitiesModel(
    abilitiesID: "ability_036",
    name: "Inferno",
    description: "Unleashes a blazing fire that deals damage over time.",
    hpBonus: 25,
    mpCost: 20,
    cooldown: 6,
    type: AbilityType.attack,
    targetType: TargetType.all,
    affectsEnemies: true,
  ),
  // Dread Knight Abilities
  // Dark Cleave - Single target attack with self-heal
  AbilitiesModel(
    abilitiesID: "ability_037",
    name: "Dark Cleave",
    description: "A heavy attack that drains some HP from enemies.",
    hpBonus: 25,
    mpCost: 15,
    cooldown: 6,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
  ),
  // Unholy Resilience - Self-target defensive buff
  AbilitiesModel(
    abilitiesID: "ability_038",
    name: "Unholy Resilience",
    description: "Grants temporary immunity to death for 1 turn.",
    hpBonus: 50,
    mpCost: 25,
    cooldown: 10,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
  ),
  // Cursed Strike - Single target debuff
  AbilitiesModel(
    abilitiesID: "ability_039",
    name: "Cursed Strike",
    description: "Inflicts a debuff that reduces enemy defense.",
    hpBonus: 20,
    defenseBonus: -10,
    mpCost: 12,
    cooldown: 5,
    type: AbilityType.debuff,
    targetType: TargetType.single,
    affectsEnemies: true,
  ),
];

// Helper function to find an ability by its ID
AbilitiesModel? getAbilityById(String abilitiesID) {
  return abilitiesList.firstWhere(
    (ability) => ability.abilitiesID == abilitiesID,
    orElse: () => throw Exception("Ability not found"),
  );
}
