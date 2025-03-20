import '../models/girl_farmer_model.dart';
import 'dart:math';

final Random _random = Random();

// Helper function to generate random stats based on rarity and class
Map<String, int> _generateStats(String rarity, String type) {
  int baseHp, baseMp, baseSp, baseAtk, baseDef, baseAgi;

  // Base stats based on class
  switch (type) {
    case 'Blademaster (Kensai)':
      baseHp = 110;
      baseMp = 30;
      baseSp = 40;
      baseAtk = 12;
      baseDef = 6;
      baseAgi = 10;
      break;
    case 'Arcane Sage (Kenja)':
      baseHp = 90;
      baseMp = 80;
      baseSp = 20;
      baseAtk = 8;
      baseDef = 4;
      baseAgi = 6;
      break;
    case 'Phantom Reaver (Kageriba)':
      baseHp = 100;
      baseMp = 40;
      baseSp = 50;
      baseAtk = 11;
      baseDef = 5;
      baseAgi = 12;
      break;
    case 'Divine Cleric (Seito)':
      baseHp = 120;
      baseMp = 70;
      baseSp = 30;
      baseAtk = 9;
      baseDef = 7;
      baseAgi = 5;
      break;
    case 'Dread Knight (Jūkishi)':
      baseHp = 140;
      baseMp = 50;
      baseSp = 25;
      baseAtk = 13;
      baseDef = 9;
      baseAgi = 5;
      break;
    case 'Elementalist (Seirei Jutsushi)':
      baseHp = 100;
      baseMp = 90;
      baseSp = 25;
      baseAtk = 7;
      baseDef = 5;
      baseAgi = 7;
      break;
    case 'Warden (Shugosha)':
      baseHp = 115;
      baseMp = 50;
      baseSp = 35;
      baseAtk = 10;
      baseDef = 7;
      baseAgi = 8;
      break;
    case 'Runebinder (Kokuinsha)':
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

final List<GirlFarmer> girlsData = [
  // Common Girls (1-2 stars)
  GirlFarmer(
    id: 'common-1',
    name: 'Luna',
    rarity: 'Common',
    stars: 1,
    miningEfficiency: 2,
    image: 'assets/images/girls/luna.png',
    race: 'Human',
    type: 'Blademaster (Kensai)',
    region: 'Astravia',
    description:
        "A humble farmer from Astravia, Luna wields her blade with precision, inspired by the knights of the Celestial Order.",
    hp: _generateStats('Common', 'Blademaster (Kensai)')['hp']!,
    mp: _generateStats('Common', 'Blademaster (Kensai)')['mp']!,
    sp: _generateStats('Common', 'Blademaster (Kensai)')['sp']!,
    attackPoints:
        _generateStats('Common', 'Blademaster (Kensai)')['attackPoints']!,
    defensePoints:
        _generateStats('Common', 'Blademaster (Kensai)')['defensePoints']!,
    agilityPoints:
        _generateStats('Common', 'Blademaster (Kensai)')['agilityPoints']!,
  ),
  GirlFarmer(
    id: 'common-2',
    name: 'Aria',
    rarity: 'Common',
    stars: 1,
    miningEfficiency: 3,
    image: 'assets/images/girls/aria.png',
    race: 'Eldren',
    type: 'Arcane Sage (Kenja)',
    region: 'Sylvaris',
    description:
        "Aria is a young Eldren mage from Sylvaris, gifted in elemental magic. She spends her days tending to the enchanted forests.",
    hp: _generateStats('Common', 'Arcane Sage (Kenja)')['hp']!,
    mp: _generateStats('Common', 'Arcane Sage (Kenja)')['mp']!,
    sp: _generateStats('Common', 'Arcane Sage (Kenja)')['sp']!,
    attackPoints:
        _generateStats('Common', 'Arcane Sage (Kenja)')['attackPoints']!,
    defensePoints:
        _generateStats('Common', 'Arcane Sage (Kenja)')['defensePoints']!,
    agilityPoints:
        _generateStats('Common', 'Arcane Sage (Kenja)')['agilityPoints']!,
  ),
  GirlFarmer(
    id: 'common-3',
    name: 'Elyse',
    rarity: 'Common',
    stars: 2,
    miningEfficiency: 4,
    image: 'assets/images/girls/elyse.png',
    race: 'Daevan',
    type: 'Phantom Reaver (Kageriba)',
    region: 'Ashen Dominion',
    description:
        "Elyse, a Daevan from the Ashen Dominion, is a shadowy figure who uses her agility to navigate the darkest corners of Eldoria. She seeks redemption for her cursed lineage.",
    hp: _generateStats('Common', 'Phantom Reaver (Kageriba)')['hp']!,
    mp: _generateStats('Common', 'Phantom Reaver (Kageriba)')['mp']!,
    sp: _generateStats('Common', 'Phantom Reaver (Kageriba)')['sp']!,
    attackPoints:
        _generateStats('Common', 'Phantom Reaver (Kageriba)')['attackPoints']!,
    defensePoints:
        _generateStats('Common', 'Phantom Reaver (Kageriba)')['defensePoints']!,
    agilityPoints:
        _generateStats('Common', 'Phantom Reaver (Kageriba)')['agilityPoints']!,
  ),
  GirlFarmer(
    id: 'common-4',
    name: 'Tessa',
    rarity: 'Common',
    stars: 1,
    miningEfficiency: 1,
    image: 'assets/images/girls/tessa.png',
    race: 'Therian',
    type: 'Divine Cleric (Seito)',
    region: 'Astravia',
    description:
        "Tessa, a Therian cleric, channels the light of Solmara to heal and protect. Her connection to nature makes her a beloved figure in Astravia.",
    hp: _generateStats('Common', 'Divine Cleric (Seito)')['hp']!,
    mp: _generateStats('Common', 'Divine Cleric (Seito)')['mp']!,
    sp: _generateStats('Common', 'Divine Cleric (Seito)')['sp']!,
    attackPoints:
        _generateStats('Common', 'Divine Cleric (Seito)')['attackPoints']!,
    defensePoints:
        _generateStats('Common', 'Divine Cleric (Seito)')['defensePoints']!,
    agilityPoints:
        _generateStats('Common', 'Divine Cleric (Seito)')['agilityPoints']!,
  ),
  GirlFarmer(
    id: 'common-5',
    name: 'Mira',
    rarity: 'Common',
    stars: 2,
    miningEfficiency: 3,
    image: 'assets/images/girls/mira.png',
    race: 'Dracovar',
    type: 'Dread Knight (Jūkishi)',
    region: 'Draknir Sovereignty',
    description:
        "Mira, a fierce Dracovar warrior, wields dark magic to protect her homeland. Her draconic heritage gives her unmatched strength and resilience.",
    hp: _generateStats('Common', 'Dread Knight (Jūkishi)')['hp']!,
    mp: _generateStats('Common', 'Dread Knight (Jūkishi)')['mp']!,
    sp: _generateStats('Common', 'Dread Knight (Jūkishi)')['sp']!,
    attackPoints:
        _generateStats('Common', 'Dread Knight (Jūkishi)')['attackPoints']!,
    defensePoints:
        _generateStats('Common', 'Dread Knight (Jūkishi)')['defensePoints']!,
    agilityPoints:
        _generateStats('Common', 'Dread Knight (Jūkishi)')['agilityPoints']!,
  ),
  GirlFarmer(
    id: 'common-6',
    name: 'Lyra',
    rarity: 'Common',
    stars: 2,
    miningEfficiency: 2,
    image: 'assets/images/girls/lyra.png',
    race: 'Fae-born',
    type: 'Elementalist (Seirei Jutsushi)',
    region: 'Elementara',
    description:
        "Lyra, a mischievous Fae-born, commands the elements with ease. Her playful nature hides a deep connection to the chaotic realm of Elementara.",
    hp: _generateStats('Common', 'Elementalist (Seirei Jutsushi)')['hp']!,
    mp: _generateStats('Common', 'Elementalist (Seirei Jutsushi)')['mp']!,
    sp: _generateStats('Common', 'Elementalist (Seirei Jutsushi)')['sp']!,
    attackPoints: _generateStats(
        'Common', 'Elementalist (Seirei Jutsushi)')['attackPoints']!,
    defensePoints: _generateStats(
        'Common', 'Elementalist (Seirei Jutsushi)')['defensePoints']!,
    agilityPoints: _generateStats(
        'Common', 'Elementalist (Seirei Jutsushi)')['agilityPoints']!,
  ),
  GirlFarmer(
    id: 'common-7',
    name: 'Rina',
    rarity: 'Common',
    stars: 1,
    miningEfficiency: 4,
    image: 'assets/images/girls/rina.png',
    race: 'Human',
    type: 'Warden (Shugosha)',
    region: 'Astravia',
    description:
        "Rina, a skilled archer from Astravia, defends her homeland with unwavering loyalty. Her arrows are said to never miss their mark.",
    hp: _generateStats('Common', 'Warden (Shugosha)')['hp']!,
    mp: _generateStats('Common', 'Warden (Shugosha)')['mp']!,
    sp: _generateStats('Common', 'Warden (Shugosha)')['sp']!,
    attackPoints:
        _generateStats('Common', 'Warden (Shugosha)')['attackPoints']!,
    defensePoints:
        _generateStats('Common', 'Warden (Shugosha)')['defensePoints']!,
    agilityPoints:
        _generateStats('Common', 'Warden (Shugosha)')['agilityPoints']!,
  ),
  GirlFarmer(
    id: 'common-8',
    name: 'Zara',
    rarity: 'Common',
    stars: 2,
    miningEfficiency: 1,
    image: 'assets/images/girls/zara.png',
    race: 'Eldren',
    type: 'Runebinder (Kokuinsha)',
    region: 'Sylvaris',
    description:
        "Zara, an Eldren runebinder, inscribes powerful runes into her weapons. Her knowledge of ancient magic makes her a valuable ally.",
    hp: _generateStats('Common', 'Runebinder (Kokuinsha)')['hp']!,
    mp: _generateStats('Common', 'Runebinder (Kokuinsha)')['mp']!,
    sp: _generateStats('Common', 'Runebinder (Kokuinsha)')['sp']!,
    attackPoints:
        _generateStats('Common', 'Runebinder (Kokuinsha)')['attackPoints']!,
    defensePoints:
        _generateStats('Common', 'Runebinder (Kokuinsha)')['defensePoints']!,
    agilityPoints:
        _generateStats('Common', 'Runebinder (Kokuinsha)')['agilityPoints']!,
  ),
  GirlFarmer(
    id: 'common-9',
    name: 'Siena',
    rarity: 'Common',
    stars: 1,
    miningEfficiency: 2,
    image: 'assets/images/girls/siena.png',
    race: 'Daevan',
    type: 'Blademaster (Kensai)',
    region: 'Ashen Dominion',
    description:
        "Siena, a Daevan blademaster, fights to prove her worth in a world that fears her kind. Her blade is as sharp as her resolve.",
    hp: _generateStats('Common', 'Blademaster (Kensai)')['hp']!,
    mp: _generateStats('Common', 'Blademaster (Kensai)')['mp']!,
    sp: _generateStats('Common', 'Blademaster (Kensai)')['sp']!,
    attackPoints:
        _generateStats('Common', 'Blademaster (Kensai)')['attackPoints']!,
    defensePoints:
        _generateStats('Common', 'Blademaster (Kensai)')['defensePoints']!,
    agilityPoints:
        _generateStats('Common', 'Blademaster (Kensai)')['agilityPoints']!,
  ),
  GirlFarmer(
    id: 'common-10',
    name: 'Freya',
    rarity: 'Common',
    stars: 1,
    miningEfficiency: 3,
    image: 'assets/images/girls/freya.png',
    race: 'Therian',
    type: 'Arcane Sage (Kenja)',
    region: 'Astravia',
    description:
        "Freya, a Therian mage, combines her beastly instincts with arcane knowledge. She is a fierce protector of Astravia's farmlands.",
    hp: _generateStats('Common', 'Arcane Sage (Kenja)')['hp']!,
    mp: _generateStats('Common', 'Arcane Sage (Kenja)')['mp']!,
    sp: _generateStats('Common', 'Arcane Sage (Kenja)')['sp']!,
    attackPoints:
        _generateStats('Common', 'Arcane Sage (Kenja)')['attackPoints']!,
    defensePoints:
        _generateStats('Common', 'Arcane Sage (Kenja)')['defensePoints']!,
    agilityPoints:
        _generateStats('Common', 'Arcane Sage (Kenja)')['agilityPoints']!,
  ),

  // Rare Girls (3-4 stars)
  GirlFarmer(
    id: 'rare-1',
    name: 'Stella',
    rarity: 'Rare',
    stars: 3,
    miningEfficiency: 6,
    image: 'assets/images/girls/stella.png',
    race: 'Human',
    type: 'Phantom Reaver (Kageriba)',
    region: 'Ashen Dominion',
    description:
        "Stella, a rare Phantom Reaver, moves like a shadow through the Ashen Dominion. Her skills make her a feared assassin in the underworld.",
    hp: _generateStats('Rare', 'Phantom Reaver (Kageriba)')['hp']!,
    mp: _generateStats('Rare', 'Phantom Reaver (Kageriba)')['mp']!,
    sp: _generateStats('Rare', 'Phantom Reaver (Kageriba)')['sp']!,
    attackPoints:
        _generateStats('Rare', 'Phantom Reaver (Kageriba)')['attackPoints']!,
    defensePoints:
        _generateStats('Rare', 'Phantom Reaver (Kageriba)')['defensePoints']!,
    agilityPoints:
        _generateStats('Rare', 'Phantom Reaver (Kageriba)')['agilityPoints']!,
  ),
  GirlFarmer(
    id: 'rare-2',
    name: 'Elara',
    rarity: 'Rare',
    stars: 3,
    miningEfficiency: 5,
    image: 'assets/images/girls/elara.png',
    race: 'Eldren',
    type: 'Divine Cleric (Seito)',
    region: 'Sylvaris',
    description:
        "Elara, a rare Divine Cleric, channels the light of Solmara to heal and protect. Her presence brings hope to the darkest battles.",
    hp: _generateStats('Rare', 'Divine Cleric (Seito)')['hp']!,
    mp: _generateStats('Rare', 'Divine Cleric (Seito)')['mp']!,
    sp: _generateStats('Rare', 'Divine Cleric (Seito)')['sp']!,
    attackPoints:
        _generateStats('Rare', 'Divine Cleric (Seito)')['attackPoints']!,
    defensePoints:
        _generateStats('Rare', 'Divine Cleric (Seito)')['defensePoints']!,
    agilityPoints:
        _generateStats('Rare', 'Divine Cleric (Seito)')['agilityPoints']!,
  ),
  GirlFarmer(
    id: 'rare-3',
    name: 'Nina',
    rarity: 'Rare',
    stars: 4,
    miningEfficiency: 8,
    image: 'assets/images/girls/nina.png',
    race: 'Dracovar',
    type: 'Dread Knight (Jūkishi)',
    region: 'Draknir Sovereignty',
    description:
        "Nina, a rare Dread Knight, wields dark magic with unmatched skill. Her draconic heritage makes her a formidable force on the battlefield.",
    hp: _generateStats('Rare', 'Dread Knight (Jūkishi)')['hp']!,
    mp: _generateStats('Rare', 'Dread Knight (Jūkishi)')['mp']!,
    sp: _generateStats('Rare', 'Dread Knight (Jūkishi)')['sp']!,
    attackPoints:
        _generateStats('Rare', 'Dread Knight (Jūkishi)')['attackPoints']!,
    defensePoints:
        _generateStats('Rare', 'Dread Knight (Jūkishi)')['defensePoints']!,
    agilityPoints:
        _generateStats('Rare', 'Dread Knight (Jūkishi)')['agilityPoints']!,
  ),
  GirlFarmer(
    id: 'rare-4',
    name: 'Isla',
    rarity: 'Rare',
    stars: 3,
    miningEfficiency: 7,
    image: 'assets/images/girls/isla.png',
    race: 'Fae-born',
    type: 'Elementalist (Seirei Jutsushi)',
    region: 'Elementara',
    description:
        "Isla, a rare Elementalist, commands the forces of nature with ease. Her connection to Elementara makes her a powerful ally.",
    hp: _generateStats('Rare', 'Elementalist (Seirei Jutsushi)')['hp']!,
    mp: _generateStats('Rare', 'Elementalist (Seirei Jutsushi)')['mp']!,
    sp: _generateStats('Rare', 'Elementalist (Seirei Jutsushi)')['sp']!,
    attackPoints: _generateStats(
        'Rare', 'Elementalist (Seirei Jutsushi)')['attackPoints']!,
    defensePoints: _generateStats(
        'Rare', 'Elementalist (Seirei Jutsushi)')['defensePoints']!,
    agilityPoints: _generateStats(
        'Rare', 'Elementalist (Seirei Jutsushi)')['agilityPoints']!,
  ),
  GirlFarmer(
    id: 'rare-5',
    name: 'Selene',
    rarity: 'Rare',
    stars: 4,
    miningEfficiency: 6,
    image: 'assets/images/girls/selene.png',
    race: 'Human',
    type: 'Warden (Shugosha)',
    region: 'Astravia',
    description:
        "Selene, a rare Warden, defends Astravia with her bow and unwavering loyalty. Her arrows are said to pierce even the toughest armor.",
    hp: _generateStats('Rare', 'Warden (Shugosha)')['hp']!,
    mp: _generateStats('Rare', 'Warden (Shugosha)')['mp']!,
    sp: _generateStats('Rare', 'Warden (Shugosha)')['sp']!,
    attackPoints: _generateStats('Rare', 'Warden (Shugosha)')['attackPoints']!,
    defensePoints:
        _generateStats('Rare', 'Warden (Shugosha)')['defensePoints']!,
    agilityPoints:
        _generateStats('Rare', 'Warden (Shugosha)')['agilityPoints']!,
  ),
  GirlFarmer(
    id: 'rare-6',
    name: 'Vivian',
    rarity: 'Rare',
    stars: 3,
    miningEfficiency: 5,
    image: 'assets/images/girls/vivian.png',
    race: 'Eldren',
    type: 'Runebinder (Kokuinsha)',
    region: 'Sylvaris',
    description:
        "Vivian, a rare Runebinder, inscribes powerful runes into her weapons. Her knowledge of ancient magic makes her a valuable ally.",
    hp: _generateStats('Rare', 'Runebinder (Kokuinsha)')['hp']!,
    mp: _generateStats('Rare', 'Runebinder (Kokuinsha)')['mp']!,
    sp: _generateStats('Rare', 'Runebinder (Kokuinsha)')['sp']!,
    attackPoints:
        _generateStats('Rare', 'Runebinder (Kokuinsha)')['attackPoints']!,
    defensePoints:
        _generateStats('Rare', 'Runebinder (Kokuinsha)')['defensePoints']!,
    agilityPoints:
        _generateStats('Rare', 'Runebinder (Kokuinsha)')['agilityPoints']!,
  ),

  // Unique Girls (5-6 stars)
  GirlFarmer(
    id: 'unique-1',
    name: 'Astrid',
    rarity: 'Unique',
    stars: 5,
    miningEfficiency: 10,
    image: 'assets/images/girls/astrid.png',
    race: 'Daevan',
    type: 'Blademaster (Kensai)',
    region: 'Ashen Dominion',
    description:
        "Astrid, a unique Blademaster, wields her blade with unmatched skill. Her dark past fuels her determination to protect the innocent.",
    hp: _generateStats('Unique', 'Blademaster (Kensai)')['hp']!,
    mp: _generateStats('Unique', 'Blademaster (Kensai)')['mp']!,
    sp: _generateStats('Unique', 'Blademaster (Kensai)')['sp']!,
    attackPoints:
        _generateStats('Unique', 'Blademaster (Kensai)')['attackPoints']!,
    defensePoints:
        _generateStats('Unique', 'Blademaster (Kensai)')['defensePoints']!,
    agilityPoints:
        _generateStats('Unique', 'Blademaster (Kensai)')['agilityPoints']!,
  ),
  GirlFarmer(
    id: 'unique-2',
    name: 'Seraphina',
    rarity: 'Unique',
    stars: 6,
    miningEfficiency: 12,
    image: 'assets/images/girls/seraphina.png',
    race: 'Therian',
    type: 'Arcane Sage (Kenja)',
    region: 'Astravia',
    description:
        "Seraphina, a unique Arcane Sage, commands the elements with unparalleled mastery. Her wisdom and power make her a beacon of hope in Astravia.",
    hp: _generateStats('Unique', 'Arcane Sage (Kenja)')['hp']!,
    mp: _generateStats('Unique', 'Arcane Sage (Kenja)')['mp']!,
    sp: _generateStats('Unique', 'Arcane Sage (Kenja)')['sp']!,
    attackPoints:
        _generateStats('Unique', 'Arcane Sage (Kenja)')['attackPoints']!,
    defensePoints:
        _generateStats('Unique', 'Arcane Sage (Kenja)')['defensePoints']!,
    agilityPoints:
        _generateStats('Unique', 'Arcane Sage (Kenja)')['agilityPoints']!,
  ),
  GirlFarmer(
    id: 'unique-3',
    name: 'Elysia',
    rarity: 'Unique',
    stars: 5,
    miningEfficiency: 9,
    image: 'assets/images/girls/elysia.png',
    race: 'Dracovar',
    type: 'Phantom Reaver (Kageriba)',
    region: 'Draknir Sovereignty',
    description:
        "Elysia, a unique Phantom Reaver, moves like a shadow through the battlefield. Her draconic heritage gives her unmatched agility and strength.",
    hp: _generateStats('Unique', 'Phantom Reaver (Kageriba)')['hp']!,
    mp: _generateStats('Unique', 'Phantom Reaver (Kageriba)')['mp']!,
    sp: _generateStats('Unique', 'Phantom Reaver (Kageriba)')['sp']!,
    attackPoints:
        _generateStats('Unique', 'Phantom Reaver (Kageriba)')['attackPoints']!,
    defensePoints:
        _generateStats('Unique', 'Phantom Reaver (Kageriba)')['defensePoints']!,
    agilityPoints:
        _generateStats('Unique', 'Phantom Reaver (Kageriba)')['agilityPoints']!,
  ),
  GirlFarmer(
    id: 'unique-4',
    name: 'Celestia',
    rarity: 'Unique',
    stars: 6,
    miningEfficiency: 11,
    image: 'assets/images/girls/celestia.png',
    race: 'Fae-born',
    type: 'Divine Cleric (Seito)',
    region: 'Elementara',
    description:
        "Celestia, a unique Divine Cleric, channels the light of Solmara to heal and protect. Her connection to Elementara makes her a powerful ally.",
    hp: _generateStats('Unique', 'Divine Cleric (Seito)')['hp']!,
    mp: _generateStats('Unique', 'Divine Cleric (Seito)')['mp']!,
    sp: _generateStats('Unique', 'Divine Cleric (Seito)')['sp']!,
    attackPoints:
        _generateStats('Unique', 'Divine Cleric (Seito)')['attackPoints']!,
    defensePoints:
        _generateStats('Unique', 'Divine Cleric (Seito)')['defensePoints']!,
    agilityPoints:
        _generateStats('Unique', 'Divine Cleric (Seito)')['agilityPoints']!,
  ),
  GirlFarmer(
    id: 'unique-5',
    name: 'Zyra',
    rarity: 'Unique',
    stars: 5,
    miningEfficiency: 10,
    image: 'assets/images/girls/zyra.png',
    race: 'Human',
    type: 'Dread Knight (Jūkishi)',
    region: 'Astravia',
    description:
        "Zyra, a unique Dread Knight, wields dark magic with unmatched skill. Her loyalty to Astravia is unwavering, even in the face of darkness.",
    hp: _generateStats('Unique', 'Dread Knight (Jūkishi)')['hp']!,
    mp: _generateStats('Unique', 'Dread Knight (Jūkishi)')['mp']!,
    sp: _generateStats('Unique', 'Dread Knight (Jūkishi)')['sp']!,
    attackPoints:
        _generateStats('Unique', 'Dread Knight (Jūkishi)')['attackPoints']!,
    defensePoints:
        _generateStats('Unique', 'Dread Knight (Jūkishi)')['defensePoints']!,
    agilityPoints:
        _generateStats('Unique', 'Dread Knight (Jūkishi)')['agilityPoints']!,
  ),
  GirlFarmer(
    id: 'unique-6',
    name: 'Amara',
    rarity: 'Unique',
    stars: 6,
    miningEfficiency: 12,
    image: 'assets/images/girls/amara.png',
    race: 'Eldren',
    type: 'Elementalist (Seirei Jutsushi)',
    region: 'Sylvaris',
    description:
        "Amara, a unique Elementalist, commands the forces of nature with unparalleled mastery. Her wisdom and power make her a beacon of hope in Sylvaris.",
    hp: _generateStats('Unique', 'Elementalist (Seirei Jutsushi)')['hp']!,
    mp: _generateStats('Unique', 'Elementalist (Seirei Jutsushi)')['mp']!,
    sp: _generateStats('Unique', 'Elementalist (Seirei Jutsushi)')['sp']!,
    attackPoints: _generateStats(
        'Unique', 'Elementalist (Seirei Jutsushi)')['attackPoints']!,
    defensePoints: _generateStats(
        'Unique', 'Elementalist (Seirei Jutsushi)')['defensePoints']!,
    agilityPoints: _generateStats(
        'Unique', 'Elementalist (Seirei Jutsushi)')['agilityPoints']!,
  ),
];
