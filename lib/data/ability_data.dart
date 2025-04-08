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
    elementType: ElementType.none,
    affectsEnemies: false,
    healsCaster: true, // Explicitly mark as self-heal
  ),

// 2. Basic - Tactical Strike
  AbilitiesModel(
    abilitiesID: "human_002",
    name: "Tactical Strike",
    description: "A precise attack that ignores 30% of defense.",
    hpBonus: 25,
    spCost: 8,
    cooldown: 3,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
    criticalPoint: 15,
    // Add defense penetration effect
    statusEffects: [
      StatusEffect(
        id: "armor_pen",
        name: "Armor Penetration",
        duration: 1,
        defenseModifier: -30, // Ignores 30% defense
      ),
    ],
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
    // Add duration via StatusEffect
    statusEffects: [
      StatusEffect(
        id: "rally_attack",
        name: "Rallying Cry",
        duration: 3,
        attackModifier: 15,
      ),
    ],
  ),

// 4. Rare - Last Stand
  AbilitiesModel(
    abilitiesID: "human_004",
    name: "Last Stand",
    description: "When HP is below 30%, gain +50% defense and +20% attack.",
    defenseBonus: 50,
    attackBonus: 20,
    spCost: 15,
    cooldown: 7,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
    // Conditional effect handled in applyEffect()
    // Note: You'll need custom logic to check HP threshold
  ),

