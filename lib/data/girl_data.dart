import '../models/girl_farmer_model.dart';
import 'dart:math';

final Random _random = Random();

// Helper function to generate random stats based on rarity and type
Map<String, int> _generateStats(String rarity, String type) {
  int baseHp, baseMp, baseSp, baseAtk, baseDef, baseAgi;

  // Base stats based on type
  switch (type) {
    case 'Warrior':
      baseHp = 110;
      baseMp = 30;
      baseSp = 40;
      baseAtk = 12;
      baseDef = 6;
      baseAgi = 10;
      break;
    case 'Mage':
      baseHp = 90;
      baseMp = 80;
      baseSp = 20;
      baseAtk = 8;
      baseDef = 4;
      baseAgi = 6;
      break;
    case 'Rogue':
      baseHp = 100;
      baseMp = 40;
      baseSp = 50;
      baseAtk = 11;
      baseDef = 5;
      baseAgi = 12;
      break;
    case 'Cleric':
      baseHp = 120;
      baseMp = 70;
      baseSp = 30;
      baseAtk = 9;
      baseDef = 7;
      baseAgi = 5;
      break;
    case 'Paladin':
      baseHp = 140;
      baseMp = 50;
      baseSp = 25;
      baseAtk = 13;
      baseDef = 9;
      baseAgi = 5;
      break;
    case 'Elementalist':
      baseHp = 100;
      baseMp = 90;
      baseSp = 25;
      baseAtk = 7;
      baseDef = 5;
      baseAgi = 7;
      break;
    case 'Berserker':
      baseHp = 115;
      baseMp = 50;
      baseSp = 35;
      baseAtk = 10;
      baseDef = 7;
      baseAgi = 8;
      break;
    case 'Archer':
      baseHp = 95;
      baseMp = 85;
      baseSp = 25;
      baseAtk = 8;
      baseDef = 5;
      baseAgi = 6;
      break;
    default:
      baseHp = 100;
      baseMp = 50;
      baseSp = 30;
      baseAtk = 10;
      baseDef = 5;
      baseAgi = 7;
  }

  // Adjust stats based on rarity
  int rarityBonus = 0;
  switch (rarity) {
    case 'Common':
      rarityBonus = _random.nextInt(5) + 1; // +1 to 5
      break;
    case 'Rare':
      rarityBonus = _random.nextInt(6) + 5; // +5 to 10
      break;
    case 'Unique':
      rarityBonus = _random.nextInt(6) + 10; // +10 to 15
      break;
  }

  return {
    'hp': baseHp + rarityBonus,
    'mp': baseMp + rarityBonus,
    'sp': baseSp + rarityBonus,
    'attackPoints': baseAtk + rarityBonus,
    'defensePoints': baseDef + rarityBonus,
    'agilityPoints': baseAgi + rarityBonus,
  };
}

