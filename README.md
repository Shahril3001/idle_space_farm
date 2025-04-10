Introduction (Experimental Project):
This project is a personal experimental endeavor aimed at evaluating the capabilities of the Flutter framework as a game development platform. The objective is to determine whether Flutter can provide the necessary tools, libraries, and performance optimization features required for developers to build the foundational elements of an idle game. The focus is on assessing how well Flutter can replicate the core mechanics, such as automated resource generation, progression systems, and interactive UI elements, which are commonly found in idle games available on the Google Play Store. 

Since most idle games are traditionally developed using game engines like Unity due to their powerful rendering capabilities and built-in physics systems, this project seeks to explore whether Flutter can serve as a viable alternative. The experiment will involve developing a prototype that mimics key gameplay elements, testing performance across different devices, and evaluating how well Flutter handles animations, state management, and background processes in comparison to Unity-based implementations. Ultimately, the findings will provide insights into the feasibility of using Flutter for idle game development and its potential advantages or limitations as a cross-platform game development framework.


Inspiration:
1. RPG Maker
2. King God Castle: Pixel TD RPG
3. Idle Space Farmer - Tycoon


AI Tools:
1. https://chat.deepseek.com/ – Coding assistance, system structure, and game mechanics
2. https://chatgpt.com/ – Icon and asset generation
3. https://pixai.art/ – Image and background asset generation
4. https://stablediffusionweb.com/ – Background asset generation

Core Game Systems:
Resource Management:
- Three main resources: Energy, Minerals, and Credits
- Resource generation through farms with assigned characters
- Resource exchange system

Base Building:
- Farm system with upgradable floors (up to 25 floors per farm)
- Different farm types (Aetheris for Energy, Eldoria for Minerals)
- Floor unlocking and upgrading mechanics

Character System:
- "Girl" characters with RPG stats (HP, MP, SP, attack, defense, agility)
- Different rarities (Common, Rare, Unique)
- Leveling system with stat growth
- Race system (Human, Eldren, Therian, Dracovar, Daemon)
- Class system (Divine Cleric, Phantom Reaver, etc.)
- Ability system with cooldowns and resource costs

Equipment System:
- Weapons, armor, and accessories
- Rarity tiers (Common to Mythic)
- Enhancement system
- Slot limitations (e.g., can't equip two two-handed weapons)
- Type and race restrictions
- Stat bonuses (attack, defense, HP, etc.)

Shop System:
- Daily refresh mechanic
- Multiple categories (girls, equipment, potions, ability scrolls)
- Purchasable items with various currencies
- Manual refresh option(daily 3x)

Potion System:
- Different rarities (Common to Legendary)
- Permanent stat boosts
- Usage restrictions
- Selling and inventory management

Battle System:
- Turn-based combat with initiative based on agility
- Ability usage with MP/SP costs
- Status effects (buffs/debuffs)
- Elemental affinities
- Critical hits
- Auto-battle option
- Victory/defeat conditions

Gacha Mechanics:
- Character summoning
- Equipment summoning
- Rarity probabilities (1% Mythic, 5% Legendary, etc.)

Progression Systems:
- Character leveling (up to level 100)
- Farm upgrades increasing resource generation
- Floor unlocking and upgrading
- Equipment enhancement
- Ability unlocks at certain levels

Technical Features:
- Game state persistence (save/load system)
- Offline progress calculation
- Timer-based resource generation
- Daily reset mechanics
