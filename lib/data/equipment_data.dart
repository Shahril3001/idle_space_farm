import '../models/equipment_model.dart';

final List<Equipment> equipmentList = [
  // Common Weapons
  Equipment(
    id: "wpn_001",
    name: "Rusty Sword",
    slot: EquipmentSlot.weapon,
    rarity: EquipmentRarity.common,
    attackBonus: 3,
    allowedTypes: ["warrior", "knight"],
    allowedRaces: ["human", "elf"],
  ),
  Equipment(
    id: "wpn_002",
    name: "Wooden Staff",
    slot: EquipmentSlot.weapon,
    rarity: EquipmentRarity.common,
    attackBonus: 2,
    mpBonus: 5,
    allowedTypes: ["mage", "priest"],
  ),
  Equipment(
    id: "wpn_003",
    name: "Chipped Dagger",
    slot: EquipmentSlot.weapon,
    rarity: EquipmentRarity.common,
    attackBonus: 2,
    agilityBonus: 1,
    allowedTypes: ["rogue", "assassin"],
  ),

  // Common Armor
  Equipment(
    id: "arm_001",
    name: "Leather Vest",
    slot: EquipmentSlot.armor,
    rarity: EquipmentRarity.common,
    defenseBonus: 3,
    hpBonus: 5,
  ),
  Equipment(
    id: "arm_002",
    name: "Cloth Robe",
    slot: EquipmentSlot.armor,
    rarity: EquipmentRarity.common,
    defenseBonus: 1,
    mpBonus: 10,
    allowedTypes: ["mage", "priest"],
  ),

  // Common Accessories
  Equipment(
    id: "acc_001",
    name: "Copper Ring",
    slot: EquipmentSlot.accessory,
    rarity: EquipmentRarity.common,
    hpBonus: 3,
  ),
  Equipment(
    id: "acc_002",
    name: "Leather Gloves",
    slot: EquipmentSlot.accessory,
    rarity: EquipmentRarity.common,
    agilityBonus: 2,
  ),

  // Uncommon Weapons
  Equipment(
    id: "wpn_101",
    name: "Iron Broadsword",
    slot: EquipmentSlot.weapon,
    rarity: EquipmentRarity.uncommon,
    attackBonus: 5,
    allowedTypes: ["warrior", "knight"],
  ),
  Equipment(
    id: "wpn_102",
    name: "Apprentice's Wand",
    slot: EquipmentSlot.weapon,
    rarity: EquipmentRarity.uncommon,
    attackBonus: 3,
    mpBonus: 10,
    spBonus: 5,
    allowedTypes: ["mage", "priest"],
  ),

  // Uncommon Armor
  Equipment(
    id: "arm_101",
    name: "Chainmail",
    slot: EquipmentSlot.armor,
    rarity: EquipmentRarity.uncommon,
    defenseBonus: 6,
    hpBonus: 8,
    agilityBonus: -1,
  ),

  // Rare Weapons
  Equipment(
    id: "wpn_201",
    name: "Silver Rapier",
    slot: EquipmentSlot.weapon,
    rarity: EquipmentRarity.rare,
    attackBonus: 8,
    agilityBonus: 3,
    criticalPoint: 5,
    allowedTypes: ["knight", "assassin"],
  ),
  Equipment(
    id: "wpn_202",
    name: "Arcane Tome",
    slot: EquipmentSlot.weapon,
    rarity: EquipmentRarity.rare,
    attackBonus: 5,
    mpBonus: 20,
    spBonus: 10,
    allowedTypes: ["mage"],
  ),

  // Epic Weapons
  Equipment(
    id: "wpn_301",
    name: "Dragonbone Greatsword",
    slot: EquipmentSlot.weapon,
    rarity: EquipmentRarity.epic,
    attackBonus: 15,
    hpBonus: 10,
    allowedTypes: ["warrior"],
    isTradable: false,
  ),
  Equipment(
    id: "wpn_302",
    name: "Staff of the Archmage",
    slot: EquipmentSlot.weapon,
    rarity: EquipmentRarity.epic,
    attackBonus: 10,
    mpBonus: 30,
    spBonus: 20,
    allowedTypes: ["mage", "priest"],
  ),

  // Legendary Weapons
  Equipment(
    id: "wpn_401",
    name: "Excalibur",
    slot: EquipmentSlot.weapon,
    rarity: EquipmentRarity.legendary,
    attackBonus: 25,
    defenseBonus: 5,
    hpBonus: 15,
    criticalPoint: 15,
    allowedTypes: ["knight"],
    allowedRaces: ["human"],
    isTradable: false,
  ),

  // Mythic Weapons
  Equipment(
    id: "wpn_501",
    name: "Blade of Creation",
    slot: EquipmentSlot.weapon,
    rarity: EquipmentRarity.mythic,
    attackBonus: 35,
    defenseBonus: 10,
    hpBonus: 30,
    mpBonus: 20,
    spBonus: 20,
    agilityBonus: 5,
    criticalPoint: 20,
    allowedTypes: ["warrior", "knight"],
    isTradable: false,
  ),

  // Special/Unique Items
  Equipment(
    id: "acc_301",
    name: "Amulet of the Phoenix",
    slot: EquipmentSlot.accessory,
    rarity: EquipmentRarity.epic,
    hpBonus: 30,
    mpBonus: 15,
    isTradable: false,
  ),
  Equipment(
    id: "arm_401",
    name: "Armor of the Fallen King",
    slot: EquipmentSlot.armor,
    rarity: EquipmentRarity.legendary,
    defenseBonus: 25,
    hpBonus: 50,
    mpBonus: 10,
    isTradable: false,
  ),
];