// List of GirlFarmer instances
final List<GirlFarmer> girlsData = [
  // Common Girls (1-2 stars)
  GirlFarmer(
    id: 'common-1',
    name: 'Luna',
    rarity: 'Common',
    stars: 1,
    miningEfficiency: 0.02,
    image: 'assets/images/girls/luna.png',
    imageFace: 'assets/images/girls/luna-f.png',
    race: 'Human',
    type: 'Warrior',
    region: 'Astravia',
    description:
        "A humble warrior from Astravia, Luna wields her blade with precision, inspired by the Paladins of the Celestial Order.",
    hp: _generateStats('Common', 'Warrior')['hp']!,
    mp: _generateStats('Common', 'Warrior')['mp']!,
    sp: _generateStats('Common', 'Warrior')['sp']!,
    attackPoints: _generateStats('Common', 'Warrior')['attackPoints']!,
    defensePoints: _generateStats('Common', 'Warrior')['defensePoints']!,
    agilityPoints: _generateStats('Common', 'Warrior')['agilityPoints']!,
    maxHp: _generateStats('Common', 'Warrior')['hp']!,
    maxMp: _generateStats('Common', 'Warrior')['mp']!,
    maxSp: _generateStats('Common', 'Warrior')['sp']!,
    criticalPoint: 3, // Default critical point
  ),
  GirlFarmer(
    id: 'common-2',
    name: 'Aria',
    rarity: 'Common',
    stars: 1,
    miningEfficiency: 0.03,
    image: 'assets/images/girls/aria.png',
    imageFace: 'assets/images/girls/aria-f.png',
    race: 'Eldren',
    type: 'Mage',
    region: 'Sylvaris',
    description:
        "Aria is a young Eldren mage from Sylvaris, gifted in elemental magic. She spends her days tending to the enchanted forests.",
    hp: _generateStats('Common', 'Mage')['hp']!,
    mp: _generateStats('Common', 'Mage')['mp']!,
    sp: _generateStats('Common', 'Mage')['sp']!,
    attackPoints: _generateStats('Common', 'Mage')['attackPoints']!,
    defensePoints: _generateStats('Common', 'Mage')['defensePoints']!,
    agilityPoints: _generateStats('Common', 'Mage')['agilityPoints']!,
    maxHp: _generateStats('Common', 'Mage')['hp']!,
    maxMp: _generateStats('Common', 'Mage')['mp']!,
    maxSp: _generateStats('Common', 'Mage')['sp']!,
    criticalPoint: 3, // Default critical point
  ),
  GirlFarmer(
    id: 'common-3',
    name: 'Elyse',
    rarity: 'Common',
    stars: 2,
    miningEfficiency: 0.04,
    image: 'assets/images/girls/elyse.png',
    imageFace: 'assets/images/girls/elyse-f.png',
    race: 'Eldren',
    type: 'Rogue',
    region: 'Sylvaris',
    description:
        "Elyse, a Eldren from the Sylvaris, is a shadowy figure who uses her agility to navigate the darkest corners of Eldoria. She seeks redemption for her cursed lineage.",
    hp: _generateStats('Common', 'Rogue')['hp']!,
    mp: _generateStats('Common', 'Rogue')['mp']!,
    sp: _generateStats('Common', 'Rogue')['sp']!,
    attackPoints: _generateStats('Common', 'Rogue')['attackPoints']!,
    defensePoints: _generateStats('Common', 'Rogue')['defensePoints']!,
    agilityPoints: _generateStats('Common', 'Rogue')['agilityPoints']!,
    maxHp: _generateStats('Common', 'Rogue')['hp']!,
    maxMp: _generateStats('Common', 'Rogue')['mp']!,
    maxSp: _generateStats('Common', 'Rogue')['sp']!,
    criticalPoint: 3,
  ),
  GirlFarmer(
    id: 'common-4',
    name: 'Tessa',
    rarity: 'Common',
    stars: 1,
    miningEfficiency: 0.01,
    image: 'assets/images/girls/tessa.png',
    imageFace: 'assets/images/girls/tessa-f.png',
    race: 'Therian',
    type: 'Cleric',
    region: 'Astravia',
    description:
        "Tessa, a Therian cleric, channels the light of Solmara to heal and protect. Her connection to nature makes her a beloved figure in Astravia.",
    hp: _generateStats('Common', 'Cleric')['hp']!,
    mp: _generateStats('Common', 'Cleric')['mp']!,
    sp: _generateStats('Common', 'Cleric')['sp']!,
    attackPoints: _generateStats('Common', 'Cleric')['attackPoints']!,
    defensePoints: _generateStats('Common', 'Cleric')['defensePoints']!,
    agilityPoints: _generateStats('Common', 'Cleric')['agilityPoints']!,
    maxHp: _generateStats('Common', 'Cleric')['hp']!,
    maxMp: _generateStats('Common', 'Cleric')['mp']!,
    maxSp: _generateStats('Common', 'Cleric')['sp']!,
    criticalPoint: 3,
  ),
  GirlFarmer(
    id: 'common-5',
    name: 'Mira',
    rarity: 'Common',
    stars: 2,
    miningEfficiency: 0.03,
    image: 'assets/images/girls/mira.png',
    imageFace: 'assets/images/girls/mira-f.png',
    race: 'Dracovar',
    type: 'Paladin',
    region: 'Draknir Sovereignty',
    description:
        "Mira, a fierce Dracovar warrior, wields dark magic to protect her homeland. Her draconic heritage gives her unmatched strength and resilience.",
    hp: _generateStats('Common', 'Paladin')['hp']!,
    mp: _generateStats('Common', 'Paladin')['mp']!,
    sp: _generateStats('Common', 'Paladin')['sp']!,
    attackPoints: _generateStats('Common', 'Paladin')['attackPoints']!,
    defensePoints: _generateStats('Common', 'Paladin')['defensePoints']!,
    agilityPoints: _generateStats('Common', 'Paladin')['agilityPoints']!,
    maxHp: _generateStats('Common', 'Paladin')['hp']!,
    maxMp: _generateStats('Common', 'Paladin')['mp']!,
    maxSp: _generateStats('Common', 'Paladin')['sp']!,
    criticalPoint: 3,
  ),
  GirlFarmer(
    id: 'common-6',
    name: 'Lyra',
    rarity: 'Common',
    stars: 2,
    miningEfficiency: 0.02,
    image: 'assets/images/girls/lyra.png',
    imageFace: 'assets/images/girls/lyra-f.png',
    race: 'Human',
    type: 'Elementalist',
    region: 'Elementara',
    description:
        "Lyra, a mischievous Human, commands the elements with ease. Her playful nature hides a deep connection to the chaotic realm of Elementara.",
    hp: _generateStats('Common', 'Elementalist')['hp']!,
    mp: _generateStats('Common', 'Elementalist')['mp']!,
    sp: _generateStats('Common', 'Elementalist')['sp']!,
    attackPoints: _generateStats('Common', 'Elementalist')['attackPoints']!,
    defensePoints: _generateStats('Common', 'Elementalist')['defensePoints']!,
    agilityPoints: _generateStats('Common', 'Elementalist')['agilityPoints']!,
    maxHp: _generateStats('Common', 'Elementalist')['hp']!,
    maxMp: _generateStats('Common', 'Elementalist')['mp']!,
    maxSp: _generateStats('Common', 'Elementalist')['sp']!,
    criticalPoint: 3,
  ),
  GirlFarmer(
    id: 'common-7',
    name: 'Rina',
    rarity: 'Common',
    stars: 1,
    miningEfficiency: 0.04,
    image: 'assets/images/girls/rina.png',
    imageFace: 'assets/images/girls/rina-f.png',
    race: 'Human',
    type: 'Rogue',
    region: 'Astravia',
    description:
        "Rina, a skilled rogue from Astravia, defends her homeland with unwavering loyalty. Her dagger are said to never miss their mark.",
    hp: _generateStats('Common', 'Rogue')['hp']!,
    mp: _generateStats('Common', 'Rogue')['mp']!,
    sp: _generateStats('Common', 'Rogue')['sp']!,
    attackPoints: _generateStats('Common', 'Rogue')['attackPoints']!,
    defensePoints: _generateStats('Common', 'Rogue')['defensePoints']!,
    agilityPoints: _generateStats('Common', 'Rogue')['agilityPoints']!,
    maxHp: _generateStats('Common', 'Rogue')['hp']!,
    maxMp: _generateStats('Common', 'Rogue')['mp']!,
    maxSp: _generateStats('Common', 'Rogue')['sp']!,
    criticalPoint: 3,
  ),
  GirlFarmer(
    id: 'common-8',
    name: 'Zara',
    rarity: 'Common',
    stars: 2,
    miningEfficiency: 0.01,
    image: 'assets/images/girls/zara.png',
    imageFace: 'assets/images/girls/zara-f.png',
    race: 'Eldren',
    type: 'Archer',
    region: 'Sylvaris',
    description:
        "Zara, an Eldren runebinder, inscribes powerful runes into her archer weapons. Her knowledge of ancient magic makes her a valuable ally.",
    hp: _generateStats('Common', 'Archer')['hp']!,
    mp: _generateStats('Common', 'Archer')['mp']!,
    sp: _generateStats('Common', 'Archer')['sp']!,
    attackPoints: _generateStats('Common', 'Archer')['attackPoints']!,
    defensePoints: _generateStats('Common', 'Archer')['defensePoints']!,
    agilityPoints: _generateStats('Common', 'Archer')['agilityPoints']!,
    maxHp: _generateStats('Common', 'Archer')['hp']!,
    maxMp: _generateStats('Common', 'Archer')['mp']!,
    maxSp: _generateStats('Common', 'Archer')['sp']!,
    criticalPoint: 3,
  ),
  GirlFarmer(
    id: 'common-9',
    name: 'Siena',
    rarity: 'Common',
    stars: 1,
    miningEfficiency: 0.02,
    image: 'assets/images/girls/siena.png',
    imageFace: 'assets/images/girls/siena-f.png',
    race: 'Therian',
    type: 'Warrior',
    region: 'Ashen Dominion',
    description:
        "Siena, a Therian blademaster, fights to prove her worth in a world that fears her kind. Her blade is as sharp as her resolve.",
    hp: _generateStats('Common', 'Warrior')['hp']!,
    mp: _generateStats('Common', 'Warrior')['mp']!,
    sp: _generateStats('Common', 'Warrior')['sp']!,
    attackPoints: _generateStats('Common', 'Warrior')['attackPoints']!,
    defensePoints: _generateStats('Common', 'Warrior')['defensePoints']!,
    agilityPoints: _generateStats('Common', 'Warrior')['agilityPoints']!,
    maxHp: _generateStats('Common', 'Warrior')['hp']!,
    maxMp: _generateStats('Common', 'Warrior')['mp']!,
    maxSp: _generateStats('Common', 'Warrior')['sp']!,
    criticalPoint: 3,
  ),
  GirlFarmer(
    id: 'common-10',
    name: 'Fredya',
    rarity: 'Common',
    stars: 1,
    miningEfficiency: 0.03,
    image: 'assets/images/girls/fredya.png',
    imageFace: 'assets/images/girls/fredya-f.png',
    race: 'Therian',
    type: 'Archer',
    region: 'Astravia',
    description:
        "Fredya, a Therian archer, combines her beastly instincts with archery skills. She is a fierce protector of Astravia's farmlands.",
    hp: _generateStats('Common', 'Archer')['hp']!,
    mp: _generateStats('Common', 'Archer')['mp']!,
    sp: _generateStats('Common', 'Archer')['sp']!,
    attackPoints: _generateStats('Common', 'Archer')['attackPoints']!,
    defensePoints: _generateStats('Common', 'Archer')['defensePoints']!,
    agilityPoints: _generateStats('Common', 'Archer')['agilityPoints']!,
    maxHp: _generateStats('Common', 'Archer')['hp']!,
    maxMp: _generateStats('Common', 'Archer')['mp']!,
    maxSp: _generateStats('Common', 'Archer')['sp']!,
    criticalPoint: 3,
  ),

  // Rare Girls (3-4 stars)
  GirlFarmer(
    id: 'rare-1',
    name: 'Stella',
    rarity: 'Rare',
    stars: 3,
    miningEfficiency: 0.06,
    image: 'assets/images/girls/stella.png',
    imageFace: 'assets/images/girls/stella-f.png',
    race: 'Human',
    type: 'Warrior',
    region: 'Astravia',
    description:
        "Stella, a rare Blademaster, has mastered the art of the sword. Her precision and speed make her a formidable opponent.",
    hp: _generateStats('Rare', 'Warrior')['hp']!,
    mp: _generateStats('Rare', 'Warrior')['mp']!,
    sp: _generateStats('Rare', 'Warrior')['sp']!,
    attackPoints: _generateStats('Rare', 'Warrior')['attackPoints']!,
    defensePoints: _generateStats('Rare', 'Warrior')['defensePoints']!,
    agilityPoints: _generateStats('Rare', 'Warrior')['agilityPoints']!,
    maxHp: _generateStats('Rare', 'Warrior')['hp']!,
    maxMp: _generateStats('Rare', 'Warrior')['mp']!,
    maxSp: _generateStats('Rare', 'Warrior')['sp']!,
    criticalPoint: 5,
  ),
  GirlFarmer(
    id: 'rare-2',
    name: 'Elara',
    rarity: 'Rare',
    stars: 3,
    miningEfficiency: 0.05,
    image: 'assets/images/girls/elara.png',
    imageFace: 'assets/images/girls/elara-f.png',
    race: 'Eldren',
    type: 'Mage',
    region: 'Sylvaris',
    description:
        "Elara, a rare Arcane Sage, has mastered the elements. Her spells are as beautiful as they are destructive.",
    hp: _generateStats('Rare', 'Mage')['hp']!,
    mp: _generateStats('Rare', 'Mage')['mp']!,
    sp: _generateStats('Rare', 'Mage')['sp']!,
    attackPoints: _generateStats('Rare', 'Mage')['attackPoints']!,
    defensePoints: _generateStats('Rare', 'Mage')['defensePoints']!,
    agilityPoints: _generateStats('Rare', 'Mage')['agilityPoints']!,
    maxHp: _generateStats('Rare', 'Mage')['hp']!,
    maxMp: _generateStats('Rare', 'Mage')['mp']!,
    maxSp: _generateStats('Rare', 'Mage')['sp']!,
    criticalPoint: 5,
  ),
  GirlFarmer(
    id: 'rare-3',
    name: 'Nina',
    rarity: 'Rare',
    stars: 4,
    miningEfficiency: 0.08,
    image: 'assets/images/girls/nina.png',
    imageFace: 'assets/images/girls/nina-f.png',
    race: 'Human',
    type: 'Paladin',
    region: 'Astravia',
    description:
        "Nina, a rare  Paladin, wields light magic with unmatched skill. Her paladin heritage makes her a formidable force on the battlefield.",
    hp: _generateStats('Rare', 'Paladin')['hp']!,
    mp: _generateStats('Rare', 'Paladin')['mp']!,
    sp: _generateStats('Rare', 'Paladin')['sp']!,
    attackPoints: _generateStats('Rare', 'Paladin')['attackPoints']!,
    defensePoints: _generateStats('Rare', 'Paladin')['defensePoints']!,
    agilityPoints: _generateStats('Rare', 'Paladin')['agilityPoints']!,
    maxHp: _generateStats('Rare', 'Paladin')['hp']!,
    maxMp: _generateStats('Rare', 'Paladin')['mp']!,
    maxSp: _generateStats('Rare', 'Paladin')['sp']!,
    criticalPoint: 5,
  ),
  GirlFarmer(
    id: 'rare-4',
    name: 'Isla',
    rarity: 'Rare',
    stars: 3,
    miningEfficiency: 0.07,
    image: 'assets/images/girls/isla.png',
    imageFace: 'assets/images/girls/isla-f.png',
    race: 'Human',
    type: 'Elementalist',
    region: 'Elementara',
    description:
        "Isla, a rare Elementalist, commands the forces of nature with ease. Her connection to Elementara makes her a powerful ally.",
    hp: _generateStats('Rare', 'Elementalist')['hp']!,
    mp: _generateStats('Rare', 'Elementalist')['mp']!,
    sp: _generateStats('Rare', 'Elementalist')['sp']!,
    attackPoints: _generateStats('Rare', 'Elementalist')['attackPoints']!,
    defensePoints: _generateStats('Rare', 'Elementalist')['defensePoints']!,
    agilityPoints: _generateStats('Rare', 'Elementalist')['agilityPoints']!,
    maxHp: _generateStats('Rare', 'Elementalist')['hp']!,
    maxMp: _generateStats('Rare', 'Elementalist')['mp']!,
    maxSp: _generateStats('Rare', 'Elementalist')['sp']!,
    criticalPoint: 5, // Higher critical point for Rare
  ),
  GirlFarmer(
    id: 'rare-5',
    name: 'Selene',
    rarity: 'Rare',
    stars: 4,
    miningEfficiency: 0.06,
    image: 'assets/images/girls/selene.png',
    imageFace: 'assets/images/girls/selene-f.png',
    race: 'Human',
    type: 'Warrior',
    region: 'Astravia',
    description:
        "Selene, a rare warrior, defends Astravia with her sword and unwavering loyalty. Her sword are said to pierce even the toughest armor.",
    hp: _generateStats('Rare', 'Warrior')['hp']!,
    mp: _generateStats('Rare', 'Warrior')['mp']!,
    sp: _generateStats('Rare', 'Warrior')['sp']!,
    attackPoints: _generateStats('Rare', 'Warrior')['attackPoints']!,
    defensePoints: _generateStats('Rare', 'Warrior')['defensePoints']!,
    agilityPoints: _generateStats('Rare', 'Warrior')['agilityPoints']!,
    maxHp: _generateStats('Rare', 'Warrior')['hp']!,
    maxMp: _generateStats('Rare', 'Warrior')['mp']!,
    maxSp: _generateStats('Rare', 'Warrior')['sp']!,
    criticalPoint: 5,
  ),
  GirlFarmer(
    id: 'rare-6',
    name: 'Vivian',
    rarity: 'Rare',
    stars: 3,
    miningEfficiency: 0.05,
    image: 'assets/images/girls/vivian.png',
    imageFace: 'assets/images/girls/vivian-f.png',
    race: 'Eldren',
    type: 'Archer',
    region: 'Sylvaris',
    description:
        "Vivian, a rare Runebinder, inscribes powerful runes into her archer weapons. Her knowledge of ancient magic makes her a valuable ally.",
    hp: _generateStats('Rare', 'Archer')['hp']!,
    mp: _generateStats('Rare', 'Archer')['mp']!,
    sp: _generateStats('Rare', 'Archer')['sp']!,
    attackPoints: _generateStats('Rare', 'Archer')['attackPoints']!,
    defensePoints: _generateStats('Rare', 'Archer')['defensePoints']!,
    agilityPoints: _generateStats('Rare', 'Archer')['agilityPoints']!,
    maxHp: _generateStats('Rare', 'Archer')['hp']!,
    maxMp: _generateStats('Rare', 'Archer')['mp']!,
    maxSp: _generateStats('Rare', 'Archer')['sp']!,
    criticalPoint: 5,
  ),

  // Unique Girls (5-6 stars)
  GirlFarmer(
    id: 'unique-1',
    name: 'Astrid',
    rarity: 'Unique',
    stars: 5,
    miningEfficiency: 0.10,
    image: 'assets/images/girls/astrid.png',
    imageFace: 'assets/images/girls/astrid-f.png',
    race: 'Human',
    type: 'Warrior',
    region: 'Astravia',
    description:
        "Astrid, a unique Blademaster, wields her blade with unmatched skill. Her dark past fuels her determination to protect the innocent.",
    hp: _generateStats('Unique', 'Warrior')['hp']!,
    mp: _generateStats('Unique', 'Warrior')['mp']!,
    sp: _generateStats('Unique', 'Warrior')['sp']!,
    attackPoints: _generateStats('Unique', 'Warrior')['attackPoints']!,
    defensePoints: _generateStats('Unique', 'Warrior')['defensePoints']!,
    agilityPoints: _generateStats('Unique', 'Warrior')['agilityPoints']!,
    maxHp: _generateStats('Unique', 'Warrior')['hp']!,
    maxMp: _generateStats('Unique', 'Warrior')['mp']!,
    maxSp: _generateStats('Unique', 'Warrior')['sp']!,
    criticalPoint: 10,
  ),
  GirlFarmer(
    id: 'unique-2',
    name: 'Seraphina',
    rarity: 'Unique',
    stars: 6,
    miningEfficiency: 0.12,
    image: 'assets/images/girls/seraphina.png',
    imageFace: 'assets/images/girls/seraphina-f.png',
    race: 'Therian',
    type: 'Mage',
    region: 'Astravia',
    description:
        "Seraphina, a unique Arcane Sage, commands the elements with unparalleled mastery. Her wisdom and power make her a beacon of hope in Astravia.",
    hp: _generateStats('Unique', 'Mage')['hp']!,
    mp: _generateStats('Unique', 'Mage')['mp']!,
    sp: _generateStats('Unique', 'Mage')['sp']!,
    attackPoints: _generateStats('Unique', 'Mage')['attackPoints']!,
    defensePoints: _generateStats('Unique', 'Mage')['defensePoints']!,
    agilityPoints: _generateStats('Unique', 'Mage')['agilityPoints']!,
    maxHp: _generateStats('Unique', 'Mage')['hp']!,
    maxMp: _generateStats('Unique', 'Mage')['mp']!,
    maxSp: _generateStats('Unique', 'Mage')['sp']!,
    criticalPoint: 10,
  ),
  GirlFarmer(
    id: 'unique-3',
    name: 'Elysia',
    rarity: 'Unique',
    stars: 5,
    miningEfficiency: 0.09,
    image: 'assets/images/girls/elysia.png',
    imageFace: 'assets/images/girls/elysia-f.png',
    race: 'Dracovar',
    type: 'Rogue',
    region: 'Draknir Sovereignty',
    description:
        "Elysia, a unique Phantom Reaver, moves like a shadow through the battlefield. Her draconic heritage gives her unmatched agility and strength.",
    hp: _generateStats('Unique', 'Rogue')['hp']!,
    mp: _generateStats('Unique', 'Rogue')['mp']!,
    sp: _generateStats('Unique', 'Rogue')['sp']!,
    attackPoints: _generateStats('Unique', 'Rogue')['attackPoints']!,
    defensePoints: _generateStats('Unique', 'Rogue')['defensePoints']!,
    agilityPoints: _generateStats('Unique', 'Rogue')['agilityPoints']!,
    maxHp: _generateStats('Unique', 'Rogue')['hp']!,
    maxMp: _generateStats('Unique', 'Rogue')['mp']!,
    maxSp: _generateStats('Unique', 'Rogue')['sp']!,
    criticalPoint: 10,
  ),
  GirlFarmer(
    id: 'unique-4',
    name: 'Celestia',
    rarity: 'Unique',
    stars: 6,
    miningEfficiency: 0.11,
    image: 'assets/images/girls/celestia.png',
    imageFace: 'assets/images/girls/celestia-f.png',
    race: 'Human',
    type: 'Cleric',
    region: 'Elementara',
    description:
        "Celestia, a unique Divine Cleric, channels the light of Solmara to heal and protect. Her connection to Elementara makes her a powerful ally.",
    hp: _generateStats('Unique', 'Cleric')['hp']!,
    mp: _generateStats('Unique', 'Cleric')['mp']!,
    sp: _generateStats('Unique', 'Cleric')['sp']!,
    attackPoints: _generateStats('Unique', 'Cleric')['attackPoints']!,
    defensePoints: _generateStats('Unique', 'Cleric')['defensePoints']!,
    agilityPoints: _generateStats('Unique', 'Cleric')['agilityPoints']!,
    maxHp: _generateStats('Unique', 'Cleric')['hp']!,
    maxMp: _generateStats('Unique', 'Cleric')['mp']!,
    maxSp: _generateStats('Unique', 'Cleric')['sp']!,
    criticalPoint: 10,
  ),
  GirlFarmer(
    id: 'unique-5',
    name: 'Zyra',
    rarity: 'Unique',
    stars: 5,
    miningEfficiency: 0.10,
    image: 'assets/images/girls/zyra.png',
    imageFace: 'assets/images/girls/zyra-f.png',
    race: 'Human',
    type: 'Cleric',
    region: 'Astravia',
    description:
        "Zyra, a unique Divine Cleric, channels the light of Solmara to heal and protect. Her connection to Elementara makes her a powerful ally.",
    hp: _generateStats('Unique', 'Cleric')['hp']!,
    mp: _generateStats('Unique', 'Cleric')['mp']!,
    sp: _generateStats('Unique', 'Cleric')['sp']!,
    attackPoints: _generateStats('Unique', 'Cleric')['attackPoints']!,
    defensePoints: _generateStats('Unique', 'Cleric')['defensePoints']!,
    agilityPoints: _generateStats('Unique', 'Cleric')['agilityPoints']!,
    maxHp: _generateStats('Unique', 'Cleric')['hp']!,
    maxMp: _generateStats('Unique', 'Cleric')['mp']!,
    maxSp: _generateStats('Unique', 'Cleric')['sp']!,
    criticalPoint: 10,
  ),
  GirlFarmer(
    id: 'unique-6',
    name: 'Amara',
    rarity: 'Unique',
    stars: 6,
    miningEfficiency: 0.12,
    image: 'assets/images/girls/amara.png',
    imageFace: 'assets/images/girls/amara-f.png',
    race: 'Eldren',
    type: 'Elementalist',
    region: 'Sylvaris',
    description:
        "Amara, a unique Elementalist, commands the forces of nature with unparalleled mastery. Her wisdom and power make her a beacon of hope in Sylvaris.",
    hp: _generateStats('Unique', 'Elementalist')['hp']!,
    mp: _generateStats('Unique', 'Elementalist')['mp']!,
    sp: _generateStats('Unique', 'Elementalist')['sp']!,
    attackPoints: _generateStats('Unique', 'Elementalist')['attackPoints']!,
    defensePoints: _generateStats('Unique', 'Elementalist')['defensePoints']!,
    agilityPoints: _generateStats('Unique', 'Elementalist')['agilityPoints']!,
    maxHp: _generateStats('Unique', 'Elementalist')['hp']!,
    maxMp: _generateStats('Unique', 'Elementalist')['mp']!,
    maxSp: _generateStats('Unique', 'Elementalist')['sp']!,
    criticalPoint: 10,
  ),
  GirlFarmer(
    id: 'unique-7',
    name: 'Seras',
    rarity: 'Unique',
    stars: 6,
    miningEfficiency: 0.12,
    image: 'assets/images/girls/seras.png',
    imageFace: 'assets/images/girls/seras-f.png',
    race: 'Eldran',
    type: 'Warrior',
    region: 'Sylvaris',
    description:
        "Seras, a unique warrior, commands the elements with unparalleled mastery. Her wisdom and power make her a beacon of hope in Sylvaris.",
    hp: _generateStats('Unique', 'Warrior')['hp']!,
    mp: _generateStats('Unique', 'Warrior')['mp']!,
    sp: _generateStats('Unique', 'Warrior')['sp']!,
    attackPoints: _generateStats('Unique', 'Warrior')['attackPoints']!,
    defensePoints: _generateStats('Unique', 'Warrior')['defensePoints']!,
    agilityPoints: _generateStats('Unique', 'Warrior')['agilityPoints']!,
    maxHp: _generateStats('Unique', 'Warrior')['hp']!,
    maxMp: _generateStats('Unique', 'Warrior')['mp']!,
    maxSp: _generateStats('Unique', 'Warrior')['sp']!,
    criticalPoint: 10,
  ),
  GirlFarmer(
    id: 'unique-8',
    name: 'Claudia',
    rarity: 'Unique',
    stars: 6,
    miningEfficiency: 0.12,
    image: 'assets/images/girls/claudia.png',
    imageFace: 'assets/images/girls/claudia-f.png',
    race: 'Therian',
    type: 'Archer',
    region: 'Astravia',
    description:
        "Seraphina, a unique Archer, who able commands the elements with unparalleled mastery. Her wisdom and power make her a beacon of hope in Astravia.",
    hp: _generateStats('Unique', 'Archer')['hp']!,
    mp: _generateStats('Unique', 'Archer')['mp']!,
    sp: _generateStats('Unique', 'Archer')['sp']!,
    attackPoints: _generateStats('Unique', 'Archer')['attackPoints']!,
    defensePoints: _generateStats('Unique', 'Archer')['defensePoints']!,
    agilityPoints: _generateStats('Unique', 'Archer')['agilityPoints']!,
    maxHp: _generateStats('Unique', 'Archer')['hp']!,
    maxMp: _generateStats('Unique', 'Archer')['mp']!,
    maxSp: _generateStats('Unique', 'Archer')['sp']!,
    criticalPoint: 10,
  ),
  GirlFarmer(
    id: 'unique-9',
    name: 'Anatasia',
    rarity: 'Unique',
    stars: 6,
    miningEfficiency: 0.11,
    image: 'assets/images/girls/anatasia.png',
    imageFace: 'assets/images/girls/anatasia-f.png',
    race: 'Human',
    type: 'Mage',
    region: 'Elementara',
    description:
        "Anatasia, a prodigy Mage, who able to learn and possess all spells of magis. Her connection to Elementara makes her a powerful ally.",
    hp: _generateStats('Unique', 'Mage')['hp']!,
    mp: _generateStats('Unique', 'Mage')['mp']!,
    sp: _generateStats('Unique', 'Mage')['sp']!,
    attackPoints: _generateStats('Unique', 'Mage')['attackPoints']!,
    defensePoints: _generateStats('Unique', 'Mage')['defensePoints']!,
    agilityPoints: _generateStats('Unique', 'Mage')['agilityPoints']!,
    maxHp: _generateStats('Unique', 'Mage')['hp']!,
    maxMp: _generateStats('Unique', 'Mage')['mp']!,
    maxSp: _generateStats('Unique', 'Mage')['sp']!,
    criticalPoint: 10,
  ),
  GirlFarmer(
    id: 'unique-5',
    name: 'Olivia',
    rarity: 'Unique',
    stars: 5,
    miningEfficiency: 0.10,
    image: 'assets/images/girls/olivia.png',
    imageFace: 'assets/images/girls/olivia-f.png',
    race: 'Human',
    type: 'Cleric',
    region: 'Astravia',
    description:
        "Olivia, a Holy Maiden and Divine Cleric, channels the light of Solmara to heal and protect. Her connection to Elementara makes her a powerful ally.",
    hp: _generateStats('Unique', 'Cleric')['hp']!,
    mp: _generateStats('Unique', 'Cleric')['mp']!,
    sp: _generateStats('Unique', 'Cleric')['sp']!,
    attackPoints: _generateStats('Unique', 'Cleric')['attackPoints']!,
    defensePoints: _generateStats('Unique', 'Cleric')['defensePoints']!,
    agilityPoints: _generateStats('Unique', 'Cleric')['agilityPoints']!,
    maxHp: _generateStats('Unique', 'Cleric')['hp']!,
    maxMp: _generateStats('Unique', 'Cleric')['mp']!,
    maxSp: _generateStats('Unique', 'Cleric')['sp']!,
    criticalPoint: 10,
  ),
];