// 5. Special - Heroic Sacrifice
  AbilitiesModel(
    abilitiesID: "human_005",
    name: "Heroic Sacrifice",
    description: "Deals massive damage but reduces user's HP to 1.",
    hpBonus: 999, // Special handling in applyEffect()
    spCost: 25,
    cooldown: 10,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
    criticalPoint: 30,
    // Add self-damage effect
    statusEffects: [
      StatusEffect(
        id: "self_damage",
        name: "Heroic Sacrifice",
        duration: 0, // Instant
        damagePerTurn: -999, // Special handling required
      ),
    ],
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

// 2. Basic - Sylvan Arrow
  AbilitiesModel(
    abilitiesID: "eldren_002",
    name: "Sylvan Arrow",
    description: "A magical arrow that never misses.",
    hpBonus: 20,
    spCost: 7,
    cooldown: 2,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
    criticalPoint: 20,
    elementType: ElementType.nature,
    // Guaranteed hit effect
    statusEffects: [
      StatusEffect(
        id: "guaranteed_hit",
        name: "True Strike",
        duration: 1,
        agilityModifier: 999, // Effectively can't miss
      ),
    ],
  ),

// 3. Rare - Moonlight Veil
  AbilitiesModel(
    abilitiesID: "eldren_003",
    name: "Moonlight Veil",
    description: "Protective barrier for all allies.",
    defenseBonus: 30,
    spCost: 18,
    cooldown: 6,
    type: AbilityType.buff,
    targetType: TargetType.all,
    affectsEnemies: false,
    elementType: ElementType.light,
    statusEffects: [
      StatusEffect(
        id: "moonlight_veil",
        name: "Moonlight Veil",
        duration: 2,
        defenseModifier: 30,
      ),
    ],
  ),

// 4. Rare - Ancient Whisper
  AbilitiesModel(
    abilitiesID: "eldren_004",
    name: "Ancient Whisper",
    description: "Silences all enemies for 2 turns.",
    spCost: 20,
    cooldown: 8,
    type: AbilityType.control, // Changed from debuff to control
    targetType: TargetType.all,
    affectsEnemies: true,
    elementType: ElementType.dark,
    mentalPotency: 40, // Base success chance
    statusEffects: [
      StatusEffect(
        id: "silence",
        name: "Silenced",
        duration: 2,
        controlEffect: ControlEffect(
          type: ControlEffectType
              .charm, // Or create new ControlEffectType.silence
          duration: 2,
          successChance: 0.4, // 40% base + mentalPotency
        ),
      ),
    ],
  ),

// 5. Special - World Tree's Gift
  AbilitiesModel(
    abilitiesID: "eldren_005",
    name: "World Tree's Gift",
    description: "Revives all allies with 50% HP and clears debuffs.",
    hpBonus: 50,
    spCost: 30,
    cooldown: 15,
    type: AbilityType.heal,
    targetType: TargetType.all,
    affectsEnemies: false,
    elementType: ElementType.divine,
    // Note: Requires custom logic for revival
  ),
  // Demi Human Ability
  // 1. Basic - Bestial Fury
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

// 2. Basic - Claw Swipe
  AbilitiesModel(
    abilitiesID: "therian_002",
    name: "Claw Swipe",
    description: "A rapid series of slashes (3 hits, 5 damage each).",
    hpBonus: 5, // Per hit (handled in applyEffect)
    spCost: 5,
    cooldown: 2,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
    criticalPoint: 25,
    elementType: ElementType.none,
    // Note: Requires custom logic for multi-hit
  ),

// 3. Rare - Pack Tactics
  AbilitiesModel(
    abilitiesID: "therian_003",
    name: "Pack Tactics",
    description: "Gains +10% damage per living ally (max +50%).",
    attackBonus: 10, // Base + scaling
    spCost: 15,
    cooldown: 5,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
    // Note: Requires ally count check in applyEffect()
  ),

// 4. Rare - Primal Howl
  AbilitiesModel(
    abilitiesID: "therian_004",
    name: "Primal Howl",
    description:
        "Reduces enemy defense by 20 and causes fear (25% miss chance).",
    spCost: 18,
    cooldown: 7,
    type: AbilityType.debuff,
    targetType: TargetType.all,
    affectsEnemies: true,
    elementType: ElementType.dark,
    statusEffects: [
      StatusEffect(
        id: "primal_fear",
        name: "Feared",
        duration: 2,
        defenseModifier: -20,
        agilityModifier: -15, // Simulates miss chance
      ),
    ],
  ),

// 5. Special - Blood Moon Frenzy
  AbilitiesModel(
    abilitiesID: "therian_005",
    name: "Blood Moon Frenzy",
    description: "Unstoppable frenzy (+40 ATK/+20 AGI) but loses 10% HP/turn.",
    spCost: 25,
    cooldown: 12,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
    elementType: ElementType.dark,
    statusEffects: [
      StatusEffect(
        id: "blood_frenzy",
        name: "Blood Frenzy",
        duration: 3,
        attackModifier: 40,
        agilityModifier: 20,
        damagePerTurn: -10, // Percentage handled in applyEffect()
      ),
    ],
  ),
  // Dragonoid Ability
  // 1. Basic - Dragon's Breath
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

// 2. Basic - Scales of Protection
  AbilitiesModel(
    abilitiesID: "dracovar_002",
    name: "Scales of Protection",
    description: "Grants +25 DEF for 4 turns.",
    defenseBonus: 25,
    spCost: 10,
    cooldown: 4,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
    elementType: ElementType.earth,
    statusEffects: [
      StatusEffect(
        id: "dragon_scales",
        name: "Dragon Scales",
        duration: 4,
        defenseModifier: 25,
      ),
    ],
  ),

// 3. Rare - Wing Buffet
  AbilitiesModel(
    abilitiesID: "dracovar_003",
    name: "Wing Buffet",
    description: "Delays enemy turns by reducing AGI by 15 for 2 turns.",
    spCost: 12,
    cooldown: 6,
    type: AbilityType.debuff,
    targetType: TargetType.all,
    affectsEnemies: true,
    elementType: ElementType.wind,
    statusEffects: [
      StatusEffect(
        id: "wing_buffet",
        name: "Knocked Back",
        duration: 2,
        agilityModifier: -15,
      ),
    ],
  ),

// 4. Rare - Draconic Awakening
  AbilitiesModel(
    abilitiesID: "dracovar_004",
    name: "Draconic Awakening",
    description: "Boosts all stats (+20 ATK/DEF, +15 AGI, +30 HP) for 3 turns.",
    spCost: 20,
    cooldown: 8,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
    elementType: ElementType.divine,
    statusEffects: [
      StatusEffect(
        id: "dragon_form",
        name: "Dragon Form",
        duration: 3,
        attackModifier: 20,
        defenseModifier: 20,
        agilityModifier: 15,
        // HP bonus handled in applyEffect()
      ),
    ],
  ),

// 5. Special - Apocalypse Flame
  AbilitiesModel(
    abilitiesID: "dracovar_005",
    name: "Apocalypse Flame",
    description: "Deals 40 fire damage + 10/turn burn for 3 turns.",
    hpBonus: 40,
    spCost: 30,
    cooldown: 15,
    type: AbilityType.attack,
    targetType: TargetType.all,
    affectsEnemies: true,
    criticalPoint: 20,
    elementType: ElementType.fire,
    statusEffects: [
      StatusEffect(
        id: "apocalypse_burn",
        name: "Burning",
        duration: 3,
        damagePerTurn: 10,
      ),
    ],
  ),
  // Demon Ability
  // 1. Basic - Shadow Step
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

// 2. Basic - Hellfire Blast
  AbilitiesModel(
    abilitiesID: "daemon_002",
    name: "Hellfire Blast",
    description: "Deals 25 dark/fire damage to all enemies.",
    hpBonus: 25,
    mpCost: 15,
    cooldown: 4,
    type: AbilityType.attack,
    targetType: TargetType.all,
    affectsEnemies: true,
    criticalPoint: 15,
    elementType: ElementType.dark, // Or dual-element?
  ),

// 3. Rare - Demonic Pact
  AbilitiesModel(
    abilitiesID: "daemon_003",
    name: "Demonic Pact",
    description: "Loses 15 HP to gain +30 ATK for 3 turns.",
    hpBonus: -15,
    attackBonus: 30,
    mpCost: 10,
    cooldown: 5,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
    elementType: ElementType.dark,
    statusEffects: [
      StatusEffect(
        id: "demonic_pact",
        name: "Pact Active",
        duration: 3,
        attackModifier: 30,
      ),
    ],
  ),

// 4. Rare - Soul Drain
  AbilitiesModel(
    abilitiesID: "daemon_004",
    name: "Soul Drain",
    description: "Deals 20 damage and heals caster for same amount.",
    hpBonus: 20,
    mpCost: 12,
    cooldown: 3,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
    drainsHealth: true, // Key flag for lifesteal
    elementType: ElementType.dark,
  ),

// 5. Special - Abyssal Fear
  AbilitiesModel(
    abilitiesID: "daemon_005",
    name: "Abyssal Fear",
    description: "Reduces all enemies' DEF/AGI by 15 for 3 turns.",
    mpCost: 18,
    cooldown: 4,
    type: AbilityType.debuff,
    targetType: TargetType.all,
    affectsEnemies: true,
    elementType: ElementType.dark,
    statusEffects: [
      StatusEffect(
        id: "abyssal_fear",
        name: "Terrified",
        duration: 3,
        defenseModifier: -15,
        agilityModifier: -15,
      ),
    ],
  ),

// 6. Special - Dark Regeneration
  AbilitiesModel(
    abilitiesID: "daemon_006",
    name: "Dark Regeneration",
    description: "Heals 10 HP/turn for 3 turns.",
    mpCost: 20,
    cooldown: 6,
    type: AbilityType.heal,
    targetType: TargetType.single,
    affectsEnemies: false,
    elementType: ElementType.dark,
    statusEffects: [
      StatusEffect(
        id: "dark_regen",
        name: "Dark Regeneration",
        duration: 3,
        damagePerTurn: 10, // Positive = heal
      ),
    ],
  ),

// ==================== BASIC ABILITIES ====================

// 1. Basic - Kiss of the Succubus
  AbilitiesModel(
    abilitiesID: "succubus_001",
    name: "Kiss of the Succubus",
    description: "Steals 15 HP while charming the target for 1 turn.",
    hpBonus: 15, // Damage (converted to heal via drainsHealth)
    mpCost: 10,
    cooldown: 3,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
    drainsHealth: true, // Converts damage to self-heal
    elementType: ElementType.dark,
    mentalPotency: 30, // Charm success chance
    statusEffects: [
      StatusEffect(
        id: "succubus_kiss",
        name: "Charmed",
        duration: 1,
        controlEffect: ControlEffect(
          type: ControlEffectType.charm,
          duration: 1,
          successChance: 0.3, // 30% base + mentalPotency
        ),
      ),
    ],
  ),

// 2. Basic - Lash of Desire
  AbilitiesModel(
    abilitiesID: "succubus_002",
    name: "Lash of Desire",
    description: "Deals pain and pleasure, reducing target's DEF by 20%.",
    hpBonus: 25,
    mpCost: 12,
    cooldown: 4,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
    elementType: ElementType.dark,
    statusEffects: [
      StatusEffect(
        id: "lowered_guard",
        name: "Lowered Guard",
        duration: 2,
        defenseModifier: -20, // Percentage handled in applyEffect()
      ),
    ],
  ),

// ==================== RARE ABILITIES ====================

// 3. Rare - Alluring Embrace
  AbilitiesModel(
    abilitiesID: "succubus_003",
    name: "Alluring Embrace",
    description: "Seduces all enemies, skipping their next turn (40% chance).",
    mpCost: 20,
    cooldown: 6,
    type: AbilityType.control,
    targetType: TargetType.all,
    affectsEnemies: true,
    mentalPotency: 40,
    statusEffects: [
      StatusEffect(
        id: "seduced",
        name: "Seduced",
        duration: 1,
        controlEffect: ControlEffect(
          type: ControlEffectType.seduce,
          duration: 1,
          successChance: 0.4,
        ),
      ),
    ],
  ),

// 4. Rare - Soul Siphon
  AbilitiesModel(
    abilitiesID: "succubus_004",
    name: "Soul Siphon",
    description: "Drains 30 HP over 3 turns while slowing the target.",
    mpCost: 15,
    cooldown: 5,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
    drainsHealth: true,
    elementType: ElementType.dark,
    statusEffects: [
      StatusEffect(
        id: "soul_siphon",
        name: "Soul Siphon",
        duration: 3,
        damagePerTurn: 10, // Total 30 HP drained
        agilityModifier: -15,
      ),
    ],
  ),

// ==================== SPECIAL ABILITY ====================

// 5. Special - Eternal Temptation
  AbilitiesModel(
    abilitiesID: "succubus_005",
    name: "Eternal Temptation",
    description:
        "Charms all enemies for 2 turns (50% chance) and heals per charmed target.",
    mpCost: 30,
    cooldown: 10,
    type: AbilityType.control,
    targetType: TargetType.all,
    affectsEnemies: true,
    mentalPotency: 50,
    healsCaster: true,
    healCasterAmount: 15, // Per charmed target
    elementType: ElementType.dark,
    statusEffects: [
      StatusEffect(
        id: "eternal_charm",
        name: "Eternal Charm",
        duration: 2,
        controlEffect: ControlEffect(
          type: ControlEffectType.charm,
          duration: 2,
          successChance: 0.5,
        ),
      ),
    ],
  ),

  // 1. Fireball - Now with burn chance
  AbilitiesModel(
    abilitiesID: "ability_006",
    name: "Fireball",
    description:
        "Deals 15 fire damage with 30% chance to burn (5 damage/turn for 2 turns).",
    hpBonus: 15,
    mpCost: 10,
    cooldown: 3,
    criticalPoint: 10,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
    elementType: ElementType.fire,
    statusEffects: [
      StatusEffect(
        id: "burn",
        name: "Burning",
        duration: 2,
        damagePerTurn: 5,
      ),
    ],
  ),

// 2. Heal - Added light element flavor
  AbilitiesModel(
    abilitiesID: "ability_007",
    name: "Heal",
    description: "Restores 20 HP to an ally.",
    hpBonus: 20,
    mpCost: 15,
    cooldown: 5,
    type: AbilityType.heal,
    targetType: TargetType.single,
    affectsEnemies: false,
    elementType: ElementType.light,
  ),

// 3. Agility Boost - Added duration
  AbilitiesModel(
    abilitiesID: "ability_008",
    name: "Agility Boost",
    description: "Increases AGI by 10 for 3 turns.",
    spCost: 5,
    cooldown: 4,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
    statusEffects: [
      StatusEffect(
        id: "agility_buff",
        name: "Agility Boost",
        duration: 3,
        agilityModifier: 10,
      ),
    ],
  ),

// 4. Shield Bash - Added stun effect
  AbilitiesModel(
    abilitiesID: "ability_009",
    name: "Shield Bash",
    description: "Deals 10 damage with 25% chance to stun for 1 turn.",
    hpBonus: 10,
    defenseBonus: 5,
    mpCost: 8,
    cooldown: 4,
    criticalPoint: 15,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
    elementType: ElementType.earth,
    statusEffects: [
      StatusEffect(
        id: "stun",
        name: "Stunned",
        duration: 1,
        controlEffect: ControlEffect(
          type: ControlEffectType.taunt, // Using taunt as pseudo-stun
          duration: 1,
          successChance: 0.25,
        ),
      ),
    ],
  ),

// 5. Poison Dart - Added proper poison
  AbilitiesModel(
    abilitiesID: "ability_010",
    name: "Poison Dart",
    description: "Deals 5 damage + 8 damage/turn for 3 turns.",
    hpBonus: 5,
    mpCost: 6,
    cooldown: 2,
    criticalPoint: 20,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
    elementType: ElementType.poison,
    statusEffects: [
      StatusEffect(
        id: "poison",
        name: "Poisoned",
        duration: 3,
        damagePerTurn: 8,
      ),
    ],
  ),

// 6. Mana Surge - Clarified mechanics
  AbilitiesModel(
    abilitiesID: "ability_011",
    name: "Mana Surge",
    description: "Restores 20 MP instantly.",
    mpCost: -20, // Negative cost = gain
    cooldown: 6,
    type: AbilityType.heal,
    targetType: TargetType.single,
    affectsEnemies: false,
    elementType: ElementType.light,
  ),

// 7. Berserk - Added duration and drawback
  AbilitiesModel(
    abilitiesID: "ability_012",
    name: "Berserk",
    description: "Gains +25 ATK but -10 DEF for 4 turns.",
    spCost: 15,
    cooldown: 6,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
    statusEffects: [
      StatusEffect(
        id: "berserk",
        name: "Berserk",
        duration: 4,
        attackModifier: 25,
        defenseModifier: -10,
      ),
    ],
  ),

// 8. Earthquake - Added earth element and stagger
  AbilitiesModel(
    abilitiesID: "ability_013",
    name: "Earthquake",
    description:
        "Deals 30 earth damage to all enemies, reducing AGI by 10 for 2 turns.",
    hpBonus: 30,
    mpCost: 20,
    cooldown: 8,
    criticalPoint: 5,
    type: AbilityType.attack,
    targetType: TargetType.all,
    affectsEnemies: true,
    elementType: ElementType.earth,
    statusEffects: [
      StatusEffect(
        id: "stagger",
        name: "Staggered",
        duration: 2,
        agilityModifier: -10,
      ),
    ],
  ),

// 9. Stealth - Added proper invisibility
  AbilitiesModel(
    abilitiesID: "ability_014",
    name: "Stealth",
    description: "Gains +20 AGI and becomes untargetable for 2 turns.",
    spCost: 10,
    cooldown: 7,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
    statusEffects: [
      StatusEffect(
        id: "stealth",
        name: "Stealthed",
        duration: 2,
        agilityModifier: 20,
        // Note: Requires custom logic for untargetable state
      ),
    ],
  ),

// 10. Revive - Added light element and clear debuffs
  AbilitiesModel(
    abilitiesID: "ability_015",
    name: "Revive",
    description: "Revives an ally with 50% HP and clears all debuffs.",
    hpBonus: 50,
    mpCost: 30,
    cooldown: 10,
    type: AbilityType.heal,
    targetType: TargetType.single,
    affectsEnemies: false,
    elementType: ElementType.light,
    // Note: Requires custom logic for revival
  ),

  // Warrior
  // Mage
  // Rogue
  // Cleric
  // Paladin
  // Divine Cleric Abilities
  // Holy Light - AoE heal that damages undead
  // 1. Holy Light (Enhanced with undead interaction)
  AbilitiesModel(
    abilitiesID: "cleric_001",
    name: "Holy Light",
    description: "Heals allies for 25 HP, deals 50 damage to undead.",
    hpBonus: 25,
    mpCost: 15,
    cooldown: 5,
    type: AbilityType.heal,
    targetType: TargetType.all,
    affectsEnemies: false,
    elementType: ElementType.light,
    // Special undead handling done in applyEffect()
  ),

// 2. Divine Shield (Now with invulnerability)
  AbilitiesModel(
    abilitiesID: "cleric_002",
    name: "Divine Shield",
    description: "Blocks all damage for 1 turn.",
    mpCost: 20,
    cooldown: 8,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
    statusEffects: [
      StatusEffect(
        id: "invulnerable",
        name: "Invulnerable",
        duration: 1,
        // Handled in damage calculation
      ),
    ],
  ),

// 3. Purify (Now removes all debuffs)
  AbilitiesModel(
    abilitiesID: "cleric_003",
    name: "Purify",
    description: "Cleanses all debuffs and heals 10 HP.",
    hpBonus: 10,
    mpCost: 10,
    cooldown: 6,
    type: AbilityType.heal, // Now also heals
    targetType: TargetType.single,
    affectsEnemies: false,
    elementType: ElementType.light,
  ),
  // Phantom Reaver Abilities
  // Phantom Slash - Single target attack that ignores some defense
  // 1. Phantom Slash (Now ignores 50% defense)
  AbilitiesModel(
    abilitiesID: "rogue_001",
    name: "Phantom Slash",
    description: "Deals 20 damage, ignoring 50% of defense.",
    hpBonus: 20,
    mpCost: 12,
    cooldown: 4,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
    elementType: ElementType.dark,
    statusEffects: [
      StatusEffect(
        id: "armor_pen",
        name: "Armor Penetration",
        duration: 1,
        defenseModifier: -50, // Percentage
      ),
    ],
  ),

// 2. Soul Drain (Proper life steal)
  AbilitiesModel(
    abilitiesID: "rogue_002",
    name: "Soul Drain",
    description: "Deals 15 damage, heals for 100% of damage.",
    hpBonus: 15,
    mpCost: 10,
    cooldown: 5,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
    drainsHealth: true, // Key flag
    elementType: ElementType.dark,
  ),

// 3. Shadow Veil (Now with dodge chance)
  AbilitiesModel(
    abilitiesID: "rogue_003",
    name: "Shadow Veil",
    description: "Grants +25% dodge chance for 2 turns.",
    mpCost: 18,
    cooldown: 7,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
    statusEffects: [
      StatusEffect(
        id: "shadow_veil",
        name: "Shadow Veil",
        duration: 2,
        agilityModifier: 25, // As dodge chance
      ),
    ],
  ),
  // Runebinder Abilities
  // Rune Explosion - Single target high damage
  // 1. Rune Explosion (Now with elemental choice)
  AbilitiesModel(
    abilitiesID: "archer_001",
    name: "Precision Shot",
    description:
        "A carefully aimed shot that always crits and ignores some defense.",
    hpBonus: 35,
    spCost: 15,
    cooldown: 4,
    criticalPoint: 100, // Guaranteed critical
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
    elementType: ElementType.none,
    // Special property: Defense penetration would need custom logic
    statusEffects: [
      StatusEffect(
        id: "armor_pierce",
        name: "Armor Pierced",
        duration: 2,
        defenseModifier: -10,
      ),
    ],
  ),

// 2. Arcane Barrier (Now specific to magic)
  AbilitiesModel(
    abilitiesID: "archer_002",
    name: "Volley",
    description:
        "Fires a barrage of arrows at all enemies with chance to bleed.",
    hpBonus: 22,
    spCost: 20,
    cooldown: 5,
    criticalPoint: 10,
    type: AbilityType.attack,
    targetType: TargetType.all,
    affectsEnemies: true,
    elementType: ElementType.nature,
    statusEffects: [
      StatusEffect(
        id: "bleeding",
        name: "Bleeding",
        duration: 3,
        damagePerTurn: 4,
        agilityModifier: -5,
      ),
    ],
  ),

// 3. Mana Infusion (Proper MP restore)
  AbilitiesModel(
    abilitiesID: "archer_003",
    name: "Poison Arrow",
    description:
        "A toxic arrow that deals increasing damage over time (stacks up to 3x).",
    hpBonus: 15,
    spCost: 12,
    cooldown: 3,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
    elementType: ElementType.poison,
    statusEffects: [
      StatusEffect(
        id: "poison",
        name: "Poisoned",
        duration: 4,
        damagePerTurn: 3, // Base damage (would increase with stacks)
        // Stacking logic would need custom implementation
      ),
    ],
  ),
  AbilitiesModel(
    abilitiesID: "archer_004",
    name: "Eagle Eye",
    description:
        "Sharpens focus for 3 turns, increasing crit chance and accuracy.",
    spCost: 18,
    cooldown: 6,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
    statusEffects: [
      StatusEffect(
        id: "eagle_eye",
        name: "Eagle Eye",
        duration: 3,
        attackModifier: 10,
        // Would need custom property for crit/accuracy boost
      ),
    ],
    // Special effect: Might reveal hidden enemies
  ),
  AbilitiesModel(
    abilitiesID: "archer_005",
    name: "Pinning Shot",
    description:
        "Shoots an arrow at the enemy's leg, reducing agility and chance to root.",
    hpBonus: 12,
    spCost: 14,
    cooldown: 4,
    type: AbilityType.debuff,
    targetType: TargetType.single,
    affectsEnemies: true,
    mentalPotency: 15, // Affects root chance
    statusEffects: [
      StatusEffect(
        id: "pinned",
        name: "Pinned",
        duration: 2,
        agilityModifier: -20,
        controlEffect: ControlEffect(
          type: ControlEffectType.fear,
          duration: 1,
          successChance: 0.4, // Chance to root (skip turn)
        ),
      ),
    ],
  ),
  // Arcane Sage Abilities
  // Mystic Bolt - Single target magic attack
  // 1. Mystic Bolt (Now with spellpower scaling)
  AbilitiesModel(
    abilitiesID: "mage_001",
    name: "Mystic Bolt",
    description: "Deals 22 + (INT×0.5) arcane damage.",
    hpBonus: 22,
    mpCost: 14,
    cooldown: 4,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
    elementType: ElementType.none, // Pure magic
  ),

// 2. Spell Echo (Now with 50% chance)
  AbilitiesModel(
    abilitiesID: "mage_002",
    name: "Spell Echo",
    description: "50% chance to recast last spell for free next turn.",
    mpCost: 0,
    cooldown: 7,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
    statusEffects: [
      StatusEffect(
        id: "spell_echo",
        name: "Spell Echo",
        duration: 2,
      ),
    ],
  ),

// 3. Arcane Torrent (Now properly drains MP)
  AbilitiesModel(
    abilitiesID: "mage_003",
    name: "Arcane Torrent",
    description: "Deals 10 damage and drains 15 MP.",
    hpBonus: 10,
    mpCost: 15,
    cooldown: 6,
    type: AbilityType.debuff,
    targetType: TargetType.all,
    affectsEnemies: true,
    // MP drain handled in applyEffect()
  ),

  // Warrior Abilities
  AbilitiesModel(
    abilitiesID: "warrior_001",
    name: "Blade Dance",
    description:
        "A flurry of strikes hitting multiple enemies with wind-enhanced blades.",
    hpBonus: 18,
    spCost: 12,
    cooldown: 5,
    criticalPoint: 15,
    type: AbilityType.attack,
    targetType: TargetType.all,
    affectsEnemies: true,
    elementType: ElementType.wind,
    statusEffects: [
      StatusEffect(
        id: "bleed_effect",
        name: "Bleeding",
        duration: 3,
        damagePerTurn: 3,
      ),
    ],
  ),

  AbilitiesModel(
    abilitiesID: "warrior_002",
    name: "Counter Stance",
    description:
        "Enters a stance to counter enemy attacks for 2 turns, increasing defense and counter damage.",
    defenseBonus: 20,
    attackBonus: 10,
    spCost: 15,
    cooldown: 8,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
    statusEffects: [
      StatusEffect(
        id: "counter_stance",
        name: "Counter Stance",
        duration: 2,
        attackModifier: 15,
        defenseModifier: 20,
      ),
    ],
  ),

  AbilitiesModel(
    abilitiesID: "warrior_003",
    name: "Crimson Slash",
    description:
        "A brutal slash that deals extra damage when below 50% HP and has increased crit chance.",
    hpBonus: 25,
    criticalPoint: 30, // Higher crit chance
    spCost: 15,
    cooldown: 6,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
    elementType: ElementType.fire,
    // This would need special handling in the applyEffect method
  ),
  AbilitiesModel(
    abilitiesID: "warrior_004",
    name: "Dragon's Fury",
    description:
        "Unleashes a devastating spinning attack that hits all enemies 3 times, with escalating damage and self-cleanse.",
    hpBonus: 15, // Per hit (45 total)
    spCost: 30,
    cooldown: 8,
    type: AbilityType.attack,
    targetType: TargetType.all,
    affectsEnemies: true,
    elementType: ElementType.fire,
    statusEffects: [
      StatusEffect(
        id: "dragon_rage",
        name: "Dragon's Rage",
        duration: 3,
        attackModifier: 5, // Stacking per turn
      ),
    ],
    // Special: Cleanses all debuffs on cast
    // Special: Damage increases with missing HP (execute threshold)
  ),
  AbilitiesModel(
    abilitiesID: "warrior_005",
    name: "Battle Standard",
    description:
        "Plants a banner that boosts allies' ATK/DEF by 15% and grants gradual HP recovery for 4 turns.",
    spCost: 25,
    cooldown: 7,
    type: AbilityType.buff,
    targetType: TargetType.all,
    affectsEnemies: false,
    statusEffects: [
      StatusEffect(
        id: "battle_standard",
        name: "Battle Standard",
        duration: 4,
        attackModifier: 15,
        defenseModifier: 15,
        damagePerTurn: -5, // Negative damage = healing
      ),
    ],
    // Special: Persists even if warrior is KO'd
  ),

// Paladin Abilities
  AbilitiesModel(
    abilitiesID: "paladin_001",
    name: "Guardian's Wrath",
    description:
        "A powerful counterattack after blocking an enemy hit, with chance to stun.",
    hpBonus: 20,
    spCost: 10,
    cooldown: 5,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
    elementType: ElementType.light,
    statusEffects: [
      StatusEffect(
        id: "stun_effect",
        name: "Stunned",
        duration: 1,
        controlEffect: ControlEffect(
          type: ControlEffectType.taunt,
          duration: 1,
          successChance: 0.3,
        ),
      ),
    ],
  ),

  AbilitiesModel(
    abilitiesID: "paladin_002",
    name: "Iron Fortress",
    description:
        "Greatly increases defense and provides damage reflection for 3 turns.",
    defenseBonus: 30,
    spCost: 20,
    cooldown: 7,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
    statusEffects: [
      StatusEffect(
        id: "iron_fortress",
        name: "Iron Fortress",
        duration: 3,
        defenseModifier: 30,
        // Damage reflection would need special handling
      ),
    ],
  ),

  AbilitiesModel(
    abilitiesID: "paladin_003",
    name: "Taunt",
    description:
        "Forces enemies to attack the user and reduces their attack for 2 turns.",
    defenseBonus: 10,
    spCost: 8,
    cooldown: 4,
    type: AbilityType.control,
    targetType: TargetType.all,
    affectsEnemies: true,
    mentalPotency: 20, // Increases success chance
    statusEffects: [
      StatusEffect(
        id: "taunted",
        name: "Taunted",
        duration: 2,
        attackModifier: -5,
        controlEffect: ControlEffect(
          type: ControlEffectType.taunt,
          duration: 2,
          successChance: 0.8,
        ),
      ),
    ],
  ),
  AbilitiesModel(
    abilitiesID: "paladin_004",
    name: "Divine Intervention",
    description:
        "Revives a fallen ally with 50% HP and grants 2 turns of invulnerability.",
    hpBonus: 50, // Heal amount
    mpCost: 40,
    cooldown: 10,
    type: AbilityType.heal,
    targetType: TargetType.single,
    affectsEnemies: false,
    elementType: ElementType.divine,
    statusEffects: [
      StatusEffect(
        id: "divine_protection",
        name: "Divine Protection",
        duration: 2,
        defenseModifier: 999, // Invuln representation
      ),
    ],
    // Special: Only usable when an ally is dead
  ),

  AbilitiesModel(
    abilitiesID: "paladin_005",
    name: "Aegis of Light",
    description:
        "Creates a shield absorbing 80% of damage taken by allies for 2 turns and reflects holy damage.",
    mpCost: 30,
    cooldown: 6,
    type: AbilityType.buff,
    targetType: TargetType.all,
    affectsEnemies: false,
    elementType: ElementType.light,
    statusEffects: [
      StatusEffect(
        id: "aegis_shield",
        name: "Aegis Shield",
        duration: 2,
        // Custom property: Damage absorption
      ),
    ],
    // Special: Reflected damage scales with PAL's DEF
  ),
// Elementalist Abilities
  AbilitiesModel(
    abilitiesID: "elementalist_001",
    name: "Lightning Storm",
    description:
        "Summons lightning to strike multiple enemies with chance to paralyze.",
    hpBonus: 28,
    mpCost: 22,
    cooldown: 7,
    criticalPoint: 10,
    type: AbilityType.attack,
    targetType: TargetType.all,
    affectsEnemies: true,
    elementType: ElementType.thunder,
    statusEffects: [
      StatusEffect(
        id: "paralyzed",
        name: "Paralyzed",
        duration: 2,
        agilityModifier: -15,
        cooldownRateModifier: 0.7,
      ),
    ],
  ),

  AbilitiesModel(
    abilitiesID: "elementalist_002",
    name: "Ice Barricade",
    description:
        "Creates a protective ice barrier that reduces damage and slows enemies.",
    defenseBonus: 20,
    mpCost: 18,
    cooldown: 6,
    type: AbilityType.buff,
    targetType: TargetType.all,
    affectsEnemies: false,
    elementType: ElementType.snow,
    statusEffects: [
      StatusEffect(
        id: "ice_barrier",
        name: "Ice Barrier",
        duration: 3,
        defenseModifier: 20,
      ),
      // Enemy slow effect would need separate handling
    ],
  ),

  AbilitiesModel(
    abilitiesID: "elementalist_003",
    name: "Inferno",
    description: "Unleashes a blazing fire that burns enemies over time.",
    hpBonus: 25,
    mpCost: 20,
    cooldown: 6,
    type: AbilityType.attack,
    targetType: TargetType.all,
    affectsEnemies: true,
    elementType: ElementType.fire,
    statusEffects: [
      StatusEffect(
        id: "burning",
        name: "Burning",
        duration: 4,
        damagePerTurn: 8,
      ),
    ],
  ),
  AbilitiesModel(
    abilitiesID: "elementalist_004",
    name: "Elemental Convergence",
    description:
        "Combines all elements into a prismatic explosion. Damage type changes to target's weakness.",
    hpBonus: 40,
    mpCost: 45,
    cooldown: 9,
    type: AbilityType.attack,
    targetType: TargetType.all,
    affectsEnemies: true,
    // Special: Dynamically changes element
    statusEffects: [
      StatusEffect(
        id: "elemental_break",
        name: "Elemental Break",
        duration: 3,
        defenseModifier: -20, // Reduces resistances
      ),
    ],
    // Special: Bonus damage per different element used previously
  ),
  AbilitiesModel(
    abilitiesID: "elementalist_005",
    name: "Arcane Feedback",
    description:
        "For 3 turns, 30% of damage taken is converted to MP and triggers an automatic counter-spell.",
    mpCost: 20,
    cooldown: 7,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
    statusEffects: [
      StatusEffect(
        id: "arcane_feedback",
        name: "Arcane Feedback",
        duration: 3,
        // Custom: Damage-to-MP conversion
      ),
    ],
    // Special: Counter-spell uses last used element
  ),

// Dread Knight/Berserker Abilities
  AbilitiesModel(
    abilitiesID: "berserker_001",
    name: "Dark Cleave",
    description:
        "A heavy attack that drains HP from enemies and heals the user.",
    hpBonus: 25,
    mpCost: 15,
    cooldown: 6,
    type: AbilityType.attack,
    targetType: TargetType.single,
    affectsEnemies: true,
    elementType: ElementType.dark,
    drainsHealth: true,
    healsCaster: true,
    healCasterAmount: 15, // Heals 60% of damage dealt
  ),

  AbilitiesModel(
    abilitiesID: "berserker_002",
    name: "Unholy Resilience",
    description:
        "Grants temporary immunity to death and lifesteal for 2 turns.",
    hpBonus: 50,
    mpCost: 25,
    cooldown: 10,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
    elementType: ElementType.dark,
    statusEffects: [
      StatusEffect(
        id: "unholy_resilience",
        name: "Unholy Resilience",
        duration: 2,
        // Death immunity would need special handling
      ),
    ],
  ),

  AbilitiesModel(
    abilitiesID: "berserker_003",
    name: "Cursed Strike",
    description:
        "Inflicts a debuff that reduces enemy defense and deals damage over time.",
    hpBonus: 20,
    defenseBonus: -15, // Stronger defense reduction
    mpCost: 12,
    cooldown: 5,
    type: AbilityType.debuff,
    targetType: TargetType.single,
    affectsEnemies: true,
    elementType: ElementType.poison,
    statusEffects: [
      StatusEffect(
        id: "cursed_wound",
        name: "Cursed Wound",
        duration: 4,
        damagePerTurn: 5,
        defenseModifier: -15,
      ),
    ],
  ),
  AbilitiesModel(
    abilitiesID: "berserker_004",
    name: "Ragnarok's Call",
    description:
        "Sacrifices 50% current HP to deal 300% ATK as AoE damage. Lower HP = more crit chance.",
    hpBonus: 0, // Custom calculation
    spCost: 0, // HP cost instead
    cooldown: 8,
    type: AbilityType.attack,
    targetType: TargetType.all,
    affectsEnemies: true,
    elementType: ElementType.dark,
    // Special: Damage scales inversely with HP
    // Special: Gains lifesteal if it kills
  ),
  AbilitiesModel(
    abilitiesID: "berserker_005",
    name: "Blood Pact",
    description:
        "For 4 turns, lose 10% max HP per turn but gain +40% ATK and immunity to CC.",
    spCost: 25,
    cooldown: 5,
    type: AbilityType.buff,
    targetType: TargetType.single,
    affectsEnemies: false,
    statusEffects: [
      StatusEffect(
        id: "blood_pact",
        name: "Blood Pact",
        duration: 4,
        attackModifier: 40,
        damagePerTurn: 10, // % based would need custom logic
      ),
    ],
    // Special: Cannot be dispelled
    // Special: HP loss counts as damage for berserker synergies
  ),
];

// Helper function to find an ability by its ID
AbilitiesModel? getAbilityById(String abilitiesID) {
  return abilitiesList.firstWhere(
    (ability) => ability.abilitiesID == abilitiesID,
    orElse: () => throw Exception("Ability not found"),
  );
}
